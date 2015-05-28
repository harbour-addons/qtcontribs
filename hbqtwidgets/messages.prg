   /*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2010-2014 Pritpal Bedi <bedipritpal@hotmail.com>
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
/*----------------------------------------------------------------------*/
/*
 *                                EkOnkar
 *                          ( The LORD is ONE )
 *
 *                          Harbour-Qt Widgets
 *
 *                 Pritpal Bedi <bedipritpal@hotmail.com>
 *                              17Apr2015
 */
/*----------------------------------------------------------------------*/

#include "hbtoqt.ch"
#include "hbqtstd.ch"
#include "hbqtgui.ch"
#include "inkey.ch"
#include "error.ch"
#include "hbclass.ch"
#include "hbtrace.ch"
#include "common.ch"


#define VV_DATE( xDate )                          iif( HB_ISSTRING( xDate ), DToC( SToD( xDate ) ), DToC( xDate ) )


#define STACK_MAIN_PAGE_CHATTING                  0
#define STACK_MAIN_PAGE_TOPICS                    1
#define STACK_MAIN_PAGE_REPLY                     2


CLASS HbQtChat

   DATA   oUI
   DATA   oWidget
   DATA   oParent

   DATA   oToolbar
   DATA   nLastTopic                              INIT   0
   DATA   nLastMessage                            INIT   0
   DATA   hUser
   DATA   hUsers
   DATA   hTopics                                 INIT   __hbqtStandardHash()
   DATA   aColors                                 INIT   { "red","green","orange","coral","blue","lightseagreen","navy","chocolate","crimson",  ;
                                                           "darkmagenta","blueviolet","darkblue","orangered","seagreen" }
   DATA   nNextUser                               INIT   0
   DATA   hUserColors                             INIT   __hbqtStandardHash()
   DATA   oTimer
   DATA   hTopicIds                               INIT   __hbqtStandardHash()
   DATA   hMessageIds                             INIT   {=>}
   DATA   cMode                                   INIT   ""
   DATA   oCurrentThreadedMessage
   DATA   oCurrentChatWidget
   DATA   cContext

   DATA   cCurrentTopic                           INIT   ""
   DATA   cCurrentMessage                         INIT   ""
   ACCESS currentTopic()                          INLINE ::cCurrentTopic
   ACCESS currentMessage()                        INLINE ::cCurrentMessage

   METHOD init( oParent )
   METHOD create( oParent )
   METHOD show()
   METHOD hide()

   DATA   bInfoBlock
   METHOD infoBlock( bBlock )                     SETGET
   METHOD execInfoBlock( cWhat, xData )

   METHOD buildToolbar( oLayout )
   METHOD manageToolbarClicks( cAction )
   METHOD initiateTopicOrReply( cMode )
   METHOD threadedMessageClicked( nMode, oItem, nCol )
   METHOD chronoMessageClicked( nMode, oItem, nCol )
   METHOD pullUser()
   METHOD pullUsers()
   METHOD pullTopicUsers()
   METHOD collapseTopics()
   METHOD buildMessageFrame( hMessage )
   METHOD pushMessage( cMessage, cTopicId, cParentMsgId )
   METHOD pushTopic()
   METHOD populateTopic( hTopic )
   METHOD populateMessage( hMessage )
   METHOD getColorInfo( cUser )
   METHOD pullMessages()
   METHOD pullLatestMessages()
   METHOD cronologicalView()
   METHOD threadedView()
   METHOD populateChronological( hMessage )
   METHOD focusThreadedMessage( oItem, nCol )
   METHOD hilightThreadedMessage( oItem )
   METHOD manageReply( nMode )
   METHOD pullMoreMessages()
   METHOD syncMessage( hMessage )
   METHOD manageEventClose( oEvent )

   ENDCLASS


METHOD HbQtChat:init( oParent )
   ::oParent := oParent
   RETURN Self


