{
  description = "Deno development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      devShells."${system}".default =
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        pkgs.mkShell {
          packages = with pkgs; [
            nodejs
          ];
          shellHook = ''
            																		echo ""
                        												clear
                                    						echo "Welcome to your declarative Node.js development environment!"
                                                node --version
          '';
        };
    };
}