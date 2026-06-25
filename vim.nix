{ pkgs }:

pkgs.vim-full.customize {
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
}
