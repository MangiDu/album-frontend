# Requirements:
#  - rimraf (for "rm -rf" support)
#  - multiparty (for parsing request payloads)
#  - mkdirp (for "mkdir -p" support)

fs = require('fs')
rimraf = require('rimraf')
mkdirp = require('mkdirp')
imagemagick = require 'imagemagick'
_ = require 'underscore'

Photo = require '../models/photo'
PHOTO_PREFIX = 'thumbnail-'

onUpload = (req, res) ->
  form = new (multiparty.Form)
  form.parse req, (err, fields, files) ->
    partIndex = fields.qqpartindex
    # text/plain is required to ensure support for IE9 and older
    res.set 'Content-Type', 'text/plain'
    onSimpleUpload fields, files[fileInputName][0], res, (destinationDir, fileName)->
      responseData = success: true
      photo = new Photo(
        user: req.user._id
        title: fields.qqfilename
        url: destinationDir + fileName
        thumbnail:  destinationDir + PHOTO_PREFIX + fileName
      )
      photo.save (err)->
        if err
          console.log 'photo save got a mistake'
        res.send _.extend responseData, {photo: photo}
    , ->
      responseData = error: 'Problem copying the file!'
      res.send responseData

onSimpleUpload = (fields, file, res, success, error) ->
  uuid = fields.qquuid
  responseData = success: false
  file.name = fields.qqfilename
  if isValid(file.size)
    moveUploadedFile file, uuid, success, error
  else
    failWithTooBigFile responseData, res
  return

failWithTooBigFile = (responseData, res) ->
  responseData.error = 'Too big!'
  responseData.preventRetry = true
  res.send responseData
  return

# onDeleteFile = (req, res) ->
#   uuid = req.params.uuid
#   dirToDelete = uploadedFilesPath + '/' + uuid
#   rimraf dirToDelete, (error) ->
#     if error
#       console.error 'Problem deleting file! ' + error
#       res.status 500
#     res.send()
#     return
#   return

isValid = (size) ->
  maxFileSize == 0 or size < maxFileSize

moveFile = (destinationDir, sourceFile, fileName, success, failure) ->
  info = fileName.split('.')
  suffix = info[info.length - 1]
  fileName = "#{new Date().getTime()}.#{suffix}"
  mkdirp destinationDir, (error) ->
    sourceStream = undefined
    destStream = undefined
    if error
      console.error 'Problem creating directory ' + destinationDir + ': ' + error
      failure()
    else
      sourceStream = fs.createReadStream(sourceFile)
      destStream = fs.createWriteStream(destinationDir + fileName)
      sourceStream.on('error', (error) ->
        console.error 'Problem copying file: ' + error.stack
        destStream.end()
        failure()
        return
      ).on('end', ->
        destStream.end()
        imagemagick.convert [
          destinationDir + fileName
          '-resize'
          '300x400'
          destinationDir + PHOTO_PREFIX + fileName
        ], (err) ->
          if err
            throw err
        success(destinationDir, fileName)
      ).pipe destStream
    return
  return

moveUploadedFile = (file, uuid, success, failure) ->
  destinationDir = uploadedFilesPath + '/' + uuid + '/'
  fileDestination = destinationDir + file.name
  # moveFile destinationDir, file.path, fileDestination, success, failure
  moveFile destinationDir, file.path, file.name[0], success, failure
  return

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
