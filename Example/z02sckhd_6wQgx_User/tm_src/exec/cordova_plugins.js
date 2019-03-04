cordova.define('cordova/plugin_list', function(require, exports, module) {
               module.exports = [
                                 {
                                 "id": "cordova-plugin-1password.OnePassword",
                                 "file": "plugins/cordova-plugin-1password/www/onepassword.js",
                                 "pluginId": "cordova-plugin-1password",
                                 "clobbers": [
                                              "OnePassword"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-device.device",
                                 "file": "plugins/cordova-plugin-device/www/device.js",
                                 "pluginId": "cordova-plugin-device",
                                 "clobbers": [
                                              "device"
                                              ]
                                 },
                                 {
                                 "id": "tm-plugin-controller.TMController",
                                 "file": "plugins/tm-plugin-controller/www/tmcontroller",
                                 "pluginId": "tm-plugin-controller",
                                 "clobbers": [
                                              "TMController"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-mauron85-background-geolocation.backgroundGeolocation",
                                 "file": "plugins/cordova-plugin-mauron85-background-geolocation/www/backgroundGeolocation.js",
                                 "pluginId": "cordova-plugin-mauron85-background-geolocation",
                                 "clobbers": [
                                              "backgroundGeolocation"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-camera.Camera",
                                 "file": "plugins/cordova-plugin-camera/www/CameraConstants.js",
                                 "pluginId": "cordova-plugin-camera",
                                 "clobbers": [
                                              "Camera"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-camera.CameraPopoverOptions",
                                 "file": "plugins/cordova-plugin-camera/www/CameraPopoverOptions.js",
                                 "pluginId": "cordova-plugin-camera",
                                 "clobbers": [
                                              "CameraPopoverOptions"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-camera.camera",
                                 "file": "plugins/cordova-plugin-camera/www/Camera.js",
                                 "pluginId": "cordova-plugin-camera",
                                 "clobbers": [
                                              "navigator.camera"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-camera.CameraPopoverHandle",
                                 "file": "plugins/cordova-plugin-camera/www/ios/CameraPopoverHandle.js",
                                 "pluginId": "cordova-plugin-camera",
                                 "clobbers": [
                                              "CameraPopoverHandle"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-network-information.network",
                                 "file": "plugins/cordova-plugin-network-information/www/network.js",
                                 "pluginId": "cordova-plugin-network-information",
                                 "clobbers": [
                                              "navigator.connection",
                                              "navigator.network.connection"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-network-information.Connection",
                                 "file": "plugins/cordova-plugin-network-information/www/Connection.js",
                                 "pluginId": "cordova-plugin-network-information",
                                 "clobbers": [
                                              "Connection"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-audioinput.AudioInput",
                                 "file": "plugins/cordova-plugin-audioinput/www/audioInputCapture.js",
                                 "pluginId": "cordova-plugin-audioinput",
                                 "clobbers": [
                                              "audioinput"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-geolocation.Coordinates",
                                 "file": "plugins/cordova-plugin-geolocation/www/Coordinates.js",
                                 "pluginId": "cordova-plugin-geolocation",
                                 "clobbers": [
                                              "Coordinates"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-geolocation.PositionError",
                                 "file": "plugins/cordova-plugin-geolocation/www/PositionError.js",
                                 "pluginId": "cordova-plugin-geolocation",
                                 "clobbers": [
                                              "PositionError"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-geolocation.Position",
                                 "file": "plugins/cordova-plugin-geolocation/www/Position.js",
                                 "pluginId": "cordova-plugin-geolocation",
                                 "clobbers": [
                                              "Position"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-geolocation.geolocation",
                                 "file": "plugins/cordova-plugin-geolocation/www/geolocation.js",
                                 "pluginId": "cordova-plugin-geolocation",
                                 "clobbers": [
                                              "navigator.geolocation"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.DirectoryEntry",
                                 "file": "plugins/cordova-plugin-file/www/DirectoryEntry.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.DirectoryEntry"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.DirectoryReader",
                                 "file": "plugins/cordova-plugin-file/www/DirectoryReader.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.DirectoryReader"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.Entry",
                                 "file": "plugins/cordova-plugin-file/www/Entry.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.Entry"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.File",
                                 "file": "plugins/cordova-plugin-file/www/File.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.File"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.FileEntry",
                                 "file": "plugins/cordova-plugin-file/www/FileEntry.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.FileEntry"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.FileError",
                                 "file": "plugins/cordova-plugin-file/www/FileError.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.FileError"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.FileReader",
                                 "file": "plugins/cordova-plugin-file/www/FileReader.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.FileReader"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.FileSystem",
                                 "file": "plugins/cordova-plugin-file/www/FileSystem.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.FileSystem"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.FileUploadOptions",
                                 "file": "plugins/cordova-plugin-file/www/FileUploadOptions.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.FileUploadOptions"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.FileUploadResult",
                                 "file": "plugins/cordova-plugin-file/www/FileUploadResult.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.FileUploadResult"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.FileWriter",
                                 "file": "plugins/cordova-plugin-file/www/FileWriter.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.FileWriter"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.Flags",
                                 "file": "plugins/cordova-plugin-file/www/Flags.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.Flags"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.LocalFileSystem",
                                 "file": "plugins/cordova-plugin-file/www/LocalFileSystem.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.LocalFileSystem"
                                              ],
                                 "merges": [
                                            "window"
                                            ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.Metadata",
                                 "file": "plugins/cordova-plugin-file/www/Metadata.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.Metadata"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.ProgressEvent",
                                 "file": "plugins/cordova-plugin-file/www/ProgressEvent.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.ProgressEvent"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.fileSystems",
                                 "file": "plugins/cordova-plugin-file/www/fileSystems.js",
                                 "pluginId": "cordova-plugin-file"
                                 },
                                 {
                                 "id": "cordova-plugin-file.requestFileSystem",
                                 "file": "plugins/cordova-plugin-file/www/requestFileSystem.js",
                                 "pluginId": "cordova-plugin-file",
                                 "clobbers": [
                                              "window.requestFileSystem"
                                              ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.resolveLocalFileSystemURI",
                                 "file": "plugins/cordova-plugin-file/www/resolveLocalFileSystemURI.js",
                                 "pluginId": "cordova-plugin-file",
                                 "merges": [
                                            "window"
                                            ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.isChrome",
                                 "file": "plugins/cordova-plugin-file/www/browser/isChrome.js",
                                 "pluginId": "cordova-plugin-file",
                                 "runs": true
                                 },
                                 {
                                 "id": "cordova-plugin-file.iosFileSystem",
                                 "file": "plugins/cordova-plugin-file/www/ios/FileSystem.js",
                                 "pluginId": "cordova-plugin-file",
                                 "merges": [
                                            "FileSystem"
                                            ]
                                 },
                                 {
                                 "id": "cordova-plugin-file.fileSystems-roots",
                                 "file": "plugins/cordova-plugin-file/www/fileSystems-roots.js",
                                 "pluginId": "cordova-plugin-file",
                                 "runs": true
                                 },
                                 {
                                 "id": "cordova-plugin-file.fileSystemPaths",
                                 "file": "plugins/cordova-plugin-file/www/fileSystemPaths.js",
                                 "pluginId": "cordova-plugin-file",
                                 "merges": [
                                            "cordova"
                                            ],
                                 "runs": true
                                 },
                                 {
                                 "id": "cordova.custom.plugins.exitapp.exitApp",
                                 "file": "plugins/cordova.custom.plugins.exitapp/www/ExitApp.js",
                                 "pluginId": "cordova.custom.plugins.exitapp",
                                 "merges": [
                                            "navigator.app"
                                            ]
                                 }
                                 ];
               module.exports.metadata =
               // TOP OF METADATA
               {
               "cordova-plugin-whitelist": "1.3.2",
               "cordova-plugin-1password": "0.1.5",
               "cordova-plugin-device": "1.1.6",
               "tm-plugin-controller": "1.0.0",
               "cordova-plugin-camera": "3.0.0",
               "cordova-plugin-mauron85-background-geolocation": "2.3.3",
               "cordova-plugin-document-viewer": "0.9.7",
               "cordova-plugin-network-information": "1.3.4",
               "cordova-plugin-audioinput": "0.3.0",
               "cordova-plugin-geolocation": "3.0.0",
               "cordova-plugin-compat": "1.2.0",
               "cordova-plugin-file": "5.0.0",
               "cordova.custom.plugins.exitapp": "1.0.0"
               };
               // BOTTOM OF METADATA
               });
