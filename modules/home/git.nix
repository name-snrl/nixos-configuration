{ config, ... }: {
  programs. git = {
    enable = true;
    config = {
      init.defaultBranch = "master";

      user = {
        name = config.users.users.default.name;
        email = "Demogorgon-74@ya.ru";
      };

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
      };
    };
  };
}
