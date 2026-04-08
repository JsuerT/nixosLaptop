{ config, pkgs, ... }:

let
  myVim = pkgs.vim-full.customize {
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
        coc-nvim # Nodejs bleibt in den Paketen für CoC Support
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

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Fonts
  fonts.packages = with pkgs; [ jetbrains-mono ];

  # User
  users.users.ticco = {
    isNormalUser = true;
    description = "ticco";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
  };

  # Lizenzen & Unfree
  nixpkgs.config.allowUnfree = true;

  # System Pakete
  environment.systemPackages = with pkgs; [
    git curl wget htop ripgrep fd unzip zip
    nodejs # Notwendig für CoC in Vim
    myVim
    wireshark
    firefox
    android-tools
  ];

  # Umgebungsvariablen
  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
  };

  # Datenbank
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  system.stateVersion = "24.11";
}
