/*
 * $Id: hbqtgetlist.prg 175 2013-02-23 03:27:00Z bedipritpal $
 */

/*
 * Harbour Project source code:
 *
 *
 * Copyright 2012-2014 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */


#include "hbqtgui.ch"
#include "hbclass.ch"
#include "hbtrace.ch"
#include "hbqtstd.ch"


#define GET_CLR_UNSELECTED                        0
#define GET_CLR_ENHANCED                          1
#define GET_CLR_CAPTION                           2
#define GET_CLR_ACCEL                             3


FUNCTION __hbqtGetsActiveWindow( oWindow )
   LOCAL l_oWindow
   STATIC s_oWindow
   l_oWindow := s_oWindow
   IF PCount() == 1
      s_oWindow := oWindow
   ENDIF
   RETURN l_oWindow


FUNCTION HbQtClearGets( oWnd, ... )
   LOCAL oParent

   __hbqtBindGetList( oWnd, NIL )
   FOR EACH oParent IN hb_AParams()
      __hbqtBindGetList( oParent, NIL )
   NEXT
   IF HB_ISOBJECT( oWnd )
      oWnd:setParent( QWidget() )
   ENDIF
   __hbqtGetsActiveWindow( NIL )

   RETURN NIL


// Specifically designed for direct built GETs with HbQtGet():new()
//
FUNCTION HbQtClearGetsEx( oWnd, aGets )
   LOCAL oGet

   IF HB_ISARRAY( aGets )
      FOR EACH oGet IN aGets
         oGet:destroy()
         oGet := NIL
      NEXT
   ENDIF
   IF HB_ISOBJECT( oWnd )
      oWnd:setParent( QWidget() )
   ENDIF

   RETURN NIL


FUNCTION __hbqtBindGetList( oWnd, GetList )
   LOCAL n, oGetList, oGet

   THREAD STATIC t_GetList := {}

   IF HB_ISOBJECT( oWnd )
      IF ( n := AScan( t_GetList, {|e_| e_[ 1 ] == oWnd } ) ) > 0
         oGetList := t_GetList[ n, 2 ]
      ENDIF
      HB_TRACE( HB_TR_DEBUG, n, oWnd:className() )
      IF HB_ISOBJECT( GetList )
         IF n > 0
            t_GetList[ n, 2 ] := GetList
         ELSE
            AAdd( t_GetList, { oWnd, GetList } )
         ENDIF
      ELSEIF PCount() == 2 .AND. n > 0
         oGetList := t_GetList[ n,2 ]
         hb_ADel( t_GetList, n, .T. )

         oGetList:oFocusFrame:setParent( QWidget() )
         FOR EACH oGet IN oGetList:getList()
            oGet:destroy()
            oGet := NIL
         NEXT
         oGetList := NIL
      ENDIF
   ENDIF

   RETURN oGetList


