/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2013 Pritpal Bedi <bedipritpal@hotmail.com>
 * http://harbour-project.org
 *
 */

#include "hbqtgui.ch"
#include "hbtoqt.ch"
#include "hbqtstd.ch"


#define OBJ_OWNER                                 1
#define OBJ_TYPE                                  2
#define OBJ_DURATION                              3
#define OBJ_DATABLOCK                             4
#define OBJ_ATTRIBUTES                            5

#define COMPILE( cExp )                           &( "{|| " + cExp + "}" )


FUNCTION Main()
   LOCAL oWnd, oDB

   hbqt_ErrorSys()

   oWnd := QMainWindow()

   WITH OBJECT oDB := HbQtDashBoard():new( oWnd ):create()
      :objectsBlock := {|...| manageObjects( ... ) }
   ENDWITH

   WITH OBJECT oWnd
      :setWindowTitle( "HbQt Dashboard - An Embeddable Component" )
      :setWindowIcon( QIcon( __hbqtImage( "harbour" ) ) )
      :setCentralWidget( oDB:widget() )
      :show()
      :connect( QEvent_Close, {|| saveState( oWnd, oDB ) } )
   ENDWITH
   PopulateDashboardTree( oDB )
   RestState( oWnd, oDB )

   QApplication():exec()

   RETURN NIL


STATIC FUNCTION manageObjects( ... )
   LOCAL cTitle, cType, nDuration, bBlock, aConfg, cExp, cAttrbs, oWgt, aObjects, aAttrbs, v_
   LOCAL aParams := hb_AParams()

   SWITCH aParams[ 1 ]

   CASE "New"
      cType     := aParams[ 2 ]

      SWITCH cType
      CASE "Figure"
         cTitle    := Pad( "Digital Clock", 50 )
         nDuration := 1
         cExp      := Pad( "time()", 240 )
         cAttrbs   := Pad( "{'W+/BG'}", 500 )
         EXIT
      CASE "Banner"
         cTitle    := Pad( "HbQt Info", 50 )
         nDuration := 10
         cExp      := Pad( "'HbQt is committed to provide solutions !'", 240 )
         cAttrbs   := Pad( "{'W+/B'}", 500 )
         EXIT
      CASE "Graph"
         cTitle    := Pad( "Month Wise Sales", 50 )
         nDuration := 10
         cExp      := Pad( "{{'Bananas', 2045, 'GR+'}, {'Apples', 1045, 'B+'}, {'Oranges', 3490, 'W+'}}", 240 )
         cAttrbs   := Pad( "{'Jun 2013 ,000'}", 500 )
         EXIT
      CASE "Browser"
         cTitle    := Pad( "Cummulative Sales ,000", 50 )
         nDuration := 10
         cExp      := Pad( "{{'Bananas', 2045, 'GR+'}, {'Apples', 1045, 'B+'}, {'Oranges', 3490, 'W+'}}", 240 )
         cAttrbs   := Pad( "{{1, 'item'}, {2, 'Figures'},{ 3, 'Marker'}}", 500 )
         EXIT
      CASE "Picture"
         cTitle    := Pad( "HbQt Icons", 50 )
         nDuration := 2
         cExp      := Pad( "ServeHbQtIcons()", 240 )
         cAttrbs   := Pad( "{}", 500 )
         EXIT
      ENDSWITCH

      v_:= hbQtBulkGet( { cTitle, nDuration, cExp, cAttrbs }, ;
                        { "Title", "Duration(Seconds)", "Expression", "Attributes(Array)" }, ;
                        { "@", "@Z 9999", "@S80", "@S80" }, ;
                        , ;
                        { {|| ! Empty( GetActive():varGet() ) } }, ;
                        "Define New <" + cType + "> Object" )
      IF ! Empty( v_ )
         cTitle    := Trim( v_[ 1 ] )
         nDuration := v_[ 2 ]
         cExp      := Trim( v_[ 3 ] )
         cAttrbs   := Trim( v_[ 4 ] )
         IF ! Empty( cTitle ) .AND. ! Empty( cExp )
            RETURN { cType, ;
                     cTitle, ;
                     nDuration, ;
                     COMPILE( cExp ), ;
                     iif( Empty( cAttrbs ), {}, Eval( COMPILE( cAttrbs ) ) ), ;
                     "User~" + cType + "~" + LTrim( Str( nDuration, 10, 0 ) ) + "~" + cExp + "~" + iif( Empty( cAttrbs ), "", cAttrbs ) + "~" }
         ENDIF
      ENDIF
      EXIT

   CASE "Create"
      aAttrbs   := hb_ATokens( aParams[ 3 ], "~" )
      //
      cType     := aAttrbs[ 2 ]
      nDuration := Val( aAttrbs[ OBJ_DURATION ] )
      bBlock    := COMPILE( aAttrbs[ OBJ_DATABLOCK ] )
      cAttrbs   := iif( Empty( aAttrbs[ OBJ_ATTRIBUTES ] ), "{}", aAttrbs[ OBJ_ATTRIBUTES ] )
      aConfg    := Eval( COMPILE( cAttrbs ) )

      cTitle    := aParams[ 2 ]

      RETURN { cType, cTitle, nDuration, bBlock, aConfg, aParams[ 3 ] }

   CASE "Configure"
      oWgt     := aParams[ 2 ]
      aObjects := aParams[ 3 ]

      SWITCH aObjects[ 1 ]
      CASE "Picture"
         // Reconfigure anything - oWgt represents QLabel() object.
      CASE "Banner"
      CASE "Figure"
      CASE "Browser"
      CASE "Graph"
      ENDSWITCH
      EXIT

   ENDSWITCH

   HB_SYMBOL_UNUSED( oWgt )

   RETURN NIL


