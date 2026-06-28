{
  stdenvNoCC,
  inter,
  python3Packages,
  fd,
}:
stdenvNoCC.mkDerivation (_fa: {
  pname = "inter-tuned";
  inherit (inter)
    version
    src
    meta
    ;

  nativeBuildInputs = [
    (python3Packages.opentype-feature-freezer.overrideAttrs (oa: {
      patches = oa.patches or [ ] ++ [ ./freezer.patch ];
    }))
    fd
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/ttf
    fd . -e ttf extras/ttf \
        --exec pyftfeatfreeze -v \
        -R 'Inter/Inter Tuned' \
        -f 'tnum,ss01,ss02,cv06' \
        {} $out/share/fonts/ttf/{/}

    runHook postInstall
  '';
})
