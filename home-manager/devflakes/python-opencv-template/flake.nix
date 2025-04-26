
{
  description = "Python development environment for OpenCV related projects!";
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
            (python312.withPackages (ps: with ps; [
              # overrided Python packages
              (ps.opencv4.override {
                enableGtk2 = true;
                gtk2 = pkgs.gtk2-x11; # for Wayland, use pkgs.gtk2
              })
              # Python packages
              # ps.numpy
            ]))
            # non-Python packages
            # gcc
          ];

          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            #if you get an error about a missing shared library, try listing its source here
            #pin.pkgs.stdenv.cc.cc.lib
            #pin.pkgs.libz
            #pin.pkgs.libGL
            #pin.pkgs.glib
          ];

          shellHook = ''
            echo "Welcome to your declarative Python + OpenCV development environment!"
            python --version
          '';
        };
    };
}
