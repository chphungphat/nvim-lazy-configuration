-- if true then
-- 	return {}
-- end
return {
	"ribru17/bamboo.nvim",
	event = "VeryLazy",
	priority = 1000,
	config = function()
		require("bamboo").setup({
			-- optional configuration here
		})
		require("bamboo").load()
	end,
}
