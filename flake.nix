{
    description = "careb0t's Home Manager configuration";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.05";

        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        spicetify-nix = {
            url = "github:Gerg-L/spicetify-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nixcord.url = "github:kaylorben/nixcord";

        nixvim = {
            url = "github:nix-community/nixvim/nixos-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, home-manager, ... }@inputs:
        let
            lib = nixpkgs.lib;
            system = "x86_64-linux";
            pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        in {
            homeConfigurations = {
                careb0t = home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    extraSpecialArgs = { inherit inputs; };
                    modules = [ ./home.nix ];
                };
            };
        };
}
