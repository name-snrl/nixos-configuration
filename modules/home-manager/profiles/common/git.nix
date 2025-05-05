{
  programs.git = {
    enable = true;

    aliases = {
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
    };

    aliases.lg = "log --graph";
    aliases.l = "log --graph --pretty='%C(bold yellow)%h%Creset * %C(bold magenta)%an%Creset * %C(blue)%cr%Creset: %s %C(auto)%d%Creset'";
    extraConfig.format.pretty = "format:%C(bold yellow)%h%Creset * %C(bold magenta)%an%Creset * %C(blue)%ci%Creset *%C(auto)%d%Creset%n%n%B";

    # some hacks for large repos
    # https://www.git-scm.com/docs/partial-clone
    aliases.au-promisor = "!git remote add upstream \"$@\" && shift \"$#\" && git fetch --filter=blob:none upstream";
    aliases.clone-promisor = "clone --filter=blob:none --no-checkout";
    extraConfig.clone.filterSubmodules = true;

    extraConfig = {
      init.defaultBranch = "master";

      url = {
        "git@github.com:".pushInsteadOf = "https://github.com/";
        "git@gist.github.com:".pushInsteadOf = "https://gist.github.com/";
      };

      diff.algorithm = "patience";
      diff.tool = "difftastic";
      difftool."difftastic".cmd = ''difft "$LOCAL" "$REMOTE"'';
      difftool.prompt = false;
      pager.difftool = true;

      merge.conflictStyle = "zdiff3";
      merge.autoStash = true;
      rebase.autoStash = true;
      commit.verbose = true;

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
      push = {
        followtags = true;
        autoSetupRemote = true;
        default = "current";
      };

      remote.pushdefault = "origin";
    };
  };
}
