{ config, pkgs, lib, inputs, pkgs-unstable, ... }:

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
      rebuild = "sudo nixos-rebuild switch --flake /home/sebi/git/configs/nixos-monkey#fuji";
    };

    # optional: zusätzliche RC-Dateien / Einstellungen
    initContent = ''
      # hier kannst du alles reinschreiben, was sonst in .zshrc stehen würde
      # source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      export EDITOR="nvim"
      bindkey -v
    '';
  };
}
