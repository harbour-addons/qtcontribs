/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2014 Pritpal Bedi <bedipritpal@hotmail.com>
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
 *                    Harbour HbQtPrintPreview Class
 *
 *                             Pritpal Bedi
 *                              08Oct2014
 */
/*----------------------------------------------------------------------*/


#include "inkey.ch"
#include "hbclass.ch"
#include "common.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "hbtrace.ch"


#define HBQT_PVW_TOOLBAR_NEEDED                   1     // .T.
#define HBQT_PVW_TOOLBAR_POSITION                 2     // Qt_TopToolBarArea
#define HBQT_PVW_TOOLBAR_INDICATORS_SIZE          3     // 3
#define HBQT_PVW_TOOLBAR_INDICATORS_RGB           4     // { 0,0,255 }
#define HBQT_PVW_BUTTON_BACK                      5     // .T.
#define HBQT_PVW_BUTTON_PRINT                     6     // .T.
#define HBQT_PVW_BUTTON_CURRENT_PAGE              7     // .T.
#define HBQT_PVW_BUTTON_FACING_PAGES              8     // .T.
#define HBQT_PVW_BUTTON_ALL_PAGES                 9     // .T.
#define HBQT_PVW_BUTTON_ZOOM_IN                   10    // .T.
#define HBQT_PVW_BUTTON_ZOOM_OUT                  11    // .T.
#define HBQT_PVW_BUTTON_FIT_WIDTH                 12    // .T.
#define HBQT_PVW_BUTTON_FIT_SIZE                  13    // .T.
#define HBQT_PVW_BUTTON_LANDSCAPE                 14    // .T.
#define HBQT_PVW_BUTTON_PORTRAIT                  15    // .T.
#define HBQT_PVW_BUTTON_FIRST                     16    // .T.
#define HBQT_PVW_BUTTON_PREVIOUS                  17    // .T.
#define HBQT_PVW_BUTTON_NEXT                      18    // .T.
#define HBQT_PVW_BUTTON_LAST                      19    // .T.
#define HBQT_PVW_BUTTON_SAVE                      20    // .T.
#define HBQT_PVW_BUTTON_PAGESETUP                 21    // .T.
#define HBQT_PVW_TOOLBAR_BUTTONS_GAP              22    // 0
#define HBQT_PVW_TOOLBAR_BUTTONS_WIDTH            23    // 48
#define HBQT_PVW_TOOLBAR_BUTTONS_HEIGHT           24    // 48
#define HBQT_PVW_TOOLBAR_IMAGE_WIDTH              25    // 32
#define HBQT_PVW_TOOLBAR_IMAGE_HEIGHT             26    // 32


CLASS HbQtPrintPreview

   DATA   oWidget
   DATA   oParent
   DATA   oLayout
   DATA   oToolbar
   DATA   oPreviewer
   DATA   oPrinter

   METHOD init( oParent )
   METHOD create( oParent )

   METHOD buildToolbar( oLayout )
   METHOD manageToolbarClicks( cButton )

   DATA   bPreviewBlock
   METHOD previewBlock( bBlock )                  SETGET

   DATA   bExitBlock
   METHOD exitBlock( bBlock )                     SETGET

   DATA   bSaveBlock
   METHOD saveBlock( bBlock )                     SETGET

   METHOD exec( bBlock, ... )

   METHOD refreshPreview()                        INLINE ::oPreviewer:updatePreview()

   METHOD setOptions( xOption, xValue )

   ACCESS toolbar()                               INLINE ::oToolbar
   ENDCLASS


METHOD HbQtPrintPreview:init( oParent )
   DEFAULT oParent  TO ::oParent
   ::oParent := oParent
   RETURN Self


