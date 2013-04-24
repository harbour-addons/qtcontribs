/*
 * $Id$
 */

//----------------------------------------------------------------------//
//----------------------------------------------------------------------//
//----------------------------------------------------------------------//
//
//                   Harbour Extended Features Demo
//                                    .
//                 Pritpal Bedi <pritpal@bedipritpal.com>
//
//----------------------------------------------------------------------//
//----------------------------------------------------------------------//
//----------------------------------------------------------------------//

/* UTF-8 */

#include "hbgtinfo.ch"
#include "inkey.ch"
#include "setcurs.ch"
#include "common.ch"
#include "hbqtgui.ch"


#define RGB(r,g,b) ( r + ( g * 256 ) + ( b * 256 * 256 ) )


STATIC s_nRows := 20
STATIC s_nCols := 60
STATIC s_nColorIndex := 1


PROCEDURE Main()
   LOCAL nKey, lMark, lResize, lClose
   LOCAL nHeight := 20
   LOCAL nWidth  := Int( nHeight / 2 )
   LOCAL nMSec

   Hb_GtInfo( HB_GTI_FONTWIDTH, nWidth  )
   Hb_GtInfo( HB_GTI_FONTSIZE , nHeight )
   SetCursor( SC_NONE )

   HB_GtInfo( HB_GTI_CLOSABLE, .F. )

   DispScreen()

   DO WHILE .T.

      nKey := Inkey( , INKEY_ALL + HB_INKEY_GTEVENT )

      if nKey == K_ESC
         exit
      endif

      IF nMSec != NIL .AND. hb_milliSeconds() > nMSec + 1500
         DispOutAt( maxrow(), 0, Space( maxcol()+1 ), "N/G*" )
         nMSec := NIL
      ENDIF

      DO CASE
      CASE nKey == K_ENTER
         Alert( "<Enter> Pressed" )

      CASE nKey == K_F2
         lMark := Hb_GtInfo( HB_GTI_SELECTCOPY )
         Hb_GtInfo( HB_GTI_SELECTCOPY, !lMark )

      CASE nKey == K_F3
         lResize := Hb_GtInfo( HB_GTI_RESIZABLE )
         Hb_GtInfo( HB_GTI_RESIZABLE, !lResize )

      CASE nKey == K_F4
         lClose := Hb_GtInfo( HB_GTI_CLOSABLE )
         hb_GtInfo( HB_GTI_CLOSABLE, !lClose )

      CASE nKey == K_F5
         SetPalette( 1 )

      CASE nKey == K_F6
         SetPalette( 0 )

      CASE nKey == K_F7
         SetPaletteIndex()

      CASE nKey == K_F8
         Alert( "Menu text changed. Was: " + hb_GtInfo( HB_GTI_SELECTCOPY, DToS(Date()) + " " + Time() ) )

      CASE nKey == K_F9
         hb_GTInfo( HB_GTI_RESIZEMODE, iif( hb_GTInfo( HB_GTI_RESIZEMODE ) == HB_GTI_RESIZEMODE_ROWS, HB_GTI_RESIZEMODE_FONT, HB_GTI_RESIZEMODE_ROWS ) )

      CASE nKey == K_F10
         IF hb_MTVM()
            hb_threadStart( @BrowseConsole() )
         ELSE
            Alert( "MT mode not available. Rebuild this program with -mt switch and try again." )
         ENDIF

      CASE nKey == K_F12
         IF hb_MTVM()
            hb_threadStart( {|| BuildADialog() } )
         ELSE
            Alert( "MT mode not available. Rebuild this program with -mt switch and try again." )
         ENDIF

      CASE nKey == HB_K_RESIZE
         DispScreen()
         DispOutAt( maxrow(), 33, "Resized      ", "B/G*" )
         nMSec := hb_milliSeconds()

      CASE nKey == HB_K_GOTFOCUS
         DispOutAt( maxrow(), 33, "We got focus ", "B/G*" )
         nMSec := hb_milliSeconds()

      CASE nKey == HB_K_LOSTFOCUS
         DispOutAt( maxrow(), 33, "We lost focus", "B/G*" )
         nMSec := hb_milliSeconds()

      CASE nKey == HB_K_CLOSE
         IF Alert( "Close Application", {"Yes","No" } ) == 1
            QUIT
         ENDIF

      ENDCASE
   ENDDO

   RETURN


