{ lib, inputs, ... }:
{
  flake = {
    darwinConfigurations =
      let
        darwinModules =
          { user, system }:
          {
            common =
              { pkgs, ... }:
              {
                imports = [ inputs.home-manager.darwinModules.home-manager ];
                nix = {
                  settings.experimental-features = [
                    "nix-command"
                    "flakes"
                  ];
                  gc.automatic = true;
                };
                nixpkgs = {
                  hostPlatform = system;
                  config.allowUnfree = true;
                };
                users.knownUsers = [ user ];
                users.users.${user} = {
                  uid = 501;
                  home = "/Users/${user}";
                  shell = pkgs.bash;
                };
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                system = {
                  primaryUser = user;
                  stateVersion = 6;
                  defaults = {
                    LaunchServices.LSQuarantine = false;
                    NSGlobalDomain = {
                      AppleShowAllExtensions = true;
                      KeyRepeat = 1;
                      InitialKeyRepeat = 15;
                    };
                    WindowManager.StandardHideWidgets = true;
                    dock = {
                      show-recents = false;
                      autohide = true;
                      orientation = "bottom";
                      tilesize = 32;
                      static-only = true;
                    };
                  };
                  keyboard = {
                    enableKeyMapping = true;
                    remapCapsLockToControl = true;
                  };
                };
                security.pam.services.sudo_local.touchIdAuth = true;
                home-manager.users.${user} =
                  { config, ... }:
                  {
                    imports = [
                      ../programs/homerow.nix
                      inputs.sops-nix.homeManagerModules.sops
                      inputs.nocommit.homeModules.default
                    ];
                    xdg.enable = true;
                    programs = {
                      # keep-sorted start block=yes
                      bash = {
                        enable = true;
                        shellOptions = [
                          "globstar"
                          "histreedit"
                          "extglob"
                        ];
                        historyControl = [
                          "ignorespace"
                          "ignoredups"
                        ];
                        historySize = 1000000;
                        historyFileSize = 1000000;
                        historyFile = "${config.home.homeDirectory}/.sh_history";
                      };
                      emacs = {
                        enable = true;
                        extraPackages =
                          epkgs: with epkgs; [
                            avy
                            corfu
                            editorconfig
                            exec-path-from-shell
                            fzf
                            git-gutter
                            magit
                            nix-ts-mode
                            ocaml-eglot
                            treesit-grammars.with-all-grammars
                            tuareg
                            undo-tree
                            vertico
                            zenburn-theme
                          ];
                      };
                      fzf.enable = true;
                      ghostty = {
                        enable = true;
                        package = pkgs.ghostty-bin;
                        settings = {
                          auto-update = "off";
                          link-previews = true;
                          mouse-hide-while-typing = true;
                          window-save-state = "always";
                        };
                      };
                      git = {
                        enable = true;
                        settings = {
                          init = {
                            defaultBranch = "master";
                          };
                          user = {
                            name = "Shun Ueda";
                            email = "me@shu.nu";
                          };
                          diff.algorithm = "histogram";
                          rebase = {
                            autosquash = true;
                            autostash = true;
                            stat = true;
                          };
                          merge.directoryRenames = true;
                          rerere = {
                            autoupdate = true;
                            enabled = true;
                          };
                          pull.rebase = true;
                          push.autoSetupRemote = true;
                        };
                      };
                      home-manager.enable = true;
                      homerow.enable = true;
                      mergiraf.enable = true;
                      nocommit.enable = true;
                      ssh = {
                        enable = true;
                        enableDefaultConfig = false;
                        matchBlocks = {
                          "github.com" = {
                            user = "git";
                            identityFile = config.sops.secrets.id_ed25519_github.path;
                          };
                        };
                      };
                      starship = {
                        enable = true;
                        settings = {
                          add_newline = false;
                          format = "$git_branch:$directory $character ";
                          character = {
                            format = "[\\$](white)";
                          };
                          directory = {
                            format = "[$path]($style)";
                            style = "bold blue";
                          };
                          git_branch = {
                            format = "[$branch]($style)";
                            style = "bold green";
                          };
                        };
                      };
                      zoxide.enable = true;
                      # keep-sorted end
                    };
                    fonts.fontconfig.enable = true;
                    home = {
                      username = user;
                      stateVersion = "25.11";
                      packages = with pkgs; [
                        age
                        gnupg
                        jetbrains-mono
                        maccy
                        nixd
                        ocamlPackages.ocaml-lsp
                        sops
                        typescript-language-server
                      ];
                      file = {
                        ".emacs.d" = {
                          source = ../.emacs.d;
                          recursive = true;
                        };
                        ".hushlogin" = {
                          text = "";
                        };
                      };
                      sessionVariables = {
                        EDITOR = "emacs";
                      };
                    };
                    sops = {
                      age = {
                        keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
                        sshKeyPaths = [ ];
                      };
                      gnupg.sshKeyPaths = [ ];
                      defaultSopsFile = ../secrets.yaml;
                      secrets = {
                        id_ed25519_github = { };
                        id_ed25519_oyasai = { };
                      };
                    };
                    # https://github.com/Mic92/sops-nix/issues/890
                    launchd.agents.sops-nix = pkgs.lib.mkIf pkgs.stdenv.isDarwin {
                      enable = true;
                      config = {
                        EnvironmentVariables = {
                          PATH = pkgs.lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";
                        };
                      };
                    };
                  };
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
