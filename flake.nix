{
  description = "Vermium's Home Manager & NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/nur";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nur, home-manager, ... }@attrs:
    let
      system = "x86_64-linux";

      gtk-theme = {
        name = "Materia-dark";
        package = nixpkgs.legacyPackages.${system}.materia-theme;
      };

    in
    {
      nixosConfigurations = {
        AxelLaptop01 = nixpkgs.lib.nixosSystem {
          modules = [
            ./machines/AxelLaptop01/configuration.nix
            ./machines/AxelLaptop01/hardware.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.users.vermium = import ./machines/AxelLaptop01/home;
            }
          ];
        };
      };
    };
}
