               /*
 * $Id: hbqttoolbar.prg 141 2013-01-18 02:49:32Z bedipritpal $
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2013-2016 Pritpal Bedi <bedipritpal@hotmail.com>
 * http://harbour-project.org
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
/*----------------------------------------------------------------------*/
/*
 *                               EkOnkar
 *                         ( The LORD is ONE )
 *
 *                             Pritpal Bedi
 *                              04Jan2013
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "inkey.ch"
#include "hbqtgui.ch"

#define HBQTTOOLBAR_BUTTON_DEFAULT                0
#define HBQTTOOLBAR_BUTTON_SEPARATOR              1


CLASS HbQtToolbar
   DATA   oWidget
   DATA   oParent

   DATA   enabled                                 INIT   .T.
   DATA   showToolTips                            INIT   .T.
   DATA   buttonWidth                             INIT   0
   DATA   buttonHeight                            INIT   0
   DATA   imageWidth                              INIT   0
   DATA   imageHeight                             INIT   0
   DATA   size
   DATA   hItems                                  INIT   {=>}
   DATA   hActions                                INIT   {=>}

   DATA   aItems                                  INIT   {}

   DATA   hImageList
   DATA   lSized                                  INIT   .F.

   METHOD numItems()                              INLINE Len( ::aItems )

   METHOD init( oParent )
   METHOD create( oParent )

   METHOD addItem( cCaption, xImage, xDisabledImage, xHotImage, cDLL, nStyle, xKey )
   METHOD delItem( nItem_cKey )
   METHOD getItem( nItem_cKey )
   METHOD clear()
   METHOD addToolButton( cName, cDesc, cImage, bAction, lCheckable, lDragEnabled )

   METHOD buttonClick( ... )                      SETGET

   METHOD setItemChecked( nItem_cKey, lChecked )
   METHOD setItemEnabled( nItem_cKey, lEnabled )
   METHOD setItemVisible( nItem_cKey, lVisible )
   METHOD itemToggle( nItem_cKey )

   ERROR HANDLER onError( ... )

PROTECTED:
   DATA     qByte, qMime, qDrag, qPix, qDropAction, qPos
   DATA     sl_lbClick
   DATA     sl_change
   DATA     sl_buttonMenuClick
   DATA     sl_buttonDropDown

   METHOD   execSlot( cSlot, p, p1 )

   ENDCLASS


METHOD HbQtToolbar:init( oParent )

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   RETURN Self


METHOD HbQtToolbar:create( oParent )

   DEFAULT oParent TO ::oParent
   ::oParent := oParent

   ::oWidget := QToolBar( iif( Empty( ::oParent ), NIL, ::oParent ) )
   IF ! Empty( ::oParent )
      ::oWidget:setObjectName( __hbqtGetNextIdAsString( "HbQtToolbar" ) )
   ENDIF

   IF ::imageWidth > 0 .and. ::imageHeight > 0
      ::size := QSize( __hbqtPixelsByDPI( ::imageWidth ), __hbqtPixelsByDPI( ::imageHeight ) )
   ENDIF
   ::oWidget:setIconSize( ::size )

   ::oWidget:setFocusPolicy( Qt_NoFocus )
   RETURN Self


METHOD HbQtToolbar:onError( ... )
   LOCAL cMsg := __GetMessage()

   IF SubStr( cMsg, 1, 1 ) == "_"
      cMsg := SubStr( cMsg, 2 )
   ENDIF
   RETURN ::oWidget:&cMsg( ... )


METHOD HbQtToolbar:addToolButton( cName, cDesc, cImage, bAction, lCheckable, lDragEnabled )
   RETURN ::addItem( { cName, cDesc, cImage, bAction, lCheckable, lDragEnabled } )


METHOD HbQtToolbar:addItem( cCaption, xImage, xDisabledImage, xHotImage, cDLL, nStyle, xKey )
   LOCAL oBtn, oButton
   LOCAL isAction     := HB_ISOBJECT( cCaption ) .AND. __ObjGetClsName( cCaption ) $ "QACTION,QWIDGETACTION"
   LOCAL isToolButtonB:= HB_ISOBJECT( cCaption ) .AND. __ObjGetClsName( cCaption ) == "QTOOLBUTTON"
   LOCAL isToolButton := HB_ISARRAY( cCaption )
   LOCAL isObject     := HB_ISOBJECT( cCaption )

   HB_SYMBOL_UNUSED( xDisabledImage )
   HB_SYMBOL_UNUSED( xHotImage )
   HB_SYMBOL_UNUSED( cDLL )

   DEFAULT nStyle TO HBQTTOOLBAR_BUTTON_DEFAULT

   IF isToolButton
      //{ cName, cDesc, cImage, bAction, lCheckable, lDragEnabled }
      //
      ASize( cCaption, 6 )

      DEFAULT cCaption[ 1 ] TO __hbqtGetNextIdAsString( "HbQtToolButton" )
      DEFAULT cCaption[ 2 ] TO ""
      DEFAULT cCaption[ 5 ] TO .F.
      DEFAULT cCaption[ 6 ] TO .F.

      oBtn := HbQtButtonToolbar():new( cCaption[ 1 ], nStyle, iif( HB_ISBLOCK( cCaption[ 4 ] ), cCaption[ 4 ], xKey ) )
   ELSE
      oBtn := HbQtButtonToolbar():new( iif( isAction, cCaption:text(), cCaption ), nStyle, xKey )
   ENDIF

   oBtn:index   := ::numItems + 1
   oBtn:command := 100 + oBtn:index

   IF nStyle == HBQTTOOLBAR_BUTTON_SEPARATOR
      oBtn:oAction := ::oWidget:addSeparator()

   ELSE
      IF isAction
         oBtn:oAction := cCaption

      ELSEIF isToolButtonB
         oBtn:oAction := QWidgetAction( ::oWidget )
         oBtn:oAction:setDefaultWidget( cCaption )

      ELSEIF isToolButton
         oBtn:oAction := QWidgetAction( ::oWidget )
         oButton := QToolButton()
         oBtn:oAction:setDefaultWidget( oButton )
         oBtn:cargo := oButton

         WITH OBJECT oButton
            :setObjectName( cCaption[ 1 ] )
            :setTooltip( cCaption[ 2 ] )
            :setIcon( iif( HB_ISOBJECT( cCaption[ 3 ] ), cCaption[ 3 ], QIcon( cCaption[ 3 ] ) ) )
            :setCheckable( cCaption[ 5 ] )
            :setFocusPolicy( Qt_NoFocus )
            :setAttribute( Qt_WA_AlwaysShowToolTips, .T. )
            :setCursor( QCursor( Qt_ArrowCursor ) )
            :setAutoRaise( .T. )
            IF cCaption[ 6 ]
               :connect( QEvent_MouseButtonPress  , {|p| ::execSlot( "QEvent_MousePress"  , p, oButton ) } )
               :connect( QEvent_MouseButtonRelease, {|p| ::execSlot( "QEvent_MouseRelease", p, oButton ) } )
               :connect( QEvent_MouseMove         , {|p| ::execSlot( "QEvent_MouseMove"   , p, oButton ) } )
               :connect( QEvent_Enter             , {|p| ::execSlot( "QEvent_MouseEnter"  , p, oButton ) } )
            ENDIF
         ENDWITH

      ELSEIF isObject
         WITH OBJECT oBtn:oAction := QWidgetAction( ::oWidget )
            :setDefaultWidget( cCaption )
         ENDWITH
      ELSE
         /* Create an action */
         WITH OBJECT oBtn:oAction := QAction( ::oWidget )
            :setText( cCaption )
            :setIcon( iif( HB_ISCHAR( xImage ), QIcon( xImage ), xImage ) )
         ENDWITH
      ENDIF

      /* Attach codeblock to be triggered */
      IF ! isToolButton
         oBtn:oAction:connect( "triggered(bool)", {|| ::execSlot( "triggered(bool)", oBtn ) } )
      ELSE
         IF HB_ISBLOCK( cCaption[ 4 ] )
            oButton:connect( "clicked()", cCaption[ 4 ] )
         ELSE
            oButton:connect( "clicked()", {|| ::execSlot( "triggered(bool)", oBtn ) } )
         ENDIF
      ENDIF

      /* Attach Action with Toolbar */
      ::oWidget:addAction( oBtn:oAction )
   ENDIF

   AAdd( ::aItems, { oBtn:command, oBtn, nStyle } )
   RETURN oBtn


