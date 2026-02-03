{ flake, ... }:
{
  imports = with flake.modules.home; [
    common
    ensure-jupyter-no-output
  ];
  programs = {
    ensure-jupyter-no-output.enable = true;
  };
}
