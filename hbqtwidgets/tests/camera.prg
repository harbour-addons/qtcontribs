/*
 * $Id$
 */

/*
 * Copyright 2014 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */

/*
   This example application is almost the same which is provided in
   Qt 5.3.0 distro under examples/camera section with few differences.
   The changes in original camera.ui are limited to :
   1) changing the name of the mainWindow from Camera to HbQtCamera
   2) removing all signals connected from within the .ui
   These are redone on PRG level. Rest almost every object is the same.
   I have not tested image/video configurations. Dialogs are up and running.

   The example is placed IN hbqtwidgets/tests only FOR one reason, useing Alert().
   IF Alert() calls are removed then it perfectly compiles ok via HbQt only.
*/


REQUEST __HBEXTERN__HBQTMULTIMEDIA__

#include "hbtoqt.ch"
#include "hbqtgui.ch"
#include "inkey.ch"
#include "hbtrace.ch"
#include "hbclass.ch"

FUNCTION Main()
   LOCAL oCamera

   oCamera := HbQtCamera():new()
   oCamera:create()
   oCamera:destroy()

   RETURN NIL


CLASS HbQtCamera

   METHOD new()
   METHOD create()
   METHOD destroy()

   METHOD setCamera( oCameraDevice )

   METHOD startCamera()
   METHOD stopCamera()

   METHOD record()
   METHOD pause()
   METHOD stop()
   METHOD setMuted( lSet )

   METHOD toggleLock()
   METHOD takeImage()
   METHOD displayCaptureError( nInt, nCameraImageCapture_Error, cErrorString )

   METHOD configureCaptureSettings()
   METHOD configureVideoSettings()
   METHOD configureImageSettings()

   METHOD displayRecorderError()
   METHOD displayCameraError()

   METHOD updateCameraDevice( oAction )

   METHOD updateCameraState( nCamera_State )
   METHOD updateCaptureMode()
   METHOD updateRecorderState( nMediaRecorder_State )
   METHOD setExposureCompensation( nIndex )

   METHOD updateRecordTime()

   METHOD processCapturedImage( nRequestId, oImage )
   METHOD updateLockStatus( nLockStatus, nLockChangeReason )

   METHOD displayViewfinder()
   METHOD displayCapturedImage()

   METHOD readyForCapture( lReady )
   METHOD imageSaved( nId, cFileName )

   METHOD keyPressEvent( oKeyEvent )
   METHOD keyReleaseEvent( oKeyEvent )
   METHOD closeEvent( oCloseEvent )

   DATA   oUi

   DATA   oCamera
   DATA   oImageCapture
   DATA   oMediaRecorder

   DATA   oImageSettings
   DATA   oAudioSettings
   DATA   oVideoSettings
   DATA   oVideoDevicesGroup

   DATA   cVideoContainerFormat                   INIT ""
   DATA   lIsCapturingImage                       INIT .F.
   DATA   lApplicationExiting                     INIT .F.

   METHOD loadCameraDevices()

   DATA   aActions                                INIT {}
   DATA   cCameraDevice
   DATA   oTimer

   ENDCLASS


METHOD HbQtCamera:new()
   RETURN Self


METHOD HbQtCamera:destroy()

   ::oImageSettings := NIL
   ::oAudioSettings := NIL
   ::oVideoSettings := NIL

   ::oMediaRecorder := NIL
   ::oImageCapture  := NIL
   ::oCamera        := NIL
   ::oTimer         := NIL

   ::oUi:destroy()

   RETURN NIL