FUNCTION HbQtReadGets( GetList, SayList, oParent, oFont, nLineSpacing, cTitle, xIcon, lNoModal, bProperties, bOnLastGet, lNoFocusFrame, aAttrbs, lNoResize )
   LOCAL oFLayout, oEdit, aEdit, oGet, cClsName, oFontM, lFLayout, cCaption, oGetList, oWnd
   LOCAL nLHeight, nAvgWid, cText, nObjHeight, oLabel, aPic, nAttrb, xAttrb, aInfo
   LOCAL nMinX := 50000, nMaxX := 0, nMinY := 50000, nMaxY := 0, nMLabW := 0, nMObjW := 0, nCumObjH := 0
   LOCAL nX, nY, nW, nH, nWidth, nHeight
   LOCAL aGetList := {}
   LOCAL lFit := .T.
   LOCAL lExec := .F.

   hb_default( @oFont       , HbQtSet( _QSET_GETSFONT    ) )
   hb_default( @nLineSpacing, HbQtSet( _QSET_LINESPACING ) )
   hb_default( @cTitle      , "Please Fill-up Info!" )
   hb_default( @lNoModal    , .F. )
   hb_default( @lNoResize   , .F. )

   IF .T.                                         /* Compute row height and formulae to have text width */
      oEdit      := QLineEdit( oWnd )
      oEdit      :  setFont( oFont )
      oFontM     := QFontMetrics( oEdit:font() )
      nObjHeight := oFontM:height() + HbQtSet( _QSET_EDITSPADDING )
      nLHeight   := nObjHeight + nLineSpacing
      nAvgWid    := oFontM:averageCharWidth()
      oEdit      :  setParent( QWidget() )        /* We no longer need it, destroy */
      oEdit      := NIL
   ENDIF

   IF HB_ISOBJECT( oParent )
      oWnd := oParent
   ELSE
      oWnd := QDialog()
      oWnd:setFont( oFont )
      oWnd:setWindowTitle( cTitle )

      IF ! lNoModal
         lExec := .T.
      ENDIF

      IF HB_ISARRAY( aAttrbs ) .AND. ( nAttrb := AScan( aAttrbs, {|e_| e_[ 1 ] == _QGET_ATTRB_SETMODE } ) ) > 0
         nWidth  := nAvgWid  * aAttrbs[ nAttrb, 2, 2 ] + 6 + 6
         nHeight := nLHeight * aAttrbs[ nAttrb, 2, 1 ]
         oWnd:connect( QEvent_Show, {|| oWnd:resize( nWidth, nHeight ) } )
         lFit := .F.
      ENDIF
      IF HB_ISARRAY( aAttrbs ) .AND. ( nAttrb := AScan( aAttrbs, {|e_| e_[ 1 ] == _QGET_ATTRB_RESIZABLE } ) ) > 0
         IF HB_ISLOGICAL( aAttrbs[ nAttrb, 2 ] ) .AND. ! aAttrbs[ nAttrb, 2 ]
            oWnd:setMaximumHeight( nHeight )
            oWnd:setMaximumWidth( nWidth )
            oWnd:setMinimumHeight( nHeight )
            oWnd:setMinimumWidth( nWidth )
         ENDIF
      ENDIF
      IF HB_ISARRAY( aAttrbs ) .AND. ( nAttrb := AScan( aAttrbs, {|e_| e_[ 1 ] == _QGET_ATTRB_ATROWCOLUMNONTOPOF } ) ) > 0
         xAttrb := aAttrbs[ nAttrb, 2 ]
         ASize( xAttrb, 4 )
         IF HB_ISARRAY( xAttrb ) .AND. Len( xAttrb ) >= 3 .AND. HB_ISOBJECT( xAttrb[ 1 ] ) .AND. HB_ISNUMERIC( xAttrb[ 2 ] ) .AND. HB_ISNUMERIC( xAttrb[ 3 ] )
            oWnd:setParent( xAttrb[ 1 ] )
            aInfo := __hbqtGetGlobalXYFromRowColumn( xAttrb[ 1 ], xAttrb[ 2 ], xAttrb[ 3 ], oFont )
            IF HB_ISLOGICAL( xAttrb[ 4 ] ) .AND. xAttrb[ 4 ]
               oWnd:setWindowFlags( Qt_Dialog + Qt_CustomizeWindowHint + Qt_WindowTitleHint )
            ELSE
               oWnd:setWindowFlags( Qt_Dialog + Qt_CustomizeWindowHint )
            ENDIF
            oWnd:connect( QEvent_Show , {|| __hbqtPositionWindowClientXY( oWnd, aInfo[ 1 ], aInfo[ 2 ] ) } )
            lExec := .T.
         ENDIF
      ENDIF

      IF HB_ISOBJECT( xIcon ) .AND. __objGetClsName( xIcon ) == "QICON"
         oWnd:setWindowIcon( xIcon )
      ELSEIF HB_ISCHAR( xIcon )
         oWnd:setWindowIcon( QIcon( xIcon ) )
      ENDIF
   ENDIF

   cClsName := __objGetClsName( oWnd )
   IF cClsName == "QFORMLAYOUT"
      oFLayout := oWnd
      oWnd := oFLayout:parent()
   ELSE
      oFLayout := oWnd:layout()
   ENDIF
   lFLayout := ! Empty( oFLayout )

   IF Len( GetList ) >= 1
      FOR EACH aEdit IN GetList
         oGet       := aEdit[ _QGET_GET ]
         oGet:row   := aEdit[ _QGET_ROW ]
         oGet:col   := aEdit[ _QGET_COL ]
         IF Empty( aEdit[ _QGET_CONTROL ] )
            IF ! Empty( aEdit[ _QGET_SAY ] )
               AAdd( SayList, { aEdit[ _QGET_ROW ], aEdit[ _QGET_COL ], aEdit[ _QGET_SAY ], aEdit[ _QGET_SAYPICTURE ], aEdit[ _QGET_SAYCOLOR ], aEdit[ _QGET_SAYPROPERTIES ], NIL } )
               oGet:col += Len( Transform( aEdit[ _QGET_SAY ], aEdit[ _QGET_SAYPICTURE ] ) ) + 1
            ENDIF
         ELSE
            lFit := .F.
         ENDIF
      NEXT
   ENDIF
   IF lNoResize
      lFit := .F.
   ENDIF

   /* This is independent of @ ... SAY ... GET combined */
   IF Len( SayList ) >= 1 .AND. ! lFLayout
      FOR EACH aPic IN SayList
         cText  := Transform( aPic[ 3 ], aPic[ 4 ] )

         nX    := ( aPic[ 2 ] * nAvgWid ) + 6
         nY    := aPic[ 1 ] * nLHeight
         nW    := 6 + ( Len( cText ) * nAvgWid )
         nH    := nObjHeight
         nMinX := Min( nMinX, nX )
         nMaxX := Max( nMaxX, nX + nW )
         nMinY := Min( nMinY, nY )
         nMaxY := Max( nMaxY, nY + nH )

         WITH OBJECT oLabel := QLabel( oWnd )
            :setText( cText )
            :setFont( oFont )
            :setAlignment( Qt_AlignLeft + Qt_AlignVCenter )
            :setOpenExternalLinks( .T. )
            :move( nX, nY )
            :resize( nW, nH )
         ENDWITH

         IF HB_ISBLOCK( aPic[ 6 ] )
            Eval( aPic[ 6 ], oLabel, { nX, nY, nW, nH } )
         ENDIF

         aPic[ 7 ] := oLabel
      NEXT
   ENDIF

   WITH OBJECT oGetList := HbQtGetList():New( aGetList )
      :lastGetBlock := bOnLastGet
      :focusFrame   := ! lNoFocusFrame
      :oWindow      := oWnd
      :SayList      := SayList
   ENDWITH

   IF Len( GetList ) >= 1
      FOR EACH aEdit IN GetList
         oGet := aEdit[ _QGET_GET ]

         IF Empty( aEdit[ _QGET_CONTROL ] )
            oEdit    := HbQtGet():new()
         ELSE
            oEdit    := HbQtGet():new( aEdit[ _QGET_CONTROL ] )
         ENDIF
         WITH OBJECT oEdit
            :widget  := aEdit[ _QGET_TYPE ]
            :parent  := oWnd
            :font    := oFont
            :getList := oGetList
            :get     := oGet                    /* This is important - all variables will be initialized here instead of in :new() */

            :toRow   := aEdit[ _QGET_TOROW  ]
            :toCol   := aEdit[ _QGET_TOCOL  ]
            :data    := aEdit[ _QGET_DATA   ]

            IF ! Empty( aEdit[ _QGET_COLOR ] )
               :color := aEdit[ _QGET_COLOR ]
            ENDIF

            IF HB_ISBLOCK( aEdit[ _QGET_VALIDATOR ] )
               :inputValidator := aEdit[ _QGET_VALIDATOR ]
            ENDIF

            :mousable := ! aEdit[ _QGET_NOMOUSE ]

            :create()

            IF :widget == "HbQtBrowse"
               :data[ 1 ]:oGetList := oGetList
               :data[ 1 ]:setGetObject( oEdit )
            ENDIF
         ENDWITH

         IF Empty( aEdit[ _QGET_CONTROL ] )
            nX    := ( oGet:col * nAvgWid ) + 6
            nY    := oGet:row * nLHeight
            nW    := 6 + ( oEdit:getDispWidth() * nAvgWid )
            nH    := nObjHeight * oEdit:getDispHeight() + iif( aEdit[ _QGET_TYPE ] == "QLineEdit", 0, oEdit:getDispHeight() * nLineSpacing )
            nMinX := Min( nMinX, nX )
            nMaxX := Max( nMaxX, nX + nW )
            nMinY := Min( nMinY, nY )
            nMaxY := Max( nMaxY, nY + nH )
            nMObjW := Max( nMObjW, nW )
            nCumObjH += nH + 6
            //
            IF ! lFLayout
               oEdit:setPosAndSize( { nX, nY }, { nW, nH } )
            ELSE
               WITH OBJECT oEdit:edit()
                  :setMinimumWidth( nW )
                  :setMinimumHeight( nH )
                  :setMaximumWidth( nW )
                  :setMaximumHeight( nH )
               ENDWITH
            ENDIF
            //
            oEdit:display()                        /* dimensions might have changed */
         ENDIF

         IF lFLayout .AND. Empty( aEdit[ _QGET_CONTROL ] )
            cCaption := iif( Empty( aEdit[ _QGET_CAPTION ] ), oGet:name(), aEdit[ _QGET_CAPTION ] )
            nMLabW := Max( nMLabW, 6 + ( Len( cCaption ) * nAvgWid ) )
            oFLayout:addRow( cCaption, oEdit:edit() )
         ENDIF

         AAdd( aGetList, oEdit )

         IF HB_ISBLOCK( aEdit[ _QGET_PROPERTIES ] )
            Eval( aEdit[ _QGET_PROPERTIES ], oEdit, oEdit:edit() )
         ENDIF
      NEXT

      IF lFit                                     /* Fit to the contents maintaining margins */
         IF lFLayout
            oWnd:resize( nMLabW + nMObjW + 10, nCumObjH )
         ELSE
            oWnd:resize( nMaxX + nMinX, nMaxY + nMinY )
         ENDIF
      ENDIF

   ENDIF

   GetList := aGetList                            /* TO match Clipper behavior */
   __hbQtBindGetList( oWnd, oGetList )
   __GetListSetActive( oGetList )
   __GetListLast( oGetList )

   /* Probably will be fired only when oWnd is a top level window - needs to be investigated further */
   oWnd:connect( QEvent_Close, {|oEvent| HbQtClearGets( oWnd ), oEvent:accept(), .F. } )

   IF HB_ISBLOCK( bProperties )
      Eval( bProperties, oWnd, oGetList )
   ENDIF

   IF ! HB_ISOBJECT( oParent )
      oWnd:connect( QEvent_WindowActivate, {|| oGetList:setFocus( aGetList[ 1 ], Qt_TabFocusReason ), oWnd:disconnect( QEvent_WindowActivate ), .F. } )
      oWnd:connect( QEvent_KeyPress,       {|oKey| iif( oKey:key() == 27, oWnd:done( 0 ), NIL ), .T. } )

      IF lExec
         oWnd:exec()
      ELSE
         IF ! lNoModal
            oWnd:setModal( .T. )
         ENDIF
         oWnd:show()
      ENDIF
   ELSE
      oGetList:setFocus( aGetList[ 1 ], Qt_TabFocusReason )
   ENDIF

   RETURN NIL

