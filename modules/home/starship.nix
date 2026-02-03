{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$git_branch:$directory $character ";
      character = {
        format = "[\\$](white)";
      };
      directory = {
        format = "[$path]($style)";
        style = "bold blue";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "bold green";
      };
    };
  };
}
