{ ... }:
{
  perSystem =
    { lib, pkgs, ... }:
    {
      packages = lib.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (pkgs // pkgs.emacsPackages);
        directory = ../packages;
      };
    };
}