STATIC PROCEDURE DispScreen()
   LOCAL nRow := 10
   LOCAL cColor := "N/W"
   LOCAL nMaxCol := MaxCol() + 1

   DispBegin()

   SetColor( "N/W" )
   CLS
   DispOutAt( 0, 0, PadC( "Harbour GT - New Features", nMaxCol ), "N/GR*" )

   // Contributed by Massimo Belgrano
   DispOutAt( 2, 0, PadC( "______  __             ______________________                        ", nMaxCol ), "W+/W" )
   DispOutAt( 3, 0, PadC( "___  / / /_____ ___________ /___________  _________    __  ____/____/", nMaxCol ), "W+/W" )
   DispOutAt( 4, 0, PadC( "__  /_/ /_  __ `/_  ___/_  __ \  __ \  / / /_  ___/    _  / __ __/   ", nMaxCol ), "W+/W" )
   DispOutAt( 5, 0, PadC( "_  __  / / /_/ /_  /   _  /_/ / /_/ / /_/ /_  /        / /_/ / _  /  ", nMaxCol ), "W+/W" )
   DispOutAt( 6, 0, PadC( "/_/ /_/  \__,_/ /_/    /_.___/\____/\__,_/ /_/         \____/  /_/   ", nMaxCol ), "W+/W" )

   DispOutAt( ++nRow, 0, PadC( "< F2 MarkCopy    Toggle >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "< F3 Resize      Toggle >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "< F4 Closable    Toggle >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "< F5 Palette L   Repeat >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "< F6 Palette D   Repeat >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "< F7 Palette By Index R >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "< F8 MarkCopy menu text >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "<    Click Other Window >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "<    Click X Button     >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "< F9 Resize Mode Toggle >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "< F10 Open New Window   >", nMaxCol ), cColor )
   DispOutAt( ++nRow, 0, PadC( "< F12 Open hbQT Window  >", nMaxCol ), cColor )

   DispOutAt( maxrow(), 0, Space( MaxCol() + 1 ), "N/G*" )

   DispOutAt( 0, 0                  , "TL", "N/GR*" )
   DispOutAt( 0, MaxCol() - 1       , "TR", "N/GR*" )
   DispOutAt( MaxRow(), 0           , "BL", "N/G*"  )
   DispOutAt( MaxRow(), MaxCol() - 1, "BR", "N/G*"  )

   DispEnd()
   RETURN


PROCEDURE HB_GTSYS()
   REQUEST HB_GT_QTC_DEFAULT
   REQUEST HB_GT_WIN
   REQUEST HB_GT_GUI
   REQUEST HB_GT_WVT
   RETURN


FUNCTION SetPalette( nMode )
   LOCAL aPalette := Hb_GtInfo( HB_GTI_PALETTE )

   STATIC s_nR := 198
   STATIC s_nG := 198
   STATIC s_nB := 198

   s_nR += iif( nMode == 0, -5, 5 )
   s_nG += iif( nMode == 0, -5, 5 )
   s_nB += iif( nMode == 0, -5, 5 )

   // Change "W" to slightly gray everytime you press F5
   //
   aPalette[ 8 ] := RGB( s_nR, s_nG, s_nB )

   Hb_GtInfo( HB_GTI_PALETTE, aPalette )
   DispScreen()

   RETURN NIL


FUNCTION SetPaletteIndex()

   Hb_GtInfo( HB_GTI_PALETTE, 8, RGB( 120, 200, 240 ) )
   DispScreen()

   RETURN NIL


