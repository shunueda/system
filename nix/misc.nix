{ ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      inputs',
      ...
    }:
    {
      packages = {
        inherit (inputs'.tools.packages) nix-flake-check-changed nix-grep-to-build;
      }
      // lib.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (pkgs // pkgs.emacsPackages);
        directory = ../packages;
      };
    };
}