METHOD HbQtCamera:create()

   ::oImageSettings := QImageEncoderSettings()
   ::oAudioSettings := QAudioEncoderSettings()
   ::oVideoSettings := QVideoEncoderSettings()

   ::oTimer := QTimer()
   ::oTimer:setInterval( 4000 )
   ::oTimer:connect( "timeout()", {|| ::displayViewfinder() } )

   ::oUi := hbqtui_camera()

   ::oUi:connect( QEvent_KeyPress  , {|oKeyEvent| ::keyPressEvent( oKeyEvent ) } )
   ::oUi:connect( QEvent_KeyRelease, {|oKeyEvent| ::keyReleaseEvent( oKeyEvent ) } )

   ::loadCameraDevices()
   ::oUi:takeImageButton:setEnabled( .T. )

   ::oUi:takeImageButton  :connect( "clicked()"    , {|| ::takeImage()                } )

   ::oUi:stopButton       :connect( "clicked()"    , {|| ::stop()                     } )
   ::oUi:recordButton     :connect( "clicked()"    , {|| ::record()                   } )
   ::oUi:pauseButton      :connect( "clicked()"    , {|| ::pause()                    } )
   ::oUi:muteButton       :connect( "toggled(bool)", {|lYes| ::setMuted( lYes )       } )
   ::oUi:lockButton       :connect( "clicked()"    , {|| ::toggleLock()               } )

   ::oUi:actionStartCamera:connect( "triggered()"  , {|| ::startCamera()              } )
   ::oUi:actionStopCamera :connect( "triggered()"  , {|| ::stopCamera()               } )
   ::oUi:actionSettings   :connect( "triggered()"  , {|| ::configureCaptureSettings() } )
   ::oUi:actionExit       :connect( "triggered()"  , {|| ::oUi:close()                } )

#ifdef HAVE_CAMERA_BUTTONS
   ::oUi:lockButton:hide()
#endif
   ::oUi:show()

   QApplication():exec()
   RETURN Self


METHOD HbQtCamera:loadCameraDevices()
#if 1
   ::setCamera( QCameraInfo():defaultCamera() )

#else                                             // Not working anyway, so later ...
   LOCAL cameraInfo, cameraDevice, videoDeviceAction, oList, i, description, deviceName

   cameraInfo := QCameraInfo():availableCameras()
Alert("!")
Alert( {cameraInfo:className(), cameraInfo:At( 0 ):deviceName(), cameraInfo:At( 0 ):description() } )

   ::oVideoDevicesGroup := QActionGroup( ::oUi:oWidget )
   ::oVideoDevicesGroup:setExclusive( .T. )

   oList := QCameraInfo():availableCameras()
Alert( 0 )
   IF oList:size() > 0
      FOR i := 0 TO oList:size()-1
Alert( 1 )
         cameraInfo := oList:At( i )
         deviceName := cameraInfo:deviceName()
         description := cameraInfo:description()
Alert( { deviceName, description } )
         videoDeviceAction := QAction( description, ::oVideoDevicesGroup )
         videoDeviceAction:setCheckable( .T. )
         videoDeviceAction:setData( QVariant( QByteArray( deviceName ) ) )
         IF Empty( cameraDevice )
            cameraDevice := deviceName
            videoDeviceAction:setChecked( .T. )
         ENDIF
         ::oUi:menuDevices:addAction( videoDeviceAction )
         AAdd( ::aActions, videoDeviceAction )
      NEXT
   ENDIF
Alert( 2 )
   ::oVideoDevicesGroup:connect( "triggered(QAction*)", {|oAction| ::updateCameraDevice( oAction ) } )
   ::oUi:captureWidget:connect( "currentChanged(int)" , {|nIndex| ::updateCaptureMode( nIndex ) } )

   ::setCamera( QByteArray( cameraDevice ) )

   oList := NIL
#endif
   RETURN NIL


