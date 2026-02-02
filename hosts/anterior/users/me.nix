{ ... }:
{
  imports = [ ../../programs/ensure-jupyter-no-output.nix ];
  programs = {
    ensure-jupyter-no-output.enable = true;
  };
}
