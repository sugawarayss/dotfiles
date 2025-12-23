return {
  diff = function(args)
    local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD 2>/dev/null")
    print("ブランチ" .. banch)
    if vim.v.shell_error == 0 then
      branch = branch:gsub("\n", "")
    end
    local base_branch = branch or "develop"
    print("ベースブランチ: " .. base_branch)
    return vim.fn.system("git diff --merge-base " .. base_branch .. " HEAD")
  end,
}
