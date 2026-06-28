{ lib, pkgs, ... }:
{
  # force configuration, to prevent additional settings, by DEs
  fonts = lib.mkForce {
    packages = with pkgs; [
      jetbrains-mono
      paratype-pt-sans
      paratype-pt-serif
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      twitter-color-emoji
      nerd-fonts.symbols-only

      # unicode coverage
      unifont
      symbola

      # metric-compatible fonts
      gyre-fonts
      caladea
      carlito
    ];
    fontconfig = {
      includeUserConf = false;
      defaultFonts = {
        monospace = [
          "JetBrains Mono NL Light"
          "Noto Sans Mono CJK JP"
          "Symbols Nerd Font Mono"
          "Twitter Color Emoji"
        ];
        sansSerif = [
          "PT Sans"
          "Noto Sans CJK JP"
          "Symbols Nerd Font"
          "Twitter Color Emoji"
        ];
        serif = [
          "PT Serif"
          "Noto Serif CJK JP"
          "Symbols Nerd Font"
          "Twitter Color Emoji"
        ];
        emoji = [ "Twitter Color Emoji" ];
      };
    };
  };
}
