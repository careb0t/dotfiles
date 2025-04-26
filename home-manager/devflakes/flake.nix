{
  description = "careb0t's flake templates";

  outputs =
    { ... }:
    {
      templates = {
        gen = {
          path = ./gen-template;
          description = "General development environment";
        };
        deno = {
          path = ./deno-template;
          description = "Deno development environment";
        };
        python = {
          path = ./python-template;
          description = "Python development environment";
        };
        python-opencv = {
          path = ./python-opencv-template;
          description = "Python development environment with OpenCV"
        };
        node = {
          path = ./node-template;
          description = "Node.js development environment";
        };
        go = {
          path = ./go-template;
          description = "Go development environment";
        };
        php = {
          path = ./php-template;
          description = "PHP development environment";
        };
      };
    };
}
