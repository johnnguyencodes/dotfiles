return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim" },
    { "mason-org/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lua" },
    { "saadparwaiz1/cmp_luasnip" },
    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },
  },
  config = function()
    local cmp = require("cmp")

    -- lsp-zero's "recommended" preset loaded friendly-snippets into
    -- LuaSnip implicitly (manage_luasnip=true). Now explicit.
    require("luasnip.loaders.from_vscode").lazy_load()

    ------------------------------------------------------------------
    -- mason.nvim / mason-lspconfig.nvim (native vim.lsp.enable model)
    ------------------------------------------------------------------
    require("mason").setup()

    -- Advertise nvim-cmp's completion capabilities to every LSP server
    -- (equivalent of lsp-zero's cmp_capabilities = true).
    vim.lsp.config("*", {
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
    })

    -- lua_ls: recognize the `vim` global + Neovim runtime files so editing
    -- this config doesn't show "undefined global vim" warnings.
    -- Values are lsp-zero's own nvim_workspace() defaults, unchanged.
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          telemetry = { enable = false },
          runtime = { version = "LuaJIT", path = runtime_path },
          diagnostics = { globals = { "vim" } },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.fn.expand("$VIMRUNTIME/lua"),
              vim.fn.stdpath("config") .. "/lua",
            },
          },
        },
      },
    })

    -- Installs anything missing and calls vim.lsp.enable() for each.
    -- arduino_language_server is intentionally excluded: it's not in the
    -- mason-lspconfig registry and is set up by hand in init.lua.
    require("mason-lspconfig").setup({
      ensure_installed = {
        "rust_analyzer",
        "eslint",
        "html",
        "cssls",
        "lua_ls",
        "graphql",
        "jsonls",
      },
      automatic_enable = true,
    })

    ------------------------------------------------------------------
    -- Keymaps on LSP attach (replaces lsp-zero's lsp.on_attach)
    ------------------------------------------------------------------
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("johnnyfiive-lsp-attach", { clear = true }),
      callback = function(event)
        local function opts(desc)
          return { buffer = event.buf, remap = false, desc = desc }
        end

        vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts("Go to Declaration"))
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts("Go to Definition"))
        vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts("Go to Implementation"))
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts("Hover Documentation"))
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts("Workspace Symbols"))
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts("Show Diagnostic"))
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts("Next Diagnostic"))
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts("Prev Diagnostic"))
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts("Code Action"))
        vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts("Find References"))
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts("Rename Symbol"))
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts("Signature Help"))

        -- Previously-invisible lsp-zero defaults (set_lsp_keymaps=true)
        -- that are live today and not covered above. `<C-k>`/`gl` omitted:
        -- `<C-k>` is already globally bound to quickfix-next in remap.lua
        -- (confirmed dead today), `gl` is a pure duplicate of <leader>vd.
        vim.keymap.set("n", "go", function() vim.lsp.buf.type_definition() end, opts("Go to Type Definition"))
        vim.keymap.set("n", "gr", function() vim.lsp.buf.references() end, opts("Find References"))
        vim.keymap.set({ "n", "x" }, "<F4>", function() vim.lsp.buf.code_action() end, opts("Code Action"))
      end,
    })

    ------------------------------------------------------------------
    -- nvim-cmp (manual replacement for lsp.setup_nvim_cmp)
    ------------------------------------------------------------------
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
      },
      preselect = "none",
      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },
      mapping = {
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-f>"] = cmp.mapping.scroll_docs(5),
        ["<C-u>"] = cmp.mapping.scroll_docs(-5),
        ["<C-e>"] = cmp.mapping(function()
          if cmp.visible() then cmp.abort() else cmp.complete() end
        end),
        ["<C-d>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          if luasnip.jumpable(1) then luasnip.jump(1) else fallback() end
        end, { "i", "s" }),
        ["<C-b>"] = cmp.mapping(function(fallback)
          local luasnip = require("luasnip")
          if luasnip.jumpable(-1) then luasnip.jump(-1) else fallback() end
        end, { "i", "s" }),
        -- <Tab>/<S-Tab>/<Down>/<Up> intentionally left unmapped, same as
        -- the old code's explicit `cmp_mappings["<Tab>"] = nil` etc.
      },
      -- Flat source list (not a two-tier priority group) -- matches
      -- lsp-zero's actual M.sources() exactly.
      sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "buffer", keyword_length = 3 },
        { name = "luasnip", keyword_length = 2 },
      },
      window = {
        -- bordered() reads vim.o.winborder (set in init.lua) when no
        -- explicit border is passed, so this stays in sync with the
        -- LSP hover/signature-help border automatically.
        documentation = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
          max_height = 15,
          max_width = 60,
        }),
      },
      formatting = {
        fields = { "abbr", "menu", "kind" },
        format = function(entry, item)
          local n = entry.source.name
          if n == "nvim_lsp" then
            item.menu = "[LSP]"
          elseif n == "nvim_lua" then
            item.menu = "[nvim]"
          else
            item.menu = string.format("[%s]", n)
          end
          return item
        end,
      },
    })

    -- nvim_lua completion only in Lua buffers, appended to the same flat
    -- list -- lsp-zero's nvim_workspace() only registers this for
    -- filetype=lua, not globally.
    cmp.setup.filetype("lua", {
      sources = {
        { name = "path" },
        { name = "nvim_lsp" },
        { name = "buffer", keyword_length = 3 },
        { name = "luasnip", keyword_length = 2 },
        { name = "nvim_lua" },
      },
    })

    -- `/` cmdline setup
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "luasnip" },
        { name = "nvim_lua" },
      },
    })

    -- `:` cmdline setup
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    ------------------------------------------------------------------
    -- Diagnostics (only the keys lsp-zero actually applies: virtual_text,
    -- severity_sort, float -- underline/update_in_insert were never
    -- plumbed through by lsp-zero either, so they're just Neovim's own
    -- core defaults already, nothing to add)
    ------------------------------------------------------------------
    vim.diagnostic.config({
      virtual_text = true,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "E",
          [vim.diagnostic.severity.WARN] = "W",
          [vim.diagnostic.severity.HINT] = "H",
          [vim.diagnostic.severity.INFO] = "I",
        },
      },
    })
  end,
}
