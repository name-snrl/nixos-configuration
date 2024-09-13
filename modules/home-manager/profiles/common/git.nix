{ config, ... }:
{
  programs.git = {
    enable = true;

    userName = "${config.home.username}";
    userEmail = "Demogorgon-74@ya.ru";

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
      push = {
        followtags = true;
        autoSetupRemote = true;
        default = "current";
      };

      remote.pushdefault = "origin";
    };
  };
}
