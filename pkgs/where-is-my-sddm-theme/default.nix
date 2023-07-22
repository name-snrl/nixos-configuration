{ lib
, writeText
, stdenvNoCC
, fetchFromGitHub
, fetchpatch
, qtgraphicaleffects
, themeConfig ? null
}:
let
  user-cfg = writeText "theme.conf.user"
    (lib.generators.toINI { } { General = themeConfig; });
in
stdenvNoCC.mkDerivation rec {
  pname = "where-is-my-sddm-theme";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "stepanzubkov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-rGn7HKgiPaVxwsURrveHQCQ2RX2JG0HMlLLwnJCoEKg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/stepanzubkov/where-is-my-sddm-theme/pull/5.patch";
      sha256 = "sha256-O+z877zq5piK8UxK50TysoD8eXk9e8x90MG23FHxzuQ=";
    })
  ];

  propagatedUserEnvPkgs = [ qtgraphicaleffects ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes/
    cp -r where_is_my_sddm_theme/ $out/share/sddm/themes/
  '' + lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf.user
  '';
}

