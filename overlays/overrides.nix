/**
  Overlay that overrides existing packages.
*/
inputs: final: prev: {

  neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${final.system}.neovim;

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

  # TODO https://discourse.nixos.org/t/what-is-the-right-way-to-add-optional-pkgs-to-nixos-binary-cache/37547
  swayfx-unwrapped = prev.swayfx-unwrapped.overrideAttrs (_: {
    __contentAddressed = true;
  });
  openvpn3 = prev.openvpn3.overrideAttrs (_: {
    __contentAddressed = true;
  });

  # TODO push to upstream
  wluma = prev.wluma.overrideAttrs (oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [ prev.pandoc ];

    patches = [ ./0001-don-t-install-bin.patch ];

    postPatch = ''
      substituteInPlace 90-wluma-backlight.rules \
        --replace "/bin/chgrp" "${prev.coreutils}/bin/chgrp" \
        --replace "/bin/chmod" "${prev.coreutils}/bin/chmod"

      substituteInPlace wluma.service \
        --replace "/usr/bin" "$out/bin"
    '';

    postBuild = ''
      # nixpkgs doesn't have marked-man, so create manpages using pandoc
      pandoc --standalone --to man README.md -o "$pname.7"
      gzip "$pname.7"
    '';

    postInstall =
      oa.postInstall
      + ''
        make PREFIX=$out install
      '';
  });

  # https://github.com/flatpak/xdg-desktop-portal-gtk/issues/465
  xdg-desktop-portal-gtk = prev.xdg-desktop-portal-gtk.overrideAttrs (_: {
    postInstall = ''
      substituteInPlace $out/share/xdg-desktop-portal/portals/gtk.portal \
        --replace-fail 'org.freedesktop.impl.portal.Inhibit;' ""
    '';
  });

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

  swayimg =
    with final;
    let
      swim-wp = writeShellApplication {
        name = "swim-wp";
        runtimeInputs = [ gnused ];
        text = ''
          exec ${prev.swayimg}/bin/swayimg \
              --fullscreen \
              --config=list.all=no \
              --config=viewer.antialiasing=yes \
              --config=keys.viewer.e='exec sed -i "s@output.*fill@output \* bg % fill@g" ~/.config/sway/config' \
              ${wallpapers}
        '';
      };
      desktop = makeDesktopItem {
        desktopName = "Swayimg-wallpapers";
        name = "swim-wp";
        exec = "${swim-wp}/bin/swim-wp";
        categories = [
          "Graphics"
          "Viewer"
        ];
        icon = "swayimg";
      };
      wallpapers = lib.concatStringsSep " " (
        lib.forEach (lib.importJSON ./wallhaven-collection.json) (data: (fetchurl data))
      );
    in
    symlinkJoin {
      name = "swayimg";
      paths = [
        prev.swayimg
        swim-wp
        desktop
      ];
      postBuild = "ln -s $out/bin/swayimg $out/bin/swim";
    };

  graphite-gtk-theme = prev.graphite-gtk-theme.overrideAttrs (_: {
    __contentAddressed = true;

    version = "flake";
    src = inputs.graphite-gtk;

    installPhase = ''
      runHook preInstall

      patchShebangs install.sh
      name= ./install.sh \
        --size compact \
        --tweaks darker nord rimless \
        --dest $out/share/themes

      jdupes --quiet --link-soft --recurse $out/share

      runHook postInstall
    '';
  });

  graphite-kde-theme = prev.graphite-kde-theme.overrideAttrs (_: {
    __contentAddressed = true;

    version = "flake";
    src = inputs.graphite-kde;
    propagatedUserEnvPkgs = [ ];

    installPhase = ''
      runHook preInstall

      patchShebangs install.sh
      substituteInPlace install.sh \
        --replace '$HOME/.local' $out \
        --replace '$HOME/.config' $out/share
      name= ./install.sh --theme nord --rimless

      runHook postInstall
    '';
  });
}
