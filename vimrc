"===[ Title ]===================================================================

set title

"===[ Files encoding & format ]=================================================

set encoding=utf-8
set fileformats=unix,dos,mac

filetype plugin indent on

"===[ Leader key ]==============================================================

let mapleader="\<Space>"
let maplocalleader="\\"

"===[ Options ]=================================================================

set nowrap              " Disable line wrapping
set nojoinspaces        " Disable double-spaces after '.', '?' and '!'

set history=200         " Remember last 200 commands
set scrolloff=5         " Scroll when 5 lines from top/bottom
set modelines=0         " Disable modelines

set splitright          " Split vertically to the right
set splitbelow          " Split horizontally below

set virtualedit=block   " Square up visual selections

set pastetoggle=<F2>    " Toggle paste mode

if (v:version >= 703)
	set matchpairs+=<:>,«:» " Make % match angle brackets
endif

if has('clipboard')
	set clipboard^=unnamedplus
endif

"===[ Status Line ]=============================================================

" Cut at start
set statusline=%<

" Filename
set statusline+=%#StatusLineFile#\ %-1.50f\ %#StatusLine#

" File encoding and format
set statusline+=%#StatusLineFileEncoding#\ %{&fenc?&fenc:&enc}%#StatusLine#
set statusline+=%#StatusLineFileFormat#\ %{&ff}%#StatusLine#
set statusline+=%#StatusLineFileFormat#\ %#StatusLine#

" Show spell check status
set statusline+=%#StatusLineSpell#
set statusline+=%{&spell?printf('\ %s\ ',&spelllang):''}
set statusline+=%#StatusLine#

" Start the right part of the status line
set statusline+=\ %=