METHOD HbQtChat:create( oParent )
   LOCAL oLayout

   DEFAULT oParent TO ::oParent

   ::oParent := oParent

   ::oUI := hbqtui_messages( oParent )
   ::oWidget := ::oUI:widget()

   IF HB_ISOBJECT( oParent )
      IF Empty( oLayout := oParent:layout() )
         oLayout := QHBoxLayout()
         ::oParent:setLayout( oLayout )
         oLayout:addWidget( ::oWidget )
      ELSE
         SWITCH __objGetClsName( oLayout )
         CASE "QVBOXLAYOUT"
         CASE "QHBOXLAYOUT"
            oLayout:addWidget( ::oWidget )
            EXIT
         CASE "QGRIDLAYOUT"
            oLayout:addWidget( ::oWidget, 0, 0, 1, 1 )
            EXIT
         ENDSWITCH
      ENDIF
   ENDIF

   ::buildToolbar( ::oUI:hLayoutChatTools )

   ::oUI:btnReplyOk    :connect( "clicked()", {|| ::manageReply( 1 ) } )
   ::oUI:btnReplyCancel:connect( "clicked()", {|| ::manageReply( 2 ) } )

   ::oUI:btnTopicOk    :connect( "clicked()", {|| ::initiateTopicOrReply( "Create" ) } )
   ::oUI:btnTopicCancel:connect( "clicked()", {|| ::oUI:stackBase:setCurrentWidget( ::oUI:pageChatting ) } )
   WITH OBJECT ::oUI:treeChatMessages
      :connect( "currentItemChanged(QTreeWidgetItem*,QTreeWidgetItem*)", {|| ::oUI:treeChatMessages:clearSelection() } )
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)", {|oCur,nCol| ::threadedMessageClicked( 2, oCur, nCol ) } )
      :setContentsMargins( 5,5,5,5 )
      :setIconSize( QSize( __hbqtPixelsByDPI( 32 ), __hbqtPixelsByDPI( 32 ) ) )
   ENDWITH
   __hbqtApplyStandardScroller( ::oUI:treeChatMessages )

   WITH OBJECT ::oUI:treeMessagesChrono
      :connect( "itemDoubleClicked(QTreeWidgetItem*,int)", {|oItem,nCol| ::chronoMessageClicked( 2, oItem, nCol ) } )
   ENDWITH
   __hbqtApplyStandardScroller( ::oUI:treeMessagesChrono )

   __hbqtApplyStandardScroller( ::oUI:treeTopicGroup )
   __hbqtApplyStandardScroller( ::oUI:plainMessageToReply )
   __hbqtApplyStandardScroller( ::oUI:plainReplyText )

   WITH OBJECT ::oUI:treeTopicGroup
      :setStyleSheet( ;
          "QTreeView::item:text {margin-left: 2px;}" + ;
          "QTreeView::indicator {width: " + __hbqtCssPX( 32 ) + "}" + ;
          "QTreeView::indicator {height: " + __hbqtCssPX( 32 ) + "}" + ;
          "QTreeView::indicator:unchecked {image: url(" + __hbqtImage( "checkbox-unchecked-g" ) + ");}" + ;
          "QTreeView::indicator:checked {image: url(" + __hbqtImage( "checkbox-checked-g" ) + ");}" )
   ENDWITH

   WITH OBJECT ::oUI:stackChat
      :connect( "currentChanged(int)", {|nIndex| ::oCurrentChatWidget := ::oUI:stackChat:widget( nIndex ) } )
   ENDWITH

   WITH OBJECT ::oUI:btnChatMore
      :connect( "clicked()", {|| ::pullMoreMessages() } )
   ENDWITH

   WITH OBJECT ::oTimer := QTimer()
      :setInterval( 3000 )
      :connect( "timeout()", {|| ::pullLatestMessages() } )
   ENDWITH
   __hbqtManageEditEvents( ::oUI:editTopicText )
   __hbqtManageEditEvents( ::oUI:plainReplyBody )
   __hbqtManageEditEvents( ::oUI:plainReplyText )

   __hbqtRegisterForEventClose( {|oEvent| ::manageEventClose( oEvent ) } )
   RETURN Self