PROCEDURE BrowseConsole()
   LOCAL cTitle, oBrowse, lEnd, nKey, i, aStruct
   LOCAL aColor := { 'W+/N', 'W+/B', 'W+/G', 'W+/BG', 'W+/N*', 'W+/RB', 'N/W*', 'N/GR*' }

   STATIC nBrowser := 0
   STATIC nZx := 0
   STATIC nZy := 0

   nBrowser++
   nZx += 20
   nZy += 20

   /* allocate own GT driver */
   hb_gtReload( 'QTC' )
   Hb_GtInfo( HB_GTI_PALETTE, 8, RGB( 120, 200, 240 ) )

   IF ( nBrowser % 2 ) != 0
      Hb_GtInfo( HB_GTI_RESIZEMODE, HB_GTI_RESIZEMODE_ROWS )
   ENDIF
   Hb_GtInfo( HB_GTI_WINTITLE, 'test.dbf    [' + iif( ( nBrowser % 2 ) != 0, 'RESIZABLE_BY_ROWS', 'RESIZABLE_BY_FONT' ) + ']' )

   SetCursor( SC_NONE )

   s_nColorIndex++
   IF s_nColorIndex > len( aColor )
      s_nColorIndex := 1
   ENDIF

   s_nRows++
   s_nCols += 2

   SetMode( s_nRows, s_nCols )
   SetColor( aColor[ s_nColorIndex ] )
   Hb_GtInfo( HB_GTI_WINTITLE, cTitle )
   Hb_GtInfo( HB_GTI_SETPOS_XY, nZx, nZy )

   cTitle := 'New Window with '+ hb_ntos( MaxRow() ) +;
                          ' Rows and ' + hb_ntos( MaxCol() ) + ' Columns'
   DispOutAt( 0, 0, padc( cTitle, maxcol() + 1 ), 'N/GR*' )

   USE ..\..\..\tests\test SHARED
   aStruct := DbStruct()

   oBrowse := TBrowse():New( 1, 0, maxrow(), maxcol() )

   oBrowse:ColSep        := hb_UTF8ToStr( " │ " )
   oBrowse:HeadSep       := hb_UTF8ToStr( "─┬─" )
   oBrowse:GoTopBlock    := {|| dbGoTop() }
   oBrowse:GoBottomBlock := {|| dbGoBottom() }
   oBrowse:SkipBlock     := {| nSkip | dbSkipBlock( nSkip, oBrowse ) }

   for i := 1 to len( aStruct )
      oBrowse:AddColumn( TBColumnNew( aStruct[ i,1 ], BlockField( i ) ) )
   next

   oBrowse:configure()

   lEnd := .F.
   DO WHILE ! lEnd
      oBrowse:ForceStable()

      nKey := InKey( 0, INKEY_ALL + HB_INKEY_GTEVENT )

      IF BrwHandleKey( oBrowse, nKey, @lEnd )
         //
      ELSE
         IF nKey == HB_K_RESIZE
            cTitle := 'New Window with '+ltrim( str( MaxRow() ) )+;
                          ' Rows and '+ltrim( str( MaxCol() ) )+' Columns'
            DispOutAt( 0, 0, padc( cTitle, maxcol()+1 ), 'N/GR*' )

            oBrowse:nBottom := MaxRow()
            oBrowse:nRight := MaxCol()
            oBrowse:Configure()
            oBrowse:RefreshAll()
         ENDIF
      ENDIF
   ENDDO

   DbCloseArea()

   RETURN


STATIC FUNCTION DbSkipBlock( n, oTbr )

   LOCAL nSkipped := 0

   if n == 0
      DBSkip( 0 )

   elseif n > 0
      do while nSkipped != n .and. TBNext( oTbr )
         nSkipped++
      enddo
   else
      do while nSkipped != n .and. TBPrev( oTbr )
         nSkipped--
      enddo
   endif

   RETURN nSkipped


STATIC FUNCTION TBNext( oTbr )

   LOCAL nSaveRecNum := recno()
   LOCAL lMoved := .T.

   HB_SYMBOL_UNUSED( oTbr )

   if Eof()
      lMoved := .F.
   else
      DBSkip( 1 )
      if Eof()
         lMoved := .F.
         DBGoTo( nSaveRecNum )
      endif
   endif

   RETURN lMoved


STATIC FUNCTION TBPrev( oTbr )
   LOCAL nSaveRecNum := Recno()
   LOCAL lMoved := .T.

   HB_SYMBOL_UNUSED( oTbr )

   DBSkip( -1 )

   if Bof()
      DBGoTo( nSaveRecNum )
      lMoved := .F.
   endif

   RETURN lMoved


