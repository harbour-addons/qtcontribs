/*
 * $Id$
 */

/*
 * Copyright 2014 Pritpal Bedi <bedipritpal@hotmail.com>
 * www - http://harbour-project.org
 */

#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "inkey.ch"
#include "hbtrace.ch"
#include "hbclass.ch"
#include "common.ch"


STATIC s_oDialog, s_oAct


PROCEDURE Main()
   LOCAL oDA, oWnd, oELoop
   LOCAL lExit := .F.

   hbqt_errorsys()

   WITH OBJECT oWnd := QMainWindow()
      :setAttribute( Qt_WA_DeleteOnClose, .F. )
      :setMouseTracking( .T. )
      :SetFixedSize( 640, 435 )
      //
      :connect( QEvent_KeyPress, {|e| My_Events( e, @lExit ) } )
      :connect( QEvent_Close, {|| lExit := .T. } )
      //
      :show()
   ENDWITH 
   IF .T.
      oDA := QWidget( oWnd )
      oWnd:setCentralWidget( oDA )
      //
      Build_MenuBar( oWnd, @lExit )
   ENDIF
   WITH OBJECT oWnd
      :Show()
   ENDWITH 
   IF .T.
      USE testwgt.dbf NEW
   ENDIF
   IF .T.
      s_oDialog := CompositeDialog():new( oWnd ):create()
   ENDIF
   //
   oELoop := QEventLoop( oWnd )
   DO WHILE .t.
      oELoop:processEvents()
      IF lExit
         EXIT
      ENDIF
      oWnd:setWindowTitle( "Number of Qt Objects: " + hb_ntos( __hbqt_itemsInGlobalList() ) )
   ENDDO
   oELoop:exit( 0 )
   //
   IF .T.
      dbCloseAll()
   ENDIF
   RETURN


FUNCTION My_Events( e, lExit )
   IF e:key() == Qt_Key_Escape
      lExit := .T.
   ENDIF
   RETURN NIL


STATIC FUNCTION Build_MenuBar( oWnd )
   LOCAL oMenuBar, oMenu
   IF .T.
      oMenuBar := oWnd:menuBar()
      oMenu := QMenu( oMenuBar )
      oMenu:setTitle( "Customer Info" )
   ENDIF
   WITH OBJECT s_oAct := oMenu:addAction( "Customer Info" )
      :connect( "triggered(bool)", { || s_oDialog:show() } )
   ENDWITH 
   IF .T.
      oMenuBar:addMenu( oMenu )
   ENDIF
   RETURN NIL 

//-------------------------------------------------------------------//
//                     Class CompositeDialog
//-------------------------------------------------------------------//   

CLASS CompositeDialog  
   DATA   oDlg 
   DATA   oParent 
   DATA   oBrowse
   DATA   kEsc
   DATA   kIns
   DATA   cCust                                   INIT Space( 8 )
   DATA   cCustName                               INIT Space( 30 )
   DATA   cAddress1                               INIT Space( 39 )
   DATA   cAddress2                               INIT Space( 39 )
   DATA   cAddress3                               INIT Space( 39 )
   DATA   getList                                 INIT {}
   DATA   sayList                                 INIT {}
   
   METHOD init( oParent )
   METHOD create( oParent )
   METHOD show()
   METHOD hide()

   ENDCLASS 
   
   
METHOD CompositeDialog:init( oParent )
   IF .T.
      ::oParent := oParent 
   ENDIF
   RETURN Self 
   
   
METHOD CompositeDialog:create( oParent )
   IF .T.
      DEFAULT oParent TO ::oParent 
      ::oParent := oParent 
   ENDIF
   WITH OBJECT ::oDlg := hbqtui_composite()
      :setWindowTitle( "Number of Qt Objects: " + hb_ntos( __hbqt_itemsInGlobalList() ) )
      :setWindowModality( Qt_ApplicationModal )
      :lower()
      :hide()
      
      :connect( QEvent_Close, {|| ::hide() } )
      :connect( QEvent_KeyPress, {|e| iif( e:key() == Qt_Key_Escape, ::hide(), NIL ) } )
      
      :labelTitle:setStyleSheet( "background-color: qlineargradient(spread:pad, x1:0, y1:0.574, x2:1, y2:0, stop:0 rgba(37, 58, 122, 255), stop:1 rgba(255, 255, 255, 255));" )
      :labelStatus:setStyleSheet( "background-color: rgb(215, 253, 255);" )
      
      :listItems:addItem( "First" )
      :listItems:addItem( "Second" )
      :listItems:addItem( "Third" )
      :listItems:addItem( "Fourth" )
      :listItems:addItem( "Fifth" )
      
      :btnOpt1:connect( "clicked()", {|| ::oDlg:labelStatus:setText( "Option 1 Clicked" ) } )
      :btnOpt2:connect( "clicked()", {|| ::oDlg:labelStatus:setText( "Option 2 Clicked" ) } )
      :btnOpt3:connect( "clicked()", {|| ::oDlg:labelStatus:setText( "Option 3 Clicked" ) } )
      :btnOpt4:connect( "clicked()", {|| ::oDlg:labelStatus:setText( "Option 4 Clicked" ) } )
   ENDWITH
   IF .T.
      ::kEsc := SetKey( K_ESC, {|| ::oDlg:hide() } )
      ::kIns := SetKey( K_INS, {|| ReadInsert( ! ReadInsert() ) } )
      ReadInsert( .T. )
   ENDIF    
   IF .T.
      ::oBrowse := BuildBrowse( ::oDlg )
   ENDIF
   RETURN Self 
   

