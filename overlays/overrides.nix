# Overlay that overrides existing packages.
inputs: final: prev: {

  neovim-unwrapped =
    inputs.neovim-nightly-overlay.packages.${final.stdenv.hostPlatform.system}.neovim;

  ki-editor =
    with final;
    symlinkJoin {
      name = "ki-editor";
      paths = lib.singleton (
        inputs.ki-editor.packages.${stdenv.hostPlatform.system}.ki-editor-wayland.overrideAttrs (oa: {
          patches = oa.patches or [ ] ++ [
            ./0001-make-keymaps-more-native.patch
          ];
        })
      );
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram "$out/bin/ki" \
            --set-default KI_EDITOR_THEME 'One Dark' \
            --suffix PATH : ${
              lib.makeBinPath [
                nixfmt
                nil
              ]
            }
      '';
    };

  firefox = prev.firefox.override {
    extraPolicies = {
      DisableTelemetry = true;
      EnableTrackingProtection = true;
      HttpsOnlyMode = true;
      NetworkPrediction = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        FeatureRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = false;
        Locked = true;
      };
    };
  };

  gojq =
    with final;
    symlinkJoin {
      name = "gojq";
      paths = [
        jq.man
        prev.gojq
      ];
      postBuild = "mv $out/bin/gojq $out/bin/jq";
    };
}