METHOD HbQtChat:hide()
   ::oTimer:stop()
   ::execInfoBlock( "HideMessagesRequested" )
   RETURN Self


METHOD HbQtChat:show()
   IF .T.
      ::oToolbar:swapImage( "Back", ::execInfoBlock( "IconForBackButton" ) )

      ::oUI:treeChatMessages:clear()
      ::oUI:treeMessagesChrono:clear()

      ::cContext := ::execInfoBlock( "MessagesContext" )

      ::hMessageIds := {=>}
      hb_HCaseMatch( ::hMessageIds, .F. )
      hb_HKeepOrder( ::hMessageIds, .F. )

      ::hTopicIds    := __hbqtStandardHash()
      ::nLastTopic   := 0
      ::nLastMessage := 0

      ::pullUser()
      ::pullMessages()

      ::oTimer:start()
   // ::oUI:stackChat:setCurrentWidget( ::oUI:pageChatTopics )
      ::oUI:stackChat:setCurrentWidget( ::oUI:pageChatAll )
      ::oUI:stackBase:setCurrentWidget( ::oUI:pageChatting )
      ::execInfoBlock( "ShowMessagesRequested" )
   ENDIF
   RETURN Self


METHOD HbQtChat:infoBlock( bBlock )
   LOCAL bOldBlock := ::bInfoBlock
   IF HB_ISBLOCK( bBlock )
      ::bInfoBlock := bBlock
   ENDIF
   RETURN bOldBlock


METHOD HbQtChat:execInfoBlock( cWhat, xData )
   LOCAL hRspns

   IF HB_ISBLOCK( ::infoBlock() )
      hRspns := Eval( ::infoBlock(), cWhat, xData )
   ENDIF
   RETURN hRspns


METHOD HbQtChat:manageEventClose( oEvent )
   LOCAL lHandeled := .T.

   IF ! ::oWidget:isVisible()
      RETURN .F.
   ENDIF
   SWITCH ::oUI:stackBase:currentIndex()
   CASE STACK_MAIN_PAGE_CHATTING
      ::hide()
      EXIT
   CASE STACK_MAIN_PAGE_TOPICS
      ::oTimer:start()
      ::oUI:stackBase:setCurrentIndex( STACK_MAIN_PAGE_CHATTING )
      EXIT
   CASE STACK_MAIN_PAGE_REPLY
      ::oTimer:start()
      ::oUI:stackBase:setCurrentIndex( STACK_MAIN_PAGE_CHATTING )
      EXIT
   OTHERWISE
      lHandeled := .F.
   ENDSWITCH
   IF lHandeled
      oEvent:ignore()
   ENDIF
   RETURN lHandeled


METHOD HbQtChat:pullLatestMessages()
   LOCAL hMessages, hMessage

   IF ! Empty( hMessages := ::execInfoBlock( "PullNewMessages", { ::cContext, ::nLastMessage } ) )
      FOR EACH hMessage IN hMessages
         ::syncMessage( hMessage )
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtChat:pullMoreMessages()
   LOCAL hMessages, hMessage
   LOCAL cLowestMsgId := hb_HKeyAt( ::hMessageIds, 1 )

   hMessages := ::execInfoBlock( "PullMoreMessages", { cLowestMsgId, ::cContext, 50 } )
   IF ! Empty( hMessages )
      FOR EACH hMessage IN hMessages DESCEND
         ::syncMessage( hMessage )
      NEXT
   ELSE
      Alert( "No more messages..." )
   ENDIF
   RETURN Self


