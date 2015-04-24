let s:containedinlist = {
	\ 'php': 'phpBracketInString,phpVarSelector,phpClExpressions,phpIdentifier',
	\ }

if (exists('g:semanticContainedlistOverride'))
	let s:containedinlist = extend(s:containedinlist, g:semanticContainedlistOverride)
endif

function! containedinlist#GetContainedinlist()
	return s:containedinlist
endfunction
