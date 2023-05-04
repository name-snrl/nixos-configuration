{ pkgs, inputs, ... }: {
  imports = [ inputs.shlyupa.nixosModules.metric-compatible-fonts ];
  fonts = {
    enableDefaultFonts = false;
    fonts = with pkgs; [
      exo2
      jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      unifont
      symbola
      joypixels
      nerd-fonts-symbols
    ];
    fontconfig.crOSMaps = true;
    fontconfig.defaultFonts = {
      monospace = [
        "JetBrains Mono NL Light"
        "Symbols Nerd Font"
        "Noto Sans Mono CJK JP"
      ];
      sansSerif = [
        "Exo 2"
        "Noto Sans CJK JP"
        "Symbols Nerd Font"
      ];
      serif = [
        "Tinos"
        "Noto Serif CJK JP"
        "Symbols Nerd Font"
      ];
      emoji = [ "JoyPixels" ];
    };
  };
}
