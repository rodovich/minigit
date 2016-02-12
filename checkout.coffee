fs = require('fs')

MINIGIT_DIR = '.minigit'
REFS_DIR = "#{MINIGIT_DIR}/refs"
OBJECTS_DIR = "#{MINIGIT_DIR}/objects"

module.exports = (branch) ->
  hash = fs.readFileSync("#{REFS_DIR}/#{branch}").toString().trim()
  commit = JSON.parse(fs.readFileSync("#{OBJECTS_DIR}/#{hash}").toString())

  fs.readdir '.', (err, files) ->
    return if err?

    for file in files when not fs.statSync(file).isDirectory()
      fs.unlinkSync(file)

    for { file, hash } in commit.files
      data = fs.readFileSync("#{OBJECTS_DIR}/#{hash}")
      fs.writeFileSync file, data

    fs.writeFileSync "#{MINIGIT_DIR}/HEAD", branch

    console.log "Switched to branch '#{branch}'"
