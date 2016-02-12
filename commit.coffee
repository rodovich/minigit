fs = require('fs')
crypto = require('crypto')

OBJECTS_DIR = '.minigit/objects'

writeObject = (data) ->
  hash = crypto.createHash('sha1').update(data).digest('hex')
  fs.writeFileSync "#{OBJECTS_DIR}/#{hash}", data
  hash

module.exports = (message) ->
  date = new Date()

  fs.readdir '.', (err, files) ->
    return if err?

    commitFiles = (file for file in files when not fs.statSync(file).isDirectory())
    commitFiles.sort()

    commit = { date, message }
    commit.files = for file in commitFiles
      data = fs.readFileSync(file)
      hash = writeObject(data)
      { file, hash }

    commitData = JSON.stringify(commit)
    commitHash = writeObject(commitData)

    console.log "#{commitHash}: #{message}"
