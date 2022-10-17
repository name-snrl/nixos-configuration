{ config, ... }: {
  programs. git = {
    enable = true;
    config = {
      init.defaultBranch = "master";

      user = {
        name = config.userName;
        email = "Demogorgon-74@ya.ru";
      };

      url = {
        "git@github.com:".pushInsteadOf = "https://github.com/";
        "git@gist.github.com:".pushInsteadOf = "https://gist.github.com/";
      };

      pager.difftool = true;

      diff = {
        tool = "difftastic";
      };

      difftool = {
        prompt = false;
        "difftastic".cmd = ''difft "$LOCAL" "$REMOTE"'';
      };

      alias = {
        st = "status";
        cm = "commit -m";
        cb = "checkout -B";
        dt = "difftool";
      };
    };
  };
}
