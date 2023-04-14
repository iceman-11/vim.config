"===[ Modified default color scheme ]===========================================

" Author: Stéphane LAMBERT

if has("gui_running")
	set background=dark
endif

hi clear

if exists("syntax_on")
	syntax reset
endif

"===[ Load default ]============================================================

runtime colors/default.vim

"===[ Customs colors ]==========================================================

let colors_name = "iceman_default"

hi HLNext
	\ guibg=DarkRed     guifg=White
	\ ctermbg=DarkRed   ctermfg=White
	\ cterm=none

hi! link ColorColumn Pmenu

"===[ Status Line ]=============================================================

hi link StatusLineFile PmenuSel
hi link StatusLineFlags PmenuSel
hi link StatusLineSpell WildMenu

hi link StatusLineFileFormat StatusLine
hi link StatusLineFileEncoding StatusLine

"===[ END ]=====================================================================
