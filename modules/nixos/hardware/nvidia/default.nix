  #config = mkIf cfg.enable {
    #services.xserver.videoDrivers = ["nvidia"];
    #};

   # environment.shellAliases = {nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";};

    
{
  config,
  lib,
  pkgs,
  namespace,
  options,
  ...
}:
let
  inherit (lib) mkDefault mkIf versionOlder;
  inherit (lib.${namespace}) mkBoolOpt;
  cfg = config.${namespace}.hardware.nvidia;

  # use the latest possible nvidia package
  nvStable = config.boot.kernelPackages.nvidiaPackages.stable.version;
  nvBeta = config.boot.kernelPackages.nvidiaPackages.beta.version;

  nvidiaPackage =
    if (versionOlder nvBeta nvStable) then
      config.boot.kernelPackages.nvidiaPackages.stable
    else
      config.boot.kernelPackages.nvidiaPackages.beta;
in
{
  options.${namespace}.hardware.nvidia = {
    enable = mkBoolOpt false "Whether or not to enable support for nvidia.";
  };

  config = mkIf cfg.enable {
    boot.blacklistedKernelModules = [ "nouveau" ];

    environment.systemPackages = with pkgs; [
      nvfancontrol

      nvtopPackages.nvidia

      # mesa
      mesa

      # vulkan
      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];

    hardware = {
      nvidia =  {
        package = mkDefault nvidiaPackage;
        modesetting.enable = mkDefault true;

        powerManagement = {
          enable = mkDefault true;
          finegrained = mkDefault false;
        };

        open = mkDefault true;
        nvidiaSettings = false;
        nvidiaPersistenced = true;
        forceFullCompositionPipeline = true;
      };

      graphics = {
        extraPackages = with pkgs; [ nvidia-vaapi-driver ];
        extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
      };

      # Hyprland settings
      environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor rendering issue on wlr nvidia.

      environment.shellAliases = {nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";};
    };
  };
}
