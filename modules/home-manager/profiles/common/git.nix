{
  programs.git = {
    enable = true;
    settings = {
      init.defaultBranch = "master";

      url = {
        "git@github.com:".pushInsteadOf = "https://github.com/";
        "git@gist.github.com:".pushInsteadOf = "https://gist.github.com/";
      };

      alias = {
        st = "status";
        cm = "commit";
        sw = "switch";
        df = "diff";
        fx = "commit --fixup";
        rb = "rebase --autosquash --interactive";
        prb = "pull --rebase";
        cb = "switch -c";
        bd = "branch -D";
      };

      alias.l = "log --graph --pretty='%C(bold yellow)%h%Creset * %C(bold magenta)%an%Creset * %C(blue)%cr%Creset: %s %C(auto)%d%Creset'";
      alias.lg = "log --graph";
      format.pretty = "format:%C(bold yellow)%h%Creset * %C(bold magenta)%an%Creset * %C(blue)%ci%Creset *%C(auto)%d%Creset%n%n%B";

      diff.algorithm = "patience";
      # don't forget to use `--ext-diff` with commands like log, show, stash,
      # and other to get syntax diffs, and `--no-ext-diff` with diff if you want
      # standard diff
      diff.external = "difft";
      merge.conflictStyle = "zdiff3";

      # some hacks for large repos
      # https://www.git-scm.com/docs/partial-clone
      alias.au-promisor = "!git remote add upstream \"$@\" && shift \"$#\" && git fetch --filter=blob:none upstream";
      alias.clone-promisor = "clone --filter=blob:none --no-checkout";
      clone.filterSubmodules = true;

      # triangular workflow
      #
      # 1. clone your fork
      # 2. configure upstream using git au/au-promisor aliases, see above
      # 3. on branch createion branch off from upstream:
      #    `git cb <new_name> upstream/master`
      #
      # now you will push to origin and pull from upstream by default. this
      # makes it easier to stay in sync with upstream, while still pushing your
      # changes to origin
      alias.au = "remote add -f upstream";
      remote.pushdefault = "origin";
      push.autoSetupRemote = true;
      push.default = "current";

      # other
      push.followtags = true;
      merge.autoStash = true;
      rebase.autoStash = true;
      commit.verbose = true;
    };
  };
}
