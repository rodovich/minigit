[command, args...] = process.argv[2..]

COMMANDS = ['init']
if command in COMMANDS
  require("./#{command}")(args...)
else
  console.log 'minigit <command>'
  for command in COMMANDS
    console.log "  #{command}"