METHOD HbQtChat:pullMessages()
   LOCAL hMessages, hMessage

   hMessages := ::execInfoBlock( "PullMessages", { ::cContext, 50 } )
   IF ! Empty( hMessages )
      FOR EACH hMessage IN hMessages DESCEND
         ::syncMessage( hMessage )
      NEXT
   ENDIF
   RETURN Self


METHOD HbQtChat:syncMessage( hMessage )
   LOCAL hTopic
   LOCAL lPost := .F.

   IF ! hb_HHasKey( ::hTopicIds, hMessage[ "topicid" ] )
      IF ! Empty( hTopic := ::execInfoBlock( "PullTopic", hMessage[ "topicid" ] ) )
         lPost := .T.
      ENDIF
   ELSE
      lPost := .T.
   ENDIF
   IF lPost
      IF HB_ISHASH( hTopic )
         ::populateTopic( hTopic )
      ENDIF
      ::populateMessage( hMessage )
      ::populateChronological( hMessage )
   ENDIF
   RETURN Self


METHOD HbQtChat:focusThreadedMessage( oItem, nCol )
   LOCAL i, j, oTopicItem, oMessageItem
   LOCAL oTree := ::oUI:treeChatMessages
   LOCAL cTopicId := oItem:whatsThis( nCol )
   LOCAL cMessageId := oItem:toolTip( nCol )

   FOR i := 0 TO oTree:topLevelItemCount() - 1
      oTree:collapseItem( oTree:topLevelItem( i ) )
   NEXT

   FOR i := 0 TO oTree:topLevelItemCount() - 1
      IF oTree:topLevelItem( i ):whatsThis( 0 ) == cTopicId
         oTopicItem := oTree:topLevelItem( i )
         FOR j := 0 TO oTopicItem:childCount() - 1
            IF oTopicItem:child( j ):tooltip( 0 ) == cMessageId
               oMessageItem := oTopicItem:child( j )
               EXIT
            ENDIF
         NEXT
         EXIT
      ENDIF
   NEXT

   IF HB_ISOBJECT( oTopicItem )
      WITH OBJECT oTree
         :expandItem( oTopicItem )
         :setCurrentItem( oMessageItem )
      ENDWITH
      ::hilightThreadedMessage( oMessageItem )
   ENDIF
   ::oUI:stackChat:setCurrentWidget( ::oUI:pageChatTopics )
   RETURN Self


METHOD HbQtChat:hilightThreadedMessage( oItem )
   WITH OBJECT ::oUI:treeChatMessages
      :clearSelection()
   ENDWITH
   IF ! Empty( ::oCurrentThreadedMessage )
      ::oCurrentThreadedMessage:setBackground( 0, QBrush() )
   ENDIF
   oItem:setBackground( 0, __hbqtGradientBrush( QColor( Qt_yellow ), QColor( Qt_red ), 0 ) )
   ::oCurrentThreadedMessage := oItem
   WITH OBJECT ::oUI:treeChatMessages
      :clearSelection()
   ENDWITH
   RETURN Self


METHOD HbQtChat:populateChronological( hMessage )
   LOCAL oFrame, oItem, n, nItems
   LOCAL oTree := ::oUI:treeMessagesChrono

   IF .T.
      oFrame := ::buildMessageFrame( hMessage )
      WITH OBJECT oItem  := QTreeWidgetItem()
         :setSizeHint( 0, oFrame:sizeHint() )
         :setFlags( Qt_NoItemFlags )
         :setWhatsThis( 0, hMessage[ "topicid" ] )
         :setTooltip( 0, hMessage[ "serial" ] )
      ENDWITH
      IF ( nItems := oTree:topLevelItemCount() ) == 0
         oTree:insertTopLevelItem( 0, oItem )
      ELSE
         IF oTree:topLevelItem( nItems - 1 ):tooltip( 0 ) > hMessage[ "serial" ]
            oTree:addTopLevelItem( oItem )
         ELSE
            FOR n := 0 TO nItems - 1
               IF oTree:topLevelItem( n ):tooltip( 0 ) < hMessage[ "serial" ]
                  oTree:insertTopLevelItem( n, oItem )
               ENDIF
            NEXT
         ENDIF
      ENDIF
      WITH OBJECT oTree
         :setItemWidget( oItem, 0, oFrame )
      ENDWITH
   ENDIF
   RETURN Self