METHOD HbQtCamera:setCamera( oCameraDevice )
   ::oImageCapture  := NIL
   ::oMediaRecorder := NIL
   ::oCamera        := NIL

   IF Empty( oCameraDevice )
      ::oCamera := QCamera()
   ELSE
      ::oCamera := QCamera( oCameraDevice )
   ENDIF

   ::oCamera:connect( "lockFailed()", {|| Alert( "Lock Failed" ) } )
   ::oCamera:connect( "stateChanged(QCamera::State)", {|nState| ::updateCameraState( nState ) } )
   ::oCamera:connect( "error(QCamera::Error)"       , {|| ::displayCameraError() } )

   ::oMediaRecorder := QMediaRecorder( ::oCamera )
   ::oMediaRecorder:connect( "stateChanged(QMediaRecorder::State)", {|nState| ::updateRecorderState( nState ) } )

   ::oImageCapture := QCameraImageCapture( ::oCamera )

   ::oMediaRecorder:connect( "durationChanged(qint64)"     , {|nInt| ::updateRecordTime( nInt ) } )
   ::oMediaRecorder:connect( "error(QMediaRecorder::Error)", {|nRecorderError| ::displayRecorderError( nRecorderError ) } )

   ::oMediaRecorder:setMetaData( "QMediaMetaData::Title", QVariant( QLatin1String( "Test Title" ) ) )

   ::oUi:exposureCompensation:connect( "valueChanged(int)", {|n| ::setExposureCompensation( n ) } )

   ::oCamera:setViewfinder( ::oUi:viewfinder )

   ::updateCameraState( ::oCamera:state() )
   ::updateLockStatus( ::oCamera:lockStatus(), QCamera_UserRequest )
   ::updateRecorderState( ::oMediaRecorder:state() )

   ::oImageCapture:connect( "readyForCaptureChanged(bool)"                 , {|lReady| ::readyForCapture( lReady ) } )
   ::oImageCapture:connect( "imageCaptured(int,QImage)"                    , {|int, oImage| ::processCapturedImage( int, oImage ) } )
   ::oImageCapture:connect( "imageSaved(int,QString)"                      , {|n, cFileName| ::imageSaved( n, cFileName ) } )
   ::oImageCapture:connect( "error(int,QCameraImageCapture::Error,QString)", {|n, nError, cError| ::displayCaptureError( n, nError, cError ) } )

   ::oCamera:connect( "lockStatusChanged(QCamera::LockStatus,QCamera::LockChangeReason)", {|nLockStatus, nLockChangeReason| ::updateLockStatus( nLockStatus, nLockChangeReason ) } )

   ::oUi:captureWidget:setTabEnabled( 0, ::oCamera:isCaptureModeSupported( QCamera_CaptureStillImage ) )
   ::oUi:captureWidget:setTabEnabled( 1, ::oCamera:isCaptureModeSupported( QCamera_CaptureVideo      ) )

   ::updateCaptureMode()

   ::oCamera:start()

   RETURN Self


METHOD HbQtCamera:keyPressEvent( oKeyEvent )
   IF oKeyEvent:isAutoRepeat()
      RETURN .F.
   ENDIF

   SWITCH oKeyEvent:key()
   CASE Qt_Key_CameraFocus
      ::displayViewfinder()
      ::oCamera:searchAndLock()
      oKeyEvent:accept()
      EXIT
   CASE Qt_Key_Camera
      IF ::oCamera:captureMode() == QCamera_CaptureStillImage
         ::takeImage()
      ELSE
         IF ::oMediaRecorder:state() == QMediaRecorder_RecordingState
            ::stop()
         ELSE
            ::record()
         ENDIF
      ENDIF
      oKeyEvent:accept()
      EXIT
   ENDSWITCH
   RETURN .F.


METHOD HbQtCamera:keyReleaseEvent( oKeyEvent )
   IF oKeyEvent:isAutoRepeat()
      RETURN .F.
   ENDIF

   SWITCH oKeyEvent:key()
   CASE Qt_Key_CameraFocus
      ::oCamera:unlock()
      EXIT
   ENDSWITCH

   RETURN .F.


METHOD HbQtCamera:updateRecordTime()
   LOCAL cStr := "Recorded " + hb_ntos( ::oMediaRecorder:duration() / 1000 ) + " sec"
   ::oUi:statusbar:showMessage(  cStr )
   RETURN Self


METHOD HbQtCamera:processCapturedImage( nRequestId, oImage )
   LOCAL scaledImage

   HB_SYMBOL_UNUSED( nRequestId )
   scaledImage := oImage:scaled( ::oUi:viewfinder:size(), Qt_KeepAspectRatio, Qt_SmoothTransformation )

   ::oUi:lastImagePreviewLabel:setPixmap( QPixmap():fromImage( scaledImage ) )

   ::displayCapturedImage()                       // Show for 4 seconds
   ::oTimer:start()

   RETURN Self


METHOD HbQtCamera:configureCaptureSettings()
   SWITCH ::oCamera:captureMode()
   CASE QCamera_CaptureStillImage
      ::configureImageSettings()
      EXIT
   CASE QCamera_CaptureVideo
      ::configureVideoSettings()
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtCamera:configureVideoSettings()
   LOCAL oSettingsDialog := VideoSettings():new( ::oMediaRecorder )

   oSettingsDialog:setAudioSettings( ::oAaudioSettings )
   oSettingsDialog:setVideoSettings( ::oVideoSettings )
   oSettingsDialog:setFormat( ::oVideoContainerFormat )

   IF oSettingsDialog:exec() > 0
       ::oAudioSettings := oSettingsDialog:audioSettings()
       ::oVideoSettings := oSettingsDialog:videoSettings()
       ::oVideoContainerFormat := oSettingsDialog:format()
       ::oMediaRecorder:setEncodingSettings( ::oAudioSettings, ::oVideoSettings, ::oVideoContainerFormat )
   ENDIF
   RETURN Self


