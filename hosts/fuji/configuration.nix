{ config, pkgs, lib, inputs, pkgs-unstable, ... }:
{
  imports = [
    ./nvim
    ../../modules/mango.nix
    ../../home/ranger

    inputs.mangowc.nixosModules.mango
    inputs.dankMaterialShell.nixosModules.greeter

    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true; # teilt pkgs mit NixOS
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs pkgs-unstable; };
    users.sebi = { ... }: {
      imports = [
        inputs.mangowc.hmModules.mango
        inputs.dankMaterialShell.homeModules.dankMaterialShell.default
      ];

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
    };
  };
}