METHOD HbQtChat:populateMessage( hMessage )
   LOCAL oParent, i, oItem, nMessage, cMessage, oFont, nItems
   LOCAL nItemSize := 60
   LOCAL cTopicId := hMessage[ "topicid" ]

   IF .T.
      nMessage := Val( hMessage[ "serial" ] )
      IF ! hb_HHasKey( ::hMessageIds, hMessage[ "serial" ] )
         ::hMessageIds[ hMessage[ "serial" ] ] := hMessage
         ::nLastMessage := Max( nMessage, ::nLastMessage )

         FOR i := 0 TO ::oUI:treeChatMessages:topLevelItemCount() - 1
            IF ::oUI:treeChatMessages:topLevelItem( i ):whatsThis( 0 ) == cTopicId
               oParent := ::oUI:treeChatMessages:topLevelItem( i )
               EXIT
            ENDIF
         NEXT
         IF ! Empty( oParent )
            WITH OBJECT oFont := ::oUI:treeChatMessages:font()
               :setPixelSize( __hbqtPixelsByDPI( 18 ) )
            ENDWITH
            cMessage := "[#" + hMessage[ "serial" ] + " " +;
                         VV_DATE( hMessage[ "date" ] ) + " " + hMessage[ "time" ] + " " + hMessage[ "user" ] + "]" +;
                         Chr( 10 ) +;
                         hMessage[ "message" ]
            WITH OBJECT oItem  := QTreeWidgetItem()
               :setFlags( Qt_ItemIsEnabled + Qt_ItemIsSelectable )
               :setWhatsThis( 0, cTopicId )
               :setTooltip( 0, hMessage[ "serial" ] )
               :setText( 0, cMessage )
               :setFont( 0, oFont )
               :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
            ENDWITH
            IF ( nItems := oParent:childCount() ) == 0
               oParent:addChild( oItem )
            ELSE
               IF oParent:child( nItems - 1 ):tooltip( 0 ) > hMessage[ "serial" ]
                  oParent:addChild( oItem )
               ELSE
                  FOR i := 0 TO nItems - 1
                     IF oParent:child( i ):tooltip( 0 ) < hMessage[ "serial" ]
                        oParent:insertChild( i, oItem )
                     ENDIF
                  NEXT
               ENDIF
            ENDIF
            WITH OBJECT ::oUI:treeChatMessages
               :expandItem( oParent )
               :scrollToItem( oItem:parent() )
               :scrollToItem( oItem )
            ENDWITH
         ENDIF
         RETURN .T.
      ENDIF
   ENDIF
   RETURN .F.


