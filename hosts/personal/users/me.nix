{
  self,
  config,
  pkgs,
  ...
}:
{
  imports = [ self.homeModules.common ];

  home.packages = with pkgs; [ prismlauncher ];

  programs = {
    discord.enable = true;
  };
}