METHOD HbQtPrintPreview:create( oParent )
   LOCAL oVLay, oHLay

   DEFAULT oParent  TO ::oParent
   ::oParent := oParent

   ::oWidget := QWidget()
   WITH OBJECT oVLay := QVBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   ::oWidget:setLayout( oVLay )

   WITH OBJECT oHLay := QHBoxLayout()
      :setContentsMargins( 0,0,0,0 )
      :setSpacing( 0 )
   ENDWITH
   oVLay:addLayout( oHLay )

   ::oPreviewer := QPrintPreviewWidget()
   oVLay:addWidget( ::oPreviewer )

   ::buildToolbar( oHLay )

   IF __objDerivedFrom( ::oParent, "QVBOXLAYOUT" )
      ::oLayout := ::oParent
   ELSEIF __objDerivedFrom( ::oParent, "QHBOXLAYOUT" )
      ::oLayout := ::oParent
   ELSE
      IF Empty( ::oLayout := ::oParent:layout() )
         ::oLayout := QVBoxLayout()
         ::oParent:setLayout( ::oLayout )
      ENDIF
   ENDIF
   IF ! Empty( ::oLayout )
      ::oLayout:addWidget( ::oWidget )
   ENDIF

   ::oPreviewer:connect( "paintRequested(QPrinter*)", {|oPrinter| ::exec( ::previewBlock(), oPrinter ) } )
   RETURN Self


METHOD HbQtPrintPreview:setOptions( xOption, xValue )
   HB_SYMBOL_UNUSED( xOption + xValue )
   RETURN Self


METHOD HbQtPrintPreview:buildToolbar( oLayout )

   WITH OBJECT ::oToolbar := HbQtScrollableToolbar():new()
      :create( oLayout )
   ENDWITH
   WITH OBJECT ::oToolbar
      :addToolbarButton( "Exit"     , "Exit"     , "prv_undo"        , {|| ::manageToolbarClicks( "Exit"        ) }  )
      :addToolbarButton( "Printer"  , "Print"    , "prv_printer"     , {|| ::manageToolbarClicks( "Printer"     ) }  )
      :addToolbarButton( "Page1"    , "Page1"    , "prv_page_one"    , {|| ::manageToolbarClicks( "Page1"       ) }  )
      :addToolbarButton( "Page2"    , "Page2"    , "prv_page_double" , {|| ::manageToolbarClicks( "Page2"       ) }  )
      :addToolbarButton( "Page4"    , "Page4"    , "prv_page_four"   , {|| ::manageToolbarClicks( "Page4"       ) }  )
      :addToolbarButton( "ZoomIn"   , "ZoomIn"   , "prv_zoom-in"     , {|| ::manageToolbarClicks( "ZoomIn"      ) }, .F., .F., .T., .F. )
      :addToolbarButton( "ZoomOut"  , "ZoomOut"  , "prv_zoom-out"    , {|| ::manageToolbarClicks( "ZoomOut"     ) }, .F., .F., .T., .F. )
      :addToolbarButton( "FitWidth" , "FitWidth" , "prv_fit-width"   , {|| ::manageToolbarClicks( "FitWidth"    ) }  )
      :addToolbarButton( "FitBest"  , "FitBest"  , "prv_fit-best"    , {|| ::manageToolbarClicks( "FitBest"     ) }  )
      :addToolbarButton( "Landscape", "Landscape", "prv_landscape"   , {|| ::manageToolbarClicks( "Landscape"   ) }  )
      :addToolbarButton( "Portrait" , "Portrait" , "prv_portrait"    , {|| ::manageToolbarClicks( "Portrait"    ) }  )
      :addToolbarButton( "Left1"    , "Left1"    , "prv_leftall-4"   , {|| ::manageToolbarClicks( "Left1"       ) }  )
      :addToolbarButton( "Left"     , "Left"     , "prv_left-4"      , {|| ::manageToolbarClicks( "Left"        ) }  )
      :addToolbarButton( "Right"    , "Right"    , "prv_right-4"     , {|| ::manageToolbarClicks( "Right"       ) }  )
      :addToolbarButton( "Right1"   , "Right1"   , "prv_rightall-4"  , {|| ::manageToolbarClicks( "Right1"      ) }  )
      :addToolbarButton( "Save"     , "Save"     , "prv_save-1"      , {|| ::manageToolbarClicks( "Save"        ) }  )
      :addToolbarButton( "PageSetup", "PageSetup", "prv_page-setup"  , {|| ::manageToolbarClicks( "PageSetup"   ) }  )
   ENDWITH
   RETURN Self


