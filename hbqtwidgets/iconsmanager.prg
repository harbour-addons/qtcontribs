 /*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2023-2023 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                             Pritpal Bedi
 *                              12May2023
 */
/*----------------------------------------------------------------------*/

#include "hbclass.ch"
#include "common.ch"
#include "inkey.ch"
#include "fileio.ch"
#include "hbgtinfo.ch"
#include "hbhrb.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"


CLASS HbQtIconsManager

   DATA   oUI
   DATA   oWidget
   DATA   oParent
   DATA   bBlockCallback 
   DATA   nRows                                   INIT 3
   DATA   nCols                                   INIT 10
   DATA   hIcons                                  INIT NIL 
   DATA   nTextH                                  INIT 0
   DATA   nIconW                                  INIT 52
   DATA   nIconH                                  INIT 52
   DATA   nMaxIconBytes                           INIT 10000
   DATA   cIconsPath                              INIT NIL 
   
   ACCESS widget()                                INLINE ::oWidget

   METHOD init( oParent, bBlock )
   METHOD create( oParent, bBlock )
   METHOD show()
   METHOD hide()
   METHOD connect()
   METHOD requestIcons()
   METHOD addIcon()
   METHOD publishIcons( hIcons )
   METHOD iconSelected( cName )
   
   ACCESS iconsPath()                             INLINE ::cIconsPath
   METHOD setIconsPath( cPath )                   INLINE ::cIconsPath := cPath 
   ENDCLASS 
   
   
METHOD HbQtIconsManager:init( oParent, bBlock ) 
   DEFAULT oParent TO ::oParent 
   DEFAULT bBlock  TO ::bBlockCallback
   ::oParent := oParent
   ::bBlockCallback := bBlock 
   RETURN Self 
   
   
METHOD HbQtIconsManager:create( oParent, bBlock )   
   DEFAULT oParent TO ::oParent 
   DEFAULT bBlock  TO ::bBlockCallback
   ::oParent := oParent
   DEFAULT ::oParent TO __hbqtAppWidget()
   ::bBlockCallback := bBlock 
  
   WITH OBJECT ::oUI := hbqtui_iconsmanager( ::oParent )
      ::oWidget := :widget()
   ENDWITH 
   ::connect()   
   ::requestIcons()
   RETURN Self 
   

METHOD HbQtIconsManager:show()
   ::oWidget:exec()
   RETURN NIL 
   
    
METHOD HbQtIconsManager:hide()
   ::oWidget:hide()
   RETURN NIL 
   
    
METHOD HbQtIconsManager:connect()
   WITH OBJECT ::oUI 
      :oWidget() : connect( QEvent_Close, {|| ::oUI:oWidget():done( 0 ) } )
      :toolAddIcon() : connect( "clicked()", {|| ::addIcon() } )
      WITH OBJECT :gridIcons()
         :setContentsMargins( 3,3,3,3 )
         :setHorizontalSpacing( 3 )
         :setVerticalSpacing( 3 )
         :setAlignment( hb_bitOr( Qt_AlignLeft, Qt_AlignTop ) )
      ENDWITH
   ENDWITH
   RETURN NIL 
   

METHOD HbQtIconsManager:requestIcons()
   IF HB_ISBLOCK( ::bBlockCallback )
      ::hIcons := Eval( ::bBlockCallback, "provide_icons" )   
   ENDIF
   IF ! HB_ISHASH( ::hIcons )
      ::hIcons := __hbqtStandardHash()
   ENDIF
   hb_HKeepOrder( ::hIcons, .F. )
   ::publishIcons( ::hIcons )
   RETURN NIL 
   

