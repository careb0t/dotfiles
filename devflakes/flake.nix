{
  description = "careb0t's flake templates";

  outputs =
    { ... }:
    {
      templates = {
        deno = {
          path = ./deno-template;
          description = "Deno development environment";
        };
        python = {
          path = ./python-template;
          description = "Python development environment";
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
