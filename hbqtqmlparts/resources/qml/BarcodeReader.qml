
import QtQml 2.0
import QtQuick 2.2
import QtMultimedia 5.4

import QZXing 2.3
import HBQAbstractVideoSurface 1.0


Rectangle {
    id         : cameraUI
    objectName : "camerainterface"
    width      : 480
    height     : 800
    color      : "black"

    property bool stopScanningFrames

    signal imageCaptured( string image )
    signal tagFound( string tag )


    function startScanning() {
       stopScanningFrames = false;
    }
    function stopScanning() {
       stopScanningFrames = true;
    }
    function stopCamera() {
        cameraUI.stopScanning();
        camera.stop();
    }
    function startCamera() {
        camera.start();
        cameraUI.startScanning();
        myVideoSurface.decoder = decoder;
        myVideoSurface.source  = camera;
    }

    Camera {
        id: camera
        objectName: "camera"
        captureMode: Camera.CaptureViewfinder

        focus {
            focusMode: Camera.FocusMacro + Camera.FocusContinuous
            focusPointMode: Camera.FocusPointCenter
        }

        exposure {
            exposureMode: Camera.ExposureSteadyPhoto
        }

        imageProcessing {
            contrast       : 1.0
            saturation     : -1.0
            denoisingLevel : 1.0
        }

        imageCapture {
            onImageCaptured: {
                //cameraImage.source = preview;
                cameraUI.imageCaptured( preview );
            }
        }
    }

    VideoOutput {
        id               : viewfinder
        objectName       : "viewfinder"
        visible          : true
        anchors.fill     : parent
        focus            : visible
        autoOrientation  : true
        source           : Qt.platform.os == "android" ? camera : myVideoSurface

        property int lW  : 480
        property int lW2 : 240

        property int lH  : 300
        property int lH2 : 150

        property int pW  : 300
        property int pW2 : 150

        property int pH  : 480
        property int pH2 : 240

        property bool isLS : viewfinder.width > viewfinder.height

        // display focus areas on camera viewfinder:
        //
        Repeater {
            model: camera.focus.focusZones
            Rectangle {
                id    :  focusArea
                color : "transparent"

                x     : viewfinder.width  / 2 - ( viewfinder.isLS ? viewfinder.lW2 : viewfinder.pW2 )
                y     : viewfinder.height / 2 - ( viewfinder.isLS ? viewfinder.lH2 : viewfinder.pH2 )
                width : viewfinder.isLS ? viewfinder.lW : viewfinder.pW
                height: viewfinder.isLS ? viewfinder.lH : viewfinder.pH

                Rectangle {
                    x       : viewfinder.isLS ? 0 + 5 : parent.width / 2 - 3
                    y       : viewfinder.isLS ? parent.height / 2 - 3 : 0 + 5
                    width   : viewfinder.isLS ? parent.width - 10 : 5
                    height  : viewfinder.isLS ? 5 : parent.height - 10
                    color   : "red"
                    opacity : 0.3
                }
            }
        }

        Repeater {
            model: 1
            Rectangle {
                x       : 0
                y       : 0
                width   : viewfinder.width
                height  : viewfinder.height / 2 - ( viewfinder.isLS ? viewfinder.lH2 : viewfinder.pH2 )
                color   : "black"
                opacity : 0.5
            }
        }

        Repeater {
            model: 1
            Rectangle {
                x       : 0
                y       : viewfinder.height / 2 + ( viewfinder.isLS ? viewfinder.lH2 : viewfinder.pH2 )
                width   : viewfinder.width
                height  : viewfinder.height / 2 - ( viewfinder.isLS ? viewfinder.lH2 : viewfinder.pH2 )
                color   : "black"
                opacity : 0.5
            }
        }

        Repeater {
            model: 1
            Rectangle {
                x       : 0
                y       : viewfinder.height / 2 - ( viewfinder.isLS ? viewfinder.lH2 : viewfinder.pH2 )
                width   : viewfinder.width  / 2 - ( viewfinder.isLS ? viewfinder.lW2 : viewfinder.pW2 )
                height  : viewfinder.isLS ? viewfinder.lH : viewfinder.pH
                color   : "black"
                opacity : 0.5
            }
        }

        Repeater {
            model: 1
            Rectangle {
                x       : viewfinder.width  / 2 + ( viewfinder.isLS ? viewfinder.lW2 : viewfinder.pW2 )
                y       : viewfinder.height / 2 - ( viewfinder.isLS ? viewfinder.lH2 : viewfinder.pH2 )
                width   : viewfinder.width  / 2 - ( viewfinder.isLS ? viewfinder.lW2 : viewfinder.pW2 )
                height  : viewfinder.isLS ? viewfinder.lH : viewfinder.pH
                color   : "black"
                opacity : 0.5
            }
        }
    }

    QZXing{
        id         : decoder
        objectName : "qzxing"
        onTagFound : {
            if( ! cameraUI.stopScanningFrames )
            {
                cameraUI.stopScanningFrames = true;
                playSoundCameraFlash.play();
                cameraUI.tagFound( tag );
            }
        }
    }

    HBQAbstractVideoSurface{
        id         : myVideoSurface
        objectName : "videosurface"
    }

    SoundEffect {
        id      : playSoundCameraFlash
        source  : "qrc:/hbqtqml/resources/wav/barcode-beep.wav"
    }
}