STATIC FUNCTION BlockField( i )
   RETURN {|| fieldget( i ) }


STATIC FUNCTION BrwHandleKey( oBrowse, nKey, lEnd )
   LOCAL lRet := .T.

   DO CASE
   CASE nKey == K_ESC        ; lEnd := .T.
   CASE nKey == K_ENTER      ; lEnd := .T.
   CASE nKey == K_DOWN       ; oBrowse:Down()
   CASE nKey == K_UP         ; oBrowse:Up()
   CASE nKey == K_LEFT       ; oBrowse:Left()
   CASE nKey == K_RIGHT      ; oBrowse:Right()
   CASE nKey == K_PGDN       ; oBrowse:pageDown()
   CASE nKey == K_PGUP       ; oBrowse:pageUp()
   CASE nKey == K_CTRL_PGUP  ; oBrowse:goTop()
   CASE nKey == K_CTRL_PGDN  ; oBrowse:goBottom()
   CASE nKey == K_HOME       ; oBrowse:home()
   CASE nKey == K_END        ; oBrowse:end()
   CASE nKey == K_CTRL_LEFT  ; oBrowse:panLeft()
   CASE nKey == K_CTRL_RIGHT ; oBrowse:panRight()
   CASE nKey == K_CTRL_HOME  ; oBrowse:panHome()
   CASE nKey == K_CTRL_END   ; oBrowse:panEnd()
   CASE nKey == K_MWBACKWARD ; oBrowse:down()
   CASE nKey == K_MWFORWARD  ; oBrowse:up()
   OTHERWISE                 ; lRet := .F.
   ENDCASE

   RETURN lRet


STATIC PROCEDURE BuildADialog()
   LOCAL tb1, mo1, lay1, lay2, bt1, bt2, bt3, hd1, i, oDgt, oSmdl
   LOCAL oDA
   LOCAL aStru1
   LOCAL nCX1
   LOCAL nCY1
   LOCAL oEventLoop

   SET DATE ANSI
   SET CENTURY ON

   oDA := QWidget()
   oDA:resize(640,460 )
   lay1 := QVBoxLayout( oDA )

   USE "../../../tests/test.dbf" SHARED NEW

   aStru1 := DBStruct()
   nCX1 := 0
   nCY1 := 0
   tb1 := QTableView()
   mo1 := HBQAbstractItemModel( {| t, r, x, y| my_browse( 1, aStru1, t, r, x, y ) } )
   tb1:setModel( mo1 )

   oDgt := tb1:itemDelegate()
   oDgt:connect( "commitData(QWidget*)", {| w | my_save( w, 1, aStru1, @nCX1, @nCY1 ) } )
   oSMdl := tb1:selectionModel()
   oSMdl:connect( "currentChanged(QModelIndex,QModelIndex)", {| n | my_select( n, @nCX1, @nCY1 ) } )

   hd1 := tb1:horizontalHeader()
   FOR i := 1 To Len( aStru1 )
      hd1:resizeSection( i - 1, aStru1[ i, 3 ] * 6 + 60 )
   NEXT
   tb1:verticalHeader():setDefaultSectionSize( 24 )

   lay1:addWidget( tb1 )

   lay2 := QHBoxLayout()
   lay1:addlayout( lay2 )

   ( bt1 := QPushButton() ):SetText( "Dummy 1" )
   ( bt2 := QPushButton() ):SetText( "Dummy 2" )
   ( bt3 := QPushButton() ):SetText( "Dummy 3" )

   lay2:addWidget( bt1 )
   lay2:addStretch()
   lay2:addWidget( bt2 )
   lay2:addWidget( bt3 )

   oEventLoop := QEventLoop( oDA )
   oDA:connect( QEvent_Close, {|| oEventLoop:exit( 0 ) } )
   oDA:Show()
   oEventLoop:exec()

   DbCloseAll()

   RETURN


