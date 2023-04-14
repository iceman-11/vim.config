"===[ Syntax highlighting groups ]==============================================

" Maintainer: Stéphane LAMBERT

" If already loaded, we're done...
if exists("loaded_synstack")
    finish
endif
let loaded_synstack = 1

" Preserve external compatibility options, then enable full vim compatibility...
let s:save_cpo = &cpo
set cpo&vim


runtime plugin/documap.vim

Nmap <Leader>sg [Show syntax highlighting group] :call SynStack()<CR>

function! SynStack()

	if !exists("*synstack")

		return
	endif

	echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Restore previous external compatibility options
let &cpo = s:save_cpo

"===============================================================================
