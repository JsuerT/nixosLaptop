{ config, pkgs, ... }:

#variabeln definiert
let
  vimconfig = pkgs.vim-full.customize {
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
        vim-polyglot
        indentLine
        auto-pairs
        vim-autoformat
        vim-colors-solarized
        coc-nvim
      ];
    };

    vimrcConfig.customRC = ''
      syntax on
      set number
      set relativenumber
      set termguicolors
      set encoding=utf-8
      set shiftwidth=2
      set tabstop=2
      set softtabstop=2
      set expandtab
      set mouse=a
      set hidden
      set clipboard=unnamedplus
      set updatetime=300
      set signcolumn=yes

      " Solarized Dark
      set background=dark
      let g:solarized_termcolors = 256
      let g:solarized_use16 = 1
      colorscheme solarized

      " Airline
      let g:airline_theme = 'solarized'
      let g:airline_powerline_fonts = 1

      " Leader & Keybinds
      let mapleader = " "
      nnoremap <C-n> :NERDTreeToggle<CR>
      nnoremap <leader>ff :Files<CR>
      nnoremap <leader>fg :GFiles<CR>
      nnoremap <F3> :Autoformat<CR>

      " CoC (Autocompletion) Konfiguration
      inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
      inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
      inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
    '';
  };
      in

###################################################################################

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

  services.xserver.xkb = { layout = "de"; variant = ""; };
  console.keyMap = "de";

  # Plasma 6
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  #fingerprint
  /*services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;
  services.fwupd.enable = true;
  */


  #touchscreen
#funktioniert nicht :/
boot.kernelParams = [ "psmouse.synaptics_intertouch=1" "i2c_designware.forcing_timing=1""ic2_hid.noselftest=1"];
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

#keys assignment
  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        settings = {
          main = {
           pageup= "102nd";
           pagedown= "S-102nd";
          };
        };
      };
    };
  };

  # Lizenzen & Unfree
  nixpkgs.config.allowUnfree = true;

  # System Pakete
  environment.systemPackages = with pkgs; [
    git
    jdk21
    curl
    wget
    htop
    ripgrep
    fd
    unzip
    zip
    htop

    #für compilierne von latex
    texliveFull
    biber

    discord
    nodejs
    vimconfig
    wireshark
    firefox
    android-tools
    libreoffice
    arduino
    steam
  ];

  environment.shellAliases={
    bye="shutdown now";
    Ergo="cd /run/media/ticco/INTENSO/SchuleErgo";
    Info="cd /run/media/ticco/INTENSO/Info";
    ".."= "cd ..";
    list="for c in $(ls | cut -c1 | sort -u); do
    echo "$c"
    ls | grep "^$c" | sed 's/^/├── /'
    echo
done";

  };

  # Datenbank
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  system.stateVersion = "24.11";
}


