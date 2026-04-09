{ ... }:
{
  perSystem.treefmt = {
    programs = {
      # keep-sorted start block=yes
      autocorrect.enable = true;
      keep-sorted.enable = true;
      nixfmt = {
        enable = true;
        strict = true;
      };
      typos.enable = true;
      yamlfmt = {
        enable = true;
        settings.formatter = {
          type = "basic";
          retain_line_breaks_single = true;
          scan_folded_as_literal = true;
          line_ending = "lf";
        };
      };
      # keep-sorted end
    };
  };
}
