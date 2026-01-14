{ flake-parts-lib, ... }:
{
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    { ... }:
    {
      treefmt = {
        programs = {
          keep-sorted = {
            enable = true;
          };
          nixfmt = {
            enable = true;
            strict = true;
          };
        };
      };
    }
  );
}
