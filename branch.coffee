fs = require('fs')

MINIGIT_DIR = '.minigit'
REFS_DIR = "#{MINIGIT_DIR}/refs"

module.exports = (branch) ->
  head = fs.readFileSync("#{MINIGIT_DIR}/HEAD").toString().trim()
  hash = fs.readFileSync("#{REFS_DIR}/#{head}")
  fs.writeFileSync("#{REFS_DIR}/#{branch}", hash)
