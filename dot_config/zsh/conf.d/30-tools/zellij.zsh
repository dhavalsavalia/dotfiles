# Zellij auto-naming wrapper
# Automatically names sessions after the current directory

# Smart attach/create with dir-based naming
zj() {
  local session_name=${1:-${PWD:t}}

  # Sanitize session name (replace dots, spaces with dashes)
  session_name=${session_name//[. ]/-}

  # Attach to existing or create new session
  zellij attach "$session_name" 2>/dev/null || zellij -s "$session_name"
}

# Alias for common usage
alias z="zj"
