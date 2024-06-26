{
  description = "You could not live with your own failure. Where did that bring you? Back to me. - Thanos";

  inputs = {
    # Core
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # For nixd
    flake-compat = {
      url = "github:inclyc/flake-compat";
      flake = false;
    };

   devenv.url = "github:cachix/devenv/v1.0.7";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    persist-retro.url = "github:Geometer1729/persist-retro";

    # Home
    neovim = {
      url = "github:IogaMaster/neovim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:IogaMaster/nix-colors";
    prism.url = "github:IogaMaster/prism";

    # Deployments
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-anywhere = {
      url = "github:numtide/nixos-anywhere";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.disko.follows = "disko";
    };

    # Misc
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";

    dzgui-nix = {
      url = "github:lelgenio/dzgui-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs:
    let
      lib = inputs.snowfall-lib.mkLib {
        inherit inputs;
        src = ./.;

        snowfall = {
          meta = {
            name = "dotfiles";
            title = "dotfiles";
          };

          namespace = "custom";
        };
      };
    in
    (lib.mkFlake {
      inherit inputs;
      src = ./.;

      channels-config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-25.9.0"
        ];
      };

      #    overlays = with inputs; [
      #     neovim.overlays.x86_64-linux.neovim
      #
      #       flux.overlays.default
      #    ];

      systems.modules.nixos = with inputs; [

        disko.nixosModules.disko
      #  {
          # Required for impermanence
       #   fileSystems."/persist".neededForBoot = true;
       # }

      ];

      templates = import ./templates { };

    });
   
}