METHOD HbQtToolbar:setItemChecked( nItem_cKey, lChecked )
   LOCAL oBtn, lOldState

   IF ! Empty( oBtn := ::getItem( nItem_cKey ) )
      IF oBtn:oAction:isCheckable()
         lOldState := oBtn:oAction:isChecked()
         IF HB_ISLOGICAL( lChecked )
            oBtn:oAction:setChecked( lChecked )
         ENDIF
      ENDIF
   ENDIF
   RETURN lOldState


METHOD HbQtToolbar:setItemEnabled( nItem_cKey, lEnabled )
   LOCAL oBtn, lOldState

   IF ! Empty( oBtn := ::getItem( nItem_cKey ) )
      lOldState := oBtn:oAction:isEnabled()
      IF HB_ISLOGICAL( lEnabled )
         oBtn:oAction:setEnabled( lEnabled )
      ENDIF
   ENDIF
   RETURN lOldState


METHOD HbQtToolbar:setItemVisible( nItem_cKey, lVisible )
   LOCAL oBtn, lOldState

   IF ! Empty( oBtn := ::getItem( nItem_cKey ) )
      lOldState := oBtn:oAction:visible()
      IF HB_ISLOGICAL( lVisible )
         oBtn:oAction:setVisible( lVisible )
      ENDIF
   ENDIF
   RETURN lOldState


