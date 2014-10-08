# Semantic-Highlight.vim

Where every variable is a different color, an idea popularized by <a href="https://medium.com/@evnbr/coding-in-color-3a6db2743a1e">Evan Brooks'</a> blog post.

This is an early version of an experimental but developing plugin.

<img src="https://raw.githubusercontent.com/jaxbot/semantic-highlight.vim/master/semantic-highlight.png">

## Install

Vundle or Neobundle:

```
Plugin 'jaxbot/semantic-highlight.vim'
```

Pathogen:

```
git clone https://github.com/jaxbot/semantic-highlight.vim.git
```

## Usage

In a file, run `:SemanticHighlight` to convert variables into colors. Run `:SemanticHighlightRevert` to revert.

You can also map `:SemanticHighlightToggle` to a shortcut to toggle the effect on and off:

```
:nnoremap <Leader>s :SemanticHighlightToggle<cr>
```

To have the sematic highlihgint trigger whenever you enter insert mode and change text add 

```
autocmd BufEnder * :SemanticHighlight
```

Note: On slower machines this could be potentially bottlenecking
## Customization
###Colors
Set `g:semanticTermColors` and/or `g:semanticGUIColors` to a list of colors, then run `RebuildSemanticColors` to flush the cache. The color lists look like:

```
let s:semanticGUIColors = [ '#72d572', '#c5e1a5', '#e6ee9c', '#fff59d', '#ffe082', '#ffcc80', '#ffab91', '#bcaaa4', '#b0bec5', '#ffa726', '#ff8a65', '#f9bdbb', '#f9bdbb', '#f8bbd0', '#e1bee7', '#d1c4e9', '#ffe0b2', '#c5cae9', '#d0d9ff', '#b3e5fc', '#b2ebf2', '#b2dfdb', '#a3e9a4', '#dcedc8' , '#f0f4c3', '#ffb74d' ]
```
or

```
let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,16,125,124,19]
```

Either list can also be set in your vimrc

###Blacklist
Certain words can be reserved (such as keywords in the languages you use)

The built in blacklist is 

```
['if', 'endif', 'for', 'endfor', 'while', 'endwhile', 'endfunction', 'break', 'goto', 'else', 'call']
``` 

but can be overidden in your .vimc with 

```
let g:blacklist = ['some','keywords','you','would','like','this','plugin','to','ignore']
```

## Kudos

Big thanks to John Leimon, whose [Semantic C/C++ Vimscript](http://www.vim.org/scripts/script.php?script_id=4945) was inspirational in the construction of this one.

## About me

I'm Jonathan. I like to hack around with Vim, Node.js, embedded hardware, and Glass. If any of that sounds interesting, [follow me!](https://github.com/jaxbot)

