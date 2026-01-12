{ fetchFromGitHub, python3, python3Packages, }:

with python3Packages;

buildPythonPackage rec {
  pname = "rass";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "joaotavora";
    repo = "rassumfrassum";
    rev = "v${version}";
    sha256 = "sha256-FFQawil0JRTp3bfBWq8mypkCMiHuxozyblVcTBToTso=";
  };

  patchPhase = ''
    echo "from setuptools import setup; setup()" > setup.py
  '';

  buildInputs = [ python3 setuptools ];
}