METHOD HbQtToolbar:itemToggle( nItem_cKey )
   LOCAL oBtn, lOldState

   IF ! Empty( oBtn := ::getItem( nItem_cKey ) )
      IF oBtn:oAction:isCheckable()
         lOldState := oBtn:oAction:isChecked()
         oBtn:oAction:setChecked( ! lOldState )
      ENDIF
   ENDIF
   RETURN lOldState


METHOD HbQtToolbar:delItem( nItem_cKey )
   LOCAL a_

   IF HB_ISNUMERIC( nItem_cKey )
      IF Len( ::aItems ) <= nItem_cKey
         ::oWidget:removeAction( ::aItems[ nItem_cKey, 2 ]:oAction )
         hb_ADel( ::aItems, nItem_cKey, .T. )
      ENDIF

   ELSEIF HB_ISCHAR( nItem_cKey )
      FOR EACH a_ IN ::aItems
         IF HB_ISCHAR( a_[ 2 ]:key )
            IF a_[ 2 ]:key == nItem_cKey
               ::oWidget:removeAction( a_[ 2 ]:oAction )
               hb_ADel( ::aItems, a_:__enumIndex(), .T. )
               EXIT
            ENDIF
         ENDIF
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtToolbar:getItem( nItem_cKey )
   LOCAL a_

   IF HB_ISNUMERIC( nItem_cKey )
      IF Len( ::aItems ) >= nItem_cKey
         RETURN ::aItems[ nItem_cKey, 2 ]
      ENDIF

   ELSEIF HB_ISCHAR( nItem_cKey )
      FOR EACH a_ IN ::aItems
         IF HB_ISCHAR( a_[ 2 ]:key )
            IF a_[ 2 ]:key == nItem_cKey
               RETURN a_[ 2 ]
            ENDIF
         ELSEIF HB_ISBLOCK( a_[ 2 ]:key )
            IF HB_ISOBJECT( a_[ 2 ]:cargo ) .AND. a_[ 2 ]:cargo:text() == nItem_cKey
               RETURN a_[ 2 ]
            ENDIF
         ENDIF
      NEXT
   ENDIF
   RETURN NIL


METHOD HbQtToolbar:clear()

   ::oWidget:clear()
   ::aItems := {}
   RETURN Self


