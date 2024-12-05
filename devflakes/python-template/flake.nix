{
  description = "Python development environment";

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
            python3Full
          ];

          shellHook = ''
            						clear
            						echo "Welcome to your declarative Python development environment!"
                        python --version
          '';
        };
    };
}
