{ config, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "github.com" = {
        user = "git";
        identityFile = config.sops.secrets.id_ed25519_github.path;
      };
    };
  };
}