METHOD HbQtToolbar:execSlot( cSlot, p, p1 )
   LOCAL qEvent, qRC

   qEvent := p

   SWITCH cSlot

   CASE "triggered(bool)"
      ::buttonClick( p )
      EXIT
   CASE "QEvent_MouseLeave"
      EXIT
   CASE "QEvent_MouseMove"
      qRC := QRect( ::qPos:x() - 5, ::qPos:y() - 5, 10, 10 ):normalized()
      IF qRC:contains( qEvent:pos() )
         ::qByte := QByteArray( p1:objectName() )

         ::qMime := QMimeData()
         ::qMime:setData( "application/x-toolbaricon", ::qByte )
         ::qMime:setHtml( p1:objectName() )

         ::qPix  := p1:icon():pixmap( 16,16 )

         ::qDrag := QDrag( ::oWidget )
         ::qDrag:setMimeData( ::qMime )
         ::qDrag:setPixmap( ::qPix )
         ::qDrag:setHotSpot( QPoint( 15,15 ) )
         ::qDrag:setDragCursor( ::qPix, Qt_CopyAction + Qt_IgnoreAction )
         ::qDropAction := ::qDrag:exec( Qt_CopyAction + Qt_IgnoreAction )  /* Why this is not terminated GPF's */

         ::qDrag := NIL
         ::qPos  := NIL
         p1:setChecked( .f. )
         p1:setWindowState( 0 )
      ENDIF
      EXIT
   CASE "QEvent_MouseRelease"
      ::qDrag := NIL
      EXIT
   CASE "QEvent_MousePress"
      ::qPos := qEvent:pos()
      EXIT
   ENDSWITCH
   RETURN NIL


METHOD HbQtToolbar:buttonClick( ... )
   LOCAL a_:= hb_aParams()
   IF len( a_ ) == 1 .AND. HB_ISBLOCK( a_[ 1 ] )
      ::sl_lbClick := a_[ 1 ]
   ELSEIF len( a_ ) >= 1 .AND. HB_ISBLOCK( ::sl_lbClick )
      eval( ::sl_lbClick, a_[ 1 ], NIL, Self )
   ENDIF
   RETURN Self

/*----------------------------------------------------------------------*/
/*
 *       HbQtToolbarButton() Class compatible with HbQtToolbarButton()
 */
/*----------------------------------------------------------------------*/

CLASS HbQtButtonToolbar

   DATA     style                                 INIT 0
   DATA     enabled                               INIT .T.
   DATA     index                                 INIT 0
   DATA     key                                   INIT ""
   DATA     caption                               INIT ""
   DATA     image                                 INIT NIL
   DATA     disabledImage                         INIT NIL
   DATA     hotImage                              INIT NIL
   DATA     mixedState                            INIT .F.
   DATA     pressed                               INIT .F.
   DATA     visible                               INIT .T.
   DATA     left                                  INIT 0
   DATA     bottom                                INIT 0
   DATA     top                                   INIT 0
   DATA     width                                 INIT 0
   DATA     height                                INIT 0
   DATA     description                           INIT ""
   DATA     tooltipText                           INIT ""
   DATA     command                               INIT 0
   DATA     oAction
   DATA     cargo

   METHOD   init( cCaption, nStyle, xKey )

   ENDCLASS


METHOD HbQtButtonToolbar:init( cCaption, nStyle, xKey )

   DEFAULT cCaption       TO ::caption
   DEFAULT nStyle         TO ::style
   DEFAULT xKey           TO ::key

   ::caption        := cCaption
   ::style          := nStyle
   ::key            := xKey
   RETURN Self

//--------------------------------------------------------------------//
//                          HbQtEditorToolbar()
//--------------------------------------------------------------------//

