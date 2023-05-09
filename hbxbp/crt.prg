/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2011-2023 Pritpal Bedi <bedipritpal@hotmail.com>
 * http://harbour-project.org
 *
 * This program is free software; you can redistribute it AND/OR modify
 * it under the terms of the GNU General PUBLIC License as published by
 * the Free Software Foundation; either version 2, OR (at your option)
 * any later version.
 *
 * This program is distributed IN the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General PUBLIC License FOR more details.
 *
 * You should have received a copy of the GNU General PUBLIC License
 * along WITH this software; see the file COPYING.  IF NOT, write TO
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (OR visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission FOR
 * additional uses of the text contained IN its release of Harbour.
 *
 * The exception is that, IF you link the Harbour libraries WITH other
 * files TO produce an executable, this does NOT by itself cause the
 * resulting executable TO be covered by the GNU General PUBLIC License.
 * Your use of that executable is IN no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does NOT however invalidate any other reasons why
 * the executable file might be covered by the GNU General PUBLIC License.
 *
 * This exception applies only TO the code released by the Harbour
 * Project under the name Harbour.  IF you copy code FROM other
 * Harbour Project OR Free Software Foundation releases into a copy of
 * Harbour, as the General PUBLIC License permits, the exception does
 * NOT apply TO the code that you add IN this way.  TO avoid misleading
 * anyone as TO the status of such modified files, you must delete
 * this exception notice FROM them.
 *
 * IF you write modifications of your own FOR Harbour, it is your choice
 * whether TO permit this exception TO apply TO your modifications.
 * IF you DO NOT wish that, delete this exception notice.
 *
 */
/*----------------------------------------------------------------------*/
 *
 *                               EkOnkar
 *                         ( The LORD is ONE )
 *
 *                    Xbase++ Compatible xbpCrt CLASS
 *
 *                 Pritpal Bedi  <bedipritpal@hotmail.com>
 *                              12Apr2011
 *
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "inkey.ch"
#include "hbgtinfo.ch"

#include "xbp.ch"
#include "appevent.ch"

#define HB_GTI_WIDGET          2001
#define HB_GTI_DRAWINGAREA     2002
#define HB_GTI_DISABLE         2003
#define HB_GTI_EVENTLOOP       2004


CLASS XbpCrt  INHERIT  XbpWindow, XbpPartHandler

   DATA     oMenu

   /*  CONFIGURATION */
   DATA     alwaysOnTop                           INIT  .F.        /* Determines whether the dialog can be covered by other windows */
   DATA     border                                INIT  0          /* Border type FOR the XbpCrt window */
   DATA     clipChildren                          INIT  .F.
   DATA     closable                              INIT  .T.
   DATA     fontHeight                            INIT  16
   DATA     fontName                              INIT  "Courier New"
   DATA     fontWidth                             INIT  8
   DATA     gridMove                              INIT  .F.
   DATA     icon                                  INIT  0
   DATA     minMax                                INIT  .T.
   DATA     sysMenu                               INIT  .T.
   DATA     taskList                              INIT  .T.
   DATA     title                                 INIT  " "
   DATA     titleBar                              INIT  .T.
   DATA     visible                               INIT  .T.

   DATA     autoFocus                             INIT  .T.
   DATA     autoMark                              INIT  .T.
   DATA     dropFont                              INIT  .T.
   DATA     dropZone                              INIT  .F.
   DATA     helpLink                              INIT  NIL
   DATA     maxCol                                INIT  79
   DATA     maxRow                                INIT  24
   DATA     mouseMode                             INIT  1          /* Determines whether mouse coordinates are given as graphics OR text coordinates.*/
   DATA     modalResult                           INIT  NIL        /* Specifies the result of a modal dialog.                                        */
   DATA     aSyncFlush                            INIT  .F.        /* Determines the display behavior of text-mode output.                           */
   DATA     tooltipText                           INIT  ""
   DATA     useShortCuts                          INIT  .F.        /* Enables shortcut keys FOR the system menu                                      */
   DATA     xSize                                 INIT  640 READONLY
   DATA     ySize                                 INIT  400 READONLY

   /*  GUI Specifics */
   DATA     animate                               INIT  .F.
   DATA     clipParent                            INIT  .F.
   DATA     clipSiblings                          INIT  .T.
   DATA     group                                 INIT  0          /* XBP_NO_GROUP */
   DATA     sizeRedraw                            INIT  .F.
   DATA     tabStop                               INIT  .F.

   /*  CALLBACK SLOTS */
   DATA     sl_enter
   DATA     sl_leave
   DATA     sl_lbClick
   DATA     sl_lbDblClick
   DATA     sl_lbDown
   DATA     sl_lbUp
   DATA     sl_mbClick
   DATA     sl_mbDblClick
   DATA     sl_mbDown
   DATA     sl_mbUp
   DATA     sl_motion
   DATA     sl_rbClick
   DATA     sl_rbDblClick
   DATA     sl_rbDown
   DATA     sl_rbUp
   DATA     sl_wheel

   DATA     sl_close
   DATA     sl_helpRequest
   DATA     sl_keyboard
   DATA     sl_killDisplayFocus                    /* only FOR CRT */
   DATA     sl_killInputFocus
   DATA     sl_move
   DATA     sl_paint                               /* only FOR gui dialogs */
   DATA     sl_quit
   DATA     sl_resize
   DATA     sl_setDisplayFocus                     /* only FOR CRT */
   DATA     sl_setInputFocus
   DATA     sl_dragEnter
   DATA     sl_dragMotion
   DATA     sl_dragLeave
   DATA     sl_dragDrop

   /*  HARBOUR implementation */
   DATA     resizable                             INIT  .t.
   DATA     resizeMode                            INIT  HB_GTI_RESIZEMODE_FONT
   DATA     style                                 INIT  0 // (WS_OVERLAPPED + WS_CAPTION + WS_SYSMENU + WS_SIZEBOX + WS_MINIMIZEBOX + WS_MAXIMIZEBOX)
   DATA     exStyle                               INIT  0
   DATA     lModal                                INIT  .f.
   DATA     pGTp
   DATA     pGT
   DATA     objType                               INIT  0 //objTypeCrt
   DATA     ClassName                             INIT  "XBPCRT"
   DATA     drawingArea
   DATA     hWnd
   DATA     aPos                                  INIT  { 0,0 }
   DATA     aSize                                 INIT  { 24,79 }
   DATA     aPresParams                           INIT  {}
   DATA     lHasInputFocus                        INIT  .F.
   DATA     nFrameState                           INIT  0  /* normal */

   METHOD   setTitle( cTitle )                    INLINE ::title := cTitle, hb_gtInfo( HB_GTI_WINTITLE, cTitle )
   METHOD   getTitle()                            INLINE hb_gtInfo( HB_GTI_WINTITLE )
   METHOD   showWindow()                          INLINE ::show()
   METHOD   refresh()                             INLINE NIL //::invalidateRect()

   /*  LIFE CYCLE */
   METHOD   init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )
   METHOD   destroy()
   METHOD   setFocus()

   /*  METHODS */
   METHOD   currentPos()
   METHOD   currentSize()
   METHOD   captureMouse()
   METHOD   disable()
   METHOD   enable()
   METHOD   getFrameState()
   METHOD   getHWND()
   METHOD   getModalState()
   METHOD   hasInputFocus()
   METHOD   hide()
   METHOD   invalidateRect( nTop, nLeft, nBottom, nRight )
   METHOD   isEnabled()
   METHOD   isVisible()
   METHOD   lockPS()
   METHOD   lockUpdate()
   METHOD   menuBar()
   METHOD   setColorBG()
   METHOD   setColorFG()
   METHOD   setFont()
   METHOD   setFontCompoundName()
   METHOD   setFrameState( nState )
   METHOD   setPresParam()
   METHOD   setModalState()
   METHOD   setPointer()
   METHOD   setTrackPointer()
   METHOD   setPos()
   METHOD   setPosAndSize()
   METHOD   setSize( aSize, lPaint )
   METHOD   showModal()
   METHOD   show()
   METHOD   toBack()
   METHOD   toFront()
   METHOD   unlockPS()
   METHOD   winDevice()

   /* MESSAGES  */
   METHOD   enter( xParam )                       SETGET
   METHOD   leave( xParam )                       SETGET
   METHOD   lbClick( xParam )                     SETGET
   METHOD   lbDblClick( xParam )                  SETGET
   METHOD   lbDown( xParam )                      SETGET
   METHOD   lbUp( xParam )                        SETGET
   METHOD   mbClick( xParam )                     SETGET
   METHOD   mbDblClick( xParam )                  SETGET
   METHOD   mbDown( xParam )                      SETGET
   METHOD   mbUp( xParam )                        SETGET
   METHOD   motion( xParam )                      SETGET
   METHOD   rbClick( xParam )                     SETGET
   METHOD   rbDblClick( xParam )                  SETGET
   METHOD   rbDown( xParam )                      SETGET
   METHOD   rbUp( xParam )                        SETGET
   METHOD   wheel( xParam )                       SETGET
   METHOD   close( xParam )                       SETGET
   METHOD   helpRequest( xParam )                 SETGET
   METHOD   keyboard( xParam )                    SETGET
   METHOD   killDisplayFocus( xParam )            SETGET
   METHOD   killInputFocus( xParam )              SETGET
   METHOD   move( xParam )                        SETGET
   METHOD   paint( xParam )                       SETGET
   METHOD   quit( xParam, xParam1 )               SETGET
   METHOD   resize( xParam )                      SETGET
   METHOD   setDisplayFocus( xParam )             SETGET
   METHOD   setInputFocus( xParam )               SETGET
   METHOD   dragEnter( xParam, xParam1 )          SETGET
   METHOD   dragMotion( xParam )                  SETGET
   METHOD   dragLeave( xParam )                   SETGET
   METHOD   dragDrop( xParam, xParam1 )           SETGET

   DATA     nFlags
   DATA     oMDI

   ENDCLASS