METHOD HbQtChat:populateTopic( hTopic )
   LOCAL cTopic, oFont, oItem, nTopic, nItems, n
   LOCAL oTree := ::oUI:treeChatMessages
   LOCAL nItemSize := 60

   IF .T.
      nTopic := Val( hTopic[ "serial" ] )
      IF ! hb_HHasKey( ::hTopicIds, hTopic[ "serial" ] )
         ::hTopicIds[ hTopic[ "serial" ] ] := hTopic

         ::nLastTopic := Max( nTopic, ::nLastTopic )

         cTopic := "[#" + hTopic[ "serial" ] + " " + ;
                   VV_DATE( hTopic[ "date" ] ) + " " + ;
                   hTopic[ "time" ] + " " + ;
                   hTopic[ "user" ] + "]" + Chr( 10 ) + hTopic[ "topic" ]

         ::hTopics[ hTopic[ "serial" ] ] := hTopic

         WITH OBJECT oFont := oTree:font()
            :setPixelSize( __hbqtPixelsByDPI( 18 ) )
            :setBold( .T. )
         ENDWITH
         WITH OBJECT oItem  := QTreeWidgetItem()
            :setText( 0, cTopic )
            :setWhatsThis( 0, hTopic[ "serial" ] )
            :setIcon( 0, QIcon( __hbqtImage( "vz-topic" ) ) )
            :setFont( 0, oFont )
            :setBackground( 0, QBrush( QColor( 230,230,230 ) ) )
            :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
            :setExpanded( .T. )
            :setFlags( Qt_ItemIsEnabled )
         ENDWITH
         IF ( nItems := oTree:topLevelItemCount() ) == 0
            oTree:insertTopLevelItem( 0, oItem )
         ELSE
            IF oTree:topLevelItem( nItems - 1 ):whatsThis( 0 ) > hTopic[ "serial" ]
               oTree:addTopLevelItem( oItem )
            ELSE
               FOR n := 0 TO nItems - 1
                  IF oTree:topLevelItem( n ):whatsThis( 0 ) < hTopic[ "serial" ]
                     oTree:insertTopLevelItem( n, oItem )
                  ENDIF
               NEXT
            ENDIF
         ENDIF
         WITH OBJECT oTree
            :setCurrentItem( oItem )
            :expandItem( oItem )
            :scrollToItem( oItem )
         ENDWITH
         RETURN .T.
      ENDIF
   ENDIF
   RETURN oItem


METHOD HbQtChat:pushTopic()
   LOCAL hTopic, cTopic, cMessage

   IF Empty( cMessage := ::oUI:plainReplyBody:toPlainText() )
      Alert( "Please also fill topic body!" )
      RETURN Self
   ENDIF
   IF ! Empty( cTopic := ::oUI:editTopicText:text() )
      ::pullUser()
      hTopic := ::execInfoBlock( "PushTopic", { cTopic, ::cContext, ::pullTopicUsers() } )
      IF Empty( hTopic )
         Alert( "Topic could not been posted on the server, retry..." )
         RETURN Self
      ENDIF
      ::populateTopic( hTopic )
      ::pushMessage( cMessage, hTopic[ "serial" ], "" )
   ENDIF
   RETURN Self


METHOD HbQtChat:pushMessage( cMessage, cTopicId, cParentMsgId )
   LOCAL hMessage

   IF Empty( cMessage )
      RETURN Self
   ENDIF
   IF Empty( cTopicId )
      RETURN Self
   ENDIF
   IF Empty( ::hTopics )
      Alert( "Please add a topic first !" )
      RETURN Self
   ENDIF
   DEFAULT cParentMsgId TO ""
   hMessage := ::execInfoBlock( "PushMessage", { cTopicId, cParentMsgId, ::cContext, cMessage } )
   IF Empty( hMessage )
      Alert( "Message could not been posted on the server, retry..." )
      RETURN Self
   ENDIF
   ::syncMessage( hMessage )
   RETURN Self


METHOD HbQtChat:buildMessageFrame( hMessage )
   LOCAL cColor, cText, oFrame, oLay, oLabel, cAbout

   IF .T.
      cAbout := "[#" + hMessage[ "serial" ] + " " + VV_DATE( hMessage[ "date" ] ) + " " + hMessage[ "time" ] + " " + hMessage[ "user" ] + "]"
      cColor := ::getColorInfo( hMessage[ "user" ] )
      cText  := ""
      cText  += "<font size=4 color=blue>" + "   " + ::hTopicIds[ hMessage[ "topicid" ] ][ "topic" ] + "</font>"
      cText  += "<br><font size=2 color=gray>" + cAbout + "</font></br>"
      cText  += "<br><font size=3 color=" + cColor + ">" + "   " + hMessage[ "message" ] + "</font></br>"

      oFrame := QFrame()
      oLay   := QHBoxLayout( oFrame )
      oLay:setContentsMargins( 5,5,5,5 )

      WITH OBJECT oLabel := QLabel()
         :setWordWrap( .T. )
         :setText( cText )
      ENDWITH
      oLay:addWidget( oLabel )
   ENDIF
   RETURN oFrame


