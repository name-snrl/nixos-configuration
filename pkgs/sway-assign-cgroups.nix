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

  preBuild = ''
    cat > setup.py << EOF
    from setuptools import setup

    setup(
      name='sway-assign-cgroups',
      author='alebastr',
      version='${version}',
      scripts=['src/assign-cgroups.py'],
    )
    EOF
  '';

  postInstall = ''
    mv -v $out/bin/assign-cgroups.py $out/bin/sway-assign-cgroups
  '';

  propagatedBuildInputs = with python3.pkgs; [
    dbus-next
    i3ipc
    psutil
    tenacity
    xlib
  ];

  meta = with lib; {
    homepage = "https://github.com/alebastr/sway-systemd";
    description = "List processing tools and functional utilities";
    license = licenses.mit;
  };
}