/*----------------------------------------------------------------------*/
//                        CLASS HbQtGetList()
/*----------------------------------------------------------------------*/

CREATE CLASS HbQtGetList INHERIT HbGetList

   METHOD init( aGetList )
   METHOD goNext( oGet )
   METHOD goPrevious( oGet )
   METHOD goTop( oGet )
   METHOD goBottom( oGet )
   METHOD isFirstGet( oGet )
   METHOD isLastGet( oGet )
   METHOD nextGet( oGet )
   METHOD previousGet( oGet )
   METHOD getIndex( oGet )
   METHOD setFocus( xGet, nReason )
   METHOD getByIndex( nIndex )                    INLINE iif( nIndex > 0 .AND. nIndex <= Len( ::aGetList ), ::aGetList[ nIndex ], NIL )
   METHOD getList()                               INLINE ::aGetList

   DATA   bOnLastGet
   METHOD lastGetBlock( bBlock )                  SETGET
   METHOD terminate()                             INLINE iif( HB_ISBLOCK( ::bOnLastGet ), Eval( ::bOnLastGet, NIL ), NIL )

   CLASSVAR oFocusFrame                           INIT QFocusFrame()

   DATA   lFocusFrame                             INIT .T.
   METHOD focusFrame                              SETGET

   DATA   oWindow
   DATA   SayList                                 INIT {}

   ENDCLASS