METHOD HbQtChat:initiateTopicOrReply( cMode )
   LOCAL cUser, oItem, oFont
   LOCAL nItemSize := 40
   LOCAL oTree := ::oUI:treeTopicGroup

   SWITCH Lower( cMode )
   CASE "originate"
      ::oUI:editTopicText:clear()
      ::oUI:plainReplyBody:clear()
      ::oUI:editTopicText:setFocus()

      ::pullUsers()                               // prepare for users tree
      oTree:clear()
      WITH OBJECT oFont := oTree:font()
         :setPixelSize( __hbqtPixelsByDPI( 18 ) )
      ENDWITH
      IF ! Empty( ::hUsers )
         FOR EACH cUser IN ::hUsers[ "users" ]    // an array of users who can view this visual
            WITH OBJECT oItem := QTreeWidgetItem()
               :setText( 0, Upper( cUser ) )
               :setSizeHint( 0, QSize( 0, __hbqtPixelsByDPI( nItemSize ) ) )
               :setFont( 0, oFont )
               :setFlags( Qt_ItemIsEnabled + Qt_ItemIsUserCheckable )
               :setCheckState( 0, Qt_Unchecked )
            ENDWITH
            oTree:addTopLevelItem( oItem )
         NEXT
      ENDIF
      ::oTimer:stop()
      ::oUI:stackBase:setCurrentWidget( ::oUI:pageTopicParams )
      EXIT
   CASE "create"
      IF ! Empty( ::oUI:editTopicText:text() )
         ::pushTopic()
      ENDIF
      ::oTimer:start()
      ::oUI:stackBase:setCurrentWidget( ::oUI:pageChatting )
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtChat:manageReply( nMode )
   LOCAL cMessage

   SWITCH nMode
   CASE 0
      ::oUI:labelReplyTopic:setText( ::hTopicIds[ ::cCurrentTopic ][ "topic" ] )
      ::oUI:plainMessageToReply:setPlainText( ::hMessageIds[ ::cCurrentMessage ][ "message" ] )
      ::oUI:plainReplyText:clear()
      ::oUI:plainReplyText:setFocus()
      ::oTimer:stop()
      ::oUI:stackBase:setCurrentWidget( ::oUI:pageReply )
      EXIT
   CASE 1                                         // ok
      IF ! Empty( cMessage := ::oUI:plainReplyText:toPlainText() )
         ::pushMessage( cMessage, ::cCurrentTopic, ::cCurrentMessage )
      ENDIF
      ::oTimer:start()
      ::oUI:stackBase:setCurrentWidget( ::oUI:pageChatting )
      EXIT
   CASE 2
      ::oTimer:start()                            // cancel
      ::oUI:stackBase:setCurrentWidget( ::oUI:pageChatting )
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtChat:chronoMessageClicked( nMode, oItem, nCol )
   SWITCH nMode
   CASE 1                                         // SingleClick
      ::focusThreadedMessage( oItem, nCol )
      EXIT
   CASE 2                                         // DoubleClick
      ::cCurrentTopic   := oItem:whatsThis( 0 )
      ::cCurrentMessage := oItem:toolTip( 0 )
      ::manageReply( 0 )
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtChat:threadedMessageClicked( nMode, oItem, nCol )
   HB_SYMBOL_UNUSED( nCol )
   SWITCH nMode
   CASE 1                                         // SingleClick
      IF ::oUI:treeChatMessages:indexOfTopLevelItem( oItem ) == -1
         ::hilightThreadedMessage( oItem )
         ::cCurrentTopic := oItem:parent():whatsThis( 0 )
         ::cCurrentMessage := oItem:whatsThis( 0 )
      ENDIF
      EXIT
   CASE 2                                         // DoubleClick
      IF ::oUI:treeChatMessages:indexOfTopLevelItem( oItem ) == -1
         ::hilightThreadedMessage( oItem )
         ::cCurrentTopic := oItem:parent():whatsThis( 0 )
         ::cCurrentMessage := oItem:toolTip( 0 )
         ::manageReply( 0 )
      ENDIF
      EXIT
   ENDSWITCH
   RETURN Self