STATIC PROCEDURE my_save( qWidget, nArea, aStru, nCX, nCY )
   LOCAL cData := qWidget:property( "text" ):toString()

   DBSelectArea( nArea )
   DBGoto( nCY + 1 )

   SWITCH aStru[ nCX + 1, 2 ]
   CASE "C"
      FieldPut( nCX + 1, AllTrim( cData ) )
      EXIT
   CASE "N"
      FieldPut( nCX + 1, Val( cData ) )
      EXIT
   CASE "L"
      FieldPut( nCX + 1, Left( cData, 1 ) $ "YyTt" )
      EXIT
   CASE "D"
      FieldPut( nCX + 1, CToD( cData ) )
      EXIT
   ENDSWITCH
   RETURN


STATIC PROCEDURE my_select( qModelIndex, nCX, nCY  )

   nCX := qModelIndex:column()
   nCY := qModelIndex:row()
   RETURN


STATIC FUNCTION my_browse( nArea, aStru, t, role, x, y )
   THREAD STATIC lInit := .f.
   THREAD STATIC oColorN
   THREAD STATIC oColorD
   THREAD STATIC oColorLY
   THREAD STATIC oColorLN
   THREAD STATIC oSize

   IF ! lInit
      lInit := .t.
      oColorN  := QColor( 100,   0,100 )
      oColorD  := QColor( 150, 100,  0 )
      oColorLY := QColor(   0, 150,  0 )
      oColorLN := QColor( 200,   0,  0 )

      oSize := QSize(50,24)
   ENDIF

   DBSelectArea( nArea )

   SWITCH t
   CASE HBQT_QAIM_flags
      RETURN Qt_ItemIsEnabled + Qt_ItemIsSelectable + Qt_ItemIsEditable;

   CASE HBQT_QAIM_data

      SWITCH role
      CASE Qt_DisplayRole
         DBGoto( y + 1 )
         SWITCH aStru[ x + 1, 2 ]
         CASE "C"
            RETURN AllTrim( FieldGet( x + 1 ) )
         CASE "N"
            RETURN hb_NToS( FieldGet( x + 1 ) )
         CASE "L"
            RETURN iif( FieldGet( x + 1 ), "Yes", "No" )
         CASE "D"
            RETURN DToC( FieldGet( x + 1 ) )
         ENDSWITCH
         RETURN "?"

      CASE Qt_EditRole /* Here we can specify different formats for editing*/
         DBGoto( y + 1 )
         SWITCH aStru[ x + 1, 2 ]
         CASE "C"
            RETURN AllTrim( FieldGet( x + 1 ) )
         CASE "N"
            RETURN hb_NToS( FieldGet( x + 1 ) )
         CASE "L"
            RETURN iif( FieldGet( x + 1 ), "Y", "N" )
         CASE "D"
            RETURN DToC( FieldGet( x + 1 ) )
         ENDSWITCH
         RETURN "?"

      CASE Qt_ForegroundRole
         SWITCH aStru[ x + 1, 2 ]
         CASE "N"
            RETURN oColorN
         CASE "L"
            DBGoto( y + 1 )
            RETURN iif( FieldGet( x + 1 ), oColorLY, oColorLN )
         CASE "D"
            RETURN oColorD
         ENDSWITCH
         RETURN NIL

      CASE Qt_BackgroundRole
         RETURN NIL

      CASE Qt_TextAlignmentRole
         SWITCH aStru[ x + 1, 2 ]
         CASE "C"
            RETURN Qt_AlignVCenter + Qt_AlignLeft
         CASE "N"
            RETURN Qt_AlignVCenter + Qt_AlignRight
         ENDSWITCH
         RETURN Qt_AlignCenter
      ENDSWITCH
      RETURN NIL

   CASE HBQT_QAIM_headerData
      SWITCH role
      CASE Qt_DisplayRole
         IF x == Qt_Horizontal
            RETURN aStru[ y + 1, 1 ]
         ELSE
            RETURN hb_NToS( y + 1 )
         ENDIF

      CASE Qt_TextAlignmentRole
         IF x == Qt_Horizontal
            RETURN Qt_AlignCenter
         ELSE
            RETURN Qt_AlignVCenter + Qt_AlignRight
         ENDIF

      CASE Qt_SizeHintRole
         RETURN oSize
      ENDSWITCH
      RETURN NIL

   CASE HBQT_QAIM_rowCount
      RETURN LastRec()

   CASE HBQT_QAIM_columnCount
      RETURN Len( aStru )
   ENDSWITCH

   RETURN NIL

