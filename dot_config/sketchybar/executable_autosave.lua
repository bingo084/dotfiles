vim.api.nvim_create_autocmd("BufWritePost",{
    pattern = "*",
    callback =function ()
        vim.fn.jobstart({"brew","services","restart","sketchybar"})
    end
})