METHOD HbQtCamera:configureImageSettings()
   LOCAL oSettingsDialog := ImageSettings():new( ::oImageCapture )

   oSettingsDialog:setImageSettings( ::oImageSettings )

   IF oSettingsDialog:exec() > 0
      ::oImageSettings := oSettingsDialog:imageSettings()
      ::oImageCapture:setEncodingSettings( ::oImageSettings )
   ENDIF
   RETURN Self


METHOD HbQtCamera:record()
   ::oMediaRecorder:record()
   ::updateRecordTime()
   RETURN Self


METHOD HbQtCamera:pause()
   ::oMediaRecorder:pause()
   RETURN Self


METHOD HbQtCamera:stop()
   ::oMediaRecorder:stop()
   RETURN Self


METHOD HbQtCamera:setMuted( lSet )
   ::oMediaRecorder:setMuted( lSet )
   RETURN Self


METHOD HbQtCamera:toggleLock()
   SWITCH ::oCamera:lockStatus()
   CASE QCamera_Searching
   CASE QCamera_Locked
      ::oCamera:unlock()
      EXIT
   CASE QCamera_Unlocked
      ::oCamera:searchAndLock()
   ENDSWITCH
   RETURN Self


METHOD HbQtCamera:updateLockStatus( nLockStatus, nLockChangeReason )
   LOCAL oIndicationColor
   LOCAL oPalette

   SWITCH nLockStatus
   CASE QCamera_Searching
      oIndicationColor := QColor( Qt_yellow )
      ::oUi:statusbar:showMessage( "Focusing:::" )
      ::oUi:lockButton:setText( "Focusing:::" )
      EXIT
   CASE QCamera_Locked
      oIndicationColor := QColor( Qt_darkGreen )
      ::oUi:lockButton:setText( "Unlock" )
      ::oUi:statusbar:showMessage( "Focused", 2000 )
      EXIT
   CASE QCamera_Unlocked
      oIndicationColor := QColor( iif( nLockChangeReason == QCamera_LockFailed, Qt_red, Qt_black ) )
      ::oUi:lockButton:setText( "Focus" )
      IF nLockChangeReason == QCamera_LockFailed
         ::oUi:statusbar:showMessage( "Focus Failed", 2000 )
      ENDIF
      EXIT
   OTHERWISE
      oIndicationColor := QColor( Qt_black )
      EXIT
   ENDSWITCH

   oPalette := ::oUi:lockButton:palette()
   oPalette:setColor( QPalette_ButtonText, oIndicationColor )
   ::oUi:lockButton:setPalette( oPalette )

   oIndicationColor := NIL
   RETURN Self


METHOD HbQtCamera:takeImage()
   ::lIsCapturingImage := .T.
   ::oImageCapture:capture()
   RETURN Self


METHOD HbQtCamera:displayCaptureError( nInt, nCameraImageCapture_Error, cErrorString )
   HB_SYMBOL_UNUSED( nInt )
   HB_SYMBOL_UNUSED( nCameraImageCapture_Error )
   Alert( { "Image Capture Error", cErrorString } )
   ::lIsCapturingImage := .F.
   RETURN Self


METHOD HbQtCamera:startCamera()
   ::oCamera:start()
   RETURN Self


METHOD HbQtCamera:stopCamera()
   ::oCamera:stop()
   RETURN self


METHOD HbQtCamera:updateCaptureMode()
   LOCAL nTabIndex := ::oUi:captureWidget:currentIndex()
   LOCAL nCaptureMode := iif( nTabIndex == 0, QCamera_CaptureStillImage, QCamera_CaptureVideo )

   IF ::oCamera:isCaptureModeSupported( nCaptureMode )
      ::oCamera:setCaptureMode( nCaptureMode )
   ENDIF
   RETURN Self


