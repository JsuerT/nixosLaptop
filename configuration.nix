# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
      (builtins.fetchTarball {
        # Master-Zweig für Kompatibilität mit deinem 25.11 System
        url = "https://github.com/nix-community/home-manager/archive/master.tar.gz";
      } + "/nixos")      
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; 
  
  # Enable networking
  networking.networkmanager.enable = true; 
  
  # Set your time zone.
  time.timeZone = "Europe/Berlin"; 

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8"; 

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

  # Enable the X11 windowing system.
  services.xserver.enable = true; 

  # Enable the Plasma 6 Desktop Environment.
  services.displayManager.sddm.enable = true; 
  services.desktopManager.plasma6.enable = true; 

  # Configure keymap in X11
  services.xserver.xkb = { 
    layout = "de"; 
    variant = ""; 
  };

  # Configure console keymap
  console.keyMap = "de"; 

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
  };

  # Enable touchpad support.
  services.xserver.libinput.enable = true; 

  # Define a user account.
  users.users.ticco = { 
    isNormalUser = true; 
    description = "ticco"; 
    extraGroups = [ "networkmanager" "wheel" ]; 
    packages = with pkgs; [ 
    ];
  };

  programs.firefox.enable = true; 

  nixpkgs.config.allowUnfree = true; 

  services.mysql = {
    enable = true; 
    package = pkgs.mariadb;
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [ 
    mariadb
    openjdk21 
    git 
      #für autoformat in vim 
      nodePackages.prettier
      black
      clang-tools
      shfmt
#    libreoffice
    (vim-full.customize { 
      name = "vim"; 
      vimrcConfig.packages.myVimPackage = {
        start = with pkgs.vimPlugins; [ 
          vim-airline 
          vim-airline-themes 
          nerdtree 
          vim-fugitive 
          vim-gitgutter 
          vim-surround 
          vim-commentary 
          fzf-vim 
          gruvbox 
          vim-polyglot 
          indentLine 
          auto-pairs 
          vim-autoformat
        ];
      };
      vimrcConfig.customRC = '' 
        syntax on
        set number
        set relativenumber
        set termguicolors
        set encoding=utf-8
        set shiftwidth=2
        set expandtab 
        set mouse=a

        " Theme Einstellungen
        colorscheme gruvbox
        let g:airline_theme='gruvbox'
        let g:airline_powerline_fonts = 1

        " Keybindings
        let mapleader = " "

        " Strg + n öffnet den Dateibaum (NERDTree)
        nnoremap <C-n> :NERDTreeToggle<CR> 

        " Leertaste + ff sucht nach Dateien
        nnoremap <leader>ff :Files<CR> 
        
        " Leertaste + fg sucht in Git-Dateien
        nnoremap <leader>fg :GFiles<CR> 

        "autoformat mit f3"
        noremap <F3> :Autoformat<CR>
      '';
    }) 
  ];

  # Enable programs and services
  programs.nm-applet.enable = true; 
  programs.mtr.enable = true; 

  # Home Manager globale Einstellungen
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Home Manager Konfiguration für ticco
  home-manager.users.ticco = { pkgs, ... }: {
    imports = [
      # Korrekter Import des Plasma-Manager Moduls ohne Flakes
      (builtins.fetchTarball "https://github.com/nix-community/plasma-manager/archive/trunk.tar.gz" + "/modules")
    ];

    programs.plasma = {
      enable = true;
      shortcuts = {
        "kwin" = {
           "Switch to Desktop1" = "Meta+1"; 
          "Switch to Desktop 2" = "Meta+2";
          "Switch to Desktop 3" = "Meta+3";
          "Window Maximize" = "Meta+Up";
        };
        "services/org.kde.konsole.desktop" = {
          "_launch" = "Meta+Return";
        };
      };
    };

    home.stateVersion = "24.11"; 
  };

  system.stateVersion = "24.11"; 
}
