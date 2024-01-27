{ config, ... }: {
  programs. git = {
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
      push.autoSetupRemote = true;

      diff = {
        tool = "difftastic";
      };

      difftool = {
        prompt = false;
        "difftastic".cmd = ''difft "$LOCAL" "$REMOTE"'';
      };

      alias = {
        st = "status";
        cm = "commit -v";
        cb = "checkout -b";
        dt = "difftool";
        mg = "merge --squash";
        lg = "log --stat";
        # no blobs and no checkout, because checkout has been taught to bulk
        # pre-fetch all required missing blobs in a single batch
        clone-big = "clone --filter=blob:none --no-checkout";
      };
    };
  };
}
