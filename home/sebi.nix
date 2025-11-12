{ config, pkgs, ... }:
{

  programs.zsh = {
    enable = true;

    # optional: als Login-Shell setzen
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -la";
      gs = "git status";
      gp = "git pull";
      lg = "lazygit";
      vim = "nvim";
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos#fuji";
    };

    # optional: zusätzliche RC-Dateien / Einstellungen
    initContent = ''
      # hier kannst du alles reinschreiben, was sonst in .zshrc stehen würde
      export EDITOR="nvim"
      bindkey -v
    '';
  };

  programs.starship.enable = true;
}

