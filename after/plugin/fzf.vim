"===[ FZF ]===============================================================

if exists('g:loaded_fzf') && exists('g:loaded_fzf_vim')
	Nmap <Leader><Space> [Search Buffers] :Buffers<CR>
	Nmap <Leader>? [Search Files History] :History<CR>
	Nmap <Leader>/ [Search Current Buffer] :BLines<CR>
	Nmap <Leader>sb [Search All Buffers] :Lines<CR>
	Nmap <Leader>sf [Search Files] :Files<CR>
	Nmap <Leader>sh [Search Help] :Helptags<CR>
	Nmap <Leader>gf [Search Git Files] :GFiles<CR>
else
	Nmap <Leader><Space> [Search Buffers] :buffers<CR>:buffer<Space>
	Nmap <Leader>? [Search Files History] :browse oldfiles<CR>
	Nmap <Leader>sf [Search Files] :edit .<CR>
endif
