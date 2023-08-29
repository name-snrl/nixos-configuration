{ lib
, formats
, stdenvNoCC
, fetchFromGitHub
, qtgraphicaleffects
, themeConfig ? null
}:
let
  user-cfg = (formats.ini {}).generate "theme.conf.user" themeConfig;
in
stdenvNoCC.mkDerivation rec {
  pname = "where-is-my-sddm-theme";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "stepanzubkov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-40XTihp3hYbXzXSmgrmFCQjZUBkDi/NLiGQEs5ZmRIg=";
  };

  propagatedUserEnvPkgs = [ qtgraphicaleffects ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes/
    cp -r where_is_my_sddm_theme/ $out/share/sddm/themes/
  '' + lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf.user
  '';
}

