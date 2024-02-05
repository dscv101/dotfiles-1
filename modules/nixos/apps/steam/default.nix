{
  options,
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.steam;
in {
  options.apps.steam = with types; {
    enable = mkBoolOpt false "Enable or disable steam";
  };

  config = mkIf cfg.enable {
    programs.steam.enable = true;
    programs.steam.remotePlay.openFirewall = true;

    environment.systemPackages = [
      pkgs.steam
      (pkgs.makeDesktopItem {
        name = "Steam (Gamepad UI)";
        desktopName = "Steam (Gamepad UI)";
        genericName = "Application for managing and playing games on Steam.";
        categories = ["Network" "FileTransfer" "Game"];
        type = "Application";
        icon = "steam";
        exec = "steamos";
        terminal = false;
      })

      (pkgs.writeShellScriptBin "steamos" ''
        gamescope -F nis -h 720 -H 1080 -b -f -e --adaptive-sync -r 60 --expose-wayland -- steam -gamepadui -steamdeck -steamos -fulldesktopres -tenfoot
      '')
    ];

    services.xserver.windowManager.session = [
      {
        name = "Console";
        start = ''
          steamos
        '';
      }
    ];

    home.persist.directories = [
      ".local/share/Steam"
      ".steam"

      ".local/share/Terraria"
    ];
  };
}
