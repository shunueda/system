{
  inputs = {
    # keep-sorted start block=yes
    direnv-instant = {
      url = "github:mic92/direnv-instant";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.flake-parts.follows = "flake-parts";
    };
    # Patch for emacs-direnv that doesn't block the editor while loading
    emacs-direnv-async = {
      url = "github:wbolster/emacs-direnv/pull/82/head";
      flake = false;
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    majutsu = {
      url = "github:0wd0/majutsu";
      flake = false;
    };
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # For flakeModules for darwinModules and darwinConfigurations
    nix-darwin-flake-module = {
      url = "github:nix-darwin/nix-darwin/pull/1690/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-steam.url = "github:nixos/nixpkgs/pull/499915/head";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nocommit = {
      url = "github:shunueda/nocommit";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
    tools = {
      url = "github:anteriorcore/tools";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # keep-sorted end
  };
  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        # keep-sorted start
        ./hosts/anterior/darwin-configuration.nix
        ./hosts/personal/darwin-configuration.nix
        ./modules/darwin/common.nix
        ./modules/darwin/linux-builder.nix
        ./modules/home/common.nix
        ./modules/home/ghq.nix
        ./modules/home/qutebrowser.nix
        ./modules/home/screen.nix
        ./nix/misc.nix
        ./nix/treefmt.nix
        inputs.home-manager.flakeModules.home-manager
        inputs.nix-darwin-flake-module.flakeModules.default
        inputs.tools.flakeModules.checkBuildAll
        inputs.treefmt-nix.flakeModule
        # keep-sorted end
      ];
    };
}
