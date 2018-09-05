" A special thanks goes out to John Leimon <jleimon@gmail.com>
" for his more complete C/C++ version,
" which served as a great basis for understanding
" regex matching in Vim

" Allow users to configure the plugin to auto start for certain filetypes
if (exists('g:semanticEnableFileTypes'))
	if type(g:semanticEnableFileTypes) == type([])
		execute 'autocmd FileType ' . join(g:semanticEnableFileTypes, ',') . ' call s:enableHighlight()'
	elseif type(g:semanticEnableFileTypes) == type({})
		execute 'autocmd FileType ' . join(keys(g:semanticEnableFileTypes), ',') . ' call s:enableHighlight()'
		execute 'autocmd CursorHold ' . join(map(values(g:semanticEnableFileTypes), '"*." . v:val'), ',') . ' call s:semHighlight()'
	endif
endif

let s:semanticTermColors = range(20)

" The user can change the GUI/Term colors, but cannot directly access the list of colors we use
" If the user override the default in their vimrc, use that
let g:semanticTermColors = exists('g:semanticTermColors') ? g:semanticTermColors : s:semanticTermColors

" Allow the user to turn cache off
let g:semanticUseCache = exists('g:semanticUseCache') ? g:semanticUseCache : 1
let g:semanticPersistCache = exists('g:semanticPersistCache') ? g:semanticPersistCache : 1
let g:semanticPersistCacheLocation = exists('g:semanticPersistCacheLocation') ? g:semanticPersistCacheLocation : $HOME . '/.semantic-highlight-cache'

" Allow the user to override blacklists
let g:semanticEnableBlacklist = exists('g:semanticEnableBlacklist') ? g:semanticEnableBlacklist : 1

let s:blacklist = {}
if g:semanticEnableBlacklist
	let s:blacklist = blacklist#GetBlacklist()
endif

let s:containedinlist = containedinlist#GetContainedinlist()

let g:semanticUseBackground = 0
let s:hasBuiltColors = 0

command! SemanticHighlight call s:semHighlight()
command! SemanticHighlightRevert call s:disableHighlight()
command! SemanticHighlightToggle call s:toggleHighlight()
command! RebuildSemanticColors call s:buildColors()

function! s:readCache() abort
	if !filereadable(g:semanticPersistCacheLocation)
		return []
	endif

	let l:localCache = {}
	let s:cacheList = readfile(g:semanticPersistCacheLocation)
	for s:cacheListItem in s:cacheList
		let s:cacheListItemList = eval(s:cacheListItem)
		let l:localCache[s:cacheListItemList[0]] = s:cacheListItemList[1]
	endfor

	if exists("s:cacheListItem")
		unlet s:cacheListItem s:cacheList
	endif

	return l:localCache
endfunction

let s:cache = {}
let b:cache_defined = {}
if g:semanticPersistCache && filereadable(g:semanticPersistCacheLocation)
	let s:cache = s:readCache()
endif

autocmd VimLeave * call s:persistCache()

function! s:persistCache()
	let l:cacheList = []
	let l:mergedCache = extend(s:readCache(), s:cache)
	for [match,color] in items(l:mergedCache)
		call add(l:cacheList, string([match, color]))
		unlet match color
	endfor
	call writefile(l:cacheList, g:semanticPersistCacheLocation)
endfunction

function! s:getCachedColor(current_color, match)
	if !g:semanticUseCache
		return a:current_color
	endif

	if (has_key(s:cache, a:match))
		return s:cache[a:match]
	endif

	let s:cache[a:match] = a:current_color
	return a:current_color
endfunction

function! s:semHighlight()
	if s:hasBuiltColors == 0
		call s:buildColors()
	endif

	let b:cache_defined = {}

	let buflen = line('$')
	let pattern = '\<[\$]*[a-zA-Z\_][a-zA-Z0-9\_]*\>'
	let cur_color = 0
	let colorLen = len(s:semanticColors)

	while buflen
		let curline = getline(buflen)
		let index = 0
		while 1
			let match = matchstr(curline, pattern, index)

			if (empty(match))
				break
			endif

			let l:no_blacklist_exists_for_filetype = empty(s:blacklist) || !has_key(s:blacklist, &filetype)
			if ((l:no_blacklist_exists_for_filetype || index(s:blacklist[&filetype], match) == -1) && !has_key(b:cache_defined, match))
				let b:cache_defined[match] = 1
				let l:containedin = ''
				if (!empty(s:containedinlist) && has_key(s:containedinlist, &filetype))
					let l:containedin = ' containedin=' . s:containedinlist[&filetype]
				endif

				execute 'syn keyword _semantic' . s:getCachedColor(cur_color, match) . l:containedin . ' ' . match
				let cur_color = (cur_color + 1) % colorLen
			endif

			let index += len(match) + 1
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
	if $NVIM_TUI_ENABLE_TRUE_COLOR || has('gui_running') || (exists('&guicolors') && &guicolors) || exists('g:gui_oni')
		let colorType = 'gui'
		" Update color list in case the user made any changes
        call s:buildGUIColors()
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
	let b:semanticOn = 0
	for key in range(len(s:semanticColors))
		execute 'syn clear _semantic'.key
	endfor

	let b:cache_defined = {}
endfunction

function! s:enableHighlight()
	let b:cache_defined = {}
	call s:semHighlight()
	let b:semanticOn = 1
endfunction

function! s:toggleHighlight()
	if (exists('b:semanticOn') && b:semanticOn == 1)
		call s:disableHighlight()
	else
		call s:semHighlight()
		let b:semanticOn = 1
	endif
endfunction

