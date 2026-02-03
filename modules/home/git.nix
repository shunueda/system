{ ... }:
{
  programs.git = {
    enable = true;
    settings = {
      init = {
        defaultBranch = "master";
      };
      user = {
        name = "Shun Ueda";
        email = "me@shu.nu";
      };
      diff.algorithm = "histogram";
      rebase = {
        autosquash = true;
        autostash = true;
        stat = true;
      };
      merge.directoryRenames = true;
      rerere = {
        autoupdate = true;
        enabled = true;
      };
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };
}
