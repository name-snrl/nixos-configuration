{ lib
, writeText
, stdenvNoCC
, fetchFromGitHub
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

  patches = [ ./change-fillMode.patch ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes/
    cp -r where_is_my_sddm_theme/ $out/share/sddm/themes/
  '' + lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf.user
  '';

  postFixup = ''
    mkdir -p $out/nix-support
    echo ${qtgraphicaleffects} >> $out/nix-support/propagated-user-env-packages
  '';
}

