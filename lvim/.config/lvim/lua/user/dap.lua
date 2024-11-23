local dap = require('dap')

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "js-debug-adapter",
    args = { "${port}" }
  }
}

dap.configurations.typescript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Debug npm start",
    runtimeExecutable = "npm",
    runtimeArgs = { "run", "start" },
    sourceMaps = true,
    protocol = "inspector",
    rootPath = "${workspaceFolder}",
    cwd = "${workspaceFolder}",
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
  }
}