METHOD HbQtPrintPreview:manageToolbarClicks( cButton )
   LOCAL xTmp
   LOCAL oPrv := ::oPreviewer

   SWITCH cButton
   CASE "Exit"      ; ::exec( ::exitBlock() )                                                                           ; EXIT
   CASE "Printer"   ; oPrv:print()                                                                                      ; EXIT
   CASE "Page1"     ; oPrv:setSinglePageViewMode()                                                                      ; EXIT
   CASE "Page2"     ; oPrv:setFacingPagesViewMode()                                                                     ; EXIT
   CASE "Page4"     ; oPrv:setAllPagesViewMode()                                                                        ; EXIT
   CASE "ZoomIn"    ; oPrv:zoomIn()                                                                                     ; EXIT
   CASE "ZoomOut"   ; oPrv:zoomOut()                                                                                    ; EXIT
   CASE "FitWidth"  ; oPrv:fitToWidth()                                                                                 ; EXIT
   CASE "FitBest"   ; oPrv:fitInView()                                                                                  ; EXIT
   CASE "Landscape" ; oPrv:setLandscapeOrientation()                                                                    ; EXIT
   CASE "Portrait"  ; oPrv:setPortraitOrientation()                                                                     ; EXIT
   CASE "Left1"     ; oPrv:setCurrentPage( 1 )                                                                          ; EXIT
   CASE "Left"      ; xTmp := oPrv:currentPage() ; iif( xTmp > 1, oPrv:setCurrentPage( xTmp-1 ), NIL )                  ; EXIT
   CASE "Right"     ; xTmp := oPrv:currentPage() ; iif( xTmp < oPrv:pageCount(), oPrv:setCurrentPage( xTmp+1 ), NIL )   ; EXIT
   CASE "Right1"    ; oPrv:setCurrentPage( oPrv:pageCount() )                                                           ; EXIT
   CASE "Save"      ; ::exec( ::saveBlock() )                                                                           ; EXIT
   CASE "PageSetup" ;                                                                                                   ; EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtPrintPreview:previewBlock( bBlock )
   LOCAL bPrevBlock := ::bPreviewBlock
   IF HB_ISBLOCK( bBlock )
      ::bPreviewBlock := bBlock
   ENDIF
   RETURN bPrevBlock


METHOD HbQtPrintPreview:exitBlock( bBlock )
   LOCAL bPrevBlock := ::bExitBlock
   IF HB_ISBLOCK( bBlock )
      ::bExitBlock := bBlock
   ENDIF
   RETURN bPrevBlock


METHOD HbQtPrintPreview:saveBlock( bBlock )
   LOCAL bPrevBlock := ::bSaveBlock
   IF HB_ISBLOCK( bBlock )
      ::bSaveBlock := bBlock
   ENDIF
   RETURN bPrevBlock


METHOD HbQtPrintPreview:exec( bBlock, ... )
   IF HB_ISBLOCK( bBlock )
      Eval( bBlock, ... )
   ENDIF
   RETURN Self

#if 0
HB_FUNC_STATIC( SETSIZES )
{
   QSplitter * p = ( QSplitter * ) hbqt_par_ptr( 0 );
   if( p )
   {
      QList<void *> *qL = hbqt_par_QList( 1 );
      QList<int> qList;
      int i;
      for( i = 0; i < qL->size(); i++ )
      {
         qList.append( ( int ) qL->at( i ) );
      }
      p->setSizes( qList );
   }
}
#endif