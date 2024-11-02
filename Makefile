.PHONY: update
update:
	home-manager switch --flake .#careb0t

.PHONY: clean
clean:
	nix-collect-garbage -d