METHOD HbQtCamera:updateCameraState( nCamera_State )
   SWITCH nCamera_State
   CASE QCamera_ActiveState
      ::oUi:actionStartCamera:setEnabled( .F. )
      ::oUi:actionStopCamera:setEnabled( .T. )
      ::oUi:captureWidget:setEnabled( .T. )
      ::oUi:actionSettings:setEnabled( .T. )
      EXIT
   CASE QCamera_UnloadedState
   CASE QCamera_LoadedState
      ::oUi:actionStartCamera:setEnabled( .T. )
      ::oUi:actionStopCamera:setEnabled( .F. )
      ::oUi:captureWidget:setEnabled( .F. )
      ::oUi:actionSettings:setEnabled( .F. )
   ENDSWITCH
   RETURN Self


METHOD HbQtCamera:updateRecorderState( nMediaRecorder_State )
   SWITCH nMediaRecorder_State
   CASE QMediaRecorder_StoppedState
      ::oUi:recordButton:setEnabled( .T. )
      ::oUi:pauseButton:setEnabled( .T. )
      ::oUi:stopButton:setEnabled( .F. )
      EXIT
   CASE QMediaRecorder_PausedState
      ::oUi:recordButton:setEnabled( .T. )
      ::oUi:pauseButton:setEnabled( .F. )
      ::oUi:stopButton:setEnabled( .T. )
      EXIT
   CASE QMediaRecorder_RecordingState
      ::oUi:recordButton:setEnabled( .F. )
      ::oUi:pauseButton:setEnabled( .T. )
      ::oUi:stopButton:setEnabled( .T. )
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtCamera:setExposureCompensation( nIndex )
   ::oCamera:exposure():setExposureCompensation( nIndex*0.5 )
   RETURN Self


METHOD HbQtCamera:displayRecorderError()
   Alert( { "Capture error", ::oMediaRecorder:errorString() } )
   RETURN Self


METHOD HbQtCamera:displayCameraError()
   Alert( { "Camera error", ::oCamera:errorString() } )
   RETURN Self


METHOD HbQtCamera:updateCameraDevice( oAction )
   ::setCamera( oAction:data():toByteArray() )
   RETURN Self


METHOD HbQtCamera:displayViewfinder()
   ::oTimer:stop()
   ::oUi:stackedWidget:setCurrentIndex( 0 )
   RETURN Self


METHOD HbQtCamera:displayCapturedImage()
   ::oUi:stackedWidget:setCurrentIndex( 1 )
   RETURN Self


METHOD HbQtCamera:readyForCapture( lReady )
   ::oUi:takeImageButton:setEnabled( lReady )
   RETURN Self


METHOD HbQtCamera:imageSaved( nId, cFileName )
   HB_SYMBOL_UNUSED( nId )
   HB_SYMBOL_UNUSED( cFileName )
   ::lIsCapturingImage := .F.
   IF ::lApplicationExiting
      ::oUi:oWidget:close()
   ENDIF
   RETURN Self


METHOD HbQtCamera:closeEvent( oCloseEvent )
   IF ::lIsCapturingImage
      ::oUi:setEnabled( .F. )
      ::lApplicationExiting := .T.
      oCloseEvent:ignore()
   ELSE
      oCloseEvent:accept()
   ENDIF
   RETURN Self


/*----------------------------------------------------------------------*/
//                          Class imageSettings
/*----------------------------------------------------------------------*/

CLASS imageSettings
   DATA   oUi
   DATA   oImageCapture

   METHOD new( oImageCapture )
   METHOD destroy()
   METHOD exec()
   METHOD imageSettings()
   METHOD setImageSettings( imageSettings )
   METHOD boxValue( oComboBox )
   METHOD selectComboBoxItem( oComboBox, oVariant )

   ENDCLASS


METHOD imageSettings:exec()
   RETURN ::oUi:exec()


METHOD imageSettings:destroy()
   ::oUi:destroy()
   ::oImageCapture := NIL
   RETURN NIL