METHOD HbQtChat:pullUser()
   IF ! HB_ISHASH( ::hUser )
      IF Empty( ::hUser )
         ::hUser := ::execInfoBlock( "UserInfo" )
      ENDIF
      IF Empty( ::hUser )
         ::hUser := __hbqtStandardHash()
      ENDIF
   ENDIF
   RETURN Self


METHOD HbQtChat:pullUsers()

   ::hUsers := ::execInfoBlock( "AuthorizedUsers" )
   IF Empty( ::hUsers )
      ::hUsers := __hbqtStandardHash()
   ENDIF
   RETURN Self


METHOD HbQtChat:getColorInfo( cUser )
   LOCAL cColor

   IF ::hUser[ "user" ] == cUser
      RETURN "black"
   ENDIF
   IF hb_HHasKey( ::hUserColors, cUser )
      RETURN ::hUserColors[ cUser ]
   ENDIF
   ::nNextUser++
   IF ::nNextUser > Len( ::aColors )
      ::nNextUser := 1
   ENDIF
   cColor := ::aColors[ ::nNextUser ]
   ::hUserColors[ cUser ] := cColor
   RETURN cColor


METHOD HbQtChat:collapseTopics()
   LOCAL i

   FOR i := 0 TO ::oUI:treeChatMessages:topLevelItemCount() - 1
      ::oUI:treeChatMessages:topLevelItem( i ):setExpanded( .F. )
   NEXT
   RETURN Self


METHOD HbQtChat:pullTopicUsers()
   LOCAL i
   LOCAL aUsers := {}

   FOR i := 0 TO ::oUI:treeTopicGroup:topLevelItemCount() - 1
      IF ::oUI:treeTopicGroup:topLevelItem( i ):checkState( 0 ) == Qt_Checked
         AAdd( aUsers, ::oUI:treeTopicGroup:topLevelItem( i ):text( 0 ) )
      ENDIF
   NEXT
   RETURN aUsers


METHOD HbQtChat:threadedView()
   ::oUI:stackChat:setCurrentWidget( ::oUI:pageChatTopics )
   RETURN Self


METHOD HbQtChat:cronologicalView()
   ::oUI:stackChat:setCurrentWidget( ::oUI:pageChatAll )
   RETURN Self


METHOD HbQtChat:buildToolbar( oLayout )

   WITH OBJECT ::oToolbar := HbQtScrollableToolbar():new()
      :create( oLayout )
   ENDWITH
   WITH OBJECT ::oToolbar
      :addToolbarButton( "Back"    , "Back"    , "prv_undo"   , {|| ::hide() } )
      :addSeparator( "S_1" )
      :addToolbarButton( "Topic"   , "Topic"   , "vz-topic"   , {|| ::cMode := "Topic", ::initiateTopicOrReply( "Originate" ) } )
      :addToolbarButton( "Collapse", "Collapse", "vz-collapse", {|| ::collapseTopics() } )
      :addToolbarButton( "Threaded", "Threaded", "vz-threaded", {|| ::threadedView() } )
      :addToolbarButton( "Crono"   , "Crono"   , "vz-clock"   , {|| ::cronologicalView() } )
   ENDWITH
   RETURN Self


METHOD HbQtChat:manageToolbarClicks( cAction )
   HB_SYMBOL_UNUSED( cAction )
   RETURN Self