FUNCTION ServehbQtIcons()
   LOCAL aDir
   LOCAL cPath := hb_DirBase() + ".." + hb_ps() + "resources" + hb_ps()

   STATIC aUrls := {}
   STATIC nIndex := 0

   IF Empty( aUrls )
      aDir := Directory( cPath + "*.png" )
      AEval( aDir, {|e_| AAdd( aUrls, cPath + e_[ 1 ] ) } )
   ENDIF
   nIndex++
   IF nIndex > Len( aUrls )
      nIndex := 1
   ENDIF
   IF nIndex <= Len( aUrls )
      RETURN aUrls[ nIndex ]
   ENDIF

   RETURN NIL


FUNCTION restState( oDlg, oDB )
   LOCAL oSettings, oRect, cPanels, hDBState := {=>}
   LOCAL cPath := hb_DirSepAdd( GetEnv( "APPDATA" ) ) + "hbqt" + hb_ps()

   oSettings := QSettings( cPath + "settings.dash", QSettings_IniFormat )
   oDlg:restoreState( oSettings:value( "vouSettings" ):toByteArray() )

   IF oSettings:contains( "vouPosAndSize" )
      oRect := oSettings:value( "vouPosAndSize" ):toRect()
      oDlg:move( oRect:x(), oRect:y() )
      oDlg:resize( oRect:width(), oRect:height() )
   ENDIF
   /* Dashboard Settings */
   IF oSettings:contains( "dashSplitter" )
      hDBState[ "dashSplitter" ] := oSettings:value( "dashSplitter" )
   ENDIF
   //
   oDB:restState( hDBState )

   IF ! Empty( cPanels := hb_MemoRead( cPath + "objects.dash" ) )
      oDB:restPanelsInfo( hb_Deserialize( cPanels ) )
   ENDIF

   RETURN oSettings


FUNCTION saveState( oDlg, oDB )
   LOCAL oSettings, hDB, oVariant, cPanels
   LOCAL cPath := hb_DirSepAdd( GetEnv( "APPDATA" ) ) + "hbqt" + hb_ps()

   WITH OBJECT oSettings := QSettings( cPath + "settings.dash", QSettings_IniFormat )
      :setValue( "vouSettings"  , QVariant( oDlg:saveState() ) )
      :setValue( "vouPosAndSize", QVariant( QRect( oDlg:x(), oDlg:y(), oDlg:width(), oDlg:height() ) ) )
      IF ! Empty( hDB := oDB:saveState() )
         FOR EACH oVariant IN hDB
            :setValue( oVariant:__enumKey(), oVariant )
         NEXT
      ENDIF
      cPanels := hb_Serialize( oDB:savePanelsInfo() )

      hb_MemoWrit( cPath + "objects.dash", cPanels )
   ENDWITH

   RETURN oSettings