METHOD imageSettings:new( oImageCapture )
   LOCAL oList, i, description, codecName, supportedResolutions, oSize

   ::oUi := hbqtui_ImageSettings()
   ::oUi:connect( QEvent_Close, {|| ::destroy() } )

   ::oImageCapture := oImageCapture

   ::oUi:imageCodecBox:addItem( "Default image format", QVariant( "" ) )
   oList := ::oImageCapture:supportedImageCodecs()

   FOR i := 0 TO oList:size()-1
      codecName := oList:At( i )
      description = ::oImageCapture:imageCodecDescription( codecName )
      ::oUi:imageCodecBox:addItem( codecName + ": " + description, QVariant( codecName ) )
   NEXT

   ::oUi:imageQualitySlider:setRange( 0, Int( QMultimedia_VeryHighQuality ) )

   ::oUi:imageResolutionBox:addItem( "Default Resolution" )
   supportedResolutions := ::oImageCapture:supportedResolutions()
   FOR i := 0 TO supportedResolutions:size()-1
      oSize := supportedResolutions:At( i )
      ::oUi:imageResolutionBox:addItem( hb_ntos( oSize:width() ) + ":" + hb_ntos( oSize:height() ), QVariant( oSize ) )
   NEXT
   RETURN Self


METHOD imageSettings:imageSettings()
   LOCAL settings := ::oImageCapture:encodingSettings()

   settings:setCodec( ::boxValue( ::oUi:imageCodecBox ):toString() )
   settings:setQuality( ::oUi:imageQualitySlider:value() )
   settings:setResolution( ::boxValue( ::oUi:imageResolutionBox ):toSize() )

   RETURN settings


METHOD imageSettings:setImageSettings( imageSettings )
   ::selectComboBoxItem( ::oUi:imageCodecBox, QVariant(imageSettings:codec() ) )
   ::selectComboBoxItem( ::oUi:imageResolutionBox, QVariant(imageSettings:resolution() ) )
   ::oUi:imageQualitySlider:setValue( imageSettings:quality() )
   RETURN Self


METHOD imageSettings:boxValue( oComboBox )
   IF oComboBox:currentIndex()== -1
      RETURN QVariant()
   ENDIF
   RETURN oComboBox:itemData( oComboBox:currentIndex() )


METHOD imageSettings:selectComboBoxItem( oComboBox, oVariant )
   LOCAL i

   FOR i := 0 TO oComboBox:count() - 1
      IF oComboBox:itemData( i ) == oVariant
         oComboBox:setCurrentIndex( i )
         EXIT
      ENDIF
   NEXT
   RETURN Self

/*----------------------------------------------------------------------*/
//                      Class VideoSettings
/*----------------------------------------------------------------------*/

CLASS VideoSettings
   DATA   oUi
   DATA   oMediaRecorder

   METHOD new( oMediaRecorder )
   METHOD destroy()
   METHOD exec()

   METHOD audioSettings()
   METHOD setAudioSettings( audioSettings )
   METHOD videoSettings()
   METHOD setVideoSettings( videoSettings )
   METHOD format()
   METHOD setFormat( format )
   METHOD boxValue( box )
   METHOD selectComboBoxItem( box, value )

   ENDCLASS


METHOD VideoSettings:exec()
   RETURN ::oUi:exec()


METHOD VideoSettings:destroy()
   ::oUi:destroy()
   ::oMediaRecorder := NIL
   RETURN NIL


