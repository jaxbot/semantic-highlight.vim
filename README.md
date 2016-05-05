# Semantic-Highlight.vim

Where every variable is a different color, an idea popularized by <a href="https://medium.com/@evnbr/coding-in-color-3a6db2743a1e">Evan Brooks'</a> blog post.

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

## Customization

Set `g:semanticTermColors` and/or `g:semanticGUIColors` to a list of colors, then run `RebuildSemanticColors` to flush the cache. The color lists look like:

```
let s:semanticGUIColors = [ '#72d572', '#c5e1a5', '#e6ee9c', '#fff59d', '#ffe082', '#ffcc80', '#ffab91', '#bcaaa4', '#b0bec5', '#ffa726', '#ff8a65', '#f9bdbb', '#f9bdbb', '#f8bbd0', '#e1bee7', '#d1c4e9', '#ffe0b2', '#c5cae9', '#d0d9ff', '#b3e5fc', '#b2ebf2', '#b2dfdb', '#a3e9a4', '#dcedc8' , '#f0f4c3', '#ffb74d' ]
```
or

```
let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,16,125,124,19]
```

Either list can also be set in your vimrc

## Language support

This plugin is language agnostic, meaning it will work on any language with words. However, some languages have been tweaked by default to disable highlighting of language keywords.

Current language support with keyword blacklists:

* C
* C++
* CoffeeScript
* Java
* JavaScript
* PHP
* Python
* Ruby
* Rust
* TypeScript

This can be customized locally by populating `g:semanticBlacklistOverride` like so:

```
let g:semanticBlacklistOverride = {
	\ 'javascript': [
	\	'setTimeout',
	\	'break',
	\	'dance',
	\ ]
\ }
```

If you want to add language support to the plugin itself, feel free to edit autoload/blacklist.vim and submit a pull request with your changes. Help is appreciated!

## Adding characters to be included in highlights

Some languages, such as PHP and JavaScript, allow special characters to be used in variable names.

Consider the following:

```JS
var $someObject = '1231';
var someObject = 1231;
```

Without the `autocommand` outlined below, only thed `someObject` portion of the variable would be semantically highlighted, and highlighted the same colour as the `$`-free variable. To have the preceding `$` included in the semantic highlight, use the following snippet in your vimrc:

```
autocmd FileType javascript setlocal iskeyword+=$
```

## Kudos

Big thanks to John Leimon, whose [Semantic C/C++ Vimscript](http://www.vim.org/scripts/script.php?script_id=4945) was inspirational in the construction of this one.

Also big thanks to everyone who submitted bugs, suggestions, and pull requests!

## About me

I'm Jonathan. I like to hack around with Vim, Node.js, embedded hardware, and Glass. If any of that sounds interesting, [follow me!](https://github.com/jaxbot)