FUNCTION HbQtEditorToolbar( oHbQtEditor )
   LOCAL oToolbar

   WITH OBJECT oToolbar := HbQtToolbar():new( oHbQtEditor:widget() )
      :size := QSize( __hbqtPixelsByDPI( 12 ), __hbqtPixelsByDPI( 12 ) )
      :create( "SelectedText_Toolbar" )
      :hide()
      :setObjectName( "ToolbarSelectedText" )
      :setWindowTitle( "Actions on Selected Text" )
      :setStyleSheet( "background-color: rgba(232,232,232,255); border: 1px solid rgba(170,170,170,255); border-radius: 5px; padding: 1px;" )
      :setMovable( .T. )
      :setFloatable( .T. )
      :setFocusPolicy( Qt_NoFocus )
      :setAttribute( Qt_WA_AlwaysShowToolTips, .T. )
   ENDWITH

   WITH OBJECT oToolbar
#if 0
      :addToolButton( "Undo"      , "Undo"                   , __hbqtImage( "undo"          ), {|| oHbQtEditor:undo()                        }, .f. )
      :addToolButton( "Redo"      , "Redo"                   , __hbqtImage( "redo"          ), {|| oHbQtEditor:redo()                        }, .f. )
      :addToolButton( "Cut"       , "Cut"                    , __hbqtImage( "cut"           ), {|| oHbQtEditor:cut()                         }, .f. )
      :addToolButton( "Copy"      , "Copy"                   , __hbqtImage( "copy"          ), {|| oHbQtEditor:copy()                        }, .f. )
      :addToolButton( "Paste"     , "Paste"                  , __hbqtImage( "paste"         ), {|| oHbQtEditor:paste()                       }, .f. )
#endif
      :addToolButton( "SelMode"   , "SelectionMode"          , __hbqtImage( "stream"        ), {|| oHbQtEditor:toggleSelectionMode()         }, .t. )
      :addToolButton( "ToUpper"   , "To Upper"               , __hbqtImage( "toupper"       ), {|| oHbQtEditor:caseUpper()                   }, .f. )
      :addToolButton( "ToLower"   , "To Lower"               , __hbqtImage( "tolower"       ), {|| oHbQtEditor:caseLower()                   }, .f. )
      :addToolButton( "InvertCase", "Invert Case"            , __hbqtImage( "invertcase"    ), {|| oHbQtEditor:caseInvert()                  }, .f. )
      :addToolButton( "BlockCmnt" , "Block Comment"          , __hbqtImage( "blockcomment"  ), {|| oHbQtEditor:blockComment()                }, .f. )
      :addToolButton( "StreamCmnt", "Stream Comment"         , __hbqtImage( "streamcomment" ), {|| oHbQtEditor:streamComment()               }, .f. )
      :addToolButton( "IndentR"   , "Indent Right"           , __hbqtImage( "blockindentr"  ), {|| oHbQtEditor:blockIndent(  1 )             }, .f. )
      :addToolButton( "IndentL"   , "Indent Left"            , __hbqtImage( "blockindentl"  ), {|| oHbQtEditor:blockIndent( -1 )             }, .f. )
      :addToolButton( "Sgl2Dbl"   , "Single to Double Quotes", __hbqtImage( "sgl2dblquote"  ), {|| oHbQtEditor:convertDQuotes()              }, .f. )
      :addToolButton( "Dbl2Sgl"   , "Double to Single Quotes", __hbqtImage( "dbl2sglquote"  ), {|| oHbQtEditor:convertQuotes()               }, .f. )
      :addToolButton( "Stringify" , "Stringify Selection"    , __hbqtImage( "stringify"     ), {|| oHbQtEditor:stringify()                   }, .f. )
      :addToolButton( "AlignAt"   , "Align At..."            , __hbqtImage( "align_at"      ), {|| oHbQtEditor:alignAt()                     }, .f. )
      :addToolButton( "Orientation","Change Orientation"     , __hbqtImage( "prv_page-setup"), {|v| v := oHbQtEditor:oToolbar, ;
                                       v:setOrientation( iif( v:orientation() == Qt_Vertical, Qt_Horizontal, Qt_Vertical ) ), v:adjustSize() }, .f. )
      :addToolButton( "Close"     , "Hide Me"                , __hbqtImage( "closetab"      ), {|| oHbQtEditor:oToolbar:hide()               }, .f. )
   ENDWITH
   RETURN oToolbar


