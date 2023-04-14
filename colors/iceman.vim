"===[ Modified hybrid color scheme ]============================================

" Author: Stéphane LAMBERT

set background=dark

hi clear

if exists("syntax_on")
	syntax reset
endif

"===[ Load hybrid ]=============================================================

runtime colors/hybrid.vim

"===[ Customs colors ]==========================================================

let colors_name = "iceman"

hi HLNext
	\ guibg=#cc6666 guifg=#1d1f21 gui=none
	\ ctermbg=167   ctermfg=234   cterm=none
	\ term=none

hi! link ColorColumn Pmenu

"===[ Status Line ]=============================================================

hi StatusLine
	\ guifg=#262626 guibg=#ffffff gui=reverse
	\ ctermfg=235   ctermbg=15    cterm=reverse
	\ term=reverse

hi StatusLineFile
	\ guifg=#c5c8c6 guibg=#373b41 gui=reverse
	\ ctermfg=250   ctermbg=237   cterm=reverse
	\ term=reverse

hi StatusLineFlags
	\ guifg=#c5c8c6 guibg=#373b41 gui=reverse
	\ ctermfg=250   ctermbg=237   cterm=reverse
	\ term=reverse

hi StatusLineSpell
	\ guifg=#1d1f21 guibg=#81a2be gui=none
	\ ctermfg=234   ctermbg=110   cterm=none
	\ term=none

hi StatusLineFileFormat
	\ guifg=#81a2be guibg=#1d1f21 gui=none
	\ ctermfg=110   ctermbg=234   cterm=none
	\ term=none

hi StatusLineFileEncoding
	\ guifg=#b294bb guibg=#1d1f21 gui=none
	\ ctermfg=139   ctermbg=234   cterm=none
	\ term=none

"===[ END ]=====================================================================
