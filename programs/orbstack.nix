{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.orbstack;
in
{
  options.programs.orbstack = {
    enable = lib.mkEnableOption "Fast, light, and easy way to run Docker containers and Linux machines";

    package = lib.mkPackageOption pkgs "orbstack" { nullable = true; };
  };
  config = lib.mkIf cfg.enable { home.packages = lib.mkIf (cfg.package != null) [ cfg.package ]; };
}
