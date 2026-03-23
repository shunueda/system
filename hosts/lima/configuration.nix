{ flake, ... }:
let
  user = "me";
in
{
  imports = [ flake.modules.nixos.common ];
  nixpkgs.hostPlatform = "aarch64-linux";

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
  fileSystems."/Users/me" = {
    device = "none";
    fsType = "virtiofs";
    options = [ "defaults" ];
  };
  fileSystems."/mnt/lima-cidata" = {
    device = "none";
    fsType = "virtiofs";
    options = [
      "defaults"
      "ro"
    ];
  };

  boot.loader.grub.devices = [ "/dev/sda" ];

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = [ "wheel" ];
  };

  security.sudo.enable = true;

  system.stateVersion = "25.11";
  home-manager.users.${user}.home.stateVersion = "25.11";
}
