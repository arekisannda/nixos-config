let
  inherit (builtins)
    div
    isInt
    stringLength
    substring
    genList
    concatStringsSep
    elemAt
    ;

  fdiv =
    a: b:
    let
      q = div a b;
    in
    if (a - q * b) != 0 && ((a < 0) != (b < 0)) then q - 1 else q;
  fmod = a: b: a - b * (fdiv a b);

  # Padding helpers
  rep = k: c: concatStringsSep "" (genList (_: c) k);
  padWith =
    c: w: n:
    let
      s = toString n;
      l = stringLength s;
    in
    if l >= w then s else rep (w - l) c + s;
  pad = padWith "0";
  spad2 = padWith " " 2;

  dayNames = [
    "Sunday"
    "Monday"
    "Tuesday"
    "Wednesday"
    "Thursday"
    "Friday"
    "Saturday"
  ];
  monthNames = [
    "January"
    "February"
    "March"
    "April"
    "May"
    "June"
    "July"
    "August"
    "September"
    "October"
    "November"
    "December"
  ];
  short = s: substring 0 3 s;

  # Normalize input into { sec, nsec, offset, zone }.
  norm =
    t:
    let
      a = if isInt t then { sec = t; } else t;
      offset = a.offset or 0;
      nsec0 = a.nsec or 0;
      carry = fdiv nsec0 1000000000;
    in
    {
      sec = a.sec + carry;
      nsec = nsec0 - carry * 1000000000;
      inherit offset;
      zone = a.zone or (if offset == 0 then "UTC" else "");
    };

  # Break a time into calendar fields (in its own offset).
  parts =
    t:
    let
      n = norm t;
      local = n.sec + n.offset;
      days = fdiv local 86400;
      secs = local - days * 86400;

      # Days since epoch → civil date (Howard Hinnant's algorithm, floor-division safe)
      z = days + 719468;
      era = fdiv z 146097;
      doe = z - era * 146097;
      yoe = div (doe - div doe 1460 + div doe 36524 - div doe 146096) 365;
      doy = doe - (365 * yoe + div yoe 4 - div yoe 100);
      mp = div (5 * doy + 2) 153;
      d = doy - div (153 * mp + 2) 5 + 1;
      m = if mp < 10 then mp + 3 else mp - 9;
      y = yoe + era * 400 + (if m <= 2 then 1 else 0);

      hh = div secs 3600;
      h12 =
        let
          h = fmod hh 12;
        in
        if h == 0 then 12 else h;
    in
    n
    // {
      year = y;
      month = m;
      day = d;
      hour = hh;
      minute = div (fmod secs 3600) 60;
      second = fmod secs 60;
      inherit h12;
      ampm = if hh >= 12 then "PM" else "AM";
      weekday = elemAt dayNames (fmod (days + 4) 7); # 1970-01-01 was a Thursday
      monthName = elemAt monthNames (m - 1);
      yy = pad 2 (fmod y 100);
      yyyy = pad 4 y;
    };

  # Zone pieces
  numZone =
    sep: p:
    let
      mins = div p.offset 60;
      sign = if mins < 0 then "-" else "+";
      a = if mins < 0 then -mins else mins;
    in
    "${sign}${pad 2 (div a 60)}${sep}${pad 2 (fmod a 60)}";
  tzName = p: if p.zone != "" then p.zone else numZone "" p;
  isoZone = p: if p.offset == 0 then "Z" else numZone ":" p;

  # Fractional seconds
  nano9 = p: pad 9 p.nsec;
  fracFixed = digits: p: "." + substring 0 digits (nano9 p);
  trimZeros =
    s:
    let
      l = stringLength s;
    in
    if l > 0 && substring (l - 1) 1 s == "0" then trimZeros (substring 0 (l - 1) s) else s;
  fracTrim = p: if p.nsec == 0 then "" else "." + trimZeros (nano9 p);

  # Common fragments
  hms = p: "${pad 2 p.hour}:${pad 2 p.minute}:${pad 2 p.second}";
  hm = p: "${pad 2 p.hour}:${pad 2 p.minute}";
  ymd = p: "${p.yyyy}-${pad 2 p.month}-${pad 2 p.day}";
  stamp = p: "${short p.monthName} ${spad2 p.day} ${hms p}";

  mk = f: t: f (parts t);