METHOD VideoSettings:new( oMediaRecorder )
   LOCAL i, oList, codecName, description, oSize, cRate, format

   ::oMediaRecorder := oMediaRecorder

   ::oUi := hbqtui_videoSettings()
   ::oUi:connect( QEvent_Close, {|| ::destroy() } )


   ::oUi:audioCodecBox:addItem( "Default audio codec", QVariant( "" ) )
   oList := ::oMediaRecorder:supportedAudioCodecs()
   FOR i := 0 TO oList:count()-1
      codecName := oList:At( i )
      description := oMediaRecorder:audioCodecDescription( codecName )
      ::oUi:audioCodecBox:addItem( codecName + ": " + description, QVariant( codecName ) )
   NEXT
   oList := NIL

   oList := ::oMediaRecorder:supportedAudioSampleRates()
   FOR i := 0 TO oList:count()-1
      ::oUi:audioSampleRateBox:addItem( hb_ntos( oList:At( i ) ), QVariant( oList:At( i ) ) )
   NEXT
   oList := NIL

   ::oUi:audioQualitySlider:setRange( 0, Int( QMultimedia_VeryHighQuality ) )

   ::oUi:videoCodecBox:addItem( "Default video codec", QVariant( "" ) )
   oList := ::oMediaRecorder:supportedVideoCodecs()
   FOR i := 1 TO oList:count()-1
      codecName := oList:At( i )
      description := ::oMediaRecorder:videoCodecDescription( codecName )
      ::oUi:videoCodecBox:addItem( codecName + ": " + description, QVariant( codecName ) )
   NEXT
   oList := NIL

   ::oUi:videoQualitySlider:setRange( 0, Int( QMultimedia_VeryHighQuality ) )

   ::oUi:videoResolutionBox:addItem( "Default" )
   oList := ::oMediaRecorder:supportedResolutions()
   FOR i := 1 TO oList:count()-1
      oSize := oList:At( i )
      ::oUi:videoResolutionBox:addItem( hb_ntos( oSize:width() ) + "x" + hb_ntos( oSize:height() ), QVariant( oSize ) )
   NEXT
   oList := NIL

   ::oUi:videoFramerateBox:addItem( "Default" )
   oList := ::oMediaRecorder:supportedFrameRates()
   FOR i := 1 TO oList:count()-1
      cRate := hb_ntos( oList:At( i ) )
      ::oUi:videoFramerateBox:addItem( cRate, QVariant( oList:At( i ) ) )
   NEXT
   oList := NIL

   ::oUi:containerFormatBox:addItem( "Default container", QVariant( "" ) )
   oList := ::oMediaRecorder:supportedContainers()
   FOR i := 1 TO oList:count()-1
      format := oList:At( i )
      ::oUi:containerFormatBox:addItem( format + ":" + ::oMediaRecorder:containerDescription( format ), QVariant( format ) )
   NEXT
   oList := NIL

   RETURN Self

METHOD VideoSettings:audioSettings()
   LOCAL settings := ::oMediaRecorder:audioSettings()

   settings:setCodec( ::boxValue( ::oUi:audioCodecBox):toString() )
   settings:setQuality( ::oUi:audioQualitySlider:value() )
   settings:setSampleRate( ::boxValue( ::oUi:audioSampleRateBox ):toInt() )

   RETURN settings


METHOD VideoSettings:setAudioSettings( audioSettings )
   ::selectComboBoxItem( ::oUi:audioCodecBox, QVariant( audioSettings:codec() ) )
   ::selectComboBoxItem( ::oUi:audioSampleRateBox, QVariant( audioSettings:sampleRate() ) )
   ::oUi:audioQualitySlider:setValue( audioSettings:quality() )
   RETURN Self


METHOD VideoSettings:videoSettings()
   LOCAL settings := ::oMediaRecorder:videoSettings()

   settings:setCodec( ::boxValue( ::oUi:videoCodecBox):toString() )
   settings:setQuality( ::oUi:videoQualitySlider:value() )
   settings:setResolution( ::boxValue( ::oUi:videoResolutionBox ):toSize() )
   settings:setFrameRate( ::boxValue( ::oUi:videoFramerateBox ):value() )

   RETURN settings


METHOD VideoSettings:setVideoSettings( videoSettings )
   LOCAL i, itemRate

   ::selectComboBoxItem( ::oUi:videoCodecBox, QVariant( videoSettings:codec() ) )
   ::selectComboBoxItem( ::oUi:videoResolutionBox, QVariant( videoSettings:resolution() ) )
   ::oUi:videoQualitySlider:setValue( videoSettings:quality() )

   FOR i := 0 TO ::oUi:videoFramerateBox:count()-1
      itemRate := ::oUi:videoFramerateBox:itemData(i):value()
      //IF qFuzzyCompare( itemRate, videoSettings:frameRate() )
      IF itemRate == videoSettings:frameRate()
          ::oUi:videoFramerateBox:setCurrentIndex( i )
          EXIT
       ENDIF
   NEXT
   RETURN Self


METHOD VideoSettings:format()
   RETURN ::boxValue( ::oUi:containerFormatBox ):toString()


METHOD VideoSettings:setFormat( format )
   ::selectComboBoxItem( ::oUi:containerFormatBox, QVariant( format ) )
   RETURN Self


METHOD VideoSettings:boxValue( box )
   LOCAL idx := box:currentIndex()
   IF idx == -1
      RETURN QVariant()
   ENDIF
   RETURN box:itemData( idx )


METHOD VideoSettings:selectComboBoxItem( box, value )
   LOCAL i
   FOR i := 0 TO box:count()-1
      IF box:itemData( i ) == value
         box:setCurrentIndex( i )
         EXIT
      ENDIF
   NEXT
   RETURN Self

