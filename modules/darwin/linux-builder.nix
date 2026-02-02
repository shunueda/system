{ lib, ... }:
{
  nix = {
    linux-builder = {
      enable = true;
      ephemeral = true;
      systems = lib.platforms.linux;
      config.boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
      config.virtualisation.cores = 6;
      config.virtualisation.memorySize = lib.mkForce 12000;
      config.virtualisation.diskSize = lib.mkForce (100 * 1000);
      maxJobs = 12;
    };
    settings.trusted-users = [ "@admin" ];
  };
}
