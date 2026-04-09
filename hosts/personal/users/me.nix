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
    ssh = {
      matchBlocks = {
        "oyasai.io" = {
          user = "oyasai";
          identityFile = config.sops.secrets.id_ed25519_oyasai.path;
        };
      };
    };
  };
}
