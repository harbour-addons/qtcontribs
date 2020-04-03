
import QtQml 2.0
import QtQuick 2.2
import QtMultimedia 5.4

import HBQAbstractVideoSurface 1.0


Rectangle {
    id         : cameraUI
    objectName : "camerainterface"
    width      : 480
    height     : 800
    color      : "black"

    signal imageCaptured( string image )

    function stopCamera() {
        camera.stop();
    }
    function startCamera() {
        camera.start();
    }
    function capture() {
        camera.imageCapture.capture();
    }
    function getImage() {
        ;
    }

    Camera {
        id: camera
        objectName: "camera"
        captureMode: Camera.CaptureStillImage

        imageCapture {
            onImageCaptured: {
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
        source           : camera
        autoOrientation  : true

        MouseArea {
            anchors.fill: parent;
            onClicked: camera.imageCapture.capture();
        }
    }

    SoundEffect {
        id      : playSoundCameraFlash
        source  : "qrc:/hbqtqml/resources/wav/barcode-beep.wav"
    }
}

