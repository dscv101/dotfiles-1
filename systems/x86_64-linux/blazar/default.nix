{ lib
, pkgs
, ...
}: {
  imports = [ ./hardware-configuration.nix 
              "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module
              ./disks.nix
  ];

  # Enable Bootloader
  system.boot.efi.enable = true;

  suites.desktop.enable = true;
  suites.development.enable = true;

  hardware.nvidia.enable = true;
  hardware.amd.enable = true;
  services.ssh.enable = true;
  environment.systemPackages = with pkgs; [
    
  ];

  # services.hydra = {
  #   enable = true;
  #   hydraURL = "http://localhost:3000";
  #   notificationSender = "hydra@localhost";
  #   buildMachinesFiles = [];
  #   useSubstitutes = true;
  #
  #   logo = ../../../.github/assets/flake.webp;
  # };
  #
  # system.nix.extraUsers = [
  #   "hydra"
  #   "hydra-evaluator"
  #   "hydra-queue-runner"
  # ];

  impermanence.enable = true;

  networking.interfaces.enp0s31f6 = {
    name = "enp0s31f6";
    useDHCP = lib.mkDefault true;
  };

  # ======================== DO NOT CHANGE THIS ========================
  system.stateVersion = "24.05";
  # ======================== DO NOT CHANGE THIS ========================
}
