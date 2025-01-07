return {
    "williamboman/mason.nvim",
    opts = {
        ui = {
            check_outdated_packages_on_open = true,
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    },
}
