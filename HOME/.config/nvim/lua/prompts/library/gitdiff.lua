return {
  -- 作業ブランチと分岐元(develop があれば develop、なければ main)との差分を返す
  diff = function()
    local base_branch = vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", "develop" }) ~= "" and "develop" or "main"
    return vim.fn.system({ "git", "diff", "--merge-base", base_branch, "HEAD" })
  end,
}
