[command, args...] = process.argv[2..]

COMMANDS = [
  'branch'
  'checkout'
  'commit'
  'diff'
  'init'
  'log'
  'merge'
  'merge-base'
]

if command in COMMANDS
  require("./#{command}")(args...)
else
  console.log 'minigit <command>'
  for command in COMMANDS
    console.log "  #{command}"
