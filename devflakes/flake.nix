{
  description = "careb0t's flake templates";

  outputs = { self, ... }: {
    templates = {
      deno = {
        path = ./deno-template;
        description = "Deno development environment";
      };
      python = {
        path = ./python-template;
        description = "Python development environment";
      };
    };
  };
}
