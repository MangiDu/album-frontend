# This example:
#  - handles non-CORS environments
#  - handles delete file requests assuming the method is DELETE
#  - Ensures the file size does not exceed the max
#  - Handles chunked upload requests
#
# Requirements:
#  - rimraf (for "rm -rf" support)
#  - multiparty (for parsing request payloads)
#  - mkdirp (for "mkdir -p" support)

# 是不是需要imagemagick生成thumbnail？

fs = require('fs')
rimraf = require('rimraf')
mkdirp = require('mkdirp')

onUpload = (req, res) ->
  form = new (multiparty.Form)
  form.parse req, (err, fields, files) ->
    console.log 'on upload'
    console.log fields
    console.log files
    console.log '==================='
    partIndex = fields.qqpartindex
    # text/plain is required to ensure support for IE9 and older
    res.set 'Content-Type', 'text/plain'
    if partIndex == null
      onSimpleUpload fields, files[fileInputName][0], res
    else
      onChunkedUpload fields, files[fileInputName][0], res
    return
  return

onSimpleUpload = (fields, file, res) ->
  uuid = fields.qquuid
  responseData = success: false
  file.name = fields.qqfilename
  if isValid(file.size)
    moveUploadedFile file, uuid, (->
      responseData.success = true
      res.send responseData
      return
    ), ->
      responseData.error = 'Problem copying the file!'
      res.send responseData
      return
  else
    failWithTooBigFile responseData, res
  return

onChunkedUpload = (fields, file, res) ->
  size = parseInt(fields.qqtotalfilesize)
  uuid = fields.qquuid
  index = fields.qqpartindex
  totalParts = parseInt(fields.qqtotalparts)
  responseData = success: false
  file.name = fields.qqfilename
  if isValid(size)
    storeChunk file, uuid, index, totalParts, (->
      if index < totalParts - 1
        responseData.success = true
        res.send responseData
      else
        combineChunks file, uuid, (->
          responseData.success = true
          res.send responseData
          return
        ), ->
          responseData.error = 'Problem conbining the chunks!'
          res.send responseData
          return
      return
    ), (reset) ->
      responseData.error = 'Problem storing the chunk!'
      res.send responseData
      return
  else
    failWithTooBigFile responseData, res
  return

failWithTooBigFile = (responseData, res) ->
  responseData.error = 'Too big!'
  responseData.preventRetry = true
  res.send responseData
  return

onDeleteFile = (req, res) ->
  uuid = req.params.uuid
  dirToDelete = uploadedFilesPath + '/' + uuid
  rimraf dirToDelete, (error) ->
    if error
      console.error 'Problem deleting file! ' + error
      res.status 500
    res.send()
    return
  return

isValid = (size) ->
  maxFileSize == 0 or size < maxFileSize

moveFile = (destinationDir, sourceFile, destinationFile, success, failure) ->
  mkdirp destinationDir, (error) ->
    sourceStream = undefined
    destStream = undefined
    if error
      console.error 'Problem creating directory ' + destinationDir + ': ' + error
      failure()
    else
      sourceStream = fs.createReadStream(sourceFile)
      destStream = fs.createWriteStream(destinationFile)
      sourceStream.on('error', (error) ->
        console.error 'Problem copying file: ' + error.stack
        destStream.end()
        failure()
        return
      ).on('end', ->
        destStream.end()
        success()
        return
      ).pipe destStream
    return
  return

moveUploadedFile = (file, uuid, success, failure) ->
  destinationDir = uploadedFilesPath + '/' + uuid + '/'
  fileDestination = destinationDir + file.name
  moveFile destinationDir, file.path, fileDestination, success, failure
  return

storeChunk = (file, uuid, index, numChunks, success, failure) ->
  destinationDir = uploadedFilesPath + '/' + uuid + '/' + chunkDirName + '/'
  chunkFilename = getChunkFilename(index, numChunks)
  fileDestination = destinationDir + chunkFilename
  moveFile destinationDir, file.path, fileDestination, success, failure
  return

combineChunks = (file, uuid, success, failure) ->
  chunksDir = uploadedFilesPath + '/' + uuid + '/' + chunkDirName + '/'
  destinationDir = uploadedFilesPath + '/' + uuid + '/'
  fileDestination = destinationDir + file.name
  fs.readdir chunksDir, (err, fileNames) ->
    destFileStream = undefined
    if err
      console.error 'Problem listing chunks! ' + err
      failure()
    else
      fileNames.sort()
      destFileStream = fs.createWriteStream(fileDestination, flags: 'a')
      appendToStream destFileStream, chunksDir, fileNames, 0, (->
        rimraf chunksDir, (rimrafError) ->
          if rimrafError
            console.log 'Problem deleting chunks dir! ' + rimrafError
          return
        success()
        return
      ), failure
    return
  return

appendToStream = (destStream, srcDir, srcFilesnames, index, success, failure) ->
  if index < srcFilesnames.length
    fs.createReadStream(srcDir + srcFilesnames[index]).on('end', ->
      appendToStream destStream, srcDir, srcFilesnames, index + 1, success, failure
      return
    ).on('error', (error) ->
      console.error 'Problem appending chunk! ' + error
      destStream.end()
      failure()
      return
    ).pipe destStream, end: false
  else
    destStream.end()
    success()
  return

getChunkFilename = (index, count) ->
  digits = new String(count).length
  zeros = new Array(digits + 1).join('0')
  (zeros + index).slice -digits

multiparty = require('multiparty')
fileInputName = process.env.FILE_INPUT_NAME or 'qqfile'
publicDir = process.env.PUBLIC_DIR
nodeModulesDir = process.env.NODE_MODULES_DIR
uploadedFilesPath = process.env.UPLOADED_FILES_DIR || './photo-storage'
chunkDirName = 'chunks'

# in bytes, 0 for unlimited
maxFileSize = process.env.MAX_FILE_SIZE or 0

module.exports = (router)->
  router.post '/upload', onUpload
  # app.delete '/server/uploads/:uuid', onDeleteFile
