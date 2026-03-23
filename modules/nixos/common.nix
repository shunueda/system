{ inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  nix = {
    settings = {
      allow-import-from-derivation = false;
      experimental-features = [
        "nix-command"
        "flakes"
        "ca-derivations"
        "dynamic-derivations"
      ];
      sandbox = true;
    };
    gc.automatic = true;
  };
  nixpkgs.config.allowUnfree = true;
}
