{ config, pkgs, ... }:

let
  myVim = import ./vim.nix { inherit pkgs; };
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";

  # Plasma 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Touchscreen Tweaks
  boot.kernelParams = [ "psmouse.synaptics_intertouch=1" "i2c_designware.forcing_timing=1" "ic2_hid.noselftest=1" ];
  boot.initrd.kernelModules = [ "i2c_hid_acpi" "hid_multitouch" "raydium_i2c_ts" ];
  boot.kernelModules = [ "hid_multitouch" "i2c_hid_acpi" ];
  services.libinput.enable = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # User
  users.users.ticco = {
    isNormalUser = true;
    description = "ticco";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
  };

  # Keys assignment
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        settings = {
          main = {
            pageup = "102nd";
            pagedown = "S-102nd";
            sysrq = "G-102nd";
          };
        };
      };
    };
  };

  # Lizenzen & Unfree
  nixpkgs.config.allowUnfree = true;

  # System Pakete
  environment.systemPackages = with pkgs; [
    wezterm
    git
    jdk21
    curl
    wget
    htop
    ripgrep
    fd
    unzip
    zip
    lynx

    # für Compilieren von LaTeX
    texliveFull
    biber

    discord
    nodejs
    myVim
    wireshark
    firefox
    android-tools
    libreoffice
    arduino
    steam
  ];

  environment.etc."xdg/wezterm/wezterm.lua".source = ./wezterm.lua;

  environment.shellAliases = {
    bye = "shutdown now";
    Ergo = "cd /run/media/ticco/INTENSO/SchuleErgo";
    Info = "cd /run/media/ticco/INTENSO/Info";
    ".." = "cd ..";
    rmdown = "rm -rf ~/Downloads && mkdir Downloads";
    list = ''
      for c in $(ls | cut -c1 | sort -u);
      do
        echo "$c"
        ls | grep "^$c" | sed 's/^/├── /'
        echo
      done
    '';
  };

  # Datenbank
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  system.stateVersion = "24.11";
}
