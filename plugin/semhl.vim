" A special thanks goes out to John Leimon <jleimon@gmail.com>
" for his more complete C/C++ version,
" which served as a great basis for understanding
" regex matching in Vim


" Set defaults for colors
let s:semanticGUIColors = [ '#72d572', '#c5e1a5', '#e6ee9c', '#fff59d', '#ffe082', '#ffcc80', '#ffab91', '#bcaaa4', '#b0bec5', '#ffa726', '#ff8a65', '#f9bdbb', '#f9bdbb', '#f8bbd0', '#e1bee7', '#d1c4e9', '#ffe0b2', '#c5cae9', '#d0d9ff', '#b3e5fc', '#b2ebf2', '#b2dfdb', '#a3e9a4', '#dcedc8' , '#f0f4c3', '#ffb74d' ]
let s:semanticTermColors = range(20)

" The user can change the GUI/Term colors, but cannot directly access the list of colors we use
" If the user overrode the default in their vimrc, use that
let g:semanticGUIColors = exists('g:semanticGUIColors') ? g:semanticGUIColors : s:semanticGUIColors
let g:semanticTermColors = exists('g:semanticTermColors') ? g:semanticTermColors : s:semanticTermColors


let g:semanticUseBackground = 0
let s:hasBuiltColors = 0
let s:blacklist = ['if', 'endif', 'for', 'endfor', 'while', 'endwhile', 'endfunction', 'break', 'goto', 'else', 'call']

let g:blacklist = exists('g:blacklist')?  g:blacklist : s:blacklist

command! SemanticHighlight call s:semHighlight()
command! SemanticHighlightRevert call s:disableHighlight()
command! SemanticHighlightToggle call s:toggleHighlight()
command! RebuildSemanticColors call s:buildColors()

function! s:semHighlight()
	if s:hasBuiltColors == 0
		call s:buildColors()
	endif

	let i = 0
	let buflen = line('$')
	let pattern = '\<[\$]*[a-zA-Z\_][a-zA-Z0-9\_]*\>'
	let cur_color = 0
	let colorLen = len(s:semanticColors)

	while buflen
		let curline = getline(buflen)
		let index = 0
		while 1
			let match = matchstr(curline, pattern, index)
			let match_index = match(curline, pattern, index)

			if (!empty(match))
				if (index(g:blacklist, match) == -1)
					execute 'syn keyword _semantic' . cur_color . " containedin=phpBracketInString,phpVarSelector,phpClExpressions,phpIdentifier " . match
					let cur_color = (cur_color + 1) % colorLen
				endif

				let index += len(match) + 1
			else
				break
			endif
		endwhile
		let buflen -= 1
	endwhile
endfunction

function! s:buildColors()
	if (g:semanticUseBackground)
		let type = 'bg'
	else
		let type = 'fg'
	endif
	if has('gui_running')
		let colorType = 'gui'
		" Update color list in case the user made any changes
		let s:semanticColors = g:semanticGUIColors
	else
		let colorType = 'cterm'
		" Update color list in case the user made any changes
		let s:semanticColors = g:semanticTermColors
	endif

	let semIndex = 0
	for semCol in s:semanticColors
		execute 'hi! def _semantic'.semIndex.' ' . colorType . type . '='.semCol
		let semIndex += 1
	endfor
	let s:hasBuiltColors = 1
endfunction

function! s:disableHighlight()
	for key in range(len(s:semanticColors))
		execute 'syn clear _semantic'.key
	endfor
endfunction

function! s:toggleHighlight()
	if (exists("b:semanticOn") && b:semanticOn == 1)
		call s:disableHighlight()
		let b:semanticOn = 0
	else
		call s:semHighlight()
		let b:semanticOn = 1
	endif
endfunction

