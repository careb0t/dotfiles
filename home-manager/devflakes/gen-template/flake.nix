{
  description = "General development environment";

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
            # insert runtimes, libraries, etc here
          ];

          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
            # when missing  shared system libraries like libz.so.1 or libGL.so.1, add them below
            # pkgs.stdenv.cc.cc.lib
            # pkgs.libz
            # pkgs.libGL
            # pkgs.glib
          ];

          shellHook = ''
            # use if unable to run Node packages from terminal: PATH="$(realpath node_modules/.bin):$PATH"
            echo "Welcome to your declarative _ development environment!"
          '';
        };
    };
}
