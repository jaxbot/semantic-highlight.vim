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

## Customization

Set `g:semanticColors` to a dictionary of colors, then run `RebuildSemanticColors` to flush the cache. The color dictionary looks like:

```
let g:semanticColors = { 0x00: '72d572', 0x01: 'c5e1a5', 0x02: 'e6ee9c', 0x03: 'fff59d', 0x04: 'ffe082', 0x05: 'ffcc80', 0x06: 'ffab91', 0x07: 'bcaaa4', 0x08: 'b0bec5', 0x09: 'ffa726', 0x0a: 'ff8a65', 0x0b: 'f9bdbb', 0x0c: 'f9bdbb', 0x0d: 'f8bbd0', 0x0e: 'e1bee7', 0x0f: 'd1c4e9', 0x10: 'ffe0b2', 0x11: 'c5cae9', 0x12: 'd0d9ff', 0x13: 'b3e5fc', 0x14: 'b2ebf2', 0x15: 'b2dfdb', 0x16: 'a3e9a4', 0x17: 'dcedc8' , 0x18: 'f0f4c3', 0x19: 'ffb74d' }
```

## Kudos

Big thanks to John Leimon, whose [Semantic C/C++ Vimscript](http://www.vim.org/scripts/script.php?script_id=4945) was inspirational in the construction of this one.

## About me

I'm Jonathan. I like to hack around with Vim, Node.js, embedded hardware, and Glass. If any of that sounds interesting, [follow me!](https://github.com/jaxbot)

