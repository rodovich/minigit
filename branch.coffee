fs = require('fs')

MINIGIT_DIR = '.minigit'
REFS_DIR = "#{MINIGIT_DIR}/refs"

module.exports = (branch) ->
  head = fs.readFileSync("#{MINIGIT_DIR}/HEAD").toString().trim()

  if branch?.length > 0
    hash = fs.readFileSync("#{REFS_DIR}/#{head}")
    fs.writeFileSync("#{REFS_DIR}/#{branch}", hash)
  else
    fs.readdir REFS_DIR, (err, files) ->
      return if err?

      for file in files
        console.log "#{if file is head then '*' else ' '} #{file}"
