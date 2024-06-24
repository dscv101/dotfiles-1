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

  impermanence.enable = true;

  networking.interfaces.enp0s31f6 = {
    name = "enp0s31f6";
    useDHCP = lib.mkDefault true;
  };

  system.stateVersion = "24.05";

}
