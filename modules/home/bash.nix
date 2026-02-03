{ ... }:
{
  programs = {
    bash = {
      enable = true;
      shellOptions = [
        "globstar"
        "histreedit"
        "extglob"
      ];
    };
  };
}