METHOD CompositeDialog:show()   
   LOCAL GetList := {}
   LOCAL SayList := {}
   
   WITH OBJECT ::oDlg  
      :raise()
      :show()
      
      IF .T.   
         @ 0,0 QGET ::cCust     PICTURE "@! " CONTROL :lineCust()
         @ 0,0 QGET ::cCustName PICTURE "@! " CONTROL :lineCustName()
         @ 0,0 QGET ::cAddress1               CONTROL :lineAddress1()
         @ 0,0 QGET ::cAddress2               CONTROL :lineAddress2()
         @ 0,0 QGET ::cAddress3               CONTROL :lineAddress3()
         //
         READ ::oDlg:groupGets() NOFOCUSFRAME NORESIZE ;
            LASTGETBLOCK {|| ::oDlg:labelStatus():setText( "Last Get, What to Do ?" ) }
      ENDIF
   ENDWITH
   RETURN NIL 
   
   
METHOD CompositeDialog:hide()
   WITH OBJECT ::oDlg
      :lower()
      :hide()
   ENDWITH
   RETURN NIL 
   
   
STATIC FUNCTION BuildBrowse( oDlg )
   LOCAL oBrowse, i
   LOCAL aFields := { "LAST", "FIRST", "SALARY", "HIREDATE", "AGE", "CITY", "STATE", "ZIP", "NOTES" }
   LOCAL aTitles := { "Last Name", "First Name", "Salary", "Hire Date", "Age", "City", "State", "Zip", "Notes" }


   oBrowse := HbQtBrowseNew( 0, 0, 0, 0, oDlg:frameBrowse(), QFont( "Courier new", 10 ) )

   oBrowse:goTopBlock          := {| | DbGoTop()        }
   oBrowse:goBottomBlock       := {| | DbGoBottom()     }

   oBrowse:firstPosBlock       := {| | 1                }
   oBrowse:lastPosBlock        := {| | LastRec()        }
   IF indexOrd() = 0
      oBrowse:posBlock         := {| | RecNo()          }
      oBrowse:goPosBlock       := {|n| DbGoto( n )      }
      oBrowse:phyPosBlock      := {| | RecNo()          }
   ELSE
      oBrowse:posBlock         := {| | OrdKeyNo()       }
      oBrowse:goPosBlock       := {|n| OrdKeyGoto( n )  }
      oBrowse:phyPosBlock      := {| | OrdKeyNo()       }
   ENDIF

   FOR i := 1 to len( aFields )
      oBrowse:addColumn( HbQtColumnNew( aTitles[ i ], FieldWBlock( aFields[ i ], select() ) ) )
   NEXT

   oBrowse:horizontalScrollbar := .T.
   oBrowse:verticalScrollbar   := .T.
   oBrowse:toolbar             := .t.
   oBrowse:toolbarLeft         := .T.
   oBrowse:statusbar           := .F.
   oBrowse:skipBlock           := {|n| Skipper( n ) }
   oBrowse:navigationBlock     := {|nKey,xData,oBrw|  HandleMe( nKey, xData, oBrw, oDlg ) }

   RETURN oBrowse


STATIC FUNCTION HandleMe( nKey, xData, oBrw, oDlg )
   HB_SYMBOL_UNUSED( xData + oBrw )
   IF nKey == K_ESC
      oDlg:close()
      RETURN .T.
   ENDIF
   RETURN .F.


STATIC FUNCTION Skipper( nSkip )
   LOCAL i := 0

   DO CASE
   CASE ( nSkip = 0 .OR. LastRec() == 0 )
      dbSkip( 0 )
   CASE ( nSkip > 0 .AND. !eof() )
      DO WHILE ( i < nSkip )
         dbSkip( 1 )
         IF EOF()
            dbskip( -1 )
            EXIT
         ENDIF
         i++
      ENDDO
   CASE ( nSkip < 0 )
      DO WHILE ( i > nSkip )
         dbSkip( -1 )
         IF Bof()
            EXIT
         ENDIF
         i--
      ENDDO
   ENDCASE

   RETURN i

