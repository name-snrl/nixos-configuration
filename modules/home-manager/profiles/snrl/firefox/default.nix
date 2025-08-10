{ lib, config, ... }:
let
  mergeValues = xs: lib.mergeAttrsList (lib.attrValues xs);
  lock = Value: {
    inherit Value;
    Status = "locked";
  };
  default = Value: {
    inherit Value;
    Status = "default";
  };
in
{
  programs.firefox = {
    enable = true;
    profiles.${config.home.username} = {
      isDefault = true;
      userChrome =
        # turn off that stupid flash when the page starts loading
        ''
          #browser vbox#appcontent tabbrowser,
          #content,
          #tabbrowser-tabpanels,
          browser[type="content-primary"],
          browser[type="content"] > html {
            background-color:  -moz-Dialog !important;
          }
        ''
        # don't show a window with a microphone indicator or any other webrtc stuff
        + ''
          #webrtcIndicator {
            display: none;
          }
        ''
        # normal colors for the toolbar when switching to a dark theme
        # https://bugzilla.mozilla.org/show_bug.cgi?id=1711275
        + ''
          #nav-bar.browser-toolbar {
            background-color:  transparent !important;
          }
        '';
      # wp sources:
      # https://www.instagram.com/deathandmilk_/
      # https://www.artstation.com/maciej
      userContent = ''
        @-moz-document url("about:home"),
                       url("about:newtab"),
                       url("about:privatebrowsing") {
          body {
            background-color:        -moz-Dialog !important;
            background-image:   url(${./wp.png}) !important;
            background-position:          center !important;
            background-size:                 30% !important;
            background-repeat:         no-repeat !important;
          }
        }
      '';
      # things than can't be set in policies
      settings = mergeValues {
        # https://searchfox.org/mozilla-release/source/modules/libpref/init/StaticPrefList.yaml
        # https://searchfox.org/mozilla-release/source/modules/libpref/init/all.js
        # https://searchfox.org/mozilla-release/source/browser/app/profile/firefox.js
        misc = {
          "full-screen-api.warning.timeout" = 0;
          "findbar.highlightAll" = true; # highlight all matches when searching the page
          "sidebar.revamp" = false; # hide sidebar
          "browser.uiCustomization.state" = {
            currentVersion = 22;
            placements = {
              TabsToolbar = [
                "tabbrowser-tabs"
                "alltabs-button"
              ];
              nav-bar = [
                "customizableui-special-spring11"
                "customizableui-special-spring19"
                "back-button"
                "forward-button"
                "stop-reload-button"
                "history-panelmenu"
                "urlbar-container"
                "fxa-toolbar-menu-button"
                "sync-button"
                "customizableui-special-spring20"
                "customizableui-special-spring12"
                "save-to-pocket-button"
                "downloads-button"
                "unified-extensions-button"
                "reset-pbm-toolbar-button"
              ];
            };
          };
          "privacy.donottrackheader.enabled" = true;
        };
        telemetry = {
          # disable experiments or studies
          # https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections#w_mozilla-content
          "messaging-system.rsexperimentloader.enabled" = false;
          "app.normandy.enabled" = false;
          # disable additional telemetry
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.server_owner" = "";
          "toolkit.telemetry.unified" = false;
        };
      };
    };
    policies = {
      DisableForgetButton = true; # I fucked up once, don't want again
      # TODO https://nix-community.github.io/home-manager/options.xhtml#opt-programs.firefox.profiles._name_.extensions
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          default_area = "menupanel";
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        "simple-translate@sienori" = {
          default_area = "menupanel";
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/simple-translate/latest.xpi";
        };
        # vimium
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          default_area = "menupanel";
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
        };
        # dark bg and light text
        "jid1-QoFqdK4qzUfGWQ@jetpack" = {
          default_area = "menupanel";
          installation_mode = "normal_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/dark-background-light-text/latest.xpi";
        };
      };
      FirefoxHome = {
        Search = false;
        TopSites = false;
        Highlights = false;
        Locked = true;
      };
      Preferences = mergeValues {
        main = {
          # urlbar settings
          "browser.urlbar.trimURLs" = lock false;
          "network.IDN_show_punycode" = lock true;
          # downloads
          "browser.download.always_ask_before_handling_new_types" = lock true;
          "browser.download.start_downloads_in_tmp_dir" = lock true;
          # warnings
          "browser.aboutConfig.showWarning" = lock false;
          "browser.warnOnQuitShortcut" = lock false;
          # disable recommendations in about:addons' Extensions and Themes panes
          "extensions.htmlaboutaddons.recommendations.enabled" = lock false;
          "extensions.htmlaboutaddons.discover.enabled" = lock false;
          # misc
          "browser.startup.page" = default 3; # resume the previous browser session
          "browser.translations.enable" = lock false;
          "browser.fullscreen.autohide" = lock false; # hide toolbar when browser window fullscreened
          "browser.toolbars.bookmarks.visibility" = lock "never";
          "browser.link.open_newwindow.restriction" = lock 0; # always open in new tab not window
          "ui.key.menuAccessKeyFocuses" = lock false; # disable alt key toggling the menu bar
        };

        appearance = {
          "layout.css.prefers-color-scheme.content-override" = lock 2; # use system theme (light/dark)
          "toolkit.legacyUserProfileCustomizations.stylesheets" = lock true; # enable chrome/userC{hrome,ontent}.css
          "browser.tabs.inTitlebar" = lock 0; # on sway we can disable titelbar. this setting helps to hide minimize/close buttons as well
        };

        extensions = {
          "extensions.webextensions.keepStorageOnUninstall" = lock false;
          "extensions.webextensions.keepUuidOnUninstall" = lock false;
          "extensions.autoDisableScopes" = lock 0;
        };

        performance = {
          "browser.preferences.defaultPerformanceSettings.enabled" = lock false;
          "dom.ipc.processCount" = lock 4;
          "browser.tabs.unloadOnLowMemory" = lock true;
        };

        network = {
          # DNS
          "network.trr.mode" = lock 3;
          "network.trr.uri" = lock "https://dns.nextdns.io/168f8d";
        };

        privacy = {
          "network.prefetch-next" = lock false; # disable link prefetching
          # click tracking
          "browser.send_pings" = lock false;
          "browser.send_pings.require_same_host" = lock true;
          # disable video statistics
          "media.video_stats.enabled" = lock false;
          # disable giving away network info
          "dom.netinfo.enabled" = lock false;
        };

        telemetry = {
          # disable crash reports
          "browser.tabs.crashReporting.sendReport" = lock false;
          "browser.crashReports.unsubmittedCheck.enabled" = lock false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = lock false;
          # web compatibility reporter
          "extensions.webcompat-reporter.enabled" = lock false;
        };
      };
    };
  };
}
