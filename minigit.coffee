[command, args...] = process.argv[2..]

if command in ['init']
  require("./#{command}")(args...)
