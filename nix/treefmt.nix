{ flake-parts-lib, ... }:
{
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    {
      pkgs,
      lib,
      config,
      system,
      ...
    }:
    {
      treefmt = {
        programs.nixfmt = {
          enable = true;
          strict = true;
        };
      };
    }
  );
}