" Show last modified timestamp
set statusline+=%#StatusLine#
set statusline+=%{strftime(\"%H:%M\ %d-%b-%Y\",getftime(expand(\"%:p\")))}
set statusline+=%#StatusLine#

" Flags (filetype)
set statusline+=\ %#StatusLineFlags#%y%#StatusLine#

" Tab expansion and size (expandtab & shiftwidth)
set statusline+=%#StatusLineFlags#[%{&et?'s':'t'}:%{&sw}]%#StatusLine#

" Flags (modified, readonly)
set statusline+=%#StatusLineFlags#%m%r%#StatusLine#

" Show line, column and file position
set statusline+=\ %l/%L,%c%V\ %P%{\"\ \"}

" Make the status line always visible
set laststatus=2

"===[ Vim tiny & small ]========================================================

if !1 | finish | endif

"===[ Plugins ]=================================================================

runtime plugin/documap.vim
runtime plugin/visualsmartia.vim

if (v:version < 800)
	set runtimepath+=~/.vim/pack/*/start/*
endif

"===[ Mouse ]===================================================================

if has('mouse')
	set mouse=a
endif

"===[ Colour scheme ]===========================================================

syntax enable

Nmap <silent> <Leader>y [Toggle syntax highlighting]
	\ :if exists("g:syntax_on") <Bar>
	\   syntax off <Bar>
	\ else <Bar>
	\   syntax enable <Bar>
	\   call VG_Show_CursorColumn('off') <Bar>
	\ endif <CR>

if (v:version < 702) || (&t_Co < 256)
	colorscheme iceman_default
else
	colorscheme iceman
endif

"===[ Line numbers ]============================================================

set number
set relativenumber
Nmap <silent> <Leader>tn [Toggle relative numbers] :set relativenumber!<CR>

"===[ Scrolling & diff ]========================================================

"Nmap <silent> <Leader>sb [Turn scroll binding on]  :windo set scb<CR>
"Nmap <silent> <Leader>sB [Turn scroll binding off] :windo set noscb<CR>

Nmap <silent> <Leader>dt [Diff windows] :windo diffthis<CR>
Nmap <silent> <Leader>do [Diff cancel]  :diffoff<CR>

"===[ Tab handling ]============================================================

set tabstop=4      " Tab indentation levels every four columns
set shiftwidth=4   " Indent/outdent by four columns

set shiftround     " Always indent/outdent to nearest tabstop
set smarttab       " Use shiftwidths at left margin, tabstops everywhere else

function! FormatIndent(indent, to_space, size)

	" Replace leading spaces by tabs
	let spaces = repeat(' ', &tabstop)
	let result = substitute(a:indent, spaces, '\t', 'g')

	" Clean up rogue spaces
	let result = substitute(result, ' \+\ze\t', '', 'g')

	" Convert back to spaces, when needed
	if a:to_space

		let spaces = repeat(' ', a:size)
		let result = substitute(result, '\t', spaces, 'g')
	endif

	return result
endfunction

function! ConvertIndents(line1, line2, to_space, size)

	" Save current position and set size
	let pos  = getpos('.')
	let size = empty(a:size) ? &tabstop : a:size

	" Convert leading spaces
	execute a:line1 . ',' . a:line2 .
	\ 's/^\s\+/\=FormatIndent(submatch(0), a:to_space, size)/e'

	" Clean up search history
	call histdel('search', -1)

	" Change the tab size
	execute "setlocal tabstop="    . size
	execute "setlocal shiftwidth=" . size

	" Get back to the initial position
	call setpos('.', pos)
endfunction

function! InferIndent ()

	let has_lead_tabs   = 0
	let has_lead_spaces = 0
	let lead_spaces     = []

	let line_idx        = 1
	let last_line_idx   = line('$')

	while line_idx <= last_line_idx

		let line = getline(line_idx)
		let lead_char = strpart(line, 0, 1)

		if lead_char == "\t"

			let has_lead_tabs += 1

		elseif lead_char == " "

			let has_lead_spaces += 1
			let lead_spaces += [ strlen(matchstr(line, '^\s\+')) ]

		endif

		let line_idx += 1

	endwhile

	let expandtab = has_lead_spaces > has_lead_tabs

	return [ expandtab, min(lead_spaces) ]
endfunction

function! AutoSetLocalIndent()

	let [ expandtab, size ] = InferIndent()

	" Expand tabs to spaces
	execute "set " . (expandtab? "et" : "noet")

	if (expandtab) && (size > 0)

		" Change the tab size
		execute "setlocal tabstop="    . size
		execute "setlocal shiftwidth=" . size
	endif
endfunction

" Define commands
command! -nargs=? -range=% Space2Tab
	\ call ConvertIndents(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space
	\ call ConvertIndents(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent
	\ call ConvertIndents(<line1>,<line2>,&expandtab,<q-args>)
command! -nargs=1 SetIndent
	\ set ts=<args> sw=<args><BAR>echo "ts=".&ts." sw=".&sw

command! -nargs=1 SetLocalIndent
	\ setlocal ts=<args> sw=<args><BAR>echo "ts=".&ts." sw=".&sw
command! -nargs=0 AutoSetLocalIndent
	\ call AutoSetLocalIndent()

augroup AutoSetLocalIndent
	autocmd!
	autocmd BufRead * call AutoSetLocalIndent()
augroup END

" Set current indent size
Nmap <silent> <Leader>II [Auto-set indent size] :AutoSetLocalIndent<CR>

Nmap <silent> <Leader>I1 [Set indent to 1 column ] :SetLocalIndent 1<CR>
Nmap <silent> <Leader>I2 [Set indent to 2 columns] :SetLocalIndent 2<CR>
Nmap <silent> <Leader>I3 [Set indent to 3 columns] :SetLocalIndent 3<CR>
Nmap <silent> <Leader>I4 [Set indent to 4 columns] :SetLocalIndent 4<CR>
Nmap <silent> <Leader>I5 [Set indent to 5 columns] :SetLocalIndent 5<CR>
Nmap <silent> <Leader>I6 [Set indent to 6 columns] :SetLocalIndent 6<CR>
Nmap <silent> <Leader>I7 [Set indent to 7 columns] :SetLocalIndent 7<CR>
Nmap <silent> <Leader>I8 [Set indent to 8 columns] :SetLocalIndent 8<CR>
Nmap <silent> <Leader>I9 [Set indent to 9 columns] :SetLocalIndent 9<CR>

" Retab with new indent size
Nmap <silent> <Leader>T1 [Retab w/ 1 column  indent] :RetabIndent 1<CR>
Nmap <silent> <Leader>T2 [Retab w/ 2 columns indent] :RetabIndent 2<CR>
Nmap <silent> <Leader>T3 [Retab w/ 3 columns indent] :RetabIndent 3<CR>
Nmap <silent> <Leader>T4 [Retab w/ 4 columns indent] :RetabIndent 4<CR>
Nmap <silent> <Leader>T5 [Retab w/ 5 columns indent] :RetabIndent 5<CR>
Nmap <silent> <Leader>T6 [Retab w/ 6 columns indent] :RetabIndent 6<CR>
Nmap <silent> <Leader>T7 [Retab w/ 7 columns indent] :RetabIndent 7<CR>
Nmap <silent> <Leader>T8 [Retab w/ 8 columns indent] :RetabIndent 8<CR>
Nmap <silent> <Leader>T9 [Retab w/ 9 columns indent] :RetabIndent 9<CR>

" Convert to/from spaces/tabs...
Nmap <silent> <Leader>TS [Convert leading tabs to spaces]
	\ :set expandtab<CR>:Tab2Space<CR>
Nmap <silent> <Leader>TT [Convert leading spaces to tabs]
	\ :set noexpandtab<CR>:Space2Tab<CR>
Nmap <silent> <Leader>TF [Convert to 4-spaces tabs]
	\ :set noexpandtab<CR>:RetabIndent 4<CR>
Nmap <silent> <Leader>TE [Toggle expandtab]
	\ :set expandtab!<CR>

"===[ Spelling ]================================================================

set spelllang=en_gb

Nmap <silent> <Leader>ts [Toggle spell-checking]
	\ :set invspell spelllang=en_gb<CR>

"===[ Auto-update this config file ]============================================

augroup VimReload
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

Nmap <silent> <Leader>v  [Edit .vimrc]          :next $MYVIMRC<CR>
Nmap <silent> <Leader>vv [Edit .vim/plugin/...] :next ~/.vim/plugin<CR>

"===[ Remove auto comment ]=====================================================

augroup NoAutoComment
	autocmd!
	autocmd FileType * setlocal formatoptions-=c
	autocmd FileType * setlocal formatoptions-=r
	autocmd FileType * setlocal formatoptions-=o
augroup END

"===[ Make the 81st & 121st column stand out ]==================================

function! MarkMargin (on, ...)

	if exists('b:MarkMargin')
		try
			for m in b:MarkMargin
				call matchdelete(m)
			endfor
		catch /./
		endtry

		unlet b:MarkMargin
	endif

	let b:MarkMargin = []

	if a:on
		for col in a:000
			let match = matchadd('ColorColumn', '\%' . col . 'v\s*\S', 100)
			call add(b:MarkMargin, match)
		endfor
	endif
endfunction

augroup MarkMargin
	autocmd!
	autocmd BufEnter,WinEnter,TabEnter * :call MarkMargin(1, 81, 121)
augroup END

"===[ Toggle visibility of space characters ]===================================

exec "set lcs=tab:\u2192\uA0,trail:\uB7,nbsp:~,extends:\u25BA,precedes:\u25C4"

Nmap <silent> <Leader>l [Toggle list-mode] :set list!<CR>

augroup VisibleSpace
	autocmd!
	autocmd BufEnter  *       set list
	autocmd BufEnter  *       if !&modifiable
	autocmd BufEnter  *           set nolist
	autocmd BufEnter  *       endif
augroup END

"===[ Set up smarter search behaviour ]=========================================

set hlsearch        " Highlight all matches
set incsearch       " Lookahead as search pattern is specified

Nmap <silent> <BS> [Cancel search highlighting]
	\ :call HLNextOff() <BAR>
	\ :nohlsearch <BAR>
	\ :call VG_Show_CursorColumn('off')<CR>

" Setup star search in visual mode
xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch(cmdtype)

	" Save register 's'
	let temp = @s

	" Yank the current selection and escape special characters
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')

	" Restore register 's'
	let @s = temp
endfunction

"===[ Remove trailing spaces ]==================================================

Nmap <silent> <BS><BS> [Remove trailing whitespace]
	\ mz:call TrimTrailingWS()<CR>`z

function! TrimTrailingWS ()
	if search('\s\+$', 'cnw')
		:%s/\s\+$//g
	endif
endfunction

"===[ Custom commands ]=========================================================

command! -nargs=? -complete=help   Vhelp    vertical help <args>
command! -nargs=? -complete=buffer Vsbuffer vertical sbuffer <args>
command! -nargs=? -complete=buffer Tsbuffer tab      sbuffer <args>

command! -nargs=0 CDC cd %:p:h
command! -nargs=0 LCDC lcd %:p:h

"===[ Windows Explorer ]========================================================

if has('win64') || has('win32') || has('win32unix')

	Nmap <silent> <Leader>e [Windows Explorer]
		\ :exe 'silent !explorer .' <Bar> redraw!<CR>
endif

"===[ Windows Specific ]========================================================

if has('win64') || has('win32') || has('win32unix')

	map <S-Insert> "+p
	imap <S-Insert> <C-R>+
endif

"===[ Custom save commands ]====================================================

command! -bang -nargs=* -range=% Write
	\ call Write(<line1>,<line2>,<q-bang>,<q-args>)

function! Write(line1, line2, bang, args)

	exe a:line1 . ',' . a:line2 . "write" . a:bang . " " . fnameescape(a:args)
endfunction

command! -bang -nargs=* SaveAs
	\ call SaveAs(<q-bang>,<q-args>)

function! SaveAs(bang, args)

	exe "saveas" . a:bang . " " . fnameescape(a:args)
endfunction

"===[ Clean up en- and em-dashes ]==============================================

" Hyphen  (U+002D): -
" En Dash (U+2013): –
" Em Dash (U+2014): —

command! -range SDash <line1>,<line2>/[–—]
command! -range RmDash <line1>,<line2>s/[–—]/-/ge

"===[ FZF ]===============================================================

set runtimepath+=~/.fzf

"===[ Shortcuts ]===============================================================

" Delete w/o register backup
vmap <Del> "_d
Nmap <Del> [Delete] "_d
Nmap <Del><Del> [Delete line] "_dd

" Toggle read-only
Nmap <Leader>ro [Toggle Read-Only] :set ro!<CR>

" Select the entire file
Nmap <Leader>a [Select all] ggVG

" Make backspace work as expected in visual modes
vmap <BS> x

" Make 'Alt' arrow keys move visual blocks
vmap <A-UP>    <Plug>SchleppUp
vmap <A-DOWN>  <Plug>SchleppDown
vmap <A-LEFT>  <Plug>SchleppLeft
vmap <A-RIGHT> <Plug>SchleppRight

" Duplicate visual block
vmap D         <Plug>SchleppDupLeft

"===[ Reset cursor column ]=====================================================

call VG_Show_CursorColumn('off')

"===[ END ]=====================================================================
