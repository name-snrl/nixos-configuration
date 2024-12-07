{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      jetbrains-mono
      noto-fonts-lgc-plus
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
    fontconfig.defaultFonts = {
      monospace = [
        "JetBrains Mono NL Light"
        "Noto Sans Mono CJK JP"
        "Symbols Nerd Font Mono"
        "Twitter Color Emoji"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK JP"
        "Symbols Nerd Font"
        "Twitter Color Emoji"
      ];
      serif = [
        "Noto Serif"
        "Noto Serif CJK JP"
        "Symbols Nerd Font"
        "Twitter Color Emoji"
      ];
      emoji = [ "Twitter Color Emoji" ];
    };
  };
}
