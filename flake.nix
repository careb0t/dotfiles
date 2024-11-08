{
    description = "careb0t's Home Manager configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-colors.url = "github:misterio77/nix-colors";

        spicetify-nix = {
            url = "github:Gerg-L/spicetify-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixcord.url = "github:kaylorben/nixcord";
    };

    outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
        let
            lib = nixpkgs.lib;
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
            pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
        in {
            homeConfigurations = {
                careb0t = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = { inherit inputs; inherit pkgs-unstable; };
                    modules = [ ./home.nix ];
                };
            };
        };
}
