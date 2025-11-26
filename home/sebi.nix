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


  # programs.starship.enable = true;
}

