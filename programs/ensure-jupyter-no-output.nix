{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ensure-jupyter-no-output;

  ensure-jupyter-no-output = pkgs.writeShellApplication {
    name = "ensure-jupyter-no-output";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      nbstripout
    ];
    text = ''
      failures="''$(mktemp)"
      trap 'rm -f "''$failures"' EXIT
      find . -name "*.ipynb" -exec nbstripout --verify {} + | tee -a "''$failures"
      if [[ -s "''$failures" ]]; then
        echo "the above notebook files have output which must be removed with e.g. nbstripout."
        exit 1
      fi
    '';
  };
in
{
  options.programs.ensure-jupyter-no-output = {
    enable = lib.mkEnableOption "Ensure no jupyter notebook output";
  };
  config = lib.mkIf cfg.enable { home.packages = [ ensure-jupyter-no-output ]; };
}