METHOD HbQtGetList:init( aGetList )

   ::HbGetList:new( aGetList )
#if 0
   IF Empty( ::oFocusFrame )
      ::oFocusFrame := QFocusFrame()
   ENDIF
#endif
   ::oFocusFrame:setStyleSheet( "border: 1px solid red;" )

   RETURN Self


METHOD HbQtGetList:lastGetBlock( bBlock )

   IF HB_ISBLOCK( bBlock )
      ::bOnLastGet := bBlock
   ENDIF

   RETURN ::bOnLastGet


METHOD HbQtGetList:getIndex( oGet )
   RETURN AScan( ::aGetList, {|o| o == oGet } )


METHOD HbQtGetList:goNext( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n < Len( ::aGetList )
         ::setFocus( ::aGetList[ n + 1 ], Qt_TabFocusReason )
         RETURN ::aGetList[ n + 1 ]
      ELSE
         ::setFocus( ::aGetList[ 1 ], Qt_TabFocusReason )
         RETURN ::aGetList[ 1 ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:goPrevious( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n > 1
         ::setFocus( ::aGetList[ n - 1 ], Qt_BacktabFocusReason )
         RETURN ::aGetList[ n - 1 ]
      ELSE
         ::setFocus( ATail( ::aGetList ), Qt_BacktabFocusReason )
         RETURN ATail( ::aGetList )
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:goTop( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n > 1
         ::setFocus( ::aGetList[ 1 ], Qt_TabFocusReason )
         RETURN ::aGetList[ 1 ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:goBottom( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n < Len( ::aGetList )
         ::setFocus( ATail( ::aGetList ), Qt_BacktabFocusReason )
         RETURN ::aGetList[ Len( ::aGetList ) ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:isFirstGet( oGet )
   RETURN ::getIndex( oGet ) == 1


METHOD HbQtGetList:isLastGet( oGet )
   RETURN ::getIndex( oGet ) == Len( ::aGetList )


METHOD HbQtGetList:nextGet( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n == Len( ::aGetList )
         RETURN ::aGetList[ 1 ]
      ELSE
         RETURN ::aGetList[ n + 1 ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:previousGet( oGet )

   LOCAL n := ::getIndex( oGet )

   IF n > 0
      IF n == 1
         RETURN ATail( ::aGetList )
      ELSE
         RETURN ::aGetList[ n - 1 ]
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:setFocus( xGet, nReason )

   LOCAL n, oGet, cGet

   IF ! HB_ISNUMERIC( nReason )
      nReason := Qt_TabFocusReason
   ENDIF

   IF HB_ISCHAR( xGet )
      cGet := Upper( xGet )
      IF ( n := AScan( ::aGetList, {|oGet| Upper( oGet:name() ) == cGet } ) ) > 0
         oGet := ::aGetList[ n ]
      ENDIF
   ELSEIF HB_ISOBJECT( xGet )
      oGet := xGet
   ENDIF
   IF HB_ISOBJECT( oGet )
      IF oGet:cClassName == "QLINEEDIT"
         oGet:setFocus( nReason )
         oGet:positionCursor()
      ELSE
         oGet:setFocus( nReason )
      ENDIF
   ENDIF

   RETURN oGet


METHOD HbQtGetList:focusFrame( lFocusFrame )

   IF HB_ISLOGICAL( lFocusFrame )
      ::lFocusFrame := lFocusFrame
   ENDIF

   RETURN ::lFocusFrame

