{ lib, pkgs, ... }:
{
  home.shellAliases.tw = "task";
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    # it is possible to use true/false
    # https://github.com/GothenburgBitFactory/libshared/blob/1a06cb4caebdae3c5e58fe83e2fd2211d2959815/src/Configuration.cpp#L316-L320
    config = {
      column.padding = 2;
      bulk = 0;
      nag = null;

      search.case.sensitive = false;
      recurrence.confirmation = true;

      weekstart = "Monday";
      displayweeknumber = false;

      alias.ls = "list";

      report = rec {
        list = {
          sort = [ "entry+" ];
          columns = [
            "id"
            "project"
            "tags"
            "recur"
            "depends.indicator"
            "scheduled"
            "due"
            "until"
            "description"
            "entry.epoch"
          ];
          labels = null;
          filter = toString [
            "+PENDING"
            "-SCHEDULED"

            "-inbox"
            "-maybe"
          ];
        };

        next = {
          inherit (list) labels;
          filter = toString [
            "limit:page"
            "+PENDING"
            "+SCHEDULED"

            "-inbox"
            "-maybe"
          ];
          sort = lib.singleton "scheduled+" ++ list.sort;
          dateformat = "H:N:S";
          columns = [
            "id"
            "scheduled"
            "due"
            "until"
            "project"
            "tags"
            "description"
            "entry.epoch"
          ];
        };

        all = {
          inherit (list) labels;
          columns = [
            "id"
            "status.short"
            "uuid.short"
            "start.active"
            "entry.age"
            "end.age"
            "depends.indicator"
            "priority"
            "project"
            "tags.count"
            "recur.indicator"
            "wait.remaining"
            "scheduled.remaining"
            "due"
            "until.remaining"
            "description"
            "entry.epoch"
          ];
        };

        "in" = {
          inherit (list) sort columns labels;
          filter = toString [
            "+PENDING"

            "+inbox"
            "-maybe"
          ];
        };

        mb = {
          inherit (list) sort columns labels;
          filter = toString [
            "+PENDING"

            "-inbox"
            "+maybe"
          ];
        };
      };
    };
  };
}
