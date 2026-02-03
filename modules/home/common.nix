{
  flake,
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    inputs.nocommit.homeModules.default
  ]
  ++ (with flake.modules.home; [
    bash
    emacs
    ensure-jupyter-no-output
    ghostty
    git
    homerow
    ssh
    starship
  ]);
  xdg.enable = true;
  programs = {
    # keep-sorted start block=yes
    fzf.enable = true;
    home-manager.enable = true;
    mergiraf.enable = true;
    nocommit.enable = true;
    zoxide.enable = true;
    # keep-sorted end
  };
  fonts.fontconfig.enable = true;
  home = {
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
        source = ../../.emacs.d;
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
    defaultSopsFile = ../../secrets/default.yaml;
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
}
