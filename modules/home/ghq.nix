{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ghq;
in
{
  options.programs.ghq = {
    enable = lib.mkEnableOption "ghq";
    package = lib.mkPackageOption pkgs "ghq" { };
    settings = {
      root = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    programs.git.settings = lib.mkIf (cfg.settings.root != null) {
      ghq.root = cfg.settings.root;
    };
  };
}
