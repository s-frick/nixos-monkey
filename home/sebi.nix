{ config, pkgs, pkgs-unstable, ... }:
{

  home.username = "sebi";
  home.homeDirectory = "/home/sebi";
  home.stateVersion = "25.05";

  # alles dark per default
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome-themes-extra;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "Adwaita-Dark";
  };

  programs.quickshell = {
    enable = true;
    # package = pkgs-unstable.quickshell;
    # activeConfig brauchst du i.d.R. nicht setzen,
    # DMS legt configs/activeConfig selbst passend an.
  };

  programs.dankMaterialShell = {
    enable = true;
    #quickshell.package = pkgs-unstable.quickshell;
    systemd = {
      enable = true;             # Systemd service for auto-start
      restartIfChanged = true;   # Auto-restart dms.service when dankMaterialShell changes
    };
    
    # Core features
    enableSystemMonitoring = true;     # System monitoring widgets (dgop)
    enableClipboard = true;            # Clipboard history manager
    enableVPN = true;                  # VPN management widget
    enableBrightnessControl = true;    # Backlight/brightness controls
    enableColorPicker = true;          # Color picker tool
    enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
    enableAudioWavelength = true;      # Audio visualizer (cava)
    enableCalendarEvents = true;       # Calendar integration (khal)
    enableSystemSound = true;          # System sound effects
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

  programs.tmux = {
    enable = true;
    # clock24 = true;
    # mouse = true;
    historyLimit = 100000;
    baseIndex = 1;
    keyMode = "vi";
    terminal = "tmux-256color";

    plugins = with pkgs.tmuxPlugins; [ 
      nord
      yank
      vim-tmux-navigator
    ];

    extraConfig = ''
      set -ga terminal-overrides ",*:RGB"
      set -sg escape-time 0

      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send -X copy-selection-and-cancel
      set -g focus-events on
      unbind C-b
      set-option -g prefix C-Space
      bind-key C-Space send-prefix
      # switch panes using Alt-arrow without prefix
      # bind -n C-h select-pane -L
      # bind -n C-l select-pane -R
      # bind -n C-k select-pane -U
      # bind -n C-j select-pane -D

      # resizing mit Alt/Meta + hjkl
      bind -n M-h resize-pane -L 10
      bind -n M-l resize-pane -R 10
      bind -n M-k resize-pane -U 10
      bind -n M-j resize-pane -D 10

      # don't rename windows automatically
      set-option -g allow-rename off
    '';
  };

  # programs.starship.enable = true;
}

