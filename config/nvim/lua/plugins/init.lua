local install_path = vim.fn.stdpath("data").."/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
  vim.api.nvim_command("packadd packer.nvim")
end

require("packer").startup({
  function(use)
    use "wbthomason/packer.nvim" 
    use "nvim-lua/plenary.nvim"
    use "lewis6991/impatient.nvim"

    for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config").."/lua/plugins", [[v:val =~ "\.lua$"]])) do
      if file ~= "init.lua" then
        require("plugins."..file:gsub("%.lua$", ""))(use)
      end
    end

    if packer_bootstrap then
      require("packer").sync()
    end
  end,

  config = {
    display = {
      open_fn = function()
        return require("packer.util").float { border = "single" }
      end,
      prompt_border = "single",
    },
  },
})