in
{
  # "01/02 03:04:05PM '06 -0700"
  layout = mk (
    p:
    "${pad 2 p.month}/${pad 2 p.day} ${pad 2 p.h12}:${pad 2 p.minute}:${pad 2 p.second}${p.ampm} '${p.yy} ${numZone "" p}"
  );

  # "Mon Jan _2 15:04:05 2006"
  ANSIC = mk (p: "${short p.weekday} ${stamp p} ${p.yyyy}");

  # "Mon Jan _2 15:04:05 MST 2006"
  unixDate = mk (p: "${short p.weekday} ${stamp p} ${tzName p} ${p.yyyy}");

  # "Mon Jan 02 15:04:05 -0700 2006"
  rubyDate = mk (
    p: "${short p.weekday} ${short p.monthName} ${pad 2 p.day} ${hms p} ${numZone "" p} ${p.yyyy}"
  );

  # "02 Jan 06 15:04 MST"
  RFC822 = mk (p: "${pad 2 p.day} ${short p.monthName} ${p.yy} ${hm p} ${tzName p}");

  # "02 Jan 06 15:04 -0700"
  RFC822Z = mk (p: "${pad 2 p.day} ${short p.monthName} ${p.yy} ${hm p} ${numZone "" p}");

  # "Monday, 02-Jan-06 15:04:05 MST"
  RFC850 = mk (p: "${p.weekday}, ${pad 2 p.day}-${short p.monthName}-${p.yy} ${hms p} ${tzName p}");

  # "Mon, 02 Jan 2006 15:04:05 MST"
  RFC1123 = mk (
    p: "${short p.weekday}, ${pad 2 p.day} ${short p.monthName} ${p.yyyy} ${hms p} ${tzName p}"
  );

  # "Mon, 02 Jan 2006 15:04:05 -0700"
  RFC1123Z = mk (
    p: "${short p.weekday}, ${pad 2 p.day} ${short p.monthName} ${p.yyyy} ${hms p} ${numZone "" p}"
  );

  # "2006-01-02T15:04:05Z07:00"
  RFC3339 = mk (p: "${ymd p}T${hms p}${isoZone p}");

  # "2006-01-02T15:04:05.999999999Z07:00"
  RFC3339Nano = mk (p: "${ymd p}T${hms p}${fracTrim p}${isoZone p}");

  # "20261015T143207Z"
  ISO8601 = mk (
    p:
    "${pad 4 p.year}${pad 2 p.month}${pad 2 p.day}T${pad 2 p.hour}${pad 2 p.minute}${pad 2 p.second}Z"
  );

  # "3:04PM"
  kitchen = mk (p: "${toString p.h12}:${pad 2 p.minute}${p.ampm}");

  # "Jan _2 15:04:05"
  stamp = mk stamp;

  # "Jan _2 15:04:05.000"
  stampMilli = mk (p: stamp p + fracFixed 3 p);

  # "Jan _2 15:04:05.000000"
  stampMicro = mk (p: stamp p + fracFixed 6 p);

  # "Jan _2 15:04:05.000000000"
  stampNano = mk (p: stamp p + fracFixed 9 p);

  # "2006-01-02 15:04:05"
  dateTime = mk (p: "${ymd p} ${hms p}");

  # "2006-01-02"
  dateOnly = mk ymd;

  # "15:04:05"
  timeOnly = mk hms;

  # Raw calendar fields, for building your own layouts.
  inherit parts;
}
