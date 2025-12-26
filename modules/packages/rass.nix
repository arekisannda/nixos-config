{
  fetchFromGitHub,
  python3,
  python3Packages,
}:

with python3Packages;

buildPythonPackage rec {
  pname = "rass";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "joaotavora";
    repo = "rassumfrassum";
    rev = "v${version}";
    sha256 = "1vmm83y8in4n5v99x1zb01x01yakvnirrf16j3zszyrr776vag0n";
  };

  patchPhase = ''
    echo "from setuptools import setup; setup()" > setup.py
  '';

  buildInputs = [ python3 setuptools];
}
