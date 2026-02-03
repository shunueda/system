{ pkgs, ... }:
let
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
  home.packages = [ ensure-jupyter-no-output ];
}
