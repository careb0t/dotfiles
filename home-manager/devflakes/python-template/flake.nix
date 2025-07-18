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
            # add Python version and Python packages here (if having issues with a package like OpenCV, try installing via pip instead)
            python3
          ];

          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            # when missing  shared system libraries like libz.so.1 or libGL.so.1, add them below
            pkgs.stdenv.cc.cc.lib
            pkgs.libz
            pkgs.libGL
            pkgs.glib
          ];

          shellHook = ''
            if [ ! -d "venv" ]; then
              python -m venv venv
            fi
            source venv/bin/activate
            echo "Welcome to your declarative Python environment! Python version: $(python --version)"
          '';
        };
    };
}