METHOD XbpCrt:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::xbpWindow:init( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::resizeMode  := 0
   ::mouseMode   := 0

   ::drawingArea := XbpDrawingArea():new( SELF, , {0,0}, ::aSize, , .t. )
   RETURN SELF


METHOD XbpCrt:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::XbpWindow:create( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   ::maxRow := ::aSize[ 1 ]
   ::maxCol := ::aSize[ 2 ]

   hb_gtReload( "QTC" )
   ::pGT := hb_gtSelect()

   /* Creates physical window */
   ? " "

   ::oWidget := GtQTC_MainWindow()
   ::drawingArea:oWidget := GtQTC_DrawingArea()

   ::oWidget:setWindowTitle( ::title )

   hb_gtInfo( HB_GTI_CLOSABLE , ::closable  )
   hb_gtInfo( HB_GTI_RESIZABLE, ::resizable )

   //hb_gtInfo( HB_GTI_RESIZEMODE, iif( ::resizeMode == HB_GTI_RESIZEMODE_ROWS, HB_GTI_RESIZEMODE_ROWS, HB_GTI_RESIZEMODE_FONT ) )

   IF ! empty( ::toolTipText )
      ::oWidget:setTooltip( ::toolTipText )
   ENDIF
   IF HB_ISSTRING( ::icon )
      ::oWidget:setWindowIcon( QIcon( ::icon ) )
   ENDIF

   IF ::lModal
      hb_gtInfo( HB_GTI_DISABLE, ::pGTp )
   ENDIF
   IF ::visible
      ::oWidget:show()
      ::oWidget:setFocus()
      ::lHasInputFocus := .t.
   ENDIF

   ::nFlags := ::oWidget:windowFlags()
   IF __objGetClsName( ::oParent ) $ "XBPDRAWINGAREA"
      ::setParent( ::oParent )
   ENDIF

   // HB_GtInfo( HB_GTI_NOTIFIERBLOCK, {|nEvent, ...| ::notifier( nEvent, ... ) } )
#IF 0
   hb_gtInfo( HB_GTI_PRESPARAMS, { ::exStyle, ::style, ::aPos[ 1 ], ::aPos[ 2 ], ;
                           ::maxRow+1, ::maxCol+1, ::pGTp, .F., lRowCol, HB_WNDTYPE_CRT } )
   hb_gtInfo( HB_GTI_SETFONT, { ::fontName, ::fontHeight, ::fontWidth } )
#ENDIF
   RETURN SELF


METHOD XbpCrt:configure( oParent, oOwner, aPos, aSize, aPresParams, lVisible )

   DEFAULT oParent     TO ::oParent
   DEFAULT oOwner      TO ::oOwner
   DEFAULT aPos        TO ::aPos
   DEFAULT aSize       TO ::aSize
   DEFAULT aPresParams TO ::aPresParams
   DEFAULT lVisible    TO ::visible

   ::oParent     := oParent
   ::oOwner      := oOwner
   ::aPos        := aPos
   ::aSize       := aSize
   ::aPresParams := aPresParams
   ::visible     := lVisible
   RETURN SELF


METHOD XbpCrt:destroy()

   ::oMDI := NIL
   IF HB_ISOBJECT( ::oMenu )
      ::oMenu:destroy()
   ENDIF
   IF Len( ::aChildren ) > 0
      aeval( ::aChildren, {|o| o:destroy() } )
   ENDIF
   ::pGT  := NIL
   ::pGTp := NIL
   RETURN SELF


METHOD XbpCrt:currentPos()
   RETURN SELF


METHOD XbpCrt:currentSize()
   RETURN { hb_gtInfo( HB_GTI_SCREENWIDTH ), hb_gtInfo( HB_GTI_SCREENHEIGHT ) }


METHOD XbpCrt:captureMouse()
   RETURN SELF


METHOD XbpCrt:disable()
   //hb_gtInfo( HB_GTI_DISABLE, ::pGT )
   RETURN SELF


METHOD XbpCrt:enable()
   //hb_gtInfo( HB_GTI_ENABLE, ::pGT )
   RETURN SELF


METHOD XbpCrt:getFrameState()
#IF 0
   IF WVG_IsIconic( ::hWnd )
      RETURN WVGDLG_FRAMESTAT_MINIMIZED
   ENDIF
   IF WVG_IsZoomed( ::hWnd )
      RETURN WVGDLG_FRAMESTAT_MAXIMIZED
   ENDIF
   RETURN WVGDLG_FRAMESTAT_NORMALIZED
#ENDIF
   RETURN NIL


METHOD XbpCrt:getHWND()
   RETURN ::hWnd


METHOD XbpCrt:getModalState()
   RETURN SELF


METHOD XbpCrt:hasInputFocus()
   RETURN ::lHasInputFocus


METHOD XbpCrt:hide()
   //hb_gtInfo( HB_GTI_SPEC, HB_GTS_SHOWWINDOW, HB_GTS_SW_HIDE )
   RETURN SELF


METHOD XbpCrt:invalidateRect( nTop, nLeft, nBottom, nRight )
   DEFAULT nTop TO 0
   DEFAULT nLeft TO 0
   DEFAULT nBottom TO maxrow()
   DEFAULT nRight TO maxcol()
   // Wvt_InvalidateRect( nTop, nLeft, nBottom, nRight )
   RETURN SELF


METHOD XbpCrt:isEnabled()
   RETURN SELF


METHOD XbpCrt:isVisible()
   RETURN SELF


METHOD XbpCrt:lockPS()
   RETURN SELF


METHOD XbpCrt:lockUpdate()
   RETURN SELF


METHOD XbpCrt:menuBar()
   IF ! HB_ISOBJECT( ::oMenu )
      ::oMenu := XbpMenuBar():New( SELF ):CREATE()
   ENDIF
   RETURN ::oMenu


METHOD XbpCrt:setColorBG()
   RETURN SELF


METHOD XbpCrt:setColorFG()
   RETURN SELF


METHOD XbpCrt:setFont()
   RETURN SELF


METHOD XbpCrt:setFontCompoundName()
   RETURN ""


METHOD XbpCrt:setFrameState( nState )
   LOCAL lSuccess := .f.

   HB_SYMBOL_UNUSED( nState )
   DO CASE
#IF 0
   CASE nState == XBPDLG_FRAMESTAT_MINIMIZED
      lSuccess := ::sendMessage( WM_SYSCOMMAND, SC_MINIMIZE, 0 )
   CASE nState == XBPDLG_FRAMESTAT_MAXIMIZED
      lSuccess := ::sendMessage( WM_SYSCOMMAND, SC_MAXIMIZE, 0 )
   CASE nState == XBPDLG_FRAMESTAT_NORMALIZED
      lSuccess := ::sendMessage( WM_SYSCOMMAND, SC_RESTORE, 0 )
#ENDIF
   ENDCASE
   RETURN lSuccess


METHOD XbpCrt:setModalState()
   RETURN SELF


METHOD XbpCrt:setPointer()
   RETURN SELF


METHOD XbpCrt:setTrackPointer()
   RETURN SELF


METHOD XbpCrt:setPos()
   RETURN SELF


METHOD XbpCrt:setPosAndSize()
   RETURN SELF


METHOD XbpCrt:setPresParam()
   RETURN SELF


METHOD XbpCrt:setSize( aSize, lPaint )
   IF HB_ISARRAY( aSize )
      DEFAULT lPaint TO .T.
      
      hb_gtInfo( HB_GTI_SCREENHEIGHT, aSize[ 1 ] )
      hb_gtInfo( HB_GTI_SCREENWIDTH , aSize[ 2 ] )
   ENDIF 
   RETURN SELF


METHOD XbpCrt:show()
   //Hb_GtInfo( HB_GTI_SPEC, HB_GTS_SHOWWINDOW, SW_NORMAL )
   ::lHasInputFocus := .t.
   RETURN SELF


METHOD XbpCrt:showModal()
   RETURN SELF


METHOD XbpCrt:toBack()
   RETURN SELF


METHOD XbpCrt:toFront()
   //RETURN WVG_SetWindowPosToTop( ::hWnd )
   RETURN .T.


METHOD XbpCrt:unlockPS()
   RETURN SELF


METHOD XbpCrt:winDevice()
   RETURN SELF


METHOD XbpCrt:enter( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_enter )
      eval( ::sl_enter, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_enter := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:leave( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_leave )
      Eval( ::sl_leave, NIL, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_leave := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:lbClick( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_lbClick )
      Eval( ::sl_lbClick, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_lbClick := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:lbDblClick( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_lbDblClick )
      eval( ::sl_lbDblClick, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_lbDblClick := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:lbDown( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_lbDown )
      Eval( ::sl_lbDown, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_lbDown := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:lbUp( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_lbUp )
      Eval( ::sl_lbUp, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_lbUp := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:mbClick( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_mbClick )
      Eval( ::sl_mbClick, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_mbClick := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:mbDblClick( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_mbDblClick )
      eval( ::sl_mbDblClick, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_mbDblClick := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:mbDown( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_mbDown )
      eval( ::sl_mbDown, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_mbDown := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:mbUp( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_mbUp )
      Eval( ::sl_mbUp, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_mbUp := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:motion( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_motion )
      Eval( ::sl_motion, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_motion := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:rbClick( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_rbClick )
      Eval( ::sl_rbClick, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_rbClick := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:rbDblClick( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_rbDblClick )
      Eval( ::sl_rbDblClick, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_rbDblClick := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:rbDown( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_rbDown )
      Eval( ::sl_rbDown, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_rbDown := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:rbUp( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_rbUp )
      Eval( ::sl_rbUp, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_rbUp := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:wheel( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_wheel )
      Eval( ::sl_wheel, xParam, NIL, SELF )
      RETURN SELF
   ENDIF 
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_wheel := xParam
      RETURN NIL
   ENDIF 
   RETURN SELF


METHOD XbpCrt:close( xParam )
   IF HB_ISNIL( xParam ) .AND. HB_ISBLOCK( ::sl_close )
      eval( ::sl_close, NIL, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_close := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:helpRequest( xParam )
   IF HB_ISNIL( xParam ) .AND. HB_ISBLOCK( ::sl_helpRequest )
      eval( ::sl_helpRequest, NIL, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_helpRequest := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:keyboard( xParam )
   IF HB_ISNUMERIC( xParam ) .AND. HB_ISBLOCK( ::sl_keyboard )
      eval( ::sl_keyboard, xParam, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_keyboard := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:killDisplayFocus( xParam )
   IF HB_ISNIL( xParam ) .AND. HB_ISBLOCK( ::sl_killDisplayFocus )
      eval( ::sl_killDisplayFocus, NIL, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_killDisplayFocus := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:killInputFocus( xParam )
   IF HB_ISNIL( xParam ) .AND. HB_ISBLOCK( ::sl_killInputFocus )
      eval( ::sl_killInputFocus, NIL, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_killInputFocus := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:move( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_move )
      eval( ::sl_move, xParam, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_move := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:paint( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_paint )
      eval( ::sl_paint, xParam, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_paint := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:quit( xParam, xParam1 )
   IF HB_ISNUMERIC( xParam ) .AND. HB_ISBLOCK( ::sl_quit )
      eval( ::sl_quit, xParam, xParam1, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_quit := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:resize( xParam )
   IF HB_ISBLOCK( xParam )/* .OR. HB_ISNIL( xParam ) */
      ::sl_resize := xParam
      RETURN NIL
   ENDIF
   IF empty( xParam )
      //::sendMessage( WM_SIZE, 0, 0 )
   ENDIF
   RETURN SELF


METHOD XbpCrt:setDisplayFocus( xParam )
   IF HB_ISNIL( xParam ) .AND. HB_ISBLOCK( ::setDisplayFocus )
      eval( ::setDisplayFocus, NIL, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::setDisplayFocus := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:setInputFocus( xParam )
   IF HB_ISNIL( xParam ) .AND. HB_ISBLOCK( ::sl_setInputFocus )
      eval( ::sl_setInputFocus, NIL, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_setInputFocus := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:dragEnter( xParam, xParam1 )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_dragEnter )
      eval( ::sl_dragEnter, xParam, xParam1, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_dragEnter := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:dragMotion( xParam )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_dragMotion )
      eval( ::sl_dragMotion, xParam, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_dragMotion := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:dragLeave( xParam )
   IF HB_ISNIL( xParam ) .AND. HB_ISBLOCK( ::sl_dragLeave )
      eval( ::sl_dragLeave, NIL, NIL, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_dragLeave := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:dragDrop( xParam, xParam1 )
   IF HB_ISARRAY( xParam ) .AND. HB_ISBLOCK( ::sl_dragDrop )
      eval( ::sl_dragDrop, xParam, xParam1, SELF )
      RETURN SELF
   ENDIF
   IF HB_ISBLOCK( xParam ) .OR. HB_ISNIL( xParam )
      ::sl_dragDrop := xParam
      RETURN NIL
   ENDIF
   RETURN SELF


METHOD XbpCrt:SetFocus()
   //::sendMessage( WM_ACTIVATE, 1, 0 )
   /* ::sendMessage( WM_SETFOCUS, 0, 0 ) */
   RETURN SELF

