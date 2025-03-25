return {
	"ramilito/kubectl.nvim",
	event = "VeryLazy",
	keys = {
		{
			"<leader>t8",
			function()
				require("kubectl").toggle()
			end,
			desc = "Toggle K8s",
			mode = "n",
		},
        -- For when you just want a single keypress...
		{
			"<A-8>",
			function()
				require("kubectl").toggle()
			end,
			desc = "Toggle K8s",
			mode = "n",
		},
	},
	opts = {
		kubectl_cmd = {
			cmd = "kubectl",
			-- Required so the plugin will pick up my AWS environment
			-- variables defined for me by the direnv utility.
			env = require("utils.config-utils").get_aws_env_vars(),
		},
	},
}
