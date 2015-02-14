/*
 * $Id$
 */

/*
 * Copyright 2014 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */


#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "inkey.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"
#include "common.ch"


STATIC s_lInDemoMode := .T.


FUNCTION Main()
   LOCAL oWnd, oDa, oLay, oVisualizer, oRect

   hbqt_errorsys()

   QApplication():setStyleSheet( __styleSheet() )

   oWnd := QMainWindow()

   WITH OBJECT oLay := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   WITH OBJECT oDa := QWidget()
      :setLayout( oLay )
   ENDWITH
   oWnd:setCentralWidget( oDa )
   __hbqtAppWidget( oWnd )                        // ensures that slidings and silver screen works perfect

   oVisualizer := buildVisualizer( oDA )

   oRect := QApplication():desktop():availableGeometry()
   WITH OBJECT oWnd
#ifndef __ANDROID__
      :resize( oRect:width()-150, oRect:height()-150 )
      :move( 75, 75 )
#endif
   ENDWITH

   oWnd:show()

   QApplication():exec()

   HB_SYMBOL_UNUSED( oRect + oVisualizer )
   RETURN NIL


STATIC FUNCTION __styleSheet()
   LOCAL cCSS := ""
   LOCAL aCSS := {}

   AAdd( aCSS, 'QListWidget{' )
   AAdd( aCSS, '   background-color: rgb(210,210,210);' )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QSplitter{' )
   AAdd( aCSS, '   min-height: '                 + __hbqtCssPX( 10 ) )
   AAdd( aCSS, '   min-width: '                  + __hbqtCssPX( 10 ) )
   AAdd( aCSS, '}' )
   AAdd( aCSS, 'QSplitter::handle{' )
   AAdd( aCSS, '   background-color: rgb(190,190,190);' )
   AAdd( aCSS, '}' )

   AEval( aCSS, {|e| cCSS += e + Chr( 13 ) + Chr( 10 ) } )
   RETURN cCSS



FUNCTION buildVisualizer( oDA )
   LOCAL oVisualizer

   WITH OBJECT oVisualizer := HbQtVisualizer():new():create( oDA )
#ifndef __MOBILE__
      __hbqGraphics_AllowResizeInPlace( .F. )
      :setSplitterSizes( 210, 210 )
#endif
      :visualsListBlock    := {|| supplyVisualsList() }
      :visualsLoadBlock    := {|cRefID,nVer| supplyVisualsData( cRefID, nVer ) }
      :visualsSaveBlock    := {|cRefID,nVer,hVisual| saveVisual( cRefID, nVer, hVisual ) }
      :visualInfoBlock     := {|cRequiredInfo,cRefID,nVer| supplyVisualInfo( cRequiredInfo, cRefID, nVer ) }
   ENDWITH
   RETURN oVisualizer


FUNCTION supplyVisualsData( cRefID, nVer )
   // some parameters has to be resolved here
   RETURN loadVisual( cRefID, nVer )


FUNCTION supplyVisualsList()
   LOCAL hVisuals, hList, hState, hStates, aMarker, aMarkers, hMarkers, hMarker, hField, hStruct
   LOCAL nVer := 1

   hList := __hbqtStandardHash()
   //
   hList[ "LA-FL-01" ] := __loadVisualDef( "LA-FL-01", nVer, .F. )
   hList[ "LA-FL-02" ] := __loadVisualDef( "LA-FL-02", nVer, .F. )

   IF .T.
      hStates := __hbqtStandardHash()

      hState  := __hbqtStandardHash()
      //
      hState[ "Shape"       ] := "Rectangle"
      hState[ "Area"        ] := __STATE_AREA_BOTTOMRIGHT__
      hState[ "Style"       ] := Qt_SolidPattern
      hState[ "Color"       ] := "#FF0000"
      hState[ "BorderStyle" ] := Qt_SolidLine
      hState[ "BorderWidth" ] := 1
      hState[ "BorderColor" ] := "#000000"
      //
      hStates[ "Installing" ] := hState

      hState  := __hbqtStandardHash()
      //
      hState[ "Shape"       ] := "Ellipse"
      hState[ "Area"        ] := __STATE_AREA_CENTER__
      hState[ "Style"       ] := Qt_LinearGradientPattern
      hState[ "Color"       ] := "#ADFF2F"
      hState[ "BorderStyle" ] := Qt_DotLine
      hState[ "BorderWidth" ] := 2
      hState[ "BorderColor" ] := "#FF0000"
      //
      hStates[ "Activated" ] := hState
   ENDIF

   aMarkers := {}
   AAdd( aMarkers, { "Clock"  , 1, "Ancient Clock"   , "alarm-clock.png"   , 100, 100, "Ancients"   } )
   AAdd( aMarkers, { "Content", 1, "Various Contents", "layout_content.png",  70,  70, "Modern"     } )
   AAdd( aMarkers, { "Banner" , 1, "Company Banners" , "banner.png"        ,  50,  50, "JustInTime" } )
   AAdd( aMarkers, { "Images" , 1, "Getty Images"    , "images.png"        , 100, 100, "Favourite"  } )

   hMarkers := __hbqtStandardHash()
   FOR EACH aMarker IN aMarkers
      hMarker := __hbqtStandardHash()
      hMarker[ "Identity" ] := aMarker[ 1 ]
      hMarker[ "Version"  ] := aMarker[ 2 ]
      hMarker[ "Label"    ] := aMarker[ 3 ]
      hMarker[ "Icon"     ] := __hbqtLoadResourceAsBase64String( aMarker[ 4 ] )
      hMarker[ "Width"    ] := aMarker[ 5 ]
      hMarker[ "Height"   ] := aMarker[ 6 ]
      hMarker[ "Group"    ] := aMarker[ 7 ]
      hMarkers[ aMarker[ 1 ] ] := hMarker
   NEXT

   hStruct := __hbqtStandardHash()
   IF .T.
      hField := __hbqtStandardHash()
      //
      hField[ "Field"        ] := "CODE"
      hField[ "Label"        ] := "Reference"
      hField[ "Group"        ] := ""
      hField[ "Type"         ] := "C"
      hField[ "Value"        ] := ""
      hField[ "Len"          ] := 8
      hField[ "Dec"          ] := 0
      hField[ "Picture"      ] := ""
      hField[ "ReadOnly"     ] := .F.
      hField[ "SelectOnly"   ] := .F.
      hField[ "Options"      ] := ""
      //
      hStruct[ hField[ "Field" ] ] := hField

      hField := __hbqtStandardHash()
      //
      hField[ "Field"        ] := "DESCRIPTN"
      hField[ "Label"        ] := "Description"
      hField[ "Group"        ] := ""
      hField[ "Type"         ] := "C"
      hField[ "Value"        ] := ""
      hField[ "Len"          ] := 20
      hField[ "Dec"          ] := 0
      hField[ "Picture"      ] := ""
      hField[ "ReadOnly"     ] := .F.
      hField[ "SelectOnly"   ] := .F.
      hField[ "Options"      ] := {}
      //
      hStruct[ hField[ "Field" ] ] := hField

      hField := __hbqtStandardHash()
      //
      hField[ "Field"        ] := "RANK"
      hField[ "Label"        ] := "Rank"
      hField[ "Group"        ] := ""
      hField[ "Type"         ] := "C"
      hField[ "Value"        ] := ""
      hField[ "Len"          ] := 8
      hField[ "Dec"          ] := 0
      hField[ "Picture"      ] := ""
      hField[ "ReadOnly"     ] := .F.
      hField[ "SelectOnly"   ] := .T.
      hField[ "Options"      ] := { "First", "Second", "Third", "Fourth", "Fifth" }
      //
      hStruct[ hField[ "Field" ] ] := hField
   ENDIF

   hVisuals := __hbqtStandardHash()

   hVisuals[ "Label"     ] := "Harbour"
   hVisuals[ "List"      ] := hList
   hVisuals[ "States"    ] := hStates
   hVisuals[ "Markers"   ] := hMarkers
   hVisuals[ "Structure" ] := hStruct

   RETURN hVisuals


STATIC FUNCTION __loadVisualDef( cVisual, nVer, lAll )
   LOCAL hVisual

   hVisual := __hbqtStandardHash()

   SWITCH Upper( cVisual )
   CASE "LA-FL-01"
      hVisual[ "RefID"   ] := cVisual
      hVisual[ "Version" ] := nVer
      hVisual[ "Label"   ] := "LA GF Systems"
      hVisual[ "Purpose" ] := "Displays placement of computer systems."
      hVisual[ "Icon"    ] := __hbqtLoadResourceAsBase64String( "cube-2.png" )
      hVisual[ "Group"   ] := ""
      IF lAll
         hVisual[ "Editable"] := .T.
         hVisual[ "Width"   ] := 2910
         hVisual[ "Height"  ] := 1760
         hVisual[ "Orientation" ] := QPrinter_Landscape
         hVisual[ "Markers" ] := __loadMarkersDef( hVisual[ "RefID" ] )
         hVisual[ "ImageID" ] := "MP-LAFR01"
         hVisual[ "Image"   ] := __hbqtLoadResourceAsBase64String( "harbour-b.png" )
      ENDIF
      EXIT
   CASE "LA-FL-02"
      hVisual[ "RefID"   ] := cVisual
      hVisual[ "Version" ] := nVer
      hVisual[ "Label"   ] := "LA FF Racks"
      hVisual[ "Purpose" ] := "Displays placement of floor racks."
      hVisual[ "Icon"    ] := __hbqtLoadResourceAsBase64String( "images.png" )
      hVisual[ "Group"   ] := ""
      IF lAll
         hVisual[ "Editable"] := .T.
         hVisual[ "Markers" ] := __loadMarkersDef( hVisual[ "RefID" ] )
         hVisual[ "ImageID" ] := "MP-LAFR02"
         hVisual[ "Image"   ] := __hbqtLoadResourceAsBase64String( "harbour.png" )
      ENDIF
      EXIT
   ENDSWITCH

   RETURN hVisual


STATIC FUNCTION __loadMarkersDef( cVisual )
   LOCAL hMarkers, hMarker

   hMarkers := __hbqtStandardHash()

   SWITCH Upper( cVisual )
   CASE "LA-FL-01"
      hMarker := __hbqtStandardHash()
      //
      hMarker[ "Identity" ] := "CLOCK"
      hMarker[ "Version"  ] := 1
      hMarker[ "Data"     ] := __loadDataDef( hMarker[ "Identity" ] )
      //
      hMarkers[ hMarker[ "Identity" ] ] := hMarker

      hMarker := __hbqtStandardHash()
      //
      hMarker[ "Identity" ] := "CONTENT"
      hMarker[ "Version"  ] := 1
      hMarker[ "Data"     ] := __loadDataDef( hMarker[ "Identity" ] )
      //
      hMarkers[ hMarker[ "Identity" ] ] := hMarker
      EXIT
   CASE "LA-FL-02"
      hMarker := __hbqtStandardHash()
      //
      hMarker[ "Identity" ] := "BANNER"
      hMarker[ "Version"  ] := 1
      hMarker[ "Data"     ] := __loadDataDef( hMarker[ "Identity" ] )
      //
      hMarkers[ hMarker[ "Identity" ] ] := hMarker

      hMarker := __hbqtStandardHash()
      //
      hMarker[ "Identity" ] := "IMAGES"
      hMarker[ "Version"  ] := 1
      hMarker[ "Data"     ] := __loadDataDef( hMarker[ "Identity" ] )
      //
      hMarkers[ hMarker[ "Identity" ] ] := hMarker
      EXIT
   ENDSWITCH

   RETURN hMarkers


STATIC FUNCTION __loadDataDef( cMarker )
   LOCAL hData, hField

   hData := __hbqtStandardHash()

   SWITCH Upper( cMarker )
   CASE "CLOCK"
      hField := __hbqtStandardHash()
      //
      hField[ "Field"   ] := "CODE"
      hField[ "Label"   ] := "Code"
      hField[ "Value"   ] := "00000001"
      //
      hData[ hField[ "Field" ] ] := hField

      hField := __hbqtStandardHash()
      //
      hField[ "Field"   ] := "DESCRIPTN"
      hField[ "Label"   ] := "City"
      hField[ "Value"   ] := "Los Angeles"
      //
      hData[ hField[ "Field" ] ] := hField

      hField := __hbqtStandardHash()
      //
      hField[ "Field"   ] := "RANK"
      hField[ "Label"   ] := "Age Factor"
      hField[ "Value"   ] := "10-20"
      hField[ "Options" ] := { "5-10","10-20","20-30" }
      //
      hData[ hField[ "Field" ] ] := hField
      EXIT
   CASE "CONTENT"
      hField := __hbqtStandardHash()
      //
      hField[ "Field"   ] := "CODE"
      hField[ "Label"   ] := "Code"
      hField[ "Value"   ] := "CONTENT_1"
      //
      hData[ hField[ "Field" ] ] := hField

      hField := __hbqtStandardHash()
      //
      hField[ "Field"   ] := "DESCRIPTN"
      hField[ "Label"   ] := "County"
      hField[ "Value"   ] := "Woodland"
      //
      hData[ hField[ "Field" ] ] := hField

      hField := __hbqtStandardHash()
      //
      hField[ "Field"   ] := "RANK"
      hField[ "Label"   ] := "Performance"
      hField[ "Value"   ] := "Good"
      hField[ "Options" ] := { "Good","Better","Best" }
      //
      hData[ hField[ "Field" ] ] := hField

      EXIT
   CASE "BANNER"
      hField := __hbqtStandardHash()
      //
      hField[ "Field"   ] := "CODE"
      hField[ "Label"   ] := "Reference"
      hField[ "Value"   ] := "TATA"
      hField[ "Options" ] := NIL
      //
      hData[ hField[ "Field" ] ] := hField
      EXIT
   CASE "IMAGES"
      hField := __hbqtStandardHash()
      //
      hField[ "Field"   ] := "RANK"
      hField[ "Label"   ] := "Age Factor"
      hField[ "Value"   ] := "10-20"
      hField[ "Options" ] := { "5-10","10-20","20-30" }
      //
      hData[ hField[ "Field" ] ] := hField
      EXIT
   ENDSWITCH
   RETURN hData


FUNCTION loadVisual( cRefID, nVer )
   //LOCAL oFileDlg, oList, cFile, cBuffer, cVer
   LOCAL hVisual

   DEFAULT nVer TO 1
#if 0
   cVer := hb_ntos( nVer )

   IF Empty( cRefID )
      WITH OBJECT oFileDlg := QFileDialog()
         :setAcceptMode( QFileDialog_AcceptOpen )
         :setFileMode( QFileDialog_AnyFile )
         :setViewMode( QFileDialog_List )
         :setNameFilter( "HbQt Visuals (*.hqv)" )
         IF :exec() == 1
            oList := oFileDlg:selectedFiles()
            cFile := oList:at( 0 )
         ENDIF
         __hbqt_delete( oFileDlg )
      ENDWITH
   ELSE
      cFile := cRefID + "_" + cVer + ".hqv"
   ENDIF
   IF ! Empty( cFile ) .AND. Lower( Right( cFile, 4 ) ) == ".hqv"
      cBuffer := hb_MemoRead( cFile )
      IF ! Empty( cBuffer )
         hVisual := hb_Deserialize( cBuffer )
      ENDIF
   ENDIF
   IF Empty( hVisual )
      hVisual := __hbqtStandardHash()
   ENDIF
#else
   hVisual := __loadVisualDef( cRefID, nVer, .T. )
#endif
   RETURN hVisual


FUNCTION saveVisual( cRefID, nVer, hVisual )
   LOCAL cFile, oFileDlg, oList, cExt, cSaved, cPath, cName, cVer
   LOCAL lSave := .T.

   DEFAULT nVer TO 1
   cVer := hb_ntos( nVer )

   IF Empty( cRefID )
      WITH OBJECT oFileDlg := QFileDialog()
         :setAcceptMode( QFileDialog_AcceptSave )
         :setFileMode( QFileDialog_AnyFile )
         :setViewMode( QFileDialog_List )
         :setNameFilter( "HbQt Visuals (*.hqv)" )
         IF :exec() == 1
            oList := oFileDlg:selectedFiles()
            cFile := oList:at( 0 )
            hb_fNameSplit( cFile, @cPath, @cName, @cExt )
            cSaved := cPath + cName + "_" + cVer + ".hqv"
         ELSE
            lSave := .F.
         ENDIF
         __hbqt_delete( oFileDlg )
      ENDWITH
   ELSE
      cSaved := cRefID + "_" + cVer + ".hqv"
   ENDIF
   IF lSave .AND. ! empty( cSaved )
      hb_memowrit( cSaved, hb_Serialize( hVisual ) )
   ENDIF
   RETURN iif( lSave, hb_fileExists( cSaved ), .F. )


// Demonstrates how a resource can be pulled and passed from app defined .qrc - not used in above code
//
FUNCTION __appLoadResourceAsBase64String( cResource )
   LOCAL cBuffer, oB, oFile

   oFile := QFile( ":/icons/" + cResource )
   IF oFile:open( QIODevice_ReadOnly )
      oB := oFile:readAll()
      cBuffer := oB:toBase64():data()
      oFile:close()
   ELSE
      cBuffer := ""
   ENDIF
   RETURN cBuffer


STATIC FUNCTION supplyVisualInfo( cRequiredInfo, cRefID, nVer )
   LOCAL xInfo

   IF s_lInDemoMode
      SWITCH Lower( cRequiredInfo )
      CASE "canedit"
         xInfo := __hbqtStandardHash( "response", "YES" )
         EXIT
      CASE "doneedit"
         xInfo := __hbqtStandardHash( "response", "OK" )
         EXIT
      ENDSWITCH
   ENDIF

   HB_SYMBOL_UNUSED( cRefID + nVer )
   RETURN xInfo