METHOD HbQtIconsManager:addIcon()
   LOCAL cName, hIcon, cPngFile
   LOCAL lAllowMulti := .T.
   LOCAL lCanCreate := .F.
   LOCAL xPngFile := HbQtOpenFileDialog( ::iconsPath(), "Select an Icon", "PNG Icons (*.png)", lAllowMulti, lCanCreate, /*aPos*/ )
   
   IF HB_ISSTRING( xPngFile )
      xPngFile := { xPngFile }
   ENDIF
   IF HB_ISARRAY( xPngFile )
      FOR EACH cPngFile IN xPngFile 
         IF hb_vfExists( cPngFile )
            hb_FNameSplit( cPngFile, NIL, @cName )
            cName := Lower( cName )
            IF hb_HHasKey( ::hIcons, cName )
               LOOP
            ENDIF
            hIcon := __hbqtStandardHash()
            hIcon[ "name" ] := cName
            hIcon[ "file" ] := cPngFile 
            hIcon[ "icon" ] := hb_MemoRead( cPngFile )
            IF Len( hIcon[ "icon" ] ) > ::nMaxIconBytes
               LOOP 
            ENDIF
            IF HB_ISBLOCK( ::bBlockCallback )
               IF ! Eval( ::bBlockCallback, "save_new_icon", hIcon )   
                  LOOP 
               ENDIF 
            ENDIF
            ::hIcons[ cName ] := hIcon 
         ENDIF
      NEXT
      ::publishIcons( ::hIcons )
   ENDIF
   RETURN NIL 
   
   
METHOD HbQtIconsManager:publishIcons( hIcons )   
   LOCAL oIcon, hIcon, oToolButton, oPixmap, cName, i 
   LOCAL nRow := 0, nCol := 0, nIcons := 0 
   //
   FOR EACH hIcon IN hIcons
      IF ! Empty( hIcon )
         nIcons++
      ENDIF
   NEXT    
   ::nRows := Int( nIcons / ::nCols )
   WITH OBJECT ::oUI
      WITH OBJECT :gridIcons()
         :invalidate()
         FOR i := 0 TO ::nRows - 1
            :setRowMinimumHeight( i, ::nIconH + ::nTextH )
         NEXT
         FOR i := 0 TO ::nCols - 1
            :setColumnMinimumWidth( i, ::nIconW )
         NEXT 
      ENDWITH 
      FOR EACH hIcon IN hIcons 
         IF hb_HHasKey( hIcon, "toolbutton" )
            oToolButton := hIcon[ "toolbutton" ]
         ELSE 
            oPixmap := QPixmap():fromImage( QImage():fromData( hIcon[ "icon" ], ::nMaxIconBytes ) )
            oIcon := QIcon( oPixmap )
            WITH OBJECT oToolButton := QToolButton()
               cName := hIcon[ "name" ]
               :setIcon( oIcon )
               :setText( cName )   
               :setIconSize( QSize( ::nIconW, ::nIconH ) )
               :setTooltip( cName + Chr( 10 ) + hb_ntos( oPixmap:width() ) + "x" + hb_ntos( oPixmap:height() ) )
               :setAutoRaise( .T. )
#if 0
               :setToolButtonStyle( Qt_ToolButtonTextUnderIcon )
#endif
               :setMaximumWidth( ::nIconW )
               :setMaximumHeight( ::nIconH + ::nTextH )
               //
               :connect( "clicked()", __buildActionBlock( Self, cName ) )
               //
               hIcon[ "toolbutton" ] := oToolButton
            ENDWITH
         ENDIF 
         IF .T.
            :gridIcons():addWidget( oToolButton, nRow, nCol )
            //
            nCol++
            IF nCol >= ::nCols
               nCol := 0
               nRow++ 
            ENDIF
         ENDIF 
      NEXT
   ENDWITH
   RETURN NIL 
   
   
STATIC FUNCTION __buildActionBlock( oSelf, cName )
   RETURN {|| oSelf:iconSelected( cName ) }   


METHOD HbQtIconsManager:iconSelected( cName )
   IF HB_ISBLOCK( ::bBlockCallback )
      Eval( ::bBlockCallback, "icon_selected", cName )   
   ENDIF
   ::oWidget:done( 0 )
   RETURN cName
   
      