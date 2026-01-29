{ inputs, self, ... }:
let
  user = "me"; # TODO from config
in
{
  flake = {
    darwinConfigurations =
      let
        darwinModules = {
          common =
            { pkgs, ... }:
            {
              imports = [
                inputs.home-manager.darwinModules.home-manager
                self.darwinModules.common
              ];
              home-manager.users.${user} = { };
            };
          linux-builder =
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
            };
          personal =
            { pkgs, ... }:
            {
              home-manager.users.${user} =
                { config, ... }:
                {
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
                };
            };
          anterior =
            { ... }:
            {
              home-manager.users.${user} =
                { ... }:
                {
                  imports = [ ../programs/ensure-jupyter-no-output.nix ];
                  programs = {
                    ensure-jupyter-no-output.enable = true;
                  };
                };
            };
        };
      in
      {
        personal = inputs.nix-darwin.lib.darwinSystem {
          modules =
            with darwinModules {
              user = "me";
              system = "aarch64-darwin";
            }; [
              common
              personal
            ];
        };
        anterior = inputs.nix-darwin.lib.darwinSystem {
          modules =
            with darwinModules {
              user = "me";
              system = "aarch64-darwin";
            }; [
              common
              linux-builder
              anterior
            ];
        };
      };
  };
}
