{ config, pkgs, ... }:
{

  programs.nvf = {
    enable = true;
    # Optional nett:
    defaultEditor = true;      # setzt EDITOR auf nvim
    enableManpages = true;     # dann: `man 5 nvf` für Doku

    # Optional: Neovim-Build wählen (sonst nimmt nvf das aus pkgs)
    #package = pkgs.neovim;            # Stable (Standard)
# package = pkgs.neovim-nightly;    # Nightly (siehe Schritt 3 unten)


    
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim = {
        theme.enable = true;
        lsp.enable = true;
        treesitter.enable = true;
        telescope.enable = true;
      };
      vim.languages.nix.enable = true;
      vim.languages.astro.enable = false;
    };
    # Beispiel-Grundkonfig:
  };
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

