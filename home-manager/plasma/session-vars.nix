{ pkgs, config, ... }:
# Explicitly source Home Manager session variables for the Plasma session.
#
# Linux does not have a standard user-specific mechanism for setting session
# environment variables. At one point, the `pam_env` module sourced user files,
# but this behavior was deprecated and disabled by default for security reasons.
# Home Manager currently relies on shell initialization files such as
# `~/.profile`, but these are not created unless shell configuration is enabled,
# e.g. `programs.bash.enable`.
#
# Even if shell configuration is enabled, Plasma must be started through a shell
# for those variables to be loaded, and not all display managers do that. I ran
# into this issue with GDM. SDDM, on the other hand, starts user sessions via
# the script specified by `SessionCommand` (see `sddm.conf(5)`), which launches
# the session through a shell. However, relying on shell initialization is still
# insufficient because not all users manage their shell configuration with Home
# Manager.
#
# sources:
# - <https://wiki.archlinux.org/title/Environment_variables#Per_user>
# - <https://github.com/linux-pam/linux-pam/blob/f69a6042da801096c94b30465c118e17c803f5c2/NEWS#L38-L39>
# - <https://github.com/linux-pam/linux-pam/blob/ddab692c8409c9a3b5613bd21638dea404ba4edf/modules/pam_env/pam_env.c#L53>
# - <https://github.com/sddm/sddm/blob/d7f8b0211f63e91195fa4f6560678c3c107bf3d4/data/scripts/wayland-session>
{
  xdg.configFile."plasma-workspace/env/source-hm-session-vars.sh".source =
    pkgs.writeShellScript "source-hm-session-vars.sh" ''
      source ${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh
    '';
}
