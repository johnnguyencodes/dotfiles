return {
  "epwalsh/obsidian.nvim",
  version = "*", -- Use the latest release
  dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency
  config = function()
    require("obsidian").setup({
      workspaces = {
        {
          name = "obsidian",
          path = "~/secondBrain/",
        },
      },
      completion = {
        nvim_cmp = true,
        min_chars = 2,
      },
      new_notes_location = "current_dir",
      wiki_link_func = function(opts)
        if opts.id == nil then
          return string.format("[[%s]]", opts.label)
        elseif opts.label ~= opts.id then
          return string.format("[[%s|%s]]", opts.id, opts.label)
        else
          return string.format("[[%s]]", opts.id)
        end
      end,

      mappings = {
        -- "Obsidian follow"
        ["<leader>of"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true, desc = "Obsidian Follow Link" },
        },
        -- Toggle checkboxes "Obsidian done"
        ["<leader>ch"] = {
          action = function()
            return require("obsidian").util.toggle_checkbox()
          end,
          opts = { buffer = true, desc = "Obsidian Toggle Checkbox" },
        },
        -- -- Create a new newsletter issue
        -- ["<leader>onn"] = {
        --   action = function()
        --     return require("obsidian").commands.new_note("Newsletter-Issue")
        --   end,
        --   opts = { buffer = true },
        -- },
        -- Insert a newsletter-issue template
        -- ["<leader>ont"] = {
        --   action = function()
        --     return require("obsidian").util.insert_template("Newsletter-Issue")
        --   end,
        --   opts = { buffer = true },
        -- },
      },

      ui = {
        internal_link_icon = { char = "󰿨", hl_group = "ObsidianIntLinkIcon" },
        hl_groups = {
          ObsidianIntLinkIcon = { fg = "#c792ea" },
        },
      },

      note_frontmatter_func = function(note)
        -- Equivalent to the default frontmatter function.
        local out = { id = note.id, aliases = note.aliases, tags = note.tags, area = "", project = "" }

        -- Ensure manually added metadata fields are kept in the frontmatter.
        if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
          for k, v in pairs(note.metadata) do
            out[k] = v
          end
        end
        return out
      end,

      note_id_func = function(title)
        -- Create note IDs in Zettelkasten format with timestamp and suffix.
        local suffix = ""
        if title ~= nil then
          -- Transform title into a valid file name.
          suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
        else
          -- Add 4 random uppercase letters if no title.
          for _ = 1, 4 do
            suffix = suffix .. string.char(math.random(65, 90))
          end
        end
        return tostring(os.time()) .. "-" .. suffix
      end,

      templates = {
        subdir = "Hidden/My Templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
        tags = "",
      },
    })
  end,
}
