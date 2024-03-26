{ config, ... }:
{
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "master";

      user = {
        name = config.users.users.default.name;
        email = "Demogorgon-74@ya.ru";
      };

      clone.filterSubmodules = true;

      url = {
        "git@github.com:".pushInsteadOf = "https://github.com/";
        "git@gist.github.com:".pushInsteadOf = "https://gist.github.com/";
      };

      pager.difftool = true;

      merge.conflictStyle = "zdiff3";

      diff = {
        tool = "difftastic";
        algorithm = "patience";
      };

      difftool = {
        prompt = false;
        "difftastic".cmd = ''difft "$LOCAL" "$REMOTE"'';
      };

      merge.autoStash = true;
      rebase.autoStash = true;
      commit.verbose = true;
      format.pretty = "format:%C(bold yellow)%h%Creset * %C(bold magenta)%an%Creset * %C(blue)%ci%Creset *%C(auto)%d%Creset%n%n%B";

      push = {
        followtags = true;
        autoSetupRemote = true;
        default = "current";
      };

      remote.pushdefault = "origin";

      alias = {
        st = "status";
        cm = "commit";
        sw = "switch";
        dt = "difftool";
        fx = "commit --fixup";
        au = "remote add -f upstream";
        rb = "rebase --autosquash --interactive";
        prb = "pull --rebase";
        cb = "switch -c";
        bd = "branch -D";
        lg = "log --graph";
        l = "log --graph --pretty='%C(bold yellow)%h%Creset * %C(bold magenta)%an%Creset * %C(blue)%cr%Creset: %s %C(auto)%d%Creset'";
        # no blobs and no checkout, because checkout has been taught to bulk
        # pre-fetch all required missing blobs in a single batch
        clone-big = "clone --filter=blob:none --no-checkout";
      };
    };
  };
}
