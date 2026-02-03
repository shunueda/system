{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    settings = {
      auto-update = "off";
      link-previews = true;
      mouse-hide-while-typing = true;
      window-save-state = "always";
    };
  };
}
