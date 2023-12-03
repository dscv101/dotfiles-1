{
  options,
  config,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.hardware.nvidia;
in {
  options.hardware.nvidia = with types; {
    enable = mkBoolOpt false "Enable drivers and patches for Nvidia hardware.";
  };

  config = mkIf cfg.enable {
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.modesetting.enable = true;

    # TODO: production -> stable | when https://github.com/NixOS/nixpkgs/pull/268499 is merged
    hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.production;

    environment.variables = {
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    };
    environment.shellAliases = {nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";};

    # Hyprland settings
    programs.hyprland.enableNvidiaPatches = true;
    environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.
  };
}
