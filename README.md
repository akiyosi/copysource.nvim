## copysource.nvim
copysource.nvim allows you to copy source code with line numbers.


### Usage

``` lua
function myCopy()
    require('copysource').copyWithLineNum({
        separator = '| ',
        markdown_format = true,
    })
end
vim.keymap.set("v", " yn", "<CMD>lua myCopy()<CR>", { noremap = true })
```

