{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.stack;
in
{
  options.programs.slack = {
    enable = lib.mkEnableOption "Desktop client for Slack";

    package = lib.mkPackageOption pkgs "slack" { nullable = true; };
  };
  config = lib.mkIf cfg.enable { home.packages = lib.mkIf (cfg.package != null) [ cfg.package ]; };
}
