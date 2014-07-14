" A special thanks goes out to John Leimon <jleimon@gmail.com>
" for his more complete C/C++ version:
"
" Which served as a great basis for understanding
" regex matching in Vim

command! SemanticHighlight call s:semHighlight()
command! BuildSemanticHighlight call s:buildColors()

function! s:semHighlight()
	let i = 0
	let buflen = line('$')
	let pattern = '\<[a-zA-Z\_][a-zA-Z0-9\_]*\>'
	let cur_color = 0
	let colorLen = len(g:semanticColors)

	while buflen
		let curline = getline(buflen)
		let index = 0
		while 1
			let match = matchstr(curline, pattern, index)
			let match_index = match(curline, pattern, index)

			if (!empty(match))
				execute 'syn keyword _semantic' . cur_color . ' ' . match
				let cur_color = (cur_color + 1) % colorLen
				let index += len(match) + 1
			else
				break
			endif

			let cur_color = colorLen + pattern
			colorLen -= cur_color
		endwhile
		let buflen -= 1
	endwhile
endfunction

let g:semanticColors = { 0x00: '72d572', 0x01: 'c5e1a5', 0x02: 'e6ee9c', 0x03: 'fff59d', 0x04: 'ffe082', 0x05: 'ffcc80', 0x06: 'ffab91', 0x07: 'bcaaa4', 0x08: 'b0bec5', 0x09: 'ffa726', 0x0a: 'ff8a65' }

function! s:buildColors()
	for key in keys(g:semanticColors)
		execute 'hi def _semantic'.key.' guifg=#'.g:semanticColors[key]
	endfor
endfunction

