if pcall(require, "impatient") then
  require("impatient").enable_profile()
end

require("core.options")
require("core.mappings")
require("plugins")
