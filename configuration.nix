{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };

  programs.zsh.enable = true;

  # Define a user account. Set a password with ‘passwd’.
  users.users.sebi = {
    isNormalUser = true;
    description = "sebastian";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };

  nixpkgs.config.allowUnfree = true;

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
    ];
  };

  environment.systemPackages = with pkgs; [
    coreutils-full
    tree
    git
    lazygit
    tmux
    vim 
    wget
    kitty
    wofi
    waybar
    hyprpaper
    brave
    adwaita-icon-theme
    gnome-themes-extra    # enthält Adwaita-Dark und HighContrast
  ]; 
    # systemweit dunkles GTK-Schema
  environment.variables = {
    GTK_THEME = "Adwaita:dark";   # oder "Catppuccin-Mocha-Standard-Blue-Dark" falls installiert
  };

  system.stateVersion = "25.05"; 
}
