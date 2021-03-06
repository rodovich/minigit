fs = require('fs')
crypto = require('crypto')

MINIGIT_DIR = '.minigit'
REFS_DIR = "#{MINIGIT_DIR}/refs"
OBJECTS_DIR = "#{MINIGIT_DIR}/objects"

writeObject = (data) ->
  hash = crypto.createHash('sha1').update(data).digest('hex')
  fs.writeFileSync "#{OBJECTS_DIR}/#{hash}", data
  hash

module.exports = (message) ->
  date = new Date()
  head = fs.readFileSync("#{MINIGIT_DIR}/HEAD").toString().trim()
  parent = fs.readFileSync("#{REFS_DIR}/#{head}").toString().trim()

  fs.readdir '.', (err, files) ->
    return if err?

    commitFiles = (file for file in files when not fs.statSync(file).isDirectory())
    commitFiles.sort()

    commit = { date, message, parent }
    commit.files = for file in commitFiles
      data = fs.readFileSync(file)
      hash = writeObject(data)
      { file, hash }

    commitData = JSON.stringify(commit)
    commitHash = writeObject(commitData)

    fs.writeFileSync "#{REFS_DIR}/#{head}", commitHash

    console.log "[#{head} #{commitHash}] #{message}"
