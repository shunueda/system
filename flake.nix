{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nocommit = {
      url = "github:shunueda/nocommit";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    systems.url = "github:nix-systems/default";
  };
  outputs =
    {
      flake-parts,
      home-manager,
      systems,
      treefmt-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import systems;
      imports = [
        ./nix/darwin-configurations.nix
        ./nix/treefmt.nix

        ./modules/darwin/common.nix
        treefmt-nix.flakeModule
        home-manager.flakeModules.home-manager
      ];

      homeModules = {};

      homeConfigurations = {};

      darwinModules = {
        common = {
          nix = {};
          system = {};
        };
      };

      darwinConfigurations = {
        personal = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            self.darwinModules.common
            self.darwinModules.personal
          ];
        };
        anterior = inputs.nix-darwin.lib.darwinSystem {
          modules = [
            self.darwinModules.common
            self.darwinModules.linux-builder
            self.darwinModules.anterior
          ];
        };
      };
    };
}