FUNCTION populateDashboardTree( oDB )

   WITH OBJECT oDB
      :populateTree( "Vouch", "Vouch" , "Figures"  , "", "Figures"       , __hbqtImage( "numbers" ) )
      :populateTree( "Vouch", "Vouch" , "Graphs"   , "", "Chart & Graphs", __hbqtImage( "f_chart" ) )
      :populateTree( "Vouch", "Vouch" , "Browsers" , "", "Browsers"      , __hbqtImage( "table"   ) )
      :populateTree( "Vouch", "Vouch" , "Banners"  , "", "Banners"       , __hbqtImage( "banner"  ) )
      :populateTree( "Vouch", "Vouch" , "Pictures" , "", "Pictures"      , __hbqtImage( "images"  ) )

      :populateTree( "Vouch", "Graphs", "Sales"    , "", "Sales"         , __hbqtImage( "f_chart" ) )
      :populateTree( "Vouch", "Graphs", "Purchases", "", "Purchases"     , __hbqtImage( "f_chart" ) )
      :populateTree( "Vouch", "Graphs", "Stocks"   , "", "Stocks"        , __hbqtImage( "f_chart" ) )

      :populateTree( "Vouch", "Banners"  , "Vouch Info"                    , "Vouch~Banner~300~VouFetchBanner('info')~{{{255,255,255},{0,0,255}}}~"                            , "Latest Offerings in Vouch (NOTE~ Internet Access Required!)", NIL )

      :populateTree( "Vouch", "Figures"  , "Balance: Cash Accounts"        , "Vouch~Figure~05~VouSumDat('V_LEDGER','ACSH1',11,{9})[1]~{{{255,0,0},{0,0,255}}}~"                , "Balance of All Cash Accounts"            , NIL )
      :populateTree( "Vouch", "Figures"  , "Balance: Bank Accounts"        , "Vouch~Figure~05~VouSumDat('V_LEDGER','PBCA0',11,{9})[1]~{{{255,0,0},{0,255,0}}}~"                , "Balance of All Cash Accounts"            , NIL )
      :populateTree( "Vouch", "Figures"  , "Sales Amount"                  , "Vouch~Figure~60~VouSumDat('INVSALOD',NIL,2,{28})[1]~~"                                           , "Running Sales Figure"                    , NIL )

      :populateTree( "Vouch", "Sales"    , "Sales: Monthly"                , "Vouch~Graph~300~VouSumMonthWise('INVSALOD',01,28,1000)~{'Monthly Sales ,000','typeBar,showToolbar,showShadows,showTitle,noLegends,showLabels,showValues,noYValues'}~", "Monthly Sales of Current Year"           , NIL )
      :populateTree( "Vouch", "Sales"    , "Sales: Top 10 Customers"       , "Vouch~Graph~300~VouSumOrderWise('INVSALOD',05,28,1000,10)~{'Top 10 Customers by Sales ,000'}~" , "Top 10 Customers of Current Year Sales"  , NIL )
      :populateTree( "Vouch", "Sales"    , "Sales: Top 10 Cities"          , "Vouch~Graph~300~VouSumOrderWise('INVSALOD',20,28,1000,10)~{'Top 10 Cities by Sales ,000'}~"    , "Top 10 Cities of Current Year Sales"     , NIL )

      :populateTree( "Vouch", "Purchases", "Purchases: Monthly"            , "Vouch~Graph~300~VouSumMonthWise('INVPURCH',1,28,1000)~{'Monthly Purchases ,000'}~"             , "Monthly Purchases Current Year"          , NIL )
      :populateTree( "Vouch", "Purchases", "Purchases: Top 10 Vendors"     , "Vouch~Graph~300~VouSumOrderWise('INVPURCH',5,28,1000,10)~{'Top 10 Vendors by Purchases ,000'}~", "Top 10 Vendors of Current Year Purchases", NIL )
      :populateTree( "Vouch", "Purchases", "Purchases: Top 10 Cities"      , "Vouch~Graph~300~VouSumOrderWise('INVPURCH',20,28,1000,10)~{'Top 10 Cities by Purchases ,000'}~", "Top 10 Cities of Current Year Purchases" , NIL )

      :populateTree( "Vouch", "Stocks"   , "Stock: Top 10 Items at Hand"   , "Vouch~Graph~060~VouSumOrderWise('C_STOCK',01,28,100,10,1)~{'Top 10 Items at Hand ,00'}~"        , "Top 10 Items at Hand"                    , NIL )
      :populateTree( "Vouch", "Stocks"   , "Stock: Bottom 10 Items at Hand", "Vouch~Graph~060~VouSumOrderWise('C_STOCK',01,28,100,10,2)~{'Bottom 10 Items at Hand ,00'}~"     , "Bottom 10 Items at Hand"                 , NIL )

   ENDWITH

   RETURN NIL


FUNCTION VouFetchBanner( cToken )

   SWITCH cToken
   CASE "info"  ; RETURN "Vouch, the software that GROWS with you"
   CASE "other" ; RETURN "Nothing"
   ENDSWITCH

   RETURN ""


FUNCTION VouSumDat( cTable, cAccount )

   SWITCH cTable
   CASE "V_LEDGER" ; RETURN { iif( cAccount == "ACSH1", 5000, 55000 ) + Seconds() % 88 }
   CASE "INVSALOD" ; RETURN { 10000000 - Seconds() % 45 }
   ENDSWITCH

   RETURN { 0 }


FUNCTION VouSumMonthWise( cTable, nOrd )
   LOCAL dat_:={}

   HB_SYMBOL_UNUSED( cTable )
   HB_SYMBOL_UNUSED( nOrd )

   AAdd( dat_, { "Jan", 2000, {  64, 123, 244 } } )
   AAdd( dat_, { "Feb", 7000, {  64, 254,  84 } } )
   AAdd( dat_, { "Mar", 9000, { 255, 123, 112 } } )

   RETURN dat_


FUNCTION VouSumOrderhWise( cTable, nOrd )
   LOCAL dat_:={}

   HB_SYMBOL_UNUSED( cTable )
   HB_SYMBOL_UNUSED( nOrd )

   AAdd( dat_, { "Jan", 2000, {  64, 123, 244 } } )
   AAdd( dat_, { "Feb", 7000, {  64, 254,  84 } } )
   AAdd( dat_, { "Mar", 9000, { 255, 123, 112 } } )

   RETURN dat_

