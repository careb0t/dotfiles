{ lib, pkgs, ... }:
{
    home = {
        packages = with pkgs; [
            hello
        ];

        username = "careb0t";
        homeDirectory = "/home/careb0t";

        stateVersion = "24.05";
    };
}
