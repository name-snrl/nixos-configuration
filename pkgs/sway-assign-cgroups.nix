{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sway-assign-cgroups";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "alebastr";
    repo = "sway-systemd";
    rev = "v${version}";
    hash = "sha256-Azy7XRHrKvhODxAogwtk2+W0WjGcoTy47+nT0x9aMPw=";
  };

  format = "other";
  dontBuild = true;
  dontConfigure = true;

  propagatedBuildInputs = with python3.pkgs; [
    dbus-next
    i3ipc
    psutil
    tenacity
    xlib
  ];

  installPhase = "install -Dm 0755 $src/src/assign-cgroups.py $out/bin/sway-assign-cgroups";

  meta = with lib; {
    homepage = "https://github.com/alebastr/sway-systemd";
    description = "List processing tools and functional utilities";
    license = licenses.mit;
  };
}