function! s:buildGUIColors()
    " Taking background color
    let hex_color = synIDattr(hlID("Normal"), "bg") " hex value starting with `#`
    let hex_color = strpart(hex_color, 1) " skipping the first `#`
    let hex_color = str2nr(hex_color, 16) " converting to decimal 
    " now converting to RGB
    let r = hex_color / 65536
    let g = (hex_color - r * 65536) / 256
    let b = hex_color - r * 65536 - g * 256
    " Taking a measure of darkness through HSP model
    let darkness = 1 - ( 0.299*pow(r, 2) + 0.587*pow(g, 2) + 0.114*pow(b, 2) ) / 65536

    " Set defaults for colors
    if darkness > 0.5
        let s:semanticGUIColors = ["#9CD8F7", "#F5FA1D", "#F97C65", "#35D27F", "#EB75D6", "#E5D180", "#8997F5", "#D49DA5", "#7FEC35", "#F6B223", "#B4F1C3", "#99B730", "#F67C1B", "#3AC6BE", "#EAAFF1", "#DE9A4E", "#BBEA87", "#EEF06D", "#8FB272", "#EAA481", "#F58AAE", "#80B09B", "#5DE866", "#B5A5C5", "#88ADE6", "#4DAABD", "#EDD528", "#FA6BB2", "#47F2D4", "#F47F86", "#2ED8FF", "#B8E01C", "#C5A127", "#74BB46", "#D386F1", "#97DFD6", "#B1A96F", "#66BB75", "#97AA49", "#EF874A", "#48EDF0", "#C0AE50", "#89AAB6", "#D7D1EB", "#5EB894", "#57F0AC", "#B5AF1B", "#B7A5F0", "#8BE289", "#D38AC6", "#C8EE63", "#ED9C36", "#85BA5F", "#9DEA74", "#85C52D", "#40B7E5", "#EEA3C2", "#7CE9B6", "#8CEC58", "#D8A66C", "#51C03B", "#C4CE64", "#45E648", "#4DC15E", "#63A5F3", "#EA8C66", "#D2D43E", "#E5BCE8", "#E4B7CB", "#B092F4", "#44C58C", "#D1E998", "#76E4F2", "#E19392", "#A8E5A4", "#BF9FD6", "#E8C25B", "#58F596", "#6BAEAC", "#94C291", "#7EF1DB", "#E8D65C", "#A7EA38", "#D38AE0", "#ECF453", "#5CD8B8", "#B6BF6B", "#BEE1F1", "#B1D43E", "#EBE77B", "#84A5CD", "#CFEF7A", "#A3C557", "#E4BB34", "#ECB151", "#BDC9F2", "#5EB0E9", "#E09764", "#9BE3C8", "#B3ADDC", "#B2AC36", "#C8CD4F", "#C797AF", "#DCDB26", "#BCA85E", "#E495A5", "#F37DB8", "#70C0B1", "#5AED7D", "#E49482", "#8AA1F0", "#B3EDEE", "#DAEE34", "#EBD646", "#ECA2D2", "#A0A7E6", "#3EBFD3", "#C098BF", "#F1882E", "#77BFDF", "#7FBFC7", "#D4951F", "#A5C0D0", "#B892DE", "#F8CB31", "#75D0D9", "#A6A0B4", "#EA98E4", "#F38BE6", "#DC83A4"]
    else
        let s:semanticGUIColors = ['#632708', '#0A05E2', '#06839A', '#CA2D80', '#148A29', '#1A2E7F', '#76680A', '#2B625A', '#8013CA', '#094DDC', '#4B0E3C', '#6648CF', '#0983E4', '#C53941', '#15500E', '#2165B1', '#441578', '#110F92', '#704D8D', '#155B7E', '#0A7551', '#7F4F64', '#A21799', '#4A5A3A', '#775219', '#B25542', '#122AD7', '#05944D', '#B80D2B', '#0B8079', '#D12700', '#471FE3', '#3A5ED8', '#8B44B9', '#2C790E', '#682029', '#4E5690', '#99448A', '#6855B6', '#1078B5', '#B7120F', '#3F51AF', '#765549', '#282E14', '#A1476B', '#A80F53', '#4A50E4', '#485A0F', '#741D76', '#2C7539', '#37119C', '#1263C9', '#7A45A0', '#62158B', '#7A3AD2', '#BF481A', '#115C3D', '#831649', '#7313A7', '#275993', '#AE3FC4', '#3B319B', '#BA19B7', '#B23EA1', '#9C5A0C', '#157399', '#2D2BC1', '#1A4317', '#1B4834', '#4F6D0B', '#BB3A73', '#2E1667', '#891B0D', '#1E6C6D', '#571A5B', '#406029', '#173DA4', '#A70A69', '#945153', '#6B3D6E', '#810E24', '#1729A3', '#5815C7', '#2C751F', '#130BAC', '#A32747', '#494094', '#411E0E', '#4E2BC1', '#141884', '#7B5A32', '#301085', '#5C3AA8', '#1B44CB', '#134EAE', '#42360D', '#A14F16', '#1F689B', '#641C37', '#4C5223', '#4D53C9', '#3732B0', '#386850', '#2324D9', '#4357A1', '#1B6A5A', '#0C8247', '#8F3F4E', '#A51282', '#1B6B7D', '#755E0F', '#4C1211', '#2511CB', '#1429B9', '#135D2D', '#5F5819', '#C1402C', '#3F6740', '#0E77D1', '#884020', '#804038', '#2B6AE0', '#5A3F2F', '#476D21', '#0734CE', '#8A2F26', '#595F4B', '#15671B', '#0C7419', '#237C5B']
    endif
    let g:semanticGUIColors = exists('g:semanticGUIColors') ? g:semanticGUIColors : s:semanticGUIColors
endfunction
