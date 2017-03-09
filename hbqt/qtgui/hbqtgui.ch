/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2009-2016 Pritpal Bedi <bedipritpal@hotmail.com>
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

#ifndef _HBQTGUI_CH
#define _HBQTGUI_CH

#include "hbqt_version.ch"

/*----------------------------------------------------------------------*/
//                        HBQT Defined Constants
/*----------------------------------------------------------------------*/
/*
 *   DEFINES HBQt CODEBLOCKs
 *
 *   Format:
 *   HBQT_(Qt class initials)_(Qt overloaded member)
 */
#define HBQT_QAIM_data                            1001
#define HBQT_QAIM_flags                           1003
#define HBQT_QAIM_headerData                      2001
#define HBQT_QAIM_rowCount                        3001
#define HBQT_QAIM_columnCount                     3002

/*----------------------------------------------------------------------*/

#define HBQT_GRAPHICSITEM_NONE                    0
#define HBQT_GRAPHICSITEM_RECT                    1
#define HBQT_GRAPHICSITEM_LINE                    2
#define HBQT_GRAPHICSITEM_ELLIPSE                 3
#define HBQT_GRAPHICSITEM_ARC                     4
#define HBQT_GRAPHICSITEM_CHORD                   5
#define HBQT_GRAPHICSITEM_POLYGON                 6
#define HBQT_GRAPHICSITEM_PIE                     7
#define HBQT_GRAPHICSITEM_PATH                    8
#define HBQT_GRAPHICSITEM_CHART                   9
#define HBQT_GRAPHICSITEM_GRADIENT                10
#define HBQT_GRAPHICSITEM_PICTURE                 11
#define HBQT_GRAPHICSITEM_BARCODE                 12
#define HBQT_GRAPHICSITEM_TEXT                    13
#define HBQT_GRAPHICSITEM_SIMPLETEXT              14
#define HBQT_GRAPHICSITEM_ROUNDRECT               15

#define HBQT_GRAPHICSITEM_LINE_HORIZONTAL         0
#define HBQT_GRAPHICSITEM_LINE_VERTICAL           1
#define HBQT_GRAPHICSITEM_LINE_BACKWARDDIAGONAL   2
#define HBQT_GRAPHICSITEM_LINE_FORWARDDIAGONAL    3

#define HBQT_GRAPHICSITEM_TEXT_DRAW_NONE          0
#define HBQT_GRAPHICSITEM_TEXT_DRAW_TOP           1
#define HBQT_GRAPHICSITEM_TEXT_DRAW_BOTTOM        2
#define HBQT_GRAPHICSITEM_TEXT_DRAW_ABOVE         3
#define HBQT_GRAPHICSITEM_TEXT_DRAW_BELOW         4

#define HBQT_GRAPHICSITEM_TEXT_SIZEPOLICY_NONE    0
#define HBQT_GRAPHICSITEM_TEXT_SIZEPOLICY_AUTO    1
#define HBQT_GRAPHICSITEM_TEXT_SIZEPOLICY_STRETCH 2

#define HBQT_GRAPHICSITEM_IMAGE_NO_FRAME          0
#define HBQT_GRAPHICSITEM_IMAGE_PICTURE_BIND      1
#define HBQT_GRAPHICSITEM_IMAGE_PICTURE_BOX       2

#define HBQT_GRAPHICSITEM_RESIZE_ITEM_TO_PICTURE  1
#define HBQT_GRAPHICSITEM_CENTER_PICTURE_TO_ITEM  2
#define HBQT_GRAPHICSITEM_RESIZE_PICTURE_TO_ITEM_KEEP_ASPECT_RATIO     3
#define HBQT_GRAPHICSITEM_RESIZE_PICTURE_TO_ITEM_IGNORE_ASPECT_RATIO   4

//              HBQTableView:hbSetBlock() fired constants
#define HBQT_HBQTABLEVIEW_scrollContentsBy        1


//       HBQProxyStyle Drawing Constants
#define HBQT_DRAW_PRIMITIVE                       0
#define HBQT_DRAW_CONTROL                         1
#define HBQT_DRAW_COMPLEXCONTROL                  2
#define HBQT_DRAW_ITEMPIXMAP                      3
#define HBQT_DRAW_ITEMTEXT                        4

/*----------------------------------------------------------------------*/
//                         Qt Defined Constants
/*----------------------------------------------------------------------*/

#define QEvent_None                               0        // Not an event.
#define QEvent_Timer                              1        // Regular timer events (QTimerEvent).
#define QEvent_MouseButtonPress                   2        // Mouse press (QMouseEvent).
#define QEvent_MouseButtonRelease                 3        // Mouse release (QMouseEvent).
#define QEvent_MouseButtonDblClick                4        // Mouse press again (QMouseEvent).
#define QEvent_MouseMove                          5        // Mouse move (QMouseEvent).
#define QEvent_KeyPress                           6        // Key press (QKeyEvent).
#define QEvent_KeyRelease                         7        // Key release (QKeyEvent).
#define QEvent_FocusIn                            8        // Widget gains keyboard focus (QFocusEvent).
#define QEvent_FocusOut                           9        // Widget loses keyboard focus (QFocusEvent).
#define QEvent_Enter                              10       // Mouse enters widget's boundaries.
#define QEvent_Leave                              11       // Mouse leaves widget's boundaries.
#define QEvent_Paint                              12       // Screen update necessary (QPaintEvent).
#define QEvent_Move                               13       // Widget's position changed (QMoveEvent).
#define QEvent_Resize                             14       // Widget's size changed (QResizeEvent).
#define QEvent_Show                               17       // Widget was shown on screen (QShowEvent).
#define QEvent_Hide                               18       // Widget was hidden (QHideEvent).
#define QEvent_Close                              19       // Widget was closed (QCloseEvent).
#define QEvent_ParentChange                       21       // The widget parent has changed.
#define QEvent_WindowActivate                     24       // Window was activated.
#define QEvent_WindowDeactivate                   25       // Window was deactivated.
#define QEvent_ShowToParent                       26       // A child widget has been shown.
#define QEvent_HideToParent                       27       // A child widget has been hidden.
#define QEvent_Wheel                              31       // Mouse wheel rolled (QWheelEvent).
#define QEvent_WindowTitleChange                  33       // The window title has changed.
#define QEvent_WindowIconChange                   34       // The window's icon has changed.
#define QEvent_ApplicationWindowIconChange        35       // The application's icon has changed.
#define QEvent_ApplicationFontChange              36       // The default application font has changed.
#define QEvent_ApplicationLayoutDirectionChange   37       // The default application layout direction has changed.
#define QEvent_ApplicationPaletteChange           38       // The default application palette has changed.
#define QEvent_PaletteChange                      39       // Palette of the widget changed.
#define QEvent_Clipboard                          40       // The clipboard contents have changed (QClipboardEvent).
#define QEvent_MetaCall                           43       // An asynchronous method invocation via QMetaObject_invokeMethod().
#define QEvent_SockAct                            50       // Socket activated, used to implement QSocketNotifier.
#define QEvent_ShortcutOverride                   51       // Key press in child, for overriding shortcut key handling (QKeyEvent).
#define QEvent_DeferredDelete                     52       // The object will be deleted after it has cleaned up.
#define QEvent_DragEnter                          60       // The cursor enters a widget during a drag and drop operation (QDragEnterEvent).
#define QEvent_DragLeave                          62       // The cursor leaves a widget during a drag and drop operation (QDragLeaveEvent).
#define QEvent_DragMove                           61       // A drag and drop operation is in progress (QDragMoveEvent).
#define QEvent_Drop                               63       // A drag and drop operation is completed (QDropEvent).
#define QEvent_ChildAdded                         68       // An object gets a child (QChildEvent).
#define QEvent_ChildPolished                      69       // A widget child gets polished (QChildEvent).
#define QEvent_ChildInserted                      70       // An object gets a child (QChildEvent). Qt3Support only, use ChildAdded instead.
#define QEvent_ChildRemoved                       71       // An object loses a child (QChildEvent).
#define QEvent_PolishRequest                      74       // The widget should be polished.
#define QEvent_Polish                             75       // The widget is polished.
#define QEvent_LayoutRequest                      76       // Widget layout needs to be redone.
#define QEvent_UpdateRequest                      77       // The widget should be repainted.
#define QEvent_UpdateLater                        78       // The widget should be queued to be repainted at a later time.
#define QEvent_ContextMenu                        82       // Context popup menu (QContextMenuEvent).
#define QEvent_InputMethod                        83       // An input method is being used (QInputMethodEvent).
#define QEvent_AccessibilityPrepare               86       // Accessibility information is requested.
#define QEvent_TabletMove                         87       // Wacom tablet move (QTabletEvent).
#define QEvent_LocaleChange                       88       // The system locale has changed.
#define QEvent_LanguageChange                     89       // The application translation changed.
#define QEvent_LayoutDirectionChange              90       // The direction of layouts changed.
#define QEvent_TabletPress                        92       // Wacom tablet press (QTabletEvent).
#define QEvent_TabletRelease                      93       // Wacom tablet release (QTabletEvent).
#define QEvent_OkRequest                          94       // Ok button in decoration pressed. Supported only for Windows CE.
#define QEvent_IconDrag                           96       // The main icon of a window has been dragged away (QIconDragEvent).
#define QEvent_FontChange                         97       // Widget's font has changed.
#define QEvent_EnabledChange                      98       // Widget's enabled state has changed.
#define QEvent_ActivationChange                   99       // A widget's top-level window activation state has changed.
#define QEvent_StyleChange                        100      // Widget's style has been changed.
#define QEvent_IconTextChange                     101      // Widget's icon text has been changed.
#define QEvent_ModifiedChange                     102      // Widgets modification state has been changed.
#define QEvent_WindowBlocked                      103      // The window is blocked by a modal dialog.
#define QEvent_WindowUnblocked                    104      // The window is unblocked after a modal dialog exited.
#define QEvent_WindowStateChange                  105      // The window's state (minimized, maximized or full-screen) has changed (QWindowStateChangeEvent).
#define QEvent_MouseTrackingChange                109      // The mouse tracking state has changed.
#define QEvent_ToolTip                            110      // A tooltip was requested (QHelpEvent).
#define QEvent_WhatsThis                          111      // The widget should reveal "What's This?" help (QHelpEvent).
#define QEvent_StatusTip                          112      // A status tip is requested (QStatusTipEvent).
#define QEvent_ActionChanged                      113      // An action has been changed (QActionEvent).
#define QEvent_ActionAdded                        114      // A new action has been added (QActionEvent).
#define QEvent_ActionRemoved                      115      // An action has been removed (QActionEvent).
#define QEvent_FileOpen                           116      // File open request (QFileOpenEvent).
#define QEvent_Shortcut                           117      // Key press in child for shortcut key handling (QShortcutEvent).
#define QEvent_WhatsThisClicked                   118      // A link in a widget's "What's This?" help was clicked.
#define QEvent_AccessibilityHelp                  119      // Used to query accessibility help texts (QAccessibleEvent).
#define QEvent_ToolBarChange                      120      // The toolbar button is toggled on Mac OS X.
#define QEvent_ApplicationActivate                121      // The application has been made available to the user.
#define QEvent_ApplicationActivated               121      // This enum has been deprecated. Use ApplicationActivate instead.
#define QEvent_ApplicationDeactivate              122      // The application has been suspended, and is unavailable to the user.
#define QEvent_QueryWhatsThis                     123      // The widget should accept the event if it has "What's This?" help.
#define QEvent_EnterWhatsThisMode                 124      // Send to toplevel widgets when the application enters "What's This?" mode.
#define QEvent_LeaveWhatsThisMode                 125      // Send to toplevel widgets when the application leaves "What's This?" mode.
#define QEvent_ZOrderChange                       126      // The widget's z-order has changed. This event is never sent to top level windows.
#define QEvent_HoverEnter                         127      // The mouse cursor enters a hover widget (QHoverEvent).
#define QEvent_HoverLeave                         128      // The mouse cursor leaves a hover widget (QHoverEvent).
#define QEvent_HoverMove                          129      // The mouse cursor moves inside a hover widget (QHoverEvent).
#define QEvent_AccessibilityDescription           130      // Used to query accessibility description texts (QAccessibleEvent).
#define QEvent_ParentAboutToChange                131      // The widget parent is about to change.
#define QEvent_WinEventAct                        132      // A Windows-specific activation event has occurred.
#define QEvent_EnterEditFocus                     150      // An editor widget gains focus for editing.
#define QEvent_LeaveEditFocus                     151      // An editor widget loses focus for editing.
#define QEvent_MenubarUpdated                     153      // The window's menu bar has been updated.
#define QEvent_GraphicsSceneMouseMove             155      // Move mouse in a graphics scene (QGraphicsSceneMouseEvent).
#define QEvent_GraphicsSceneMousePress            156      // Mouse press in a graphics scene (QGraphicsSceneMouseEvent).
#define QEvent_GraphicsSceneMouseRelease          157      // Mouse release in a graphics scene (QGraphicsSceneMouseEvent).
#define QEvent_GraphicsSceneMouseDoubleClick      158      // Mouse press again (double click) in a graphics scene (QGraphicsSceneMouseEvent).
#define QEvent_GraphicsSceneContextMenu           159      // Context popup menu over a graphics scene (QGraphicsSceneContextMenuEvent).
#define QEvent_GraphicsSceneHoverEnter            160      // The mouse cursor enters a hover item in a graphics scene (QGraphicsSceneHoverEvent).
#define QEvent_GraphicsSceneHoverMove             161      // The mouse cursor moves inside a hover item in a graphics scene (QGraphicsSceneHoverEvent).
#define QEvent_GraphicsSceneHoverLeave            162      // The mouse cursor leaves a hover item in a graphics scene (QGraphicsSceneHoverEvent).
#define QEvent_GraphicsSceneHelp                  163      // The user requests help for a graphics scene (QHelpEvent).
#define QEvent_GraphicsSceneDragEnter             164      // The cursor enters a graphics scene during a drag and drop operation.
#define QEvent_GraphicsSceneDragMove              165      // A drag and drop operation is in progress over a scene.
#define QEvent_GraphicsSceneDragLeave             166      // The cursor leaves a graphics scene during a drag and drop operation.
#define QEvent_GraphicsSceneDrop                  167      // A drag and drop operation is completed over a scene.
#define QEvent_GraphicsSceneWheel                 168      // Mouse wheel rolled in a graphics scene (QGraphicsSceneWheelEvent).
#define QEvent_KeyboardLayoutChange               169      // The keyboard layout has changed.
#define QEvent_DynamicPropertyChange              170      // A dynamic property was added, changed or removed from the object. User events should have values b
#define QEvent_TabletEnterProximity               171      // Wacom tablet enter proximity event (QTabletEvent), sent to QApplication.
#define QEvent_TabletLeaveProximity               172      // Wacom tablet leave proximity event (QTabletEvent), sent to QApplication.
#define QEvent_NonClientAreaMouseMove             173      // A mouse move occurred outside the client area.
#define QEvent_NonClientAreaMouseButtonPress      174      // A mouse button press occurred outside the client area.
#define QEvent_NonClientAreaMouseButtonRelease    175      // A mouse button release occurred outside the client area.
#define QEvent_NonClientAreaMouseButtonDblClick   176      // A mouse double click occurred outside the client area.
#define QEvent_MacSizeChange                      177      // The user changed his widget sizes (Mac OS X only).
#define QEvent_ContentsRectChange                 178      // The margins of the widget's content rect changed.
#define QEvent_GraphicsSceneResize                181      // Widget was resized (QGraphicsSceneResizeEvent).
#define QEvent_GraphicsSceneMove                  182      // Widget was moved (QGraphicsSceneMoveEvent).
#define QEvent_CursorChange                       183      // The widget's cursor has changed.
#define QEvent_ToolTipChange                      184      // The widget's tooltip has changed.
#define QEvent_GrabMouse                          186      // Item gains mouse grab (QGraphicsItem only).
#define QEvent_UngrabMouse                        187      // Item loses mouse grab (QGraphicsItem only).
#define QEvent_GrabKeyboard                       188      // Item gains keyboard grab (QGraphicsItem only).
#define QEvent_UngrabKeyboard                     189      // Item loses keyboard grab (QGraphicsItem only).
// Qt 4.6 Onwards : Trying to figure out how can be implemented in HbQt.
#define QEvent_StateMachineSignal                 192      // A signal delivered to a state machine (QStateMachine::SignalEvent).
#define QEvent_StateMachineWrapped                193      // The event is a wrapper for, i.e., contains, another event (QStateMachine::WrappedEvent).
#define QEvent_TouchBegin                         194      // Beginning of a sequence of touch-screen and/or track-pad events (QTouchEvent)
#define QEvent_TouchUpdate                        195      // Touch-screen event (QTouchEvent)
#define QEvent_TouchEnd                           196      // End of touch-event sequence (QTouchEvent)
#define QEvent_Gesture                            198      // A gesture was triggered (QGestureEvent)
#define QEvent_RequestSoftwareInputPanel          199      // A widget wants to open a software input panel (SIP).
#define QEvent_CloseSoftwareInputPanel            200      // A widget wants to close the software input panel (SIP).
#define QEvent_GestureOverride                    202      // A gesture override was triggered (QGestureEvent)
#define QEvent_WinIdChange                        203      // The window system identifer for this native widget has changed
#define QEvent_ScrollPrepare                      204      // The object needs to fill in its geometry information (QScrollPrepareEvent).
#define QEvent_Scroll                             205      // The object needs to scroll to the supplied position (QScrollEvent).
#define QEvent_Expose                             206      // Sent to a window when its on-screen contents are invalidated and need to be flushed from the backing store.
#define QEvent_InputMethodQuery                   207      // A input method query event (QInputMethodQueryEvent)
#define QEvent_OrientationChange                  208      // The screens orientation has changes (QScreenOrientationChangeEvent)
#define QEvent_TouchCancel                        209      // Cancellation of touch-event sequence (QTouchEvent).
#define QEvent_PlatformPanel                      212      // A platform specific panel has been requested.
#define QEvent_ApplicationStateChange             214      // The state of the application has changed.

#define QPalette_WindowText                       0        // A general foreground color.
#define QPalette_Foreground                       0        // This value is obsolete. Use WindowText instead.
#define QPalette_Button                           1        // The general button background color. This background can be different from Window as some styles require a different background color for buttons.
#define QPalette_Text                             6        // The foreground color used with Base. This is usually the same as the WindowText, in which case it must provide good contrast with Window and Base.
#define QPalette_BrightText                       7        // A text color that is very different from WindowText, and contrasts well with e.g. Dark. Typically used for text that needs to be drawn where Text or WindowText would give poor contrast, such as on pressed push buttons. Note that text colors can be used for things other than just words; text colors are usually used for text, but it's quite common to use the text color roles for lines, icons, etc.
#define QPalette_ButtonText                       8        // A foreground color used with the Button color.
#define QPalette_Base                             9        // Used mostly as the background color for text entry widgets, but can also be used for other painting - such as the background of combobox drop down lists and toolbar handles. It is usually white or another light color.
#define QPalette_Window                           10       // A general background color.
#define QPalette_Background                       10       // This value is obsolete. Use Window instead.
#define QPalette_AlternateBase                    16       // Used as the alternate background color in views with alternating row colors (see QAbstractItemView_setAlternatingRowColors()).
#define QPalette_ToolTipBase                      18       // Used as the background color for QToolTip and QWhatsThis. Tool tips use the Inactive color group of QPalette, because tool tips are not active windows.
#define QPalette_ToolTipText                      19       // Used as the foreground color for QToolTip and QWhatsThis. Tool tips use the Inactive color group of QPalette, because tool tips are not active windows.

#define QPalette_Disabled                         1
#define QPalette_Active                           0
#define QPalette_Inactive                         2
#define QPalette_Normal                           QPalette_Active
/*
 * There are some color roles used mostly for 3D bevel and shadow effects.
 * All of these are normally derived from Window, and used in ways that depend on that
 * relationship. For example, buttons depend on it to make the bevels look attractive,
 * and Motif scroll bars depend on Mid to be slightly different from Window.
 */
#define QPalette_Light                            2        // Lighter than Button color.
#define QPalette_Midlight                         3        // Between Button and Light.
#define QPalette_Dark                             4        // Darker than Button.
#define QPalette_Mid                              5        // Between Button and Dark.
#define QPalette_Shadow                           11       // A very dark color. By default, the shadow color is Qt_black.
#define QPalette_Highlight                        12       // A color to indicate a selected item or the current item. By default, the highlight color is Qt_darkBlue.
#define QPalette_HighlightedText                  13       // A text color that contrasts with Highlight. By default, the highlighted text color is Qt_white.
#define QPalette_Link                             14       // A text color used for unvisited hyperlinks. By default, the link color is Qt_blue.
#define QPalette_LinkVisited                      15       // A text color used for already visited hyperlinks. By default, the linkvisited color is Qt_magenta.
#define QPalette_NoRole                           17       // No role; this special role is often used to indicate that a role has not been assigned.


#define QAbstractSlider_SliderNoAction            0
#define QAbstractSlider_SliderSingleStepAdd       1
#define QAbstractSlider_SliderSingleStepSub       2
#define QAbstractSlider_SliderPageStepAdd         3
#define QAbstractSlider_SliderPageStepSub         4
#define QAbstractSlider_SliderToMinimum           5
#define QAbstractSlider_SliderToMaximum           6
#define QAbstractSlider_SliderMove                7

#define QAbstractSlider_SliderRangeChange         0
#define QAbstractSlider_SliderOrientationChange   1
#define QAbstractSlider_SliderStepsChange         2
#define QAbstractSlider_SliderValueChange         3

#define QLineEdit_Normal                          0        // Display characters as they are entered. This is the default.
#define QLineEdit_NoEcho                          1        // Do not display anything. This may be appropriate for passwords where even the length of the password should be kept secret.
#define QLineEdit_Password                        2        // Display asterisks instead of the characters actually entered.
#define QLineEdit_PasswordEchoOnEdit              3

#define QLineEdit_LeadingPosition                 0        // The widget is displayed to the left of the text when using layout direction Qt::LeftToRight or to the right when using Qt::RightToLeft, respectively.
#define QLineEdit_TrailingPosition                1        // The widget is displayed to the right of the text when using layout direction Qt::LeftToRight or to the left when using Qt::RightToLeft, respectively.

#define QMessageBox_InvalidRole                   -1        // The button is invalid.
#define QMessageBox_AcceptRole                    0         // Clicking the button causes the dialog to be accepted (e.g. OK).
#define QMessageBox_RejectRole                    1         // Clicking the button causes the dialog to be rejected (e.g. Cancel).
#define QMessageBox_DestructiveRole               2         // Clicking the button causes a destructive change (e.g. for Discarding Changes) and closes the dialog.
#define QMessageBox_ActionRole                    3         // Clicking the button causes changes to the elements within the dialog.
#define QMessageBox_HelpRole                      4         // The button can be clicked to request help.
#define QMessageBox_YesRole                       5         // The button is a "Yes"-like button.
#define QMessageBox_NoRole                        6         // The button is a "No"-like button.
#define QMessageBox_ApplyRole                     8         // The button applies current changes.
#define QMessageBox_ResetRole                     7         // The button resets the dialog's fields to default values.
                                                            //
#define QMessageBox_NoIcon                        0         // the message box does not have any icon.
#define QMessageBox_Question                      4         // an icon indicating that the message is asking a question.
#define QMessageBox_Information                   1         // an icon indicating that the message is nothing out of the ordinary.
#define QMessageBox_Warning                       2         // an icon indicating that the message is a warning, but can be dealt with.
#define QMessageBox_Critical                      3         // an icon indicating that the message represents a critical problem.

#define QMessageBox_Ok                            0x00000400   // An "OK" button defined with the AcceptRole.
#define QMessageBox_Open                          0x00002000   // A "Open" button defined with the AcceptRole.
#define QMessageBox_Save                          0x00000800   // A "Save" button defined with the AcceptRole.
#define QMessageBox_Cancel                        0x00400000   // A "Cancel" button defined with the RejectRole.
#define QMessageBox_Close                         0x00200000   // A "Close" button defined with the RejectRole.
#define QMessageBox_Discard                       0x00800000   // A "Discard" or "Don't Save" button, depending on the platform, defined with the DestructiveRole.
#define QMessageBox_Apply                         0x02000000   // An "Apply" button defined with the ApplyRole.
#define QMessageBox_Reset                         0x04000000   // A "Reset" button defined with the ResetRole.
#define QMessageBox_RestoreDefaults               0x08000000   // A "Restore Defaults" button defined with the ResetRole.
#define QMessageBox_Help                          0x01000000   // A "Help" button defined with the HelpRole.
#define QMessageBox_SaveAll                       0x00001000   // A "Save All" button defined with the AcceptRole.
#define QMessageBox_Yes                           0x00004000   // A "Yes" button defined with the YesRole.
#define QMessageBox_YesToAll                      0x00008000   // A "Yes to All" button defined with the YesRole.
#define QMessageBox_No                            0x00010000   // A "No" button defined with the NoRole.
#define QMessageBox_NoToAll                       0x00020000   // A "No to All" button defined with the NoRole.
#define QMessageBox_Abort                         0x00040000   // An "Abort" button defined with the RejectRole.
#define QMessageBox_Retry                         0x00080000   // A "Retry" button defined with the AcceptRole.
#define QMessageBox_Ignore                        0x00100000   // An "Ignore" button defined with the AcceptRole.
#define QMessageBox_NoButton                      0x00000000        // An invalid button.

#define Qt_NoButton                               0x00000000   // The button state does not refer to any button (see QMouseEvent_button()).
#define Qt_AllButtons                             0x07ffffff        // This value corresponds to a mask of all possible mouse buttons. Use to set the 'acceptedButtons' property of a mouseArea to accept ALL mouse buttons.
#define Qt_LeftButton                             0x00000001        // The left button is pressed, or an event refers to the left button. (The left button may be the right button on left-handed mice.)
#define Qt_RightButton                            0x00000002        // The right button.
#define Qt_MidButton                              0x00000004        // The middle button.
#define Qt_MiddleButton                           Qt_MidButton      // The middle button.
#define Qt_BackButton                             0x00000008        // The 'Back' button. (Typically present on the 'thumb' side of a mouse with extra buttons. This is NOT the tilt wheel.)
#define Qt_XButton1                               Qt_BackButton     // The 'Back' Button.
#define Qt_ExtraButton1                           Qt_XButton1       // The 'Back' Button.
#define Qt_ForwardButton                          0x00000010        // The 'Forward' Button. (Typically present beside the 'Back' button, and also pressed by the thumb.)
#define Qt_XButton2                               Qt_ForwardButton  // The 'Forward Button.
#define Qt_ExtraButton2                           Qt_ForwardButton  // The 'Forward' Button.
#define Qt_TaskButton                             0x00000020        // The 'Task' Button.
#define Qt_ExtraButton3                           Qt_TaskButton     // The 'Task' Button.
#define Qt_ExtraButton4                           0x00000040        // The 7th non-wheel Mouse Button.
#define Qt_ExtraButton5                           0x00000080        // The 8th non-wheel Mouse Button.
#define Qt_ExtraButton6                           0x00000100        // The 9th non-wheel Mouse Button.
#define Qt_ExtraButton7                           0x00000200        // The 10th non-wheel Mouse Button.
#define Qt_ExtraButton8                           0x00000400        // The 11th non-wheel Mouse Button.
#define Qt_ExtraButton9                           0x00000800        // The 12th non-wheel Mouse Button.
#define Qt_ExtraButton10                          0x00001000        // The 13th non-wheel Mouse Button.
#define Qt_ExtraButton11                          0x00002000        // The 14th non-wheel Mouse Button.
#define Qt_ExtraButton12                          0x00004000        // The 15th non-wheel Mouse Button.
#define Qt_ExtraButton13                          0x00008000        // The 16th non-wheel Mouse Button.
#define Qt_ExtraButton14                          0x00010000        // The 17th non-wheel Mouse Button.
#define Qt_ExtraButton15                          0x00020000        // The 18th non-wheel Mouse Button.
#define Qt_ExtraButton16                          0x00040000        // The 19th non-wheel Mouse Button.
#define Qt_ExtraButton17                          0x00080000        // The 20th non-wheel Mouse Button.
#define Qt_ExtraButton18                          0x00100000        // The 21st non-wheel Mouse Button.
#define Qt_ExtraButton19                          0x00200000        // The 22nd non-wheel Mouse Button.
#define Qt_ExtraButton20                          0x00400000        // The 23rd non-wheel Mouse Button.
#define Qt_ExtraButton21                          0x00800000        // The 24th non-wheel Mouse Button.
#define Qt_ExtraButton22                          0x01000000        // The 25th non-wheel Mouse Button.
#define Qt_ExtraButton23                          0x02000000        // The 26th non-wheel Mouse Button.
#define Qt_ExtraButton24                          0x04000000        // The 27th non-wheel Mouse Button.

//enum Qt::MouseEventFlag
//This enum provides additional information concerning a QMouseEvent.
#define Qt_MouseEventCreatedDoubleClick           0x01        // Indicates that Qt has created a MouseButtonDblClick event from this event. The flag is set in the causing MouseButtonPress, and not in the resulting MouseButtonDblCLick.

//enum Qt::MouseEventSource
#define Qt_MouseEventNotSynthesized               0           // The most common value. On platforms where such information is available this value indicates that the event was generated in response to a genuine mouse event in the system.
#define Qt_MouseEventSynthesizedBySystem          1           // Indicates that the mouse event was synthesized from a touch event by the platform.
#define Qt_MouseEventSynthesizedByQt              2           // Indicates that the mouse event was synthesized from an unhandled touch event by Qt.

#define Qt_AlignLeft                              0x0001      // Aligns with the left edge.
#define Qt_AlignRight                             0x0002      // Aligns with the right edge.
#define Qt_AlignHCenter                           0x0004      // Centers horizontally in the available space.
#define Qt_AlignJustify                           0x0008      // Justifies the text in the available space.
                                                              //
#define Qt_AlignTop                               0x0020      // Aligns with the top.
#define Qt_AlignBottom                            0x0040      // Aligns with the bottom.
#define Qt_AlignVCenter                           0x0080      // Centers vertically in the available space.

#define Qt_AlignCenter                            hb_bitOR( Qt_AlignVCenter, Qt_AlignHCenter )  // Centers in both dimensions.

#define Qt_AlignAbsolute                          0x0010      // If the widget's layout direction is #define Qt_RightToLeft (instead of #define Qt_LeftToRight, the default), #define Qt_AlignLeft refers to the right edge and #define Qt_AlignRight to the left edge. This is normally the desired behavior. If you want #define Qt_AlignLeft to always mean "left" and #define Qt_AlignRight to always mean "right", combine the flag with #define Qt_AlignAbsolute.
#define Qt_AlignLeading                           Qt_AlignLeft   // Synonym for #define Qt_AlignLeft.
#define Qt_AlignTrailing                          Qt_AlignRight  // Synonym for #define Qt_AlignRight.

#define Qt_AlignHorizontal_Mask                   Qt_AlignLeft + Qt_AlignRight + Qt_AlignHCenter + Qt_AlignJustify + Qt_AlignAbsolute
#define Qt_AlignVertical_Mask                     Qt_AlignTop + Qt_AlignBottom + Qt_AlignVCenter

#define Qt_AnchorName                             0     // the name attribute of the anchor. This attribute is used when scrolling to an anchor in the document.
#define Qt_AnchorHref                             1     // the href attribute of the anchor. This attribute is used when a link is clicked to determine what content to load.

#define Qt_AA_ImmediateWidgetCreation             0     // Ensures that widgets are created as soon as they are constructed. By default, resources for widgets are allocated on demand to improve efficiency and minimize resource usage. Setting or clearing this attribute affects widgets constructed after the change. Setting it tells Qt to create toplevel windows immediately. Therefore, if it is important to minimize resource consumption, do not set this attribute.
#define Qt_AA_MSWindowsUseDirect3DByDefault       1     // Is a Windows specific attribute, that will make the Direct3D paint engine the default Qt widget paint engine. Note that you can toggle usage of the Direct3D engine on individual QWidgets by setting/clearing the WA_MSWindowsUseDirect3D attribute on a specific widget. This functionality is experimental.
#define Qt_AA_DontShowIconsInMenus                2     // Actions with the Icon property won't be shown in any menus unless specifically set by the QAction_iconVisibleInMenu property.
// Menus that are currently open or menus already created in the native Mac OS X menubar MAY NOT pick up a change in this attribute. Changes in the QAction_iconVisibleInMenu property will always be picked up.

#define Qt_AA_NativeWindows                       3     // Ensures that widgets have native windows.
#define Qt_AA_DontCreateNativeWidgetSiblings      4     // Ensures that siblings of native widgets stay non-native unless specifically set by the #define Qt_WA_NativeWindow attribute.
#define Qt_AA_MacPluginApplication                5     // Stops the a Qt mac application from doing specific initializations that do not necessarily make sense when using Qt to author a plugin. This includes avoiding loading our nib for the main menu and not taking possession of the native menu bar.

#define Qt_NoArrow                                0
#define Qt_UpArrow                                1
#define Qt_DownArrow                              2
#define Qt_LeftArrow                              3
#define Qt_RightArrow                             4

// enum #define Qt_AspectRatioMode
// This enum type defines what happens to the aspect ratio when scaling an rectangle.
//
#define Qt_IgnoreAspectRatio                      0     // The size is scaled freely. The aspect ratio is not preserved.
#define Qt_KeepAspectRatio                        1     // The size is scaled to a rectangle as large as possible inside a given rectangle, preserving the aspect ratio.
#define Qt_KeepAspectRatioByExpanding             2     // The size is scaled to a rectangle as small as possible outside a given rectangle, preserving the aspect ratio.
// See also QSize_scale() and QImage_scaled().

// enum #define Qt_Axis
// This enum type defines three values to represent the three axes in the cartesian coordinate system.
#define Qt_XAxis                                  0     // The X axis.
#define Qt_YAxis                                  1     // The Y axis.
#define Qt_ZAxis                                  2     // The Z axis.
// See also QTransform_rotate() and QTransform_rotateRadians().

// enum #define Qt_BGMode - Background mode:
#define Qt_TransparentMode                        0
#define Qt_OpaqueMode                             1

//enum #define Qt_BrushStyle
//This enum type defines the brush styles supported by Qt, i.e. the fill pattern of shapes drawn using QPainter.
//
#define Qt_NoBrush                                0     // No brush pattern.
#define Qt_SolidPattern                           1     // Uniform color.
#define Qt_Dense1Pattern                          2     // Extremely dense brush pattern.
#define Qt_Dense2Pattern                          3     // Very dense brush pattern.
#define Qt_Dense3Pattern                          4     // Somewhat dense brush pattern.
#define Qt_Dense4Pattern                          5     // Half dense brush pattern.
#define Qt_Dense5Pattern                          6     // Somewhat sparse brush pattern.
#define Qt_Dense6Pattern                          7     // Very sparse brush pattern.
#define Qt_Dense7Pattern                          8     // Extremely sparse brush pattern.
#define Qt_HorPattern                             9     // Horizontal lines.
#define Qt_VerPattern                             10    // Vertical lines.
#define Qt_CrossPattern                           11    // Crossing horizontal and vertical lines.
#define Qt_BDiagPattern                           12    // Backward diagonal lines.
#define Qt_FDiagPattern                           13    // Forward diagonal lines.
#define Qt_DiagCrossPattern                       14    // Crossing diagonal lines.
#define Qt_LinearGradientPattern                  15    // Linear gradient (set using a dedicated QBrush constructor).
#define Qt_ConicalGradientPattern                 17    // Conical gradient (set using a dedicated QBrush constructor).
#define Qt_RadialGradientPattern                  16    // Radial gradient (set using a dedicated QBrush constructor).
#define Qt_TexturePattern                         24    // Custom pattern (see QBrush_setTexture()).

// enum #define Qt_CaseSensitivity
//
#define Qt_CaseInsensitive                        0
#define Qt_CaseSensitive                          1

// enum #define Qt_CheckState
// This enum describes the state of checkable items, controls, and widgets.
//
#define Qt_Unchecked                              0     // The item is unchecked.
#define Qt_PartiallyChecked                       1     // The item is partially checked. Items in hierarchical models may be partially checked if some, but not all, of their children are checked.
#define Qt_Checked                                2     // The item is checked.
// See also QCheckBox, #define Qt_ItemFlags, and #define Qt_ItemDataRole.

// enum #define Qt_ClipOperation
//
#define Qt_NoClip                                 0     // This operation turns clipping off.
#define Qt_ReplaceClip                            1     // Replaces the current clip path/rect/region with the one supplied in the function call.
#define Qt_IntersectClip                          2     // Intersects the current clip path/rect/region with the one supplied in the function call.
#define Qt_UniteClip                              3     // Unites the current clip path/rect/region with the one supplied in the function call.

// enum #define Qt_ConnectionType
// This enum describes the types of connection that can be used between signals and slots. In particular, it determines whether a particular signal is delivered to a slot immediately or queued for delivery at a later time.
//
#define Qt_DirectConnection                       1     // When emitted, the signal is immediately delivered to the slot.
#define Qt_QueuedConnection                       2     // When emitted, the signal is queued until the event loop is able to deliver it to the slot.
#define Qt_BlockingQueuedConnection               4     // Same as QueuedConnection, except that the current thread blocks until the slot has been delivered. This connection type should only be used for receivers in a different thread. Note that misuse of this type can lead to dead locks in your application.
#define Qt_AutoConnection                         0     // If the signal is emitted from the thread in which the receiving object lives, the slot is invoked directly, as with #define Qt_DirectConnection; otherwise the signal is queued, as with #define Qt_QueuedConnection.
// With queued connections, the parameters must be of types that are known to Qt's meta-object system, because Qt needs to copy the arguments to store them in an event behind the scenes. If you try to use a queued connection and get the error message
// QObject_connect: Cannot queue arguments of type 'MyType'
// call qRegisterMetaType() to register the data type before you establish the connection.
// See also Thread Support in Qt, QObject_connect(), and qRegisterMetaType().

// enum #define Qt_ContextMenuPolicy
// This enum type defines the various policies a widget can have with respect to showing a context menu.
//
#define Qt_NoContextMenu                          0     // the widget does not feature a context menu, context menu handling is deferred to the widget's parent.
#define Qt_PreventContextMenu                     4     // the widget does not feature a context menu, and in contrast to NoContextMenu, the handling is not deferred to the widget's parent. This means that all right mouse button events are guaranteed to be delivered to the widget itself through mousePressEvent(), and mouseReleaseEvent().
#define Qt_DefaultContextMenu                     1     // the widget's QWidget_contextMenuEvent() handler is called.
#define Qt_ActionsContextMenu                     2     // the widget displays its QWidget_actions() as context menu.
#define Qt_CustomContextMenu                      3     // the widget emits the QWidget_customContextMenuRequested() signal.

// enum #define Qt_Corner
// This enum type specifies a corner in a rectangle:
//
#define Qt_TopLeftCorner                          0x00000   // The top-left corner of the rectangle.
#define Qt_TopRightCorner                         0x00001   // The top-right corner of the rectangle.
#define Qt_BottomLeftCorner                       0x00002   // The bottom-left corner of the rectangle.
#define Qt_BottomRightCorner                      0x00003   // The bottom-right corner of the rectangle.

// enum #define Qt_CursorShape
// This enum type defines the various cursors that can be used.
// The standard arrow cursor is the default for widgets in a normal state.
//
#define Qt_ArrowCursor                            0     // The standard arrow cursor.
#define Qt_UpArrowCursor                          1     // An arrow pointing upwards toward the top of the screen.
#define Qt_CrossCursor                            2     // A crosshair cursor, typically used to help the user accurately select a point on the screen.
#define Qt_WaitCursor                             3     // An hourglass or watch cursor, usually shown during operations that prevent the user from interacting with the application.
#define Qt_IBeamCursor                            4     // A caret or ibeam cursor, indicating that a widget can accept and display text input.
#define Qt_SizeVerCursor                          5     // A cursor used for elements that are used to vertically resize top-level windows.
#define Qt_SizeHorCursor                          6     // A cursor used for elements that are used to horizontally resize top-level windows.
#define Qt_SizeBDiagCursor                        7     // A cursor used for elements that are used to diagonally resize top-level windows at their top-right and bottom-left corners.
#define Qt_SizeFDiagCursor                        8     // A cursor used for elements that are used to diagonally resize top-level windows at their top-left and bottom-right corners.
#define Qt_SizeAllCursor                          9     // A cursor used for elements that are used to resize top-level windows in any direction.
#define Qt_BlankCursor                            10    // A blank/invisible cursor, typically used when the cursor shape needs to be hidden.
#define Qt_SplitVCursor                           11    // A cursor used for vertical splitters, indicating that a handle can be dragged horizontally to adjust the use of available space.
#define Qt_SplitHCursor                           12    // A cursor used for horizontal splitters, indicating that a handle can be dragged vertically to adjust the use of available space.
#define Qt_PointingHandCursor                     13    // A pointing hand cursor that is typically used for clickable elements such as hyperlinks.
#define Qt_ForbiddenCursor                        14    // A slashed circle cursor, typically used during drag and drop operations to indicate that dragged content cannot be dropped on particular widgets or inside certain regions.
#define Qt_OpenHandCursor                         17    // A cursor representing an open hand, typically used to indicate that the area under the cursor is the visible part of a canvas that the user can click and drag in order to scroll around.
#define Qt_ClosedHandCursor                       18    // A cursor representing a closed hand, typically used to indicate that a dragging operation is in progress that involves scrolling.
#define Qt_WhatsThisCursor                        15    // An arrow with a question mark, typically used to indicate the presence of What's This? help for a widget.
#define Qt_BusyCursor                             16    // An hourglass or watch cursor, usually shown during operations that allow the user to interact with the application while they are performed in the background.
#define Qt_BitmapCursor                           24

// enum #define Qt_DateFormat
#define Qt_TextDate                               0     // The default Qt format, which includes the day and month name, the day number in the month, and the year in full. The day and month names will be short, localized names. This is basically equivalent to using the date format string, "ddd MMM d yyyy". See QDate_toString() for more information.
#define Qt_ISODate                                1     // ISO 8601 extended format: either YYYY-MM-DD for dates or YYYY-MM-DDTHH:MM:SS for combined dates and times.
#define Qt_SystemLocaleShortDate                  ?     // The short format used by the operating system.
#define Qt_SystemLocaleLongDate                   ?     // The long format used by the operating system.
#define Qt_DefaultLocaleShortDate                 ?     // The short format specified by the application's locale.
#define Qt_DefaultLocaleLongDate                  ?     // The long format used by the application's locale.
#define Qt_SystemLocaleDate                       2     // This enum value is deprecated. Use #define Qt_SystemLocaleShortDate instead (or #define Qt_SystemLocaleLongDate if you want long dates).
#define Qt_LocaleDate                             ?     // This enum value is deprecated. Use #define Qt_DefaultLocaleShortDate instead (or #define Qt_DefaultLocaleLongDate if you want long dates).
#define Qt_LocalDate                              SystemLocaleDate   // This enum value is deprecated. Use #define Qt_SystemLocaleShortDate instead (or #define Qt_SystemLocaleLongDate if you want long dates).
// Note: For ISODate formats, each Y, M and D represents a single digit of the year, month and day used to specify the date. Each H, M and S represents a single digit of the hour, minute and second used to specify the time. The presence of a literal T character is used to separate the date and time when both are specified.

// enum #define Qt_DayOfWeek
//
#define Qt_Monday                                 1
#define Qt_Tuesday                                2
#define Qt_Wednesday                              3
#define Qt_Thursday                               4
#define Qt_Friday                                 5
#define Qt_Saturday                               6
#define Qt_Sunday                                 7

// enum #define Qt_DockWidgetArea
// flags #define Qt_DockWidgetAreas
//
#define Qt_LeftDockWidgetArea                     0x1
#define Qt_RightDockWidgetArea                    0x2
#define Qt_TopDockWidgetArea                      0x4
#define Qt_BottomDockWidgetArea                   0x8
#define Qt_AllDockWidgetAreas                     Qt_DockWidgetArea_Mask
#define Qt_NoDockWidgetArea                       0
// The DockWidgetAreas type is a typedef for QFlags<DockWidgetArea>. It stores an OR combination of DockWidgetArea values.

// enum #define Qt_DropAction
// flags #define Qt_DropActions
//
#define Qt_CopyAction                             0x1   // Copy the data to the target.
#define Qt_MoveAction                             0x2   // Move the data from the source to the target.
#define Qt_LinkAction                             0x4   // Create a link from the source to the target.
#define Qt_ActionMask                             0xff  //
#define Qt_IgnoreAction                           0x0   // Ignore the action (do nothing with the data).
#define Qt_TargetMoveAction                       0x8002// On Windows, this value is used when the ownership of the D&D data should be taken over by the target application, i.e., the source application should not delete the data.
// On X11 this value is used to do a move.
// TargetMoveAction is not used on the Mac.
// The DropActions type is a typedef for QFlags<DropAction>. It stores an OR combination of DropAction values.

// enum #define Qt_EventPriority
// This enum can be used to specify event priorities.
//
#define Qt_HighEventPriority                      1     // Events with this priority are sent before events with NormalEventPriority or LowEventPriority.
#define Qt_NormalEventPriority                    0     // Events with this priority are sent after events with HighEventPriority, but before events with LowEventPriority.
#define Qt_LowEventPriority                       -1    // Events with this priority are sent after events with HighEventPriority or NormalEventPriority.
// Note that these values are provided purely for convenience, since event priorities can be any value between INT_MAX and INT_MIN, inclusive. For example, you can define custom priorities as being relative to each other:
// See also QCoreApplication_postEvent().

// enum #define Qt_FillRule
// Specifies which method should be used to fill the paths and polygons.
//
#define Qt_OddEvenFill                            0     // Specifies that the region is filled using the odd even fill rule. With this rule, we determine whether a point is inside the shape by using the following method. Draw a horizontal line from the point to a location outside the shape, and count the number of intersections. If the number of intersections is an odd number, the point is inside the shape. This mode is the default.
#define Qt_WindingFill                            1     // Specifies that the region is filled using the non zero winding rule. With this rule, we determine whether a point is inside the shape by using the following method. Draw a horizontal line from the point to a location outside the shape. Determine whether the direction of the line at each intersection point is up or down. The winding number is determined by summing the direction of each intersection. If the number is non zero, the point is inside the shape. This fill mode can also in most cases be considered as the intersection of closed shapes.

// enum #define Qt_FocusPolicy
// This enum type defines the various policies a widget can have with respect to acquiring keyboard focus.
//
#define Qt_TabFocus                               0x1   // the widget accepts focus by tabbing.
#define Qt_ClickFocus                             0x2   // the widget accepts focus by clicking.
#define Qt_StrongFocus                            hb_bitOR( Qt_TabFocus, Qt_ClickFocus, 0x8 )  // the widget accepts focus by both tabbing and clicking. On Mac OS X this will also be indicate that the widget accepts tab focus when in 'Text/List focus mode'.
#define Qt_WheelFocus                             hb_bitOR( Qt_StrongFocus, 0x4 )            // like #define Qt_StrongFocus plus the widget accepts focus by using the mouse wheel.
#define Qt_NoFocus                                0     // the widget does not accept focus.

// enum #define Qt_FocusReason
// This enum specifies why the focus changed. It will be passed through QWidget_setFocus and can be retrieved in the QFocusEvent sent to the widget upon focus change.
//
#define Qt_MouseFocusReason                       0     // A mouse action occurred.
#define Qt_TabFocusReason                         1     // The Tab key was pressed.
#define Qt_BacktabFocusReason                     2     // A Backtab occurred. The input for this may include the Shift or Control keys; e.g. Shift+Tab.
#define Qt_ActiveWindowFocusReason                3     // The window system made this window either active or inactive.
#define Qt_PopupFocusReason                       4     // The application opened/closed a pop-up that grabbed/released the keyboard focus.
#define Qt_ShortcutFocusReason                    5     // The user typed a label's buddy shortcut
#define Qt_MenuBarFocusReason                     6     // The menu bar took focus.
#define Qt_OtherFocusReason                       7     // Another reason, usually application-specific.
// See also Keyboard Focus.

// enum #define Qt_GlobalColor
// Qt's predefined QColor objects:
//
#define Qt_white                                  3     // White (#ffffff)
#define Qt_black                                  2     // Black (#000000)
#define Qt_red                                    7     // Red (#ff0000)
#define Qt_darkRed                                13    // Dark red (#800000)
#define Qt_green                                  8     // Green (#00ff00)
#define Qt_darkGreen                              14    // Dark green (#008000)
#define Qt_blue                                   9     // Blue (#0000ff)
#define Qt_darkBlue                               15    // Dark blue (#000080)
#define Qt_cyan                                   10    // Cyan (#00ffff)
#define Qt_darkCyan                               16    // Dark cyan (#008080)
#define Qt_magenta                                11    // Magenta (#ff00ff)
#define Qt_darkMagenta                            17    // Dark magenta (#800080)
#define Qt_yellow                                 12    // Yellow (#ffff00)
#define Qt_darkYellow                             18    // Dark yellow (#808000)
#define Qt_gray                                   5     // Gray (#a0a0a4)
#define Qt_darkGray                               4     // Dark gray (#808080)
#define Qt_lightGray                              6     // Light gray (#c0c0c0)
#define Qt_transparent                            19    // a transparent black value (i.e., QColor(0, 0, 0, 0))
#define Qt_color0                                 0     // 0 pixel value (for bitmaps)
#define Qt_color1                                 1     // 1 pixel value (for bitmaps)
// See also QColor.

// enum #define Qt_HitTestAccuracy
// This enum contains the types of accuracy that can be used by the QTextDocument class when testing for mouse clicks on text documents.
//
#define Qt_ExactHit                               0     // The point at which input occurred must coincide exactly with input-sensitive parts of the document.
#define Qt_FuzzyHit                               1     // The point at which input occurred can lie close to input-sensitive parts of the document.
// This enum is defined in the <QTextDocument> header file.

// enum #define Qt_ImageConversionFlag
// flags #define Qt_ImageConversionFlags
// The options marked "(default)" are set if no other values from the list are included (since the defaults are zero):
// Color/Mono preference (ignored for QBitmap):
//
#define Qt_AutoColor                              0x00000000   // (default) - If the image has depth 1 and contains only black and white pixels, the pixmap becomes monochrome.
#define Qt_ColorOnly                              0x00000003   // The pixmap is dithered/converted to the native display depth.
#define Qt_MonoOnly                               0x00000002   // The pixmap becomes monochrome. If necessary, it is dithered using the chosen dithering algorithm.

// Dithering mode preference for RGB channels:
//
#define Qt_DiffuseDither                          0x00000000   // (default) - A high-quality dither.
#define Qt_OrderedDither                          0x00000010   // A faster, more ordered dither.
#define Qt_ThresholdDither                        0x00000020   // No dithering; closest color is used.

// Dithering mode preference for alpha channel:
//
#define Qt_ThresholdAlphaDither                   0x00000000   // (default) - No dithering.
#define Qt_OrderedAlphaDither                     0x00000004   // A faster, more ordered dither.
#define Qt_DiffuseAlphaDither                     0x00000008   // A high-quality dither.

// Color matching versus dithering preference:
//
#define Qt_PreferDither                           0x00000040   // (default when converting to a pixmap) - Always dither 32-bit images when the image is converted to 8 bits.
#define Qt_AvoidDither                            0x00000080   // (default when converting for the purpose of saving to file) - Dither 32-bit images only if the image has more than 256 colors and it is being converted to 8 bits.
// The ImageConversionFlags type is a typedef for QFlags<ImageConversionFlag>. It stores an OR combination of ImageConversionFlag values.

// enum #define Qt_ItemDataRole
// Each item in the model has a set of data elements associated with it, each with its own role. The roles are used by the view to indicate to the model which type of data it needs.
// The general purpose roles are:
//
#define Qt_DisplayRole                            0     // The key data to be rendered in the form of text.
#define Qt_DecorationRole                         1     // The data to be rendered as a decoration in the form of an icon.
#define Qt_EditRole                               2     // The data in a form suitable for editing in an editor.
#define Qt_ToolTipRole                            3     // The data displayed in the item's tooltip.
#define Qt_StatusTipRole                          4     // The data displayed in the status bar.
#define Qt_WhatsThisRole                          5     // The data displayed for the item in "What's This?" mode.
#define Qt_SizeHintRole                           13    // The size hint for the item that will be supplied to views.

// Roles describing appearance and meta data:
//
#define Qt_FontRole                               6     // The font used for items rendered with the default delegate.
#define Qt_TextAlignmentRole                      7     // The alignment of the text for items rendered with the default delegate.
#define Qt_BackgroundRole                         8     // The background brush used for items rendered with the default delegate.
#define Qt_BackgroundColorRole                    8     // This role is obsolete. Use BackgroundRole instead.
#define Qt_ForegroundRole                         9     // The foreground brush (text color, typically) used for items rendered with the default delegate.
#define Qt_TextColorRole                          9     // This role is obsolete. Use ForegroundRole instead.
#define Qt_CheckStateRole                         10    // This role is used to obtain the checked state of an item (see #define Qt_CheckState).

// Accessibility roles:
//
#define Qt_AccessibleTextRole                     11    // The text to be used by accessibility extensions and plugins, such as screen readers.
#define Qt_AccessibleDescriptionRole              12    // A description of the item for accessibility purposes.

// User roles:
//
#define Qt_UserRole                               32    // The first role that can be used for application-specific purposes.

// enum #define Qt_ItemFlag
// flags #define Qt_ItemFlags
// This enum describes the properties of an item:
//
#define Qt_NoItemFlags                            0     // It does not have any properties set.
#define Qt_ItemIsSelectable                       1     // It can be selected.
#define Qt_ItemIsEditable                         2     // It can be edited.
#define Qt_ItemIsDragEnabled                      4     // It can be dragged.
#define Qt_ItemIsDropEnabled                      8     // It can be used as a drop target.
#define Qt_ItemIsUserCheckable                    16    // It can be checked or unchecked by the user.
#define Qt_ItemIsEnabled                          32    // The user can interact with the item.
#define Qt_ItemIsTristate                         64    // The item is checkable with three separate states.
#define Qt_ItemNeverHasChildren                   128
// Note that checkable items need to be given both a suitable set of flags and an initial state, indicating whether the item is checked or not. This is handled automatically for model/view components, but needs to be explicitly set for instances of QListWidgetItem, QTableWidgetItem, and QTreeWidgetItem.
// The ItemFlags type is a typedef for QFlags<ItemFlag>. It stores an OR combination of ItemFlag values.
// See also QAbstractItemModel.

// enum #define Qt_ItemSelectionMode
// This enum is used in QGraphicsItem, QGraphicsScene and QGraphicsView to specify how items are selected, or how to determine if a shapes and items collide.
//
#define Qt_ContainsItemShape                      0x0   // The output list contains only items whose shape is fully contained inside the selection area. Items that intersect with the area's outline are not included.
#define Qt_IntersectsItemShape                    0x1   // The output list contains both items whose shape is fully contained inside the selection area, and items that intersect with the area's outline. This is a common mode for rubber band selection.
#define Qt_ContainsItemBoundingRect               0x2   // The output list contains only items whose bounding rectangle is fully contained inside the selection area. Items that intersect with the area's outline are not included.
#define Qt_IntersectsItemBoundingRect             0x3   // The output list contains both items whose bounding rectangle is fully contained inside the selection area, and items that intersect with the area's outline. This method is commonly used for determining areas that need redrawing.
// See also QGraphicsScene_items(), QGraphicsScene_collidingItems(), QGraphicsView_items(), QGraphicsItem_collidesWithItem(), and QGraphicsItem_collidesWithPath().

#define Qt_Key_Escape                             0x01000000
#define Qt_Key_Tab                                0x01000001
#define Qt_Key_Backtab                            0x01000002
#define Qt_Key_Backspace                          0x01000003
#define Qt_Key_Return                             0x01000004
#define Qt_Key_Enter                              0x01000005     // Typically located on the keypad.
#define Qt_Key_Insert                             0x01000006
#define Qt_Key_Delete                             0x01000007
#define Qt_Key_Pause                              0x01000008     // The Pause/Break key (
#define Qt_Key_Print                              0x01000009
#define Qt_Key_SysReq                             0x0100000a
#define Qt_Key_Clear                              0x0100000b
#define Qt_Key_Home                               0x01000010
#define Qt_Key_End                                0x01000011
#define Qt_Key_Left                               0x01000012
#define Qt_Key_Up                                 0x01000013
#define Qt_Key_Right                              0x01000014
#define Qt_Key_Down                               0x01000015
#define Qt_Key_PageUp                             0x01000016
#define Qt_Key_PageDown                           0x01000017
#define Qt_Key_Shift                              0x01000020
#define Qt_Key_Control                            0x01000021     // On Mac OS X, this corresponds to the Command keys.
#define Qt_Key_Meta                               0x01000022     // On Mac OS X, this corresponds to the Control keys. On Windows keyboards, this key is mapped to the Windows key.
#define Qt_Key_Alt                                0x01000023
#define Qt_Key_AltGr                              0x01001103     // On Windows, when the KeyDown event for this key is sent, the Ctrl+Alt modifiers are also set.
#define Qt_Key_CapsLock                           0x01000024
#define Qt_Key_NumLock                            0x01000025
#define Qt_Key_ScrollLock                         0x01000026
#define Qt_Key_F1                                 0x01000030
#define Qt_Key_F2                                 0x01000031
#define Qt_Key_F3                                 0x01000032
#define Qt_Key_F4                                 0x01000033
#define Qt_Key_F5                                 0x01000034
#define Qt_Key_F6                                 0x01000035
#define Qt_Key_F7                                 0x01000036
#define Qt_Key_F8                                 0x01000037
#define Qt_Key_F9                                 0x01000038
#define Qt_Key_F10                                0x01000039
#define Qt_Key_F11                                0x0100003a
#define Qt_Key_F12                                0x0100003b
#define Qt_Key_F13                                0x0100003c
#define Qt_Key_F14                                0x0100003d
#define Qt_Key_F15                                0x0100003e
#define Qt_Key_F16                                0x0100003f
#define Qt_Key_F17                                0x01000040
#define Qt_Key_F18                                0x01000041
#define Qt_Key_F19                                0x01000042
#define Qt_Key_F20                                0x01000043
#define Qt_Key_F21                                0x01000044
#define Qt_Key_F22                                0x01000045
#define Qt_Key_F23                                0x01000046
#define Qt_Key_F24                                0x01000047
#define Qt_Key_F25                                0x01000048
#define Qt_Key_F26                                0x01000049
#define Qt_Key_F27                                0x0100004a
#define Qt_Key_F28                                0x0100004b
#define Qt_Key_F29                                0x0100004c
#define Qt_Key_F30                                0x0100004d
#define Qt_Key_F31                                0x0100004e
#define Qt_Key_F32                                0x0100004f
#define Qt_Key_F33                                0x01000050
#define Qt_Key_F34                                0x01000051
#define Qt_Key_F35                                0x01000052
#define Qt_Key_Super_L                            0x01000053
#define Qt_Key_Super_R                            0x01000054
#define Qt_Key_Menu                               0x01000055
#define Qt_Key_Hyper_L                            0x01000056
#define Qt_Key_Hyper_R                            0x01000057
#define Qt_Key_Help                               0x01000058
#define Qt_Key_Direction_L                        0x01000059
#define Qt_Key_Direction_R                        0x01000060
#define Qt_Key_Space                              0x20
#define Qt_Key_Any                                Qt_Key_Space
#define Qt_Key_Exclam                             0x21
#define Qt_Key_QuoteDbl                           0x22
#define Qt_Key_NumberSign                         0x23
#define Qt_Key_Dollar                             0x24
#define Qt_Key_Percent                            0x25
#define Qt_Key_Ampersand                          0x26
#define Qt_Key_Apostrophe                         0x27
#define Qt_Key_ParenLeft                          0x28
#define Qt_Key_ParenRight                         0x29
#define Qt_Key_Asterisk                           0x2a
#define Qt_Key_Plus                               0x2b
#define Qt_Key_Comma                              0x2c
#define Qt_Key_Minus                              0x2d
#define Qt_Key_Period                             0x2e
#define Qt_Key_Slash                              0x2f
#define Qt_Key_0                                  0x30
#define Qt_Key_1                                  0x31
#define Qt_Key_2                                  0x32
#define Qt_Key_3                                  0x33
#define Qt_Key_4                                  0x34
#define Qt_Key_5                                  0x35
#define Qt_Key_6                                  0x36
#define Qt_Key_7                                  0x37
#define Qt_Key_8                                  0x38
#define Qt_Key_9                                  0x39
#define Qt_Key_Colon                              0x3a
#define Qt_Key_Semicolon                          0x3b
#define Qt_Key_Less                               0x3c
#define Qt_Key_Equal                              0x3d
#define Qt_Key_Greater                            0x3e
#define Qt_Key_Question                           0x3f
#define Qt_Key_At                                 0x40
#define Qt_Key_A                                  0x41
#define Qt_Key_B                                  0x42
#define Qt_Key_C                                  0x43
#define Qt_Key_D                                  0x44
#define Qt_Key_E                                  0x45
#define Qt_Key_F                                  0x46
#define Qt_Key_G                                  0x47
#define Qt_Key_H                                  0x48
#define Qt_Key_I                                  0x49
#define Qt_Key_J                                  0x4a
#define Qt_Key_K                                  0x4b
#define Qt_Key_L                                  0x4c
#define Qt_Key_M                                  0x4d
#define Qt_Key_N                                  0x4e
#define Qt_Key_O                                  0x4f
#define Qt_Key_P                                  0x50
#define Qt_Key_Q                                  0x51
#define Qt_Key_R                                  0x52
#define Qt_Key_S                                  0x53
#define Qt_Key_T                                  0x54
#define Qt_Key_U                                  0x55
#define Qt_Key_V                                  0x56
#define Qt_Key_W                                  0x57
#define Qt_Key_X                                  0x58
#define Qt_Key_Y                                  0x59
#define Qt_Key_Z                                  0x5a
#define Qt_Key_BracketLeft                        0x5b
#define Qt_Key_Backslash                          0x5c
#define Qt_Key_BracketRight                       0x5d
#define Qt_Key_AsciiCircum                        0x5e
#define Qt_Key_Underscore                         0x5f
#define Qt_Key_QuoteLeft                          0x60
#define Qt_Key_BraceLeft                          0x7b
#define Qt_Key_Bar                                0x7c
#define Qt_Key_BraceRight                         0x7d
#define Qt_Key_AsciiTilde                         0x7e
#define Qt_Key_nobreakspace                       0x0a0
#define Qt_Key_exclamdown                         0x0a1
#define Qt_Key_cent                               0x0a2
#define Qt_Key_sterling                           0x0a3
#define Qt_Key_currency                           0x0a4
#define Qt_Key_yen                                0x0a5
#define Qt_Key_brokenbar                          0x0a6
#define Qt_Key_section                            0x0a7
#define Qt_Key_diaeresis                          0x0a8
#define Qt_Key_copyright                          0x0a9
#define Qt_Key_ordfeminine                        0x0aa
#define Qt_Key_guillemotleft                      0x0ab
#define Qt_Key_notsign                            0x0ac
#define Qt_Key_hyphen                             0x0ad
#define Qt_Key_registered                         0x0ae
#define Qt_Key_macron                             0x0af
#define Qt_Key_degree                             0x0b0
#define Qt_Key_plusminus                          0x0b1
#define Qt_Key_twosuperior                        0x0b2
#define Qt_Key_threesuperior                      0x0b3
#define Qt_Key_acute                              0x0b4
#define Qt_Key_mu                                 0x0b5
#define Qt_Key_paragraph                          0x0b6
#define Qt_Key_periodcentered                     0x0b7
#define Qt_Key_cedilla                            0x0b8
#define Qt_Key_onesuperior                        0x0b9
#define Qt_Key_masculine                          0x0ba
#define Qt_Key_guillemotright                     0x0bb
#define Qt_Key_onequarter                         0x0bc
#define Qt_Key_onehalf                            0x0bd
#define Qt_Key_threequarters                      0x0be
#define Qt_Key_questiondown                       0x0bf
#define Qt_Key_Agrave                             0x0c0
#define Qt_Key_Aacute                             0x0c1
#define Qt_Key_Acircumflex                        0x0c2
#define Qt_Key_Atilde                             0x0c3
#define Qt_Key_Adiaeresis                         0x0c4
#define Qt_Key_Aring                              0x0c5
#define Qt_Key_AE                                 0x0c6
#define Qt_Key_Ccedilla                           0x0c7
#define Qt_Key_Egrave                             0x0c8
#define Qt_Key_Eacute                             0x0c9
#define Qt_Key_Ecircumflex                        0x0ca
#define Qt_Key_Ediaeresis                         0x0cb
#define Qt_Key_Igrave                             0x0cc
#define Qt_Key_Iacute                             0x0cd
#define Qt_Key_Icircumflex                        0x0ce
#define Qt_Key_Idiaeresis                         0x0cf
#define Qt_Key_ETH                                0x0d0
#define Qt_Key_Ntilde                             0x0d1
#define Qt_Key_Ograve                             0x0d2
#define Qt_Key_Oacute                             0x0d3
#define Qt_Key_Ocircumflex                        0x0d4
#define Qt_Key_Otilde                             0x0d5
#define Qt_Key_Odiaeresis                         0x0d6
#define Qt_Key_multiply                           0x0d7
#define Qt_Key_Ooblique                           0x0d8
#define Qt_Key_Ugrave                             0x0d9
#define Qt_Key_Uacute                             0x0da
#define Qt_Key_Ucircumflex                        0x0db
#define Qt_Key_Udiaeresis                         0x0dc
#define Qt_Key_Yacute                             0x0dd
#define Qt_Key_THORN                              0x0de
#define Qt_Key_ssharp                             0x0df
#define Qt_Key_division                           0x0f7
#define Qt_Key_ydiaeresis                         0x0ff
#define Qt_Key_Multi_key                          0x01001120
#define Qt_Key_Codeinput                          0x01001137
#define Qt_Key_SingleCandidate                    0x0100113c
#define Qt_Key_MultipleCandidate                  0x0100113d
#define Qt_Key_PreviousCandidate                  0x0100113e
#define Qt_Key_Mode_switch                        0x0100117e
#define Qt_Key_Kanji                              0x01001121
#define Qt_Key_Muhenkan                           0x01001122
#define Qt_Key_Henkan                             0x01001123
#define Qt_Key_Romaji                             0x01001124
#define Qt_Key_Hiragana                           0x01001125
#define Qt_Key_Katakana                           0x01001126
#define Qt_Key_Hiragana_Katakana                  0x01001127
#define Qt_Key_Zenkaku                            0x01001128
#define Qt_Key_Hankaku                            0x01001129
#define Qt_Key_Zenkaku_Hankaku                    0x0100112a
#define Qt_Key_Touroku                            0x0100112b
#define Qt_Key_Massyo                             0x0100112c
#define Qt_Key_Kana_Lock                          0x0100112d
#define Qt_Key_Kana_Shift                         0x0100112e
#define Qt_Key_Eisu_Shift                         0x0100112f
#define Qt_Key_Eisu_toggle                        0x01001130
#define Qt_Key_Hangul                             0x01001131
#define Qt_Key_Hangul_Start                       0x01001132
#define Qt_Key_Hangul_End                         0x01001133
#define Qt_Key_Hangul_Hanja                       0x01001134
#define Qt_Key_Hangul_Jamo                        0x01001135
#define Qt_Key_Hangul_Romaja                      0x01001136
#define Qt_Key_Hangul_Jeonja                      0x01001138
#define Qt_Key_Hangul_Banja                       0x01001139
#define Qt_Key_Hangul_PreHanja                    0x0100113a
#define Qt_Key_Hangul_PostHanja                   0x0100113b
#define Qt_Key_Hangul_Special                     0x0100113f
#define Qt_Key_Dead_Grave                         0x01001250
#define Qt_Key_Dead_Acute                         0x01001251
#define Qt_Key_Dead_Circumflex                    0x01001252
#define Qt_Key_Dead_Tilde                         0x01001253
#define Qt_Key_Dead_Macron                        0x01001254
#define Qt_Key_Dead_Breve                         0x01001255
#define Qt_Key_Dead_Abovedot                      0x01001256
#define Qt_Key_Dead_Diaeresis                     0x01001257
#define Qt_Key_Dead_Abovering                     0x01001258
#define Qt_Key_Dead_Doubleacute                   0x01001259
#define Qt_Key_Dead_Caron                         0x0100125a
#define Qt_Key_Dead_Cedilla                       0x0100125b
#define Qt_Key_Dead_Ogonek                        0x0100125c
#define Qt_Key_Dead_Iota                          0x0100125d
#define Qt_Key_Dead_Voiced_Sound                  0x0100125e
#define Qt_Key_Dead_Semivoiced_Sound              0x0100125f
#define Qt_Key_Dead_Belowdot                      0x01001260
#define Qt_Key_Dead_Hook                          0x01001261
#define Qt_Key_Dead_Horn                          0x01001262
#define Qt_Key_Back                               0x01000061
#define Qt_Key_Forward                            0x01000062
#define Qt_Key_Stop                               0x01000063
#define Qt_Key_Refresh                            0x01000064
#define Qt_Key_VolumeDown                         0x01000070
#define Qt_Key_VolumeMute                         0x01000071
#define Qt_Key_VolumeUp                           0x01000072
#define Qt_Key_BassBoost                          0x01000073
#define Qt_Key_BassUp                             0x01000074
#define Qt_Key_BassDown                           0x01000075
#define Qt_Key_TrebleUp                           0x01000076
#define Qt_Key_TrebleDown                         0x01000077
#define Qt_Key_MediaPlay                          0x01000080     // A key setting the state of the media player to play
#define Qt_Key_MediaStop                          0x01000081     // A key setting the state of the media player to stop
#define Qt_Key_MediaPrevious                      0x01000082
#define Qt_Key_MediaNext                          0x01000083
#define Qt_Key_MediaRecord                        0x01000084
#define Qt_Key_MediaPause                         0x1000085      // A key setting the state of the media player to pause (
#define Qt_Key_MediaTogglePlayPause               0x1000086      // A key to toggle the play/pause state in the media player (rather than setting an absolute state)
#define Qt_Key_HomePage                           0x01000090
#define Qt_Key_Favorites                          0x01000091
#define Qt_Key_Search                             0x01000092
#define Qt_Key_Standby                            0x01000093
#define Qt_Key_OpenUrl                            0x01000094
#define Qt_Key_LaunchMail                         0x010000a0
#define Qt_Key_LaunchMedia                        0x010000a1
#define Qt_Key_Launch0                            0x010000a2     // On X11 this key is mapped to "My Computer" (XF86XK_MyComputer) key for legacy reasons.
#define Qt_Key_Launch1                            0x010000a3     // On X11 this key is mapped to "Calculator" (XF86XK_Calculator) key for legacy reasons.
#define Qt_Key_Launch2                            0x010000a4     // On X11 this key is mapped to XF86XK_Launch0 key for legacy reasons.
#define Qt_Key_Launch3                            0x010000a5     // On X11 this key is mapped to XF86XK_Launch1 key for legacy reasons.
#define Qt_Key_Launch4                            0x010000a6     // On X11 this key is mapped to XF86XK_Launch2 key for legacy reasons.
#define Qt_Key_Launch5                            0x010000a7     // On X11 this key is mapped to XF86XK_Launch3 key for legacy reasons.
#define Qt_Key_Launch6                            0x010000a8     // On X11 this key is mapped to XF86XK_Launch4 key for legacy reasons.
#define Qt_Key_Launch7                            0x010000a9     // On X11 this key is mapped to XF86XK_Launch5 key for legacy reasons.
#define Qt_Key_Launch8                            0x010000aa     // On X11 this key is mapped to XF86XK_Launch6 key for legacy reasons.
#define Qt_Key_Launch9                            0x010000ab     // On X11 this key is mapped to XF86XK_Launch7 key for legacy reasons.
#define Qt_Key_LaunchA                            0x010000ac     // On X11 this key is mapped to XF86XK_Launch8 key for legacy reasons.
#define Qt_Key_LaunchB                            0x010000ad     // On X11 this key is mapped to XF86XK_Launch9 key for legacy reasons.
#define Qt_Key_LaunchC                            0x010000ae     // On X11 this key is mapped to XF86XK_LaunchA key for legacy reasons.
#define Qt_Key_LaunchD                            0x010000af     // On X11 this key is mapped to XF86XK_LaunchB key for legacy reasons.
#define Qt_Key_LaunchE                            0x010000b0     // On X11 this key is mapped to XF86XK_LaunchC key for legacy reasons.
#define Qt_Key_LaunchF                            0x010000b1     // On X11 this key is mapped to XF86XK_LaunchD key for legacy reasons.
#define Qt_Key_LaunchG                            0x0100010e     // On X11 this key is mapped to XF86XK_LaunchE key for legacy reasons.
#define Qt_Key_LaunchH                            0x0100010f     // On X11 this key is mapped to XF86XK_LaunchF key for legacy reasons.
#define Qt_Key_MonBrightnessUp                    0x010000b2
#define Qt_Key_MonBrightnessDown                  0x010000b3
#define Qt_Key_KeyboardLightOnOff                 0x010000b4
#define Qt_Key_KeyboardBrightnessUp               0x010000b5
#define Qt_Key_KeyboardBrightnessDown             0x010000b6
#define Qt_Key_PowerOff                           0x010000b7
#define Qt_Key_WakeUp                             0x010000b8
#define Qt_Key_Eject                              0x010000b9
#define Qt_Key_ScreenSaver                        0x010000ba
#define Qt_Key_WWW                                0x010000bb
#define Qt_Key_Memo                               0x010000bc
#define Qt_Key_LightBulb                          0x010000bd
#define Qt_Key_Shop                               0x010000be
#define Qt_Key_History                            0x010000bf
#define Qt_Key_AddFavorite                        0x010000c0
#define Qt_Key_HotLinks                           0x010000c1
#define Qt_Key_BrightnessAdjust                   0x010000c2
#define Qt_Key_Finance                            0x010000c3
#define Qt_Key_Community                          0x010000c4
#define Qt_Key_AudioRewind                        0x010000c5
#define Qt_Key_BackForward                        0x010000c6
#define Qt_Key_ApplicationLeft                    0x010000c7
#define Qt_Key_ApplicationRight                   0x010000c8
#define Qt_Key_Book                               0x010000c9
#define Qt_Key_CD                                 0x010000ca
#define Qt_Key_Calculator                         0x010000cb     // On X11 this key is not mapped for legacy reasons. Use #define Qt_Key_Launch1 instead.
#define Qt_Key_ToDoList                           0x010000cc
#define Qt_Key_ClearGrab                          0x010000cd
#define Qt_Key_Close                              0x010000ce
#define Qt_Key_Copy                               0x010000cf
#define Qt_Key_Cut                                0x010000d0
#define Qt_Key_Display                            0x010000d1
#define Qt_Key_DOS                                0x010000d2
#define Qt_Key_Documents                          0x010000d3
#define Qt_Key_Excel                              0x010000d4
#define Qt_Key_Explorer                           0x010000d5
#define Qt_Key_Game                               0x010000d6
#define Qt_Key_Go                                 0x010000d7
#define Qt_Key_iTouch                             0x010000d8
#define Qt_Key_LogOff                             0x010000d9
#define Qt_Key_Market                             0x010000da
#define Qt_Key_Meeting                            0x010000db
#define Qt_Key_MenuKB                             0x010000dc
#define Qt_Key_MenuPB                             0x010000dd
#define Qt_Key_MySites                            0x010000de
#define Qt_Key_News                               0x010000df
#define Qt_Key_OfficeHome                         0x010000e0
#define Qt_Key_Option                             0x010000e1
#define Qt_Key_Paste                              0x010000e2
#define Qt_Key_Phone                              0x010000e3
#define Qt_Key_Calendar                           0x010000e4
#define Qt_Key_Reply                              0x010000e5
#define Qt_Key_Reload                             0x010000e6
#define Qt_Key_RotateWindows                      0x010000e7
#define Qt_Key_RotationPB                         0x010000e8
#define Qt_Key_RotationKB                         0x010000e9
#define Qt_Key_Save                               0x010000ea
#define Qt_Key_Send                               0x010000eb
#define Qt_Key_Spell                              0x010000ec
#define Qt_Key_SplitScreen                        0x010000ed
#define Qt_Key_Support                            0x010000ee
#define Qt_Key_TaskPane                           0x010000ef
#define Qt_Key_Terminal                           0x010000f0
#define Qt_Key_Tools                              0x010000f1
#define Qt_Key_Travel                             0x010000f2
#define Qt_Key_Video                              0x010000f3
#define Qt_Key_Word                               0x010000f4
#define Qt_Key_Xfer                               0x010000f5
#define Qt_Key_ZoomIn                             0x010000f6
#define Qt_Key_ZoomOut                            0x010000f7
#define Qt_Key_Away                               0x010000f8
#define Qt_Key_Messenger                          0x010000f9
#define Qt_Key_WebCam                             0x010000fa
#define Qt_Key_MailForward                        0x010000fb
#define Qt_Key_Pictures                           0x010000fc
#define Qt_Key_Music                              0x010000fd
#define Qt_Key_Battery                            0x010000fe
#define Qt_Key_Bluetooth                          0x010000ff
#define Qt_Key_WLAN                               0x01000100
#define Qt_Key_UWB                                0x01000101
#define Qt_Key_AudioForward                       0x01000102
#define Qt_Key_AudioRepeat                        0x01000103
#define Qt_Key_AudioRandomPlay                    0x01000104
#define Qt_Key_Subtitle                           0x01000105
#define Qt_Key_AudioCycleTrack                    0x01000106
#define Qt_Key_Time                               0x01000107
#define Qt_Key_Hibernate                          0x01000108
#define Qt_Key_View                               0x01000109
#define Qt_Key_TopMenu                            0x0100010a
#define Qt_Key_PowerDown                          0x0100010b
#define Qt_Key_Suspend                            0x0100010c
#define Qt_Key_ContrastAdjust                     0x0100010d
#define Qt_Key_TouchpadToggle                     0x01000110
#define Qt_Key_TouchpadOn                         0x01000111
#define Qt_Key_TouchpadOff                        0x01000112
#define Qt_Key_MicMute                            0x01000113
#define Qt_Key_Red                                0x01000114
#define Qt_Key_Green                              0x01000115
#define Qt_Key_Yellow                             0x01000116
#define Qt_Key_Blue                               0x01000117
#define Qt_Key_ChannelUp                          0x01000118
#define Qt_Key_ChannelDown                        0x01000119
#define Qt_Key_MediaLast                          0x0100ffff
#define Qt_Key_unknown                            0x01ffffff
#define Qt_Key_Call                               0x01100004     // A key to answer or initiate a call (see #define Qt_Key_ToggleCallHangup for a key to toggle current call state)
#define Qt_Key_Camera                             0x01100020     // A key to activate the camera shutter
#define Qt_Key_CameraFocus                        0x01100021     // A key to focus the camera
#define Qt_Key_Context1                           0x01100000
#define Qt_Key_Context2                           0x01100001
#define Qt_Key_Context3                           0x01100002
#define Qt_Key_Context4                           0x01100003
#define Qt_Key_Flip                               0x01100006
#define Qt_Key_Hangup                             0x01100005     // A key to end an ongoing call (see #define Qt_Key_ToggleCallHangup for a key to toggle current call state)
#define Qt_Key_No                                 0x01010002
#define Qt_Key_Select                             0x01010000
#define Qt_Key_Yes                                0x01010001
#define Qt_Key_ToggleCallHangup                   0x01100007     // A key to toggle the current call state (ie. either answer, or hangup) depending on current call state
#define Qt_Key_VoiceDial                          0x01100008
#define Qt_Key_LastNumberRedial                   0x01100009
#define Qt_Key_Execute                            0x01020003
#define Qt_Key_Printer                            0x01020002
#define Qt_Key_Play                               0x01020005
#define Qt_Key_Sleep                              0x01020004
#define Qt_Key_Zoom                               0x01020006
#define Qt_Key_Cancel                             0x01020001

#define Qt_NoModifier                             0x00000000   // No modifier key is pressed.
#define Qt_ShiftModifier                          0x02000000   // A Shift key on the keyboard is pressed.
#define Qt_ControlModifier                        0x04000000   // A Ctrl key on the keyboard is pressed.
#define Qt_AltModifier                            0x08000000   // An Alt key on the keyboard is pressed.
#define Qt_MetaModifier                           0x10000000   // A Meta key on the keyboard is pressed.
#define Qt_KeypadModifier                         0x20000000   // A keypad button is pressed.
#define Qt_GroupSwitchModifier                    0x40000000   // X11 only. A Mode_switch key on the keyboard is pressed.

// enum #define Qt_LayoutDirection
// Specifies the direction of Qt's layouts:
//
#define Qt_LeftToRight                            0    // Left-to-right layout.
#define Qt_RightToLeft                            1    // Right-to-left layout.
// Right-to-left layouts are necessary for certain languages, notably Arabic and Hebrew.
// See also QApplication_setLayoutDirection() and QWidget_setLayoutDirection().

// enum #define Qt_MaskMode
// This enum specifies the behavior of the QPixmap_createMaskFromColor() and QImage_createMaskFromColor() functions.
//
#define Qt_MaskInColor                            0    // Creates a mask where all pixels matching the given color are opaque.
#define Qt_MaskOutColor                           1    // Creates a mask where all pixels matching the given color are transparent.

// enum #define Qt_MatchFlag
// flags #define Qt_MatchFlags
// This enum describes the type of matches that can be used when searching for items in a model.
//
#define Qt_MatchExactly                           0    // Performs QVariant-based matching.
#define Qt_MatchFixedString                       8    // Performs string-based matching. String-based comparisons are case-insensitive unless the MatchCaseSensitive flag is also specified.
#define Qt_MatchContains                          1    // The search term is contained in the item.
#define Qt_MatchStartsWith                        2    // The search term matches the start of the item.
#define Qt_MatchEndsWith                          3    // The search term matches the end of the item.
#define Qt_MatchCaseSensitive                     16   // The search is case sensitive.
#define Qt_MatchRegExp                            4    // Performs string-based matching using a regular expression as the search term.
#define Qt_MatchWildcard                          5    // Performs string-based matching using a string with wildcards as the search term.
#define Qt_MatchWrap                              32   // Perform a search that wraps around, so that when the search reaches the last item in the model, it begins again at the first item and continues until all items have been examined.
#define Qt_MatchRecursive                         64   // Searches the entire hierarchy.

// enum #define Qt_Modifier
// This enum provides shorter names for the keyboard modifier keys supported by Qt.
// Note: On Mac OS X, the CTRL value corresponds to the Command keys on the Macintosh keyboard, and the META value corresponds to the Control keys.
//
#define Qt_SHIFT                                  Qt_ShiftModifier     // The Shift keys provided on all standard keyboards.
#define Qt_META                                   Qt_MetaModifier      // The Meta keys.
#define Qt_CTRL                                   Qt_ControlModifier   // The Ctrl keys.
#define Qt_ALT                                    Qt_AltModifier       // The normal Alt keys, but not keys like AltGr.
#define Qt_UNICODE_ACCEL                          0x00000000           // The shortcut is specified as a Unicode code point, not as a Qt Key.

// enum #define Qt_Orientation
// flags #define Qt_Orientations
// This type is used to signify an object's orientation.
//
#define Qt_Horizontal                             0x1
#define Qt_Vertical                               0x2

// enum #define Qt_PenCapStyle
// This enum type defines the pen cap styles supported by Qt, i.e. the line end caps that can be drawn using QPainter.
//
#define Qt_FlatCap                                0x00  // a square line end that does not cover the end point of the line.
#define Qt_SquareCap                              0x10  // a square line end that covers the end point and extends beyond it by half the line width.
#define Qt_RoundCap                               0x20  // a rounded line end.

// enum #define Qt_PenJoinStyle
// This enum type defines the pen join styles supported by Qt, i.e. which joins between two connected lines can be drawn using QPainter.
//
#define Qt_MiterJoin                              0x00  // The outer edges of the lines are extended to meet at an angle, and this area is filled.
#define Qt_BevelJoin                              0x40  // The triangular notch between the two lines is filled.
#define Qt_RoundJoin                              0x80  // A circular arc between the two lines is filled.
#define Qt_SvgMiterJoin                           0x100 // A miter join corresponding to the definition of a miter join in the SVG 1.2 Tiny specification.

// enum #define Qt_PenStyle
// This enum type defines the pen styles that can be drawn using QPainter. The styles are:
//
#define Qt_NoPen                                  0     // no line at all. For example, QPainter_drawRect() fills but does not draw any boundary line.
#define Qt_SolidLine                              1     // A plain line.
#define Qt_DashLine                               2     // Dashes separated by a few pixels.
#define Qt_DotLine                                3     // Dots separated by a few pixels.
#define Qt_DashDotLine                            4     // Alternate dots and dashes.
#define Qt_DashDotDotLine                         5     // One dash, two dots, one dash, two dots.
#define Qt_CustomDashLine                         6     // A custom pattern defined using QPainterPathStroker_setDashPattern().

// enum #define Qt_ScrollBarPolicy
// This enum type describes the various modes of QAbstractScrollArea's scroll bars.
//
#define Qt_ScrollBarAsNeeded                      0     // QAbstractScrollArea shows a scroll bar when the content is too large to fit and not otherwise. This is the default.
#define Qt_ScrollBarAlwaysOff                     1     // QAbstractScrollArea never shows a scroll bar.
#define Qt_ScrollBarAlwaysOn                      2     // QAbstractScrollArea always shows a scroll bar.

// enum #define Qt_ShortcutContext
// For a QEvent_Shortcut event to occur, the shortcut's key sequence must be entered by the user in a context where the shortcut is active. The possible contexts are these:
//
#define Qt_WidgetShortcut                         0     // The shortcut is active when its parent widget has focus.
#define Qt_WidgetWithChildrenShortcut             3     // The shortcut is active when its parent widget, or any of its children has focus. Children which are top-level widgets, except pop-ups, are not affected by this shortcut context.
#define Qt_WindowShortcut                         1     // The shortcut is active when its parent widget is a logical subwidget of the active top-level window.
#define Qt_ApplicationShortcut                    2     // The shortcut is active when one of the applications windows are active.

// enum #define Qt_SizeHint
// This enum is used by QGraphicsLayoutItem_sizeHint()
//
#define Qt_MinimumSize                            0     // is used to specify the minimum size of a graphics layout item.
#define Qt_PreferredSize                          1     // is used to specify the preferred size of a graphics layout item.
#define Qt_MaximumSize                            2     // is used to specify the maximum size of a graphics layout item.
#define Qt_MinimumDescent                         3     // is used to specify the minimum descent of a text string in a graphics layout item.

// enum #define Qt_SizeMode
// This enum is used by QPainter_drawRoundedRect() and QPainterPath_addRoundedRect() functions to specify the radii of rectangle corners with respect to the dimensions of the bounding rectangles specified.
//
#define Qt_AbsoluteSize                           0     // Specifies the size using absolute measurements.
#define Qt_RelativeSize                           1     // Specifies the size relative to the bounding rectangle, typically using percentage measurements.

// enum #define Qt_SortOrder
// This enum describes how the items in a widget are sorted.
//
#define Qt_AscendingOrder                         0     // The items are sorted ascending e.g. starts with 'AAA' ends with 'ZZZ' in Latin-1 locales
#define Qt_DescendingOrder                        1     // The items are sorted descending e.g. starts with 'ZZZ' ends with 'AAA' in Latin-1 locales

// enum #define Qt_TextElideMode
// This enum specifies where the ellipsis should appear when displaying texts that don't fit:
//
#define Qt_ElideLeft                              0     // The ellipsis should appear at the beginning of the text.
#define Qt_ElideRight                             1     // The ellipsis should appear at the end of the text.
#define Qt_ElideMiddle                            2     // The ellipsis should appear in the middle of the text.
#define Qt_ElideNone                              3     // Ellipsis should NOT appear in the text.
// #define Qt_ElideMiddle is normally the most appropriate choice for URLs (e.g., "http://www.qtsof...ovingto/beijing/"), whereas #define Qt_ElideRight is appropriate for other strings (e.g., "Deploying Applications on Ma...").

// enum #define Qt_TextFlag
// This enum type is used to define some modifier flags. Some of these flags only make sense in the context of printing:
//
#define Qt_TextSingleLine                         0x0100   // Treats all whitespace as spaces and prints just one line.
#define Qt_TextDontClip                           0x0200   // If it's impossible to stay within the given bounds, it prints outside.
#define Qt_TextExpandTabs                         0x0400   // Makes the U+0009 (ASCII tab) character move to the next tab stop.
#define Qt_TextShowMnemonic                       0x0800   // Displays the string "&P" as P (see QButton for an example). For an ampersand, use "&&".
#define Qt_TextWordWrap                           0x1000   // Breaks lines at appropriate points, e.g. at word boundaries.
#define Qt_TextWrapAnywhere                       0x2000   // Breaks lines anywhere, even within words.
#define Qt_TextHideMnemonic                       0x8000   // Same as #define Qt_TextShowMnemonic but doesn't draw the underlines.
#define Qt_TextDontPrint                          0x4000   // Treat this text as "hidden" and don't print it.
#define Qt_IncludeTrailingSpaces                  Qt_TextIncludeTrailingSpaces   // When this option is set, QTextLine_naturalTextWidth() and naturalTextRect() will return a value that includes the width of trailing spaces in the text; otherwise this width is excluded.
#define Qt_TextIncludeTrailingSpaces              0x08000000 // Same as IncludeTrailingSpaces
#define Qt_TextJustificationForced                0x10000    // Ensures that text lines are justified.
// You can use as many modifier flags as you want, except that #define Qt_TextSingleLine and #define Qt_TextWordWrap cannot be combined.
// Flags that are inappropriate for a given use are generally ignored.

// enum #define Qt_TextFormat
// This enum is used in widgets that can display both plain text and rich text, e.g. QLabel. It is used for deciding whether a text string should be interpreted as one or the other. This is normally done by passing one of the enum values to a setTextFormat() function.
//
#define Qt_PlainText                              0     // The text string is interpreted as a plain text string.
#define Qt_RichText                               1     // The text string is interpreted as a rich text string.
#define Qt_AutoText                               2     // The text string is interpreted as for #define Qt_RichText if #define Qt_mightBeRichText() returns true, otherwise as #define Qt_PlainText.
#define Qt_LogText                                3     // A special, limited text format which is only used by Q3TextEdit in an optimized mode.

// enum #define Qt_TextInteractionFlag
// flags #define Qt_TextInteractionFlags
// This enum specifies how a text displaying widget reacts to user input.
//
#define Qt_NoTextInteraction                      0     // No interaction with the text is possible.
#define Qt_TextSelectableByMouse                  1     // Text can be selected with the mouse and copied to the clipboard using a context menu or standard keyboard shortcuts.
#define Qt_TextSelectableByKeyboard               2     // Text can be selected with the cursor keys on the keyboard. A text cursor is shown.
#define Qt_LinksAccessibleByMouse                 4     // Links can be highlighted and activated with the mouse.
#define Qt_LinksAccessibleByKeyboard              8     // Links can be focused using tab and activated with enter.
#define Qt_TextEditable                           16    // The text is fully editable.
#define Qt_TextEditorInteraction                  hb_bitOR( Qt_TextSelectableByMouse, Qt_TextSelectableByKeyboard, Qt_TextEditable )             // The default for a text editor.
#define Qt_TextBrowserInteraction                 hb_bitOR( Qt_TextSelectableByMouse, Qt_LinksAccessibleByMouse, Qt_LinksAccessibleByKeyboard )  // The default for QTextBrowser.

// enum #define Qt_TimeSpec
//
#define Qt_LocalTime                              0     // Locale dependent time (Timezones and Daylight Savings Time).
#define Qt_UTC                                    1     // Coordinated Universal Time, replaces Greenwich Mean Time.
#define Qt_OffsetFromUTC                          2     // An offset in seconds from Coordinated Universal Time.

// enum #define Qt_ToolBarArea
// flags #define Qt_ToolBarAreas
//
#define Qt_LeftToolBarArea                        0x1
#define Qt_RightToolBarArea                       0x2
#define Qt_TopToolBarArea                         0x4
#define Qt_BottomToolBarArea                      0x8
#define Qt_AllToolBarAreas                        hb_bitOR( Qt_LeftToolBarArea, Qt_RightToolBarArea, Qt_TopToolBarArea, Qt_BottomToolBarArea )
#define Qt_NoToolBarArea                          0

// enum #define Qt_ToolButtonStyle
// The style of the tool button, describing how the button's text and icon should be displayed.
//
#define Qt_ToolButtonIconOnly                     0     // Only display the icon.
#define Qt_ToolButtonTextOnly                     1     // Only display the text.
#define Qt_ToolButtonTextBesideIcon               2     // The text appears beside the icon.
#define Qt_ToolButtonTextUnderIcon                3     // The text appears under the icon.
#define Qt_ToolButtonFollowStyle                  4     // Follow style

// enum #define Qt_TransformationMode
// This enum type defines whether image transformations (e.g., scaling) should be smooth or not.
//
#define Qt_FastTransformation                     0     // The transformation is performed quickly, with no smoothing.
#define Qt_SmoothTransformation                   1     // The resulting image is transformed using bilinear filtering.

// enum #define Qt_UIEffect
// This enum describes the available UI effects.
// By default, Qt will try to use the platform specific desktop settings for each effect. Use the QApplication_setDesktopSettingsAware() function (passing false as argument) to prevent this, and the QApplication_setEffectEnabled() to enable or disable a particular effect.
// Note that all effects are disabled on screens running at less than 16-bit color depth.
//
#define Qt_UI_AnimateMenu                         1     // Show animated menus.
#define Qt_UI_FadeMenu                            2     // Show faded menus.
#define Qt_UI_AnimateCombo                        3     // Show animated comboboxes.
#define Qt_UI_AnimateTooltip                      4     // Show tooltip animations.
#define Qt_UI_FadeTooltip                         5     // Show tooltip fading effects.
#define Qt_UI_AnimateToolBox                      6     // Reserved

// enum #define Qt_WhiteSpaceMode
// This enum describes the types of whitespace mode that are used by the QTextDocument class to meet the requirements of different kinds of textual information.
//
#define Qt_WhiteSpaceNormal                       0     // The whitespace mode used to display normal word wrapped text in paragraphs.
#define Qt_WhiteSpacePre                          1     // A preformatted text mode in which whitespace is reproduced exactly.
#define Qt_WhiteSpaceNoWrap                       2

// enum #define Qt_WidgetAttribute
// This enum type is used to specify various widget attributes. Attributes are set and cleared with QWidget_setAttribute(), and queried with QWidget_testAttribute(), although some have special convenience functions which are mentioned below.
//
#define Qt_WA_AcceptDrops                         78    // Allows data from drag and drop operations to be dropped onto the widget (see QWidget_setAcceptDrops()).
#define Qt_WA_AlwaysShowToolTips                  84    // Enables tooltips for inactive windows.
#define Qt_WA_ContentsPropagated                  3     // This flag is superfluous and obsolete; it no longer has any effect. Since Qt 4.1, all widgets that do not set WA_PaintOnScreen propagate their contents.
#define Qt_WA_CustomWhatsThis                     47    // Indicates that the widget wants to continue operating normally in "What's This?" mode. This is set by the widget's author.
#define Qt_WA_DeleteOnClose                       55    // Makes Qt delete this widget when the widget has accepted the close event (see QWidget_closeEvent()).
#define Qt_WA_Disabled                            0     // Indicates that the widget is disabled, i.e. it does not receive any mouse or keyboard events. There is also a getter functions QWidget_isEnabled(). This is set/cleared by the Qt kernel.
#define Qt_WA_ForceDisabled                       32    // Indicates that the widget is explicitly disabled, i.e. it will remain disabled even when all its ancestors are set to the enabled state. This implies WA_Disabled. This is set/cleared by QWidget_setEnabled() and QWidget_setDisabled().
#define Qt_WA_ForceUpdatesDisabled                59    // Indicates that updates are explicitly disabled for the widget; i.e. it will remain disabled even when all its ancestors are set to the updates-enabled state. This implies WA_UpdatesDisabled. This is set/cleared by QWidget_setUpdatesEnabled().
#define Qt_WA_GroupLeader                         72    // This attribute has been deprecated. Use QWidget_windowModality instead.
#define Qt_WA_Hover                               74    // Forces Qt to generate paint events when the mouse enters or leaves the widget. This feature is typically used when implementing custom styles; see the Styles example for details.
#define Qt_WA_InputMethodEnabled                  14    // Enables input methods for Asian languages. Must be set when creating custom text editing widgets. On Windows CE this flag can be used in addition to QApplication_autoSipEnabled to automatically display the SIP when entering a widget.
#define Qt_WA_KeyboardFocusChange                 77    // Set on a toplevel window when the users changes focus with the keyboard (tab, backtab, or shortcut).
#define Qt_WA_KeyCompression                      33    // Enables key event compression if set, and disables it if not set. By default key compression is off, so widgets receive one key press event for each key press (or more, since autorepeat is usually on). If you turn it on and your program doesn't keep up with key input, Qt may try to compress key events so that more than one character can be processed in each event. For example, a word processor widget might receive 2, 3 or more characters in each QKeyEvent_text(), if the layout recalculation takes too long for the CPU. If a widget supports multiple character unicode input, it is always safe to turn the compression on. Qt performs key event compression only for printable characters. #define Qt_Modifier keys, cursor movement keys, function keys and miscellaneous action keys (e.g. Escape, Enter, Backspace, PrintScreen) will stop key event compression, even if there are more compressible key events available. Platforms other than Mac and X11 do not support this compression, in which case turning it on will have no effect. This is set/cleared by the widget's author.
#define Qt_WA_LayoutOnEntireRect                  48    // Indicates that the widget wants QLayout to operate on the entire QWidget_rect(), not only on QWidget_contentsRect(). This is set by the widget's author.
#define Qt_WA_LayoutUsesWidgetRect                92    // Ignore the layout item rect from the style when laying out this widget with QLayout. This makes a difference in QMacStyle and QPlastiqueStyle for some widgets.
#define Qt_WA_MacNoClickThrough                   12    // When a widget that has this attribute set is clicked, and its window is inactive, the click will make the window active but won't be seen by the widget. Typical use of this attribute is on widgets with "destructive" actions, such as a "Delete" button. WA_MacNoClickThrough also applies to all child widgets of the widget that has it set.
#define Qt_WA_MacOpaqueSizeGrip                   85    // Indicates that the native Carbon size grip should be opaque instead of transparent (the default). This attribute is only applicable to Mac OS X and is set by the widget's author.
#define Qt_WA_MacShowFocusRect                    88    // Indicates that this widget should get a QFocusFrame around it. Some widgets draw their own focus halo regardless of this attribute. Not that the QWidget_focusPolicy also plays the main role in whether something is given focus or not, this only controls whether or not this gets the focus frame. This attribute is only applicable to Mac OS X.
#define Qt_WA_MacNormalSize                       89    // Indicates the widget should have the normal size for widgets in Mac OS X. This attribute is only applicable to Mac OS X.
#define Qt_WA_MacSmallSize                        90    // Indicates the widget should have the small size for widgets in Mac OS X. This attribute is only applicable to Mac OS X.
#define Qt_WA_MacMiniSize                         91    // Indicates the widget should have the mini size for widgets in Mac OS X. This attribute is only applicable to Mac OS X.
#define Qt_WA_MacVariableSize                     102   // Indicates the widget can choose between alternative sizes for widgets to avoid clipping. This attribute is only applicable to Mac OS X.
#define Qt_WA_MacBrushedMetal                     46    // Indicates the widget should be drawn in the brushed metal style as supported by the windowing system. This attribute is only applicable to Mac OS X.
#define Qt_WA_Mapped                              11    // Indicates that the widget is mapped on screen. This is set/cleared by the Qt kernel.
#define Qt_WA_MouseNoMask                         71    // Makes the widget receive mouse events for the entire widget regardless of the currently set mask, overriding QWidget_setMask(). This is not applicable for top-level windows.
#define Qt_WA_MouseTracking                       2     // Indicates that the widget has mouse tracking enabled. See QWidget_mouseTracking.
#define Qt_WA_Moved                               43    // Indicates that the widget has an explicit position. This is set/cleared by QWidget_move() and by QWidget_setGeometry().
#define Qt_WA_MSWindowsUseDirect3D                94    // Makes drawing to a widget with this attribute set use the Direct3D paint engine, if the Direct3D paint engine is available. This functionality is experimental.
#define Qt_WA_NoBackground                        Qt_WA_OpaquePaintEvent   // This value is obsolete. Use WA_OpaquePaintEvent instead.
#define Qt_WA_NoChildEventsForParent              58    // Indicates that the widget does not want ChildAdded or ChildRemoved events sent to its parent. This is rarely necessary but can help to avoid automatic insertion widgets like splitters and layouts. This is set by a widget's author.
#define Qt_WA_NoChildEventsFromChildren           39    // Indicates that the widget does not want to receive ChildAdded or ChildRemoved events sent from its children. This is set by a widget's author.
#define Qt_WA_NoMouseReplay                       54    // Used for pop-up widgets. Indicates that the most recent mouse press event should not be replayed when the pop-up widget closes. The flag is set by the widget's author and cleared by the Qt kernel every time the widget receives a new mouse event.
#define Qt_WA_NoMousePropagation                  73    // Prohibits mouse events from being propagated to the widget's parent. This attribute is disabled by default.
#define Qt_WA_TransparentForMouseEvents           51    // When enabled, this attribute disables the delivery of mouse events to the widget and its children. Mouse events are delivered to other widgets as if the widget and its children were not present in the widget hierarchy; mouse clicks and other events effectively "pass through" them. This attribute is disabled by default.
#define Qt_WA_NoSystemBackground                  9     // Indicates that the widget has no background, i.e. when the widget receives paint events, the background is not automatically repainted. Note: Unlike WA_OpaquePaintEvent, newly exposed areas are never filled with the background (e.g., after showing a window for the first time the user can see "through" it until the application processes the paint events). This flag is set or cleared by the widget's author.
#define Qt_WA_OpaquePaintEvent                    4     // Indicates that the widget paints all its pixels when it receives a paint event. Thus, it is not required for operations like updating, resizing, scrolling and focus changes to erase the widget before generating paint events. The use of WA_OpaquePaintEvent provides a small optimization by helping to reduce flicker on systems that do not support double buffering and avoiding computational cycles necessary to erase the background prior to painting. Note: Unlike WA_NoSystemBackground, WA_OpaquePaintEvent makes an effort to avoid transparent window backgrounds. This flag is set or cleared by the widget's author.
#define Qt_WA_OutsideWSRange                      49    // Indicates that the widget is outside the valid range of the window system's coordinate system. A widget outside the valid range cannot be mapped on screen. This is set/cleared by the Qt kernel.
#define Qt_WA_PaintOnScreen                       8     // Indicates that the widget wants to draw directly onto the screen. Widgets with this attribute set do not participate in composition management, i.e. they cannot be semi-transparent or shine through semi-transparent overlapping widgets. Note: This flag is only supported on X11 and it disables double buffering. On Qt for Embedded Linux, the flag only works when set on a top-level widget and it relies on support from the active screen driver. This flag is set or cleared by the widget's author. To render outside of Qt's paint system, e.g., if you require native painting primitives, you need to reimplement QWidget_paintEngine() to return 0 and set this flag.
#define Qt_WA_PaintOutsidePaintEvent              13    // Makes it possible to use QPainter to paint on the widget outside paintEvent(). This flag is not supported on Windows, Mac OS X or Embedded Linux. We recommend that you use it only when porting Qt 3 code to Qt 4.
#define Qt_WA_PaintUnclipped                      52    // Makes all painters operating on this widget unclipped. Children of this widget or other widgets in front of it do not clip the area the painter can paint on. This flag is only supported for widgets with the WA_PaintOnScreen flag set. The preferred way to do this in a cross platform way is to create a transparent widget that lies in front of the other widgets.
#define Qt_WA_PendingMoveEvent                    34    // Indicates that a move event is pending, e.g., when a hidden widget was moved. This flag is set or cleared by the Qt kernel.
#define Qt_WA_PendingResizeEvent                  35    // Indicates that a resize event is pending, e.g., when a hidden widget was resized. This flag is set or cleared by the Qt kernel.
#define Qt_WA_QuitOnClose                         76    // Makes Qt quit the application when the last widget with the attribute set has accepted closeEvent(). This behavior can be modified with the QApplication_quitOnLastWindowClosed property. By default this attribute is set for all widgets of type #define Qt_Window.
#define Qt_WA_Resized                             42    // Indicates that the widget has an explicit size. This flag is set or cleared by QWidget_resize() and QWidget_setGeometry().
#define Qt_WA_RightToLeft                         56    // Indicates that the layout direction for the widget is right to left.
#define Qt_WA_SetCursor                           38    // Indicates that the widget has a cursor of its own. This flag is set or cleared by QWidget_setCursor() and QWidget_unsetCursor().
#define Qt_WA_SetFont                             37    // Indicates that the widget has a font of its own. This flag is set or cleared by QWidget_setFont().
#define Qt_WA_SetPalette                          36    // Indicates that the widget has a palette of its own. This flag is set or cleared by QWidget_setPalette().
#define Qt_WA_SetStyle                            86    // Indicates that the widget has a style of its own. This flag is set or cleared by QWidget_setStyle().
#define Qt_WA_ShowModal                           70    // This attribute has been deprecated. Use QWidget_windowModality instead.
#define Qt_WA_StaticContents                      5     // Indicates that the widget contents are north-west aligned and static. On resize, such a widget will receive paint events only for parts of itself that are newly visible. This flag is set or cleared by the widget's author.
#define Qt_WA_StyleSheet                          97    // Indicates that the widget is styled using a style sheet.
#define Qt_WA_TranslucentBackground               120   // Indicates that the widget should have a translucent background, i.e., any non-opaque regions of the widgets will be translucent because the widget will have an alpha channel. Setting this flag causes WA_NoSystemBackground to be set. This flag is set or cleared by the widget's author.
#define Qt_WA_UnderMouse                          1     // Indicates that the widget is under the mouse cursor. The value is not updated correctly during drag and drop operations. There is also a getter function, QWidget_underMouse(). This flag is set or cleared by the Qt kernel.
#define Qt_WA_UpdatesDisabled                     10    // Indicates that updates are blocked (including the system background). This flag is set or cleared by the Qt kernel.
// Warning: This flag must never be set or cleared by the widget's author.
#define Qt_WA_WindowModified                      41    // Indicates that the window is marked as modified. On some platforms this flag will do nothing, on others (including Mac OS X and Windows) the window will take a modified appearance. This flag is set or cleared by QWidget_setWindowModified().
#define Qt_WA_WindowPropagation                   80    // Makes a toplevel window inherit font and palette from its parent.
#define Qt_WA_MacAlwaysShowToolWindow             96    // On Mac OS X, show the tool window even when the application is not active. By default, all tool windows are hidden when the application is inactive.
#define Qt_WA_SetLocale                           87    // Indicates the locale should be taken into consideration in the widget.
#define Qt_WA_StyledBackground                    93    // Indicates the widget should be drawn using a styled background.
#define Qt_WA_ShowWithoutActivating               98    // Show the widget without making it active.
#define Qt_WA_NativeWindow                        100   // Indicates that a native window is created for the widget. Enabling this flag will also force a native window for the widget's ancestors unless #define Qt_WA_DontCreateNativeAncestors is set.
#define Qt_WA_DontCreateNativeAncestors           101   // Indicates that the widget's ancestors are kept non-native even though the widget itself is native.
#define Qt_WA_X11NetWmWindowTypeDesktop           104   // Adds _NET_WM_WINDOW_TYPE_DESKTOP to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms.
#define Qt_WA_X11NetWmWindowTypeDock              105   // Adds _NET_WM_WINDOW_TYPE_DOCK to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms.
#define Qt_WA_X11NetWmWindowTypeToolBar           106   // Adds _NET_WM_WINDOW_TYPE_TOOLBAR to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. Note: Qt automaticaly sets this attribute for QToolBar.
#define Qt_WA_X11NetWmWindowTypeMenu              107   // Adds _NET_WM_WINDOW_TYPE_MENU to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. Note: Qt automatically sets this attribute for QMenu when torn-off.
#define Qt_WA_X11NetWmWindowTypeUtility           108   // Adds _NET_WM_WINDOW_TYPE_UTILITY to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. Note: Qt automatically sets this attribute for the #define Qt_Tool window type.
#define Qt_WA_X11NetWmWindowTypeSplash            109   // Adds _NET_WM_WINDOW_TYPE_SPLASH to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. Note: Qt automatically sets this attribute for the #define Qt_SplashScreen window type.
#define Qt_WA_X11NetWmWindowTypeDialog            110   // Adds _NET_WM_WINDOW_TYPE_DIALOG to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. Note: Qt automatically sets this attribute for the #define Qt_Dialog and #define Qt_Sheet window types.
#define Qt_WA_X11NetWmWindowTypeDropDownMenu      111   // Adds _NET_WM_WINDOW_TYPE_DROPDOWN_MENU to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. \notw Qt automatically sets this attribute for QMenus added to a QMenuBar.
#define Qt_WA_X11NetWmWindowTypePopupMenu         112   // Adds _NET_WM_WINDOW_TYPE_POPUP_MENU to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. Note: Qt automatically sets this attribute for QMenu.
#define Qt_WA_X11NetWmWindowTypeToolTip           113   // Adds _NET_WM_WINDOW_TYPE_TOOLTIP to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. Note: Qt automatically sets this attribute for the #define Qt_ToolTip window type.
#define Qt_WA_X11NetWmWindowTypeNotification      114   // Adds _NET_WM_WINDOW_TYPE_NOTIFICATION to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms.
#define Qt_WA_X11NetWmWindowTypeCombo             115   // Adds _NET_WM_WINDOW_TYPE_COMBO to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. Note: Qt automatically sets this attribute for the QComboBox pop-up.
#define Qt_WA_X11NetWmWindowTypeDND               116   // Adds _NET_WM_WINDOW_TYPE_DND to the window's _NET_WM_WINDOW_TYPE X11 window property. See http://standards.freedesktop.org/wm-spec/ for more details. This attribute has no effect on non-X11 platforms. Note: Qt automatically sets this attribute on the feedback widget used during a drag.
#define Qt_WA_MacFrameworkScaled                  117   // Enables resolution independence aware mode on Mac when using Carbon. This attribute has no effect on Cocoa. The attribute is off by default and can be enabled on a per-window basis.
#define Qt_WA_AcceptTouchEvents                   121     // Allows touch events (see QTouchEvent) to be sent to the widget. Must be set on all widgets that can handle touch events. Without this attribute set, events from a touch device will be sent as mouse events.
#define Qt_WA_TouchPadAcceptSingleTouchEvents     123     // Allows touchpad single touch events to be sent to the widget.
#define Qt_WA_X11DoNotAcceptFocus                 126     // Asks the window manager to not give focus to this top level window. This attribute has no effect on non-X11 platforms.
#define Qt_WA_AlwaysStackOnTop                    128     // Since Qt 5.4, this value forces QOpenGLWidget and QQuickWidget to be drawn last, on top of other widgets. Ignored for other type of widgets. Setting this attribute breaks the stacking order, but allows having a semi-transparent OpenGL widget with other widgets visible underneath. It is strongly recommended to call update() on the widget's top-level window after enabling or disabling this attribute.


// enum #define Qt_WindowFrameSection
// This enum is used to describe parts of a window frame. It is returned by QGraphicsWidget_windowFrameSectionAt() to describe what section of the window frame is under the mouse.
//
#define Qt_NoSection                              0
#define Qt_LeftSection                            1
#define Qt_TopLeftSection                         2
#define Qt_TopSection                             3
#define Qt_TopRightSection                        4
#define Qt_RightSection                           5
#define Qt_BottomRightSection                     6
#define Qt_BottomSection                          7
#define Qt_BottomLeftSection                      8
#define Qt_TitleBarArea                           9
// See also QGraphicsWidget_windowFrameEvent(), QGraphicsWidget_paintWindowFrame(), and QGraphicsWidget_windowFrameSectionAt().

// enum #define Qt_WindowModality
// This enum specifies the behavior of a modal window. A modal window is one that blocks input to other windows. Note that windows that are children of a modal window are not blocked.
//
#define Qt_NonModal                               0   // The window is not modal and does not block input to other windows.
#define Qt_WindowModal                            1   // The window is modal to a single window hierarchy and blocks input to its parent window, all grandparent windows, and all siblings of its parent and grandparent windows.
#define Qt_ApplicationModal                       2   // The window is modal to the application and blocks input to all windows.
// See also QWidget_windowModality and QDialog.

// enum #define Qt_WindowState
// flags #define Qt_WindowStates
// This enum type is used to specify the current state of a top-level window.
// The states are
//
#define Qt_WindowNoState                          0x00000000   // The window has no state set (in normal state).
#define Qt_WindowMinimized                        0x00000001   // The window is minimized (i.e. iconified).
#define Qt_WindowMaximized                        0x00000002   // The window is maximized with a frame around it.
#define Qt_WindowFullScreen                       0x00000004   // The window fills the entire screen without any frame around it.
#define Qt_WindowActive                           0x00000008   // The window is the active window, i.e. it has keyboard focus.
// The WindowStates type is a typedef for QFlags<WindowState>. It stores an OR combination of WindowState values.

// enum #define Qt_WindowType
// flags #define Qt_WindowFlags
// This enum type is used to specify various window-system properties for the widget. They are fairly unusual but necessary in a few cases. Some of these flags depend on whether the underlying window manager supports them.
// The main types are
//
#define Qt_Widget                                 0x00000000               // This is the default type for QWidget. Widgets of this type are child widgets if they have a parent, and independent windows if they have no parent. // See also #define Qt_Window and #define Qt_SubWindow.
#define Qt_Window                                 0x00000001               // Indicates that the widget is a window, usually with a window system frame and a title bar, irrespective of whether the widget has a parent or not. Note that it is not possible to unset this flag if the widget does not have a parent.
#define Qt_Dialog                                 hb_bitOR( 0x00000002, Qt_Window )  // Indicates that the widget is a window that should be decorated as a dialog (i.e., typically no maximize or minimize buttons in the title bar). This is the default type for QDialog. If you want to use it as a modal dialog, it should be launched from another window, or have a parent and used with the QWidget_windowModality property. If you make it modal, the dialog will prevent other top-level windows in the application from getting any input. We refer to a top-level window that has a parent as a secondary window.
#define Qt_Sheet                                  hb_bitOR( 0x00000004, Qt_Window )  // Indicates that the widget is a Macintosh sheet.
#define Qt_Drawer                                 hb_bitOR( 0x00000006, Qt_Window )  // Indicates that the widget is a Macintosh drawer.
#define Qt_Popup                                  hb_bitOR( 0x00000008, Qt_Window )  // Indicates that the widget is a pop-up top-level window, i.e. that it is modal, but has a window system frame appropriate for pop-up menus.
#define Qt_Tool                                   hb_bitOR( 0x0000000a, Qt_Window )  // Indicates that the widget is a tool window. A tool window is often a small window with a smaller than usual title bar and decoration, typically used for collections of tool buttons. It there is a parent, the tool window will always be kept on top of it. If there isn't a parent, you may consider using #define Qt_WindowStaysOnTopHint as well. If the window system supports it, a tool window can be decorated with a somewhat lighter frame. It can also be combined with #define Qt_FramelessWindowHint.

// On Mac OS X, tool windows correspond to the Floating class of windows. This means that the window lives on a level above normal windows; it impossible to put a normal window on top of it. By default, tool windows will disappear when the application is inactive. This can be controlled by the #define Qt_WA_MacAlwaysShowToolWindow attribute.
//
#define Qt_ToolTip                                hb_bitOR( 0x0000000c, Qt_Window )  // Indicates that the widget is a tooltip. This is used internally to implement tooltips.
#define Qt_SplashScreen                           hb_bitOR( 0x0000000e, Qt_Window )  // Indicates that the window is a splash screen. This is the default type for QSplashScreen.
#define Qt_Desktop                                hb_bitOR( 0x00000010, Qt_Window )  // Indicates that this widget is the desktop. This is the type for QDesktopWidget.
#define Qt_SubWindow                              0x00000012               // Indicates that this widget is a sub-window, such as a QMdiSubWindow widget.

// There are also a number of flags which you can use to customize the appearance of top-level
// windows. These have no effect on other windows:
//
#define Qt_MSWindowsFixedSizeDialogHint           0x00000100   // Gives the window a thin dialog border on Windows. This style is traditionally used for fixed-size dialogs.
#define Qt_MSWindowsOwnDC                         0x00000200   // Gives the window its own display context on Windows.
#define Qt_X11BypassWindowManagerHint             0x00000400   // Bypass the window manager completely. This results in a borderless window that is not managed at all (i.e., no keyboard input unless you call QWidget_activateWindow() manually).
#define Qt_FramelessWindowHint                    0x00000800   // Produces a borderless window. The user cannot move or resize a borderless window via the window system. On X11, the result of the flag is dependent on the window manager and its ability to understand Motif and/or NETWM hints. Most existing modern window managers can handle this.

// The CustomizeWindowHint flag is used to enable customization of the window controls.
// This flag must be set to allow the WindowTitleHint, WindowSystemMenuHint,
// WindowMinimizeButtonHint, WindowMaximizeButtonHint and WindowCloseButtonHint flags to be changed.
//
#define Qt_CustomizeWindowHint                    0x02000000   // Turns off the default window title hints.
#define Qt_WindowTitleHint                        0x00001000   // Gives the window a title bar.
#define Qt_WindowSystemMenuHint                   0x00002000   // Adds a window system menu, and possibly a close button (for example on Mac). If you need to hide or show a close button, it is more portable to use WindowCloseButtonHint.
#define Qt_WindowMinimizeButtonHint               0x00004000   // Adds a minimize button. On some platforms this implies #define Qt_WindowSystemMenuHint for it to work.
#define Qt_WindowMaximizeButtonHint               0x00008000   // Adds a maximize button. On some platforms this implies #define Qt_WindowSystemMenuHint for it to work.
#define Qt_WindowMinMaxButtonsHint                hb_bitOR( Qt_WindowMinimizeButtonHint, Qt_WindowMaximizeButtonHint )  // Adds a minimize and a maximize button. On some platforms this implies #define Qt_WindowSystemMenuHint for it to work.
#define Qt_WindowCloseButtonHint                  0x08000000   // Adds a close button. On some platforms this implies #define Qt_WindowSystemMenuHint for it to work.
#define Qt_WindowContextHelpButtonHint            0x00010000   // Adds a context help button to dialogs. On some platforms this implies #define Qt_WindowSystemMenuHint for it to work.
#define Qt_MacWindowToolBarButtonHint             0x10000000   // On Mac OS X adds a tool bar button (i.e., the oblong button that is on the top right of windows that have toolbars.
#define Qt_BypassGraphicsProxyWidget              0x20000000   // Prevents the window and its children from automatically embedding themselves into a QGraphicsProxyWidget if the parent widget is already embedded. You can set this flag if you want your widget to always be a toplevel widget on the desktop, regardless of whether the parent widget is embedded in a scene or not.
#define Qt_WindowShadeButtonHint                  0x00020000   //
#define Qt_WindowStaysOnTopHint                   0x00040000   // Informs the window system that the window should stay on top of all other windows. Note that on some window managers on X11 you also have to pass #define Qt_X11BypassWindowManagerHint for this flag to work correctly.
#define Qt_WindowStaysOnBottomHint                0x04000000   // Informs the window system that the window should stay on bottom of all other windows. Note that on X11 this hint will work only in window managers that support _NET_WM_STATE_BELOW atom. If a window always on the bottom has a parent, the parent will also be left on the bottom. This window hint is currently not implemented for Mac OS X.
#define Qt_WindowOkButtonHint                     0x00080000   // Adds an OK button to the window decoration of a dialog. Only supported for Windows CE.
#define Qt_WindowCancelButtonHint                 0x00100000   // Adds a Cancel button to the window decoration of a dialog. Only supported for Windows CE.
#define Qt_WindowType_Mask                        0x000000ff   // A mask for extracting the window type part of the window flags.
                                                               //
#define Qt_WMouseNoMask                           0x00080000   // Use #define Qt_WA_MouseNoMask instead.
#define Qt_WDestructiveClose                      0x00100000   // Use #define Qt_WA_DeleteOnClose instead.
#define Qt_WStaticContents                        0x00200000   // Use #define Qt_WA_StaticContents instead.
#define Qt_WGroupLeader                           0x00400000   // No longer needed.
#define Qt_WShowModal                             0x00800000   // Use QWidget_windowModality instead.
#define Qt_WNoMousePropagation                    0x01000000   // Use #define Qt_WA_NoMousePropagation instead.
#define Qt_WType_TopLevel                         Qt_Window    // Use #define Qt_Window instead.
#define Qt_WType_Dialog                           Qt_Dialog    // Use #define Qt_Dialog instead.
#define Qt_WType_Popup                            Qt_Popup     // Use #define Qt_Popup instead.
#define Qt_WType_Desktop                          Qt_Desktop   // Use #define Qt_Desktop instead.
#define Qt_WType_Mask                             Qt_WindowType_Mask   // Use Qt_WindowType_Mask instead.
#define Qt_WStyle_Customize                       0            // No longer needed.
#define Qt_WStyle_NormalBorder                    0            // No longer needed.
#define Qt_WStyle_DialogBorder                    Qt_MSWindowsFixedSizeDialogHint   // Use #define Qt_MSWindowsFixedSizeDialogHint instead.
#define Qt_WStyle_NoBorder                        Qt_FramelessWindowHint        // Use #define Qt_FramelessWindowHint instead.
#define Qt_WStyle_Title                           Qt_WindowTitleHint            // Use #define Qt_WindowTitleHint instead.
#define Qt_WStyle_SysMenu                         Qt_WindowSystemMenuHint       // Use #define Qt_WindowSystemMenuHint instead.
#define Qt_WStyle_Minimize                        Qt_WindowMinimizeButtonHint   // Use #define Qt_WindowMinimizeButtonHint instead.
#define Qt_WStyle_Maximize                        Qt_WindowMaximizeButtonHint   // Use #define Qt_WindowMaximizeButtonHint instead.
#define Qt_WStyle_MinMax                          hb_bitOR( Qt_WStyle_Minimize, WStyle_Maximize )  // Use #define Qt_WindowMinMaxButtonsHint instead.
#define Qt_WStyle_Tool                            Qt_Tool                        // Use #define Qt_Tool instead.
#define Qt_WStyle_StaysOnTop                      Qt_WindowStaysOnTopHint        // Use #define Qt_WindowStaysOnTopHint instead.
#define Qt_WStyle_ContextHelp                     Qt_WindowContextHelpButtonHint // Use #define Qt_WindowContextHelpButtonHint instead.
#define Qt_WPaintDesktop                          0                   // No longer needed.
#define Qt_WPaintClever                           0                   // No longer needed.
#define Qt_WX11BypassWM                           Qt_X11BypassWindowManagerHint  // Use #define Qt_X11BypassWindowManagerHint instead.
#define Qt_WWinOwnDC                              Qt_MSWindowsOwnDC   // Use #define Qt_MSWindowsOwnDC instead.
#define Qt_WMacSheet                              Qt_Sheet            // Use #define Qt_Sheet instead.
#define Qt_WMacDrawer                             Qt_Drawer           // Use #define Qt_Drawer instead.
#define Qt_WStyle_Splash                          Qt_SplashScreen     // Use #define Qt_SplashScreen instead.
#define Qt_WNoAutoErase                           0                   // No longer needed.
#define Qt_WRepaintNoErase                        0                   // No longer needed.
#define Qt_WNorthWestGravity                      Qt_WStaticContents  // Use #define Qt_WA_StaticContents instead.
#define Qt_WType_Modal                            hb_bitOR( Qt_Dialog, Qt_WShowModal )  // Use Qt_Dialog and QWidget_windowModality instead.
#define Qt_WStyle_Dialog                          Qt_Dialog                   // Use Qt_Dialog instead.
#define Qt_WStyle_NoBorderEx                      Qt_FramelessWindowHint      // Use Qt_FramelessWindowHint instead.
#define Qt_WResizeNoErase                         0                   // No longer needed.
#define Qt_WMacNoSheet                            0                   // No longer needed.


// Frame Shadow
#define QFrame_Plain                              0x0010   // the frame and contents appear level with the surroundings; draws using the palette QPalette::WindowText color (without any 3D effect)
#define QFrame_Raised                             0x0020   // the frame and contents appear raised; draws a 3D raised line using the light and dark colors of the current color group
#define QFrame_Sunken                             0x0030   // the frame and contents appear sunken; draws a 3D sunken line using the light and dark colors of the current color group
// Frame Shape
#define QFrame_NoFrame                            0        // QFrame draws nothing
#define QFrame_Box                                0x0001   // QFrame draws a box around its contents
#define QFrame_Panel                              0x0002   // QFrame draws a panel to make the contents appear raised or sunken
#define QFrame_StyledPanel                        0x0006   // draws a rectangular panel with a look that depends on the current GUI style. It can be raised or sunken.
#define QFrame_HLine                              0x0004   // QFrame draws a horizontal line that frames nothing (useful as separator)
#define QFrame_VLine                              0x0005   // QFrame draws a vertical line that frames nothing (useful as separator)
#define QFrame_WinPanel                           0x0003   // draws a rectangular panel that can be
               // raised or sunken like those in Windows 95. Specifying this shape sets the
               // line width to 2 pixels. WinPanel is provided for compatibility. For GUI style
               // independence we recommend using StyledPanel instead.
// Frame Style Mask
#define QFrame_Shadow_Mask                        0x00f0   // The Shadow part of frameStyle()
#define QFrame_Shape_Mask                         0x000f   // The Shape part of frameStyle()


#define QIcon_Normal                              0    // Display the pixmap when the user is not interacting with the icon, but the functionality represented by the icon is available.
#define QIcon_Disabled                            1    // Display the pixmap when the functionality represented by the icon is not available.
#define QIcon_Active                              2    // Display the pixmap when the functionality represented by the icon is available and the user is interacting with the icon, for example, moving the mouse over it or clicking it.
#define QIcon_Selected                            3    // Display the pixmap when the item represented by the icon is selected.

//enum #define QIcon_State
//This enum describes the state for which a pixmap is intended to be used. The state can be:
//
#define QIcon_On                                  0    // Display the pixmap when the widget is in an "on" state
#define QIcon_Off                                 1    // Display the pixmap when the widget is in an "off" state

#define QFont_MixedCase                           0   // This is the normal text rendering option where no capitalization change is applied.
#define QFont_AllUppercase                        1   // This alters the text to be rendered in all uppercase type.
#define QFont_AllLowercase                        2   // This alters the text to be rendered in all lowercase type.
#define QFont_SmallCaps                           3   // This alters the text to be rendered in small-caps type.
#define QFont_Capitalize                          4   // This alters the text to be rendered with the first character of each word as an uppercase character.

// enum #define QFont_SpacingType
//
#define QFont_PercentageSpacing                   0   // A value of 100 will keep the spacing unchanged; a value of 200 will enlarge the spacing after a character by the width of the character itself.
#define QFont_AbsoluteSpacing                     1   // A positive value increases the letter spacing by the corresponding pixels; a negative value decreases the spacing.

// enum #define QFont_Stretch
// Predefined stretch values that follow the CSS naming convention. The higher the value, the more stretched the text is.
//
#define QFont_UltraCondensed                      50
#define QFont_ExtraCondensed                      62
#define QFont_Condensed                           75
#define QFont_SemiCondensed                       87
#define QFont_Unstretched                         100
#define QFont_SemiExpanded                        112
#define QFont_Expanded                            125
#define QFont_ExtraExpanded                       150
#define QFont_UltraExpanded                       200

// enum #define QFont_Style
// This enum describes the different styles of glyphs that are used to display text.
//
#define QFont_StyleNormal                         0   // Normal glyphs used in unstyled text.
#define QFont_StyleItalic                         1   // Italic glyphs that are specifically designed for the purpose of representing italicized text.
#define QFont_StyleOblique                        2   // Glyphs with an italic appearance that are typically based on the unstyled glyphs, but are not fine-tuned for the purpose of representing italicized text.

// enum #define QFont_StyleHint
// Style hints are used by the font matching algorithm to find an appropriate default family if a selected font family is not available.
//
#define QFont_AnyStyle                            5                  // leaves the font matching algorithm to choose the family. This is the default.
#define QFont_SansSerif                           QFont_Helvetica    // the font matcher prefer sans serif fonts.
#define QFont_Helvetica                           0                  // is a synonym for SansSerif.
#define QFont_Serif                               QFont_Times        // the font matcher prefers serif fonts.
#define QFont_Times                               1                  // is a synonym for Serif.
#define QFont_TypeWriter                          QFont_Courier      // the font matcher prefers fixed pitch fonts.
#define QFont_Courier                             2                  // a synonym for TypeWriter.
#define QFont_OldEnglish                          3                  // the font matcher prefers decorative fonts.
#define QFont_Decorative                          QFont_OldEnglish   // is a synonym for OldEnglish.
#define QFont_System                              4                  // the font matcher prefers system fonts.

// enum #define QFont_StyleStrategy
// The style strategy tells the font matching algorithm what type of fonts should be used to find an appropriate default family.
//
#define QFont_PreferDefault                       0x0001   // the default style strategy. It does not prefer any type of font.
#define QFont_PreferBitmap                        0x0002   // prefers bitmap fonts (as opposed to outline fonts).
#define QFont_PreferDevice                        0x0004   // prefers device fonts.
#define QFont_PreferOutline                       0x0008   // prefers outline fonts (as opposed to bitmap fonts).
#define QFont_ForceOutline                        0x0010   // forces the use of outline fonts.
#define QFont_NoAntialias                         0x0100   // don't antialias the fonts.
#define QFont_PreferAntialias                     0x0080   // antialias if possible.
#define QFont_OpenGLCompatible                    0x0200   // forces the use of OpenGL compatible fonts.
#define QFont_NoFontMerging                       0x8000   // If a font does not contain a character requested to draw then Qt automatically chooses a similar looking for that contains the character. This flag disables this feature.

// Any of these may be OR-ed with one of these flags:
//
#define QFont_PreferMatch                         0x0020   // prefer an exact match. The font matcher will try to use the exact font size that has been specified.
#define QFont_PreferQuality                       0x0040   // prefer the best quality font. The font matcher will use the nearest standard point size that the font supports.

#define QFont_Light                               25
#define QFont_Normal                              50
#define QFont_DemiBold                            63
#define QFont_Bold                                75
#define QFont_Black                               87


#define QFileDialog_AcceptOpen                    0
#define QFileDialog_AcceptSave                    1

// enum #define QFileDialog_DialogLabel
//
#define QFileDialog_LookIn                        0
#define QFileDialog_FileName                      1
#define QFileDialog_FileType                      2
#define QFileDialog_Accept                        3
#define QFileDialog_Reject                        4

// enum #define QFileDialog_FileMode
// This enum is used to indicate what the user may select in the file dialog;
// i.e. what the dialog will return if the user clicks OK.
//
#define QFileDialog_AnyFile                       0   // The name of a file, whether it exists or not.
#define QFileDialog_ExistingFile                  1   // The name of a single existing file.
#define QFileDialog_Directory                     2   // The name of a directory. Both files and directories are displayed.
#define QFileDialog_ExistingFiles                 3   // The names of zero or more existing files.

// The Options type is a typedef for QFlags<Option>. It stores an OR combination of Option values.
//
#define QFileDialog_ShowDirsOnly                  0x00000001   // Only show directories in the file dialog. By default both files and directories are shown. (Valid only in the Directory file mode.)
#define QFileDialog_DontResolveSymlinks           0x00000002   // Don't resolve symlinks in the file dialog. By default symlinks are resolved.
#define QFileDialog_DontConfirmOverwrite          0x00000004   // Don't ask for confirmation if an existing file is selected. By default confirmation is requested.
#define QFileDialog_DontUseNativeDialog           0x00000010   // Don't use the native file dialog. By default on Mac OS X and Windows, the native file dialog is used.
#define QFileDialog_ReadOnly                      0x00000020   // Indicates that the model is readonly.
#define QFileDialog_HideNameFilterDetails         0x00000040   // Indicates if the is hidden or not.

//enum QFileDialog::ViewMode
//This enum describes the view mode of the file dialog; i.e. what information about each file will be displayed.
//
#define QFileDialog_Detail                        0   // Displays an icon, a name, and details for each item in the directory.
#define QFileDialog_List                          1   // Displays only an icon and a name for each item in the directory.

#define QDialog_Accepted                          1
#define QDialog_Rejected                          0


// enum QAbstractPrintDialog::PrintDialogOption
// flags QAbstractPrintDialog::PrintDialogOptions
// Used to specify which parts of the print dialog should be visible.
// The PrintDialogOptions type is a typedef for QFlags<PrintDialogOption>.
// It stores an OR combination of PrintDialogOption values.
//
#define QAbstractPrintDialog_None                 0x0000   // None of the options are enabled.
#define QAbstractPrintDialog_PrintToFile          0x0001   // The print to file option is enabled.
#define QAbstractPrintDialog_PrintSelection       0x0002   // The print selection option is enabled.
#define QAbstractPrintDialog_PrintPageRange       0x0004   // The page range selection option is enabled.
#define QAbstractPrintDialog_PrintShowPageSize    0x0008   // Show the page size + margins page only if this is enabled.
#define QAbstractPrintDialog_PrintCollateCopies   0x0010   // The collate copies option is enabled
#define QAbstractPrintDialog_PrintCurrentPage     0x0040   // The print current page option is enabled

// enum QAbstractPrintDialog::PrintRange
// Used to specify the print range selection option.
//
#define QAbstractPrintDialog_AllPages             0   // All pages should be printed.
#define QAbstractPrintDialog_Selection            1   // Only the selection should be printed.
#define QAbstractPrintDialog_PageRange            2   // The specified page range should be printed.
#define QAbstractPrintDialog_CurrentPage          3   // Only the currently visible page should be printed.

// enum QPrinter::ColorMode
// This enum type is used to indicate whether QPrinter should print in color or not.
//
#define QPrinter_Color                            1   // print in color if available, otherwise in grayscale.
#define QPrinter_GrayScale                        0   // print in grayscale, even on color printers.

// enum QPrinter::DuplexMode
// This enum is used to indicate whether printing will occur on one or both sides of each sheet of paper (simplex or duplex printing).
//
#define QPrinter_DuplexNone                       0   // Single sided (simplex) printing only.
#define QPrinter_DuplexAuto                       1   // The printer's default setting is used to determine whether duplex printing is used.
#define QPrinter_DuplexLongSide                   2   // Both sides of each sheet of paper are used for printing. The paper is turned over its longest edge before the second side is printed
#define QPrinter_DuplexShortSide                  3   // Both sides of each sheet of paper are used for printing. The paper is turned over its shortest edge before the second side is printed

// enum QPrinter::Orientation
// This enum type (not to be confused with Orientation) is used to specify each page's orientation.
//
#define QPrinter_Portrait                         0   // the page's height is greater than its width.
#define QPrinter_Landscape                        1   // the page's width is greater than its height.
// This type interacts with QPrinter::PaperSize and QPrinter::setFullPage()
// to determine the final size of the page available to the application.

// enum QPrinter::OutputFormat
// The OutputFormat enum is used to describe the format QPrinter should use for printing.
//
#define QPrinter_NativeFormat                     0   // QPrinter will print output using a method defined by the platform it is running on. This mode is the default when printing directly to a printer.
#define QPrinter_PdfFormat                        1   // QPrinter will generate its output as a searchable PDF file. This mode is the default when printing to a file.
#define QPrinter_PostScriptFormat                 2   // QPrinter will generate its output as in the PostScript format. (This feature was introduced in Qt 4.2.)

// enum QPrinter::PageOrder
// This enum type is used by QPrinter to tell the application program how to print.
//
#define QPrinter_FirstPageFirst                   0   // the lowest-numbered page should be printed first.
#define QPrinter_LastPageFirst                    1   // the highest-numbered page should be printed first.

// enum QPrinter::PaperSize
// This enum type specifies what paper size QPrinter should use.
// QPrinter does not check that the paper size is available; it just uses this information,
// together with QPrinter::Orientation and QPrinter::setFullPage(), to determine the printable area.
//
// The defined sizes (with setFullPage(true)) are:
//
#define QPrinter_A0                               5    // 841  x 1189 mm
#define QPrinter_A1                               6    // 594  x 841  mm
#define QPrinter_A2                               7    // 420  x 594  mm
#define QPrinter_A3                               8    // 297  x 420  mm
#define QPrinter_A4                               0    // 210  x 297  mm, 8.26 x 11.69 inches
#define QPrinter_A5                               9    // 148  x 210  mm
#define QPrinter_A6                               10   // 105  x 148  mm
#define QPrinter_A7                               11   // 74   x 105  mm
#define QPrinter_A8                               12   // 52   x 74   mm
#define QPrinter_A9                               13   // 37   x 52   mm
#define QPrinter_B0                               14   // 1030 x 1456 mm
#define QPrinter_B1                               15   // 728  x 1030 mm
#define QPrinter_B2                               17   // 515  x 728  mm
#define QPrinter_B3                               18   // 364  x 515  mm
#define QPrinter_B4                               19   // 257  x 364  mm
#define QPrinter_B5                               1    // 182  x 257  mm, 7.17 x 10.13 inches
#define QPrinter_B6                               20   // 128  x 182  mm
#define QPrinter_B7                               21   // 91   x 128  mm
#define QPrinter_B8                               22   // 64   x 91   mm
#define QPrinter_B9                               23   // 45   x 64   mm
#define QPrinter_B10                              16   // 32   x 45   mm
#define QPrinter_C5E                              24   // 163  x 229  mm
#define QPrinter_Comm10E                          25   // 105  x 241  mm, U.S. Common 10 Envelope
#define QPrinter_DLE                              26   // 110  x 220  mm
#define QPrinter_Executive                        4    // 191  x 254  mm, 7.5  x 10 inches
#define QPrinter_Folio                            27   // 210  x 330  mm
#define QPrinter_Ledger                           28   // 432  x 279  mm
#define QPrinter_Legal                            3    // 216  x 356  mm, 8.5  x 14 inches
#define QPrinter_Letter                           2    // 216  x 279  mm, 8.5  x 11 inches
#define QPrinter_Tabloid                          29   // 279  x 432  mm
#define QPrinter_Custom                           30   // Unknown, or a user defined size.
// With setFullPage(false) (the default), the metrics will be a bit smaller; how much
// depends on the printer in use.


// enum QPrinter::PaperSource
//
// This enum type specifies what paper source QPrinter is to use. QPrinter does not check
// that the paper source is available; it just uses this information to try and set the paper
// source. Whether it will set the paper source depends on whether the printer has that
// particular source.
//
// Warning: This is currently only implemented for Windows.
//
#define QPrinter_Auto                             6
#define QPrinter_Cassette                         11
#define QPrinter_Envelope                         4
#define QPrinter_EnvelopeManual                   5
#define QPrinter_FormSource                       12
#define QPrinter_LargeCapacity                    10
#define QPrinter_LargeFormat                      9
#define QPrinter_Lower                            1
#define QPrinter_MaxPageSource                    13
#define QPrinter_Middle                           2
#define QPrinter_Manual                           3
#define QPrinter_OnlyOne                          0
#define QPrinter_Tractor                          7
#define QPrinter_SmallFormat                      8

// enum QPrinter::PrintRange
// Used to specify the print range selection option.
//
#define QPrinter_AllPages                         0   // All pages should be printed.
#define QPrinter_Selection                        1   // Only the selection should be printed.
#define QPrinter_PageRange                        2   // The specified page range should be printed.

// enum #define QPrinter_PrinterMode
// This enum describes the mode the printer should work in. It basically presets a certain
// resolution and working mode.
//
#define QPrinter_ScreenResolution                 0   // Sets the resolution of the print device to the screen resolution. This has the big advantage that the results obtained when painting on the printer will match more or less exactly the visible output on the screen. It is the easiest to use, as font metrics on the screen and on the printer are the same. This is the default value. ScreenResolution will produce a lower quality output than HighResolution and should only be used for drafts.
#define QPrinter_PrinterResolution                1   // This value is deprecated. Is is equivalent to ScreenResolution on Unix and HighResolution on Windows and Mac. Due do the difference between ScreenResolution and HighResolution, use of this value may lead to non-portable printer code.
#define QPrinter_HighResolution                   2   // On Windows, sets the printer resolution to that defined for the printer in use. For PostScript printing, sets the resolution of the PostScript driver to 1200 dpi.
// Note: When rendering text on a QPrinter device, it is important to realize that the size of
// text, when specified in points, is independent of the resolution specified for the device itself.
// Therefore, it may be useful to specify the font size in pixels when combining text with
// graphics to ensure that their relative sizes are what you expect.

// enum QPrinter::PrinterState
//
#define QPrinter_Idle                             0
#define QPrinter_Active                           1
#define QPrinter_Aborted                          2
#define QPrinter_Error                            3

// enum QPrinter::Unit
// This enum type is used to specify the measurement unit for page and paper sizes.
//
#define QPrinter_Millimeter                       0
#define QPrinter_Point                            1
#define QPrinter_Inch                             2
#define QPrinter_Pica                             3
#define QPrinter_Didot                            4
#define QPrinter_Cicero                           5
#define QPrinter_DevicePixel                      6
// Note the difference between Point and DevicePixel. The Point unit is defined
// to be 1/72th of an inch, while the DevicePixel unit is resolution dependant and is
// based on the actual pixels, or dots, on the printer.


#define QPrintEngine_PPK_CollateCopies            0      // A boolean value indicating whether the printout should be collated or not.
#define QPrintEngine_PPK_ColorMode                1      // Refers to QPrinter::ColorMode, either color or monochrome.
#define QPrintEngine_PPK_Creator                  2      // A string describing the document's creator.
#define QPrintEngine_PPK_Duplex                   21     // A boolean value indicating whether both sides of the printer paper should be used for the printout.
#define QPrintEngine_PPK_DocumentName             3      // A string describing the document name in the spooler.
#define QPrintEngine_PPK_FontEmbedding            19     // A boolean value indicating whether data for the document's fonts should be embedded in the data sent to the printer.
#define QPrintEngine_PPK_FullPage                 4      // A boolean describing if the printer should be full page or not.
#define QPrintEngine_PPK_NumberOfCopies           5      // An integer specifying the number of copies
#define QPrintEngine_PPK_Orientation              6      // Specifies a QPrinter::Orientation value.
#define QPrintEngine_PPK_OutputFileName           7      // The output file name as a string. An empty file name indicates that the printer should not print to a file.
#define QPrintEngine_PPK_PageOrder                8      // Specifies a QPrinter::PageOrder value.
#define QPrintEngine_PPK_PageRect                 9      // A QRect specifying the page rectangle
#define QPrintEngine_PPK_PageSize                 10     // Obsolete. Use PPK_PaperSize instead.
#define QPrintEngine_PPK_PaperRect                11     // A QRect specifying the paper rectangle.
#define QPrintEngine_PPK_PaperSource              12     // Specifies a QPrinter::PaperSource value.
#define QPrintEngine_PPK_PaperSources             22     // Specifies more than one QPrinter::PaperSource value.
#define QPrintEngine_PPK_PaperSize                QPrintEngine_PPK_PageSize   // Specifies a QPrinter::PaperSize value.
#define QPrintEngine_PPK_PrinterName              13     // A string specifying the name of the printer.
#define QPrintEngine_PPK_PrinterProgram           14     // A string specifying the name of the printer program used for printing,
#define QPrintEngine_PPK_Resolution               15     // An integer describing the dots per inch for this printer.
#define QPrintEngine_PPK_SelectionOption          16
#define QPrintEngine_PPK_SupportedResolutions     17     // A list of integer QVariants describing the set of supported resolutions that the printer has.
#define QPrintEngine_PPK_SuppressSystemPrintStatus  20   // Suppress the built-in dialog for showing printing progress. As of 4.1 this only has effect on Mac OS X where, by default, a status dialog is shown.
#define QPrintEngine_PPK_WindowsPageSize          18     // An integer specifying a DM_PAPER entry on Windows.
#define QPrintEngine_PPK_CustomPaperSize          23     // A QSizeF specifying a custom paper size in the QPrinter::Point unit.
#define QPrintEngine_PPK_PageMargins              24     // A QList<QVariant> containing the left, top, right and bottom margin values.

//enum QPrintPreviewWidget::ViewMode
//This enum is used to describe the view mode of the preview widget.
//
#define QPrintPreviewWidget_SinglePageView        0      // A mode where single pages in the preview is viewed.
#define QPrintPreviewWidget_FacingPagesView       1      // A mode where the facing pages in the preview is viewed.
#define QPrintPreviewWidget_AllPagesView          2      // A view mode where all the pages in the preview is viewed.

//enum QPrintPreviewWidget::ZoomMode
//This enum is used to describe zoom mode of the preview widget.Constant   Value   Description
//
#define QPrintPreviewWidget_CustomZoom            0      // The zoom is set to a custom zoom value.
#define QPrintPreviewWidget_FitToWidth            1      // This mode fits the current page to the width of the view.
#define QPrintPreviewWidget_FitInView             2      // This mode fits the current page inside the view.

// enum QTextCursor::MoveMode
//
#define QTextCursor_MoveAnchor                    0      // Moves the anchor to the same position as the cursor itself.
#define QTextCursor_KeepAnchor                    1      // Keeps the anchor where it is.
// If the anchor() is kept where it is and the position() is moved, the text in between will be selected.

// enum QTextCursor::MoveOperation
//
#define QTextCursor_NoMove                        0      // Keep the cursor where it is
#define QTextCursor_Start                         1      // Move to the start of the document.
#define QTextCursor_StartOfLine                   3      // Move to the start of the current line.
#define QTextCursor_StartOfBlock                  4      // Move to the start of the current block.
#define QTextCursor_StartOfWord                   5      // Move to the start of the current word.
#define QTextCursor_PreviousBlock                 6      // Move to the start of the previous block.
#define QTextCursor_PreviousCharacter             7      // Move to the previous character.
#define QTextCursor_PreviousWord                  8      // Move to the beginning of the previous word.
#define QTextCursor_Up                            2      // Move up one line.
#define QTextCursor_Left                          9      // Move left one character.
#define QTextCursor_WordLeft                      10     // Move left one word.
#define QTextCursor_End                           11     // Move to the end of the document.
#define QTextCursor_EndOfLine                     13     // Move to the end of the current line.
#define QTextCursor_EndOfWord                     14     // Move to the end of the current word.
#define QTextCursor_EndOfBlock                    15     // Move to the end of the current block.
#define QTextCursor_NextBlock                     16     // Move to the beginning of the next block.
#define QTextCursor_NextCharacter                 17     // Move to the next character.
#define QTextCursor_NextWord                      18     // Move to the next word.
#define QTextCursor_Down                          12     // Move down one line.
#define QTextCursor_Right                         19     // Move right one character.
#define QTextCursor_WordRight                     20     // Move right one word.
#define QTextCursor_NextCell                      21     // Move to the beginning of the next table cell inside the current table. If the current cell is the last cell in the row, the cursor will move to the first cell in the next row.
#define QTextCursor_PreviousCell                  22     // Move to the beginning of the previous table cell inside the current table. If the current cell is the first cell in the row, the cursor will move to the last cell in the previous row.
#define QTextCursor_NextRow                       23     // Move to the first new cell of the next row in the current table.
#define QTextCursor_PreviousRow                   24     // Move to the last cell of the previous row in the current table.

// enum QTextCursor::SelectionType
// This enum describes the types of selection that can be applied with the select() function.
//
#define QTextCursor_Document                      3      // Selects the entire document.
#define QTextCursor_BlockUnderCursor              2      // Selects the block of text under the cursor.
#define QTextCursor_LineUnderCursor               1      // Selects the line of text under the cursor.
#define QTextCursor_WordUnderCursor               0      // Selects the word under the cursor. If the cursor is not positioned within a string of selectable characters, no text is selected.


// enum QTextCharFormat::UnderlineStyle
// This enum describes the different ways drawing underlined text.
//
#define QTextCharFormat_NoUnderline               0      // Text is draw without any underlining decoration.
#define QTextCharFormat_SingleUnderline           1      // A line is drawn using #define Qt_SolidLine.
#define QTextCharFormat_DashUnderline             2      // Dashes are drawn using #define Qt_DashLine.
#define QTextCharFormat_DotLine                   3      // Dots are drawn using #define Qt_DotLine;
#define QTextCharFormat_DashDotLine               4      // Dashs and dots are drawn using #define Qt_DashDotLine.
#define QTextCharFormat_DashDotDotLine            5      // Underlines draw drawn using #define Qt_DashDotDotLine.
#define QTextCharFormat_WaveUnderline             6      // The text is underlined using a wave shaped line.
#define QTextCharFormat_SpellCheckUnderline       7      // The underline is drawn depending on the QStyle::SH_SpellCeckUnderlineStyle style hint of the QApplication style. By default this is mapped to WaveUnderline, on Mac OS X it is mapped to DashDotLine.

// enum QTextCharFormat::VerticalAlignment
// This enum describes the ways that adjacent characters can be vertically aligned.
//
#define QTextCharFormat_AlignNormal               0      // Adjacent characters are positioned in the standard way for text in the writing system in use.
#define QTextCharFormat_AlignSuperScript          1      // Characters are placed above the baseline for normal text.
#define QTextCharFormat_AlignSubScript            2      // Characters are placed below the baseline for normal text.
#define QTextCharFormat_AlignMiddle               3      // The center of the object is vertically aligned with the base line. Currently, this is only implemented for inline objects.
#define QTextCharFormat_AlignBottom               5      // The bottom edge of the object is vertically aligned with the base line.
#define QTextCharFormat_AlignTop                  4      // The top edge of the object is vertically aligned with the base line.

// enum QAbstractItemView::CursorAction
// This enum describes the different ways to navigate between items,
//
#define QAbstractItemView_MoveUp                  0      // Move to the item above the current item.
#define QAbstractItemView_MoveDown                1      // Move to the item below the current item.
#define QAbstractItemView_MoveLeft                2      // Move to the item left of the current item.
#define QAbstractItemView_MoveRight               3      // Move to the item right of the current item.
#define QAbstractItemView_MoveHome                4      // Move to the top-left corner item.
#define QAbstractItemView_MoveEnd                 5      // Move to the bottom-right corner item.
#define QAbstractItemView_MovePageUp              6      // Move one page up above the current item.
#define QAbstractItemView_MovePageDown            7      // Move one page down below the current item.
#define QAbstractItemView_MoveNext                8      // Move to the item after the current item.
#define QAbstractItemView_MovePrevious            9      // Move to the item before the current item.

// enum #define QAbstractItemView_DragDropMode
// Describes the various drag and drop events the view can act upon. By default the view does not support dragging or dropping (NoDragDrop).
//
#define QAbstractItemView_NoDragDrop              0      // Does not support dragging or dropping.
#define QAbstractItemView_DragOnly                1      // The view supports dragging of its own items
#define QAbstractItemView_DropOnly                2      // The view accepts drops
#define QAbstractItemView_DragDrop                3      // The view supports both dragging and dropping
#define QAbstractItemView_InternalMove            4      // The view accepts move (not copy) operations only from itself.
// Note that the model used needs to provide support for drag and drop operations.

// enum QAbstractItemView::DropIndicatorPosition
// This enum indicates the position of the drop indicator in relation to the index at the current mouse position:
#define QAbstractItemView_OnItem                  0      // The item will be dropped on the index.
#define QAbstractItemView_AboveItem               1      // The item will be dropped above the index.
#define QAbstractItemView_BelowItem               2      // The item will be dropped below the index.
#define QAbstractItemView_OnViewport              3      // The item will be dropped onto a region of the viewport with no items. The way each view handles items dropped onto the viewport depends on the behavior of the underlying model in use.

// enum #define QAbstractItemView_EditTrigger
// flags QAbstractItemView::EditTriggers
// This enum describes actions which will initiate item editing.
//
#define QAbstractItemView_NoEditTriggers          0      // No editing possible.
#define QAbstractItemView_CurrentChanged          1      // Editing start whenever current item changes.
#define QAbstractItemView_DoubleClicked           2      // Editing starts when an item is double clicked.
#define QAbstractItemView_SelectedClicked         4      // Editing starts when clicking on an already selected item.
#define QAbstractItemView_EditKeyPressed          8      // Editing starts when the platform edit key has been pressed over an item.
#define QAbstractItemView_AnyKeyPressed           16     // Editing starts when any key is pressed over an item.
#define QAbstractItemView_AllEditTriggers         31     // Editing starts for all above actions.
// The EditTriggers type is a typedef for QFlags<EditTrigger>. It stores an OR combination of EditTrigger values.

// enum QAbstractItemView::ScrollHint
//
#define QAbstractItemView_EnsureVisible           0      // Scroll to ensure that the item is visible.
#define QAbstractItemView_PositionAtTop           1      // Scroll to position the item at the top of the viewport.
#define QAbstractItemView_PositionAtBottom        2      // Scroll to position the item at the bottom of the viewport.
#define QAbstractItemView_PositionAtCenter        3      // Scroll to position the item at the center of the viewport.

// enum #define QAbstractItemView_ScrollMode
//
#define QAbstractItemView_ScrollPerItem           0      // The view will scroll the contents one item at a time.
#define QAbstractItemView_ScrollPerPixel          1      // The view will scroll the contents one pixel at a time.

// enum #define QAbstractItemView_SelectionBehavior
//
#define QAbstractItemView_SelectItems             0      // Selecting single items.
#define QAbstractItemView_SelectRows              1      // Selecting only rows.
#define QAbstractItemView_SelectColumns           2      // Selecting only columns.

// enum #define QAbstractItemView_SelectionMode
// This enum indicates how the view responds to user selections:
//
#define QAbstractItemView_SingleSelection         1      // When the user selects an item, any already-selected item becomes unselected, and the user cannot unselect the selected item by clicking on it.
#define QAbstractItemView_ContiguousSelection     4      // When the user selects an item in the usual way, the selection is cleared and the new item selected. However, if the user presses the Shift key while clicking on an item, all items between the current item and the clicked item are selected or unselected, depending on the state of the clicked item.
#define QAbstractItemView_ExtendedSelection       3      // When the user selects an item in the usual way,
                                                         //   the selection is cleared and the new item
                                                         //   selected. However, if the user presses the Ctrl key
                                                         //   when clicking on an item, the clicked item gets toggled
                                                         //   and all other items are left untouched.
                                                         //   If the user presses the Shift key while clicking on
                                                         //   an item, all items between the current item and the
                                                         //   clicked item are selected or unselected, depending on
                                                         //   the state of the clicked item. Multiple items can be
                                                         //   selected by dragging the mouse over them.
#define QAbstractItemView_MultiSelection          2      // When the user selects an item in the usual way, the selection status of that item is toggled and the other items are left alone. Multiple items can be toggled by dragging the mouse over them.
#define QAbstractItemView_NoSelection             0      // Items cannot be selected.
// The most commonly used modes are SingleSelection and ExtendedSelection.

// enum #define QAbstractItemView_State
// Describes the different states the view can be in. This is usually only interesting when reimplementing your own view.
//
#define QAbstractItemView_NoState                 0      // The is the default state.
#define QAbstractItemView_DraggingState           1      // The user is dragging items.
#define QAbstractItemView_DragSelectingState      2      // The user is selecting items.
#define QAbstractItemView_EditingState            3      // The user is editing an item in a widget editor.
#define QAbstractItemView_ExpandingState          4      // The user is opening a branch of items.
#define QAbstractItemView_CollapsingState         5      // The user is closing a branch of items.
#define QAbstractItemView_AnimatingState          6      // The item view is performing an animation.

#define QHeaderView_Interactive                   0      // The user can resize the section. The section can also be resized programmatically using resizeSection(). The section size defaults to defaultSectionSize. (See also cascadingSectionResizes.)
#define QHeaderView_Fixed                         2      // The user cannot resize the section. The section can only be resized programmatically using resizeSection(). The section size defaults to defaultSectionSize.
#define QHeaderView_Stretch                       1      // QHeaderView will automatically resize the section to fill the available space. The size cannot be changed by the user or programmatically.
#define QHeaderView_ResizeToContents              3      // QHeaderView will automatically resize the section to its optimal size based on the contents of the entire column or row. The size cannot be changed by the user or programmatically. (This value was introduced in 4.2)

#define QSizePolicy_DefaultType                   0x00000001   // The default type, when none is specified.
#define QSizePolicy_ButtonBox                     0x00000002   // A QDialogButtonBox instance.
#define QSizePolicy_CheckBox                      0x00000004   // A QCheckBox instance.
#define QSizePolicy_ComboBox                      0x00000008   // A QComboBox instance.
#define QSizePolicy_Frame                         0x00000010   // A QFrame instance.
#define QSizePolicy_GroupBox                      0x00000020   // A QGroupBox instance.
#define QSizePolicy_Label                         0x00000040   // A QLabel instance.
#define QSizePolicy_Line                          0x00000080   // A QFrame instance with QFrame::HLine or QFrame::VLine.
#define QSizePolicy_LineEdit                      0x00000100   // A QLineEdit instance.
#define QSizePolicy_PushButton                    0x00000200   // A QPushButton instance.
#define QSizePolicy_RadioButton                   0x00000400   // A QRadioButton instance.
#define QSizePolicy_Slider                        0x00000800   // A QAbstractSlider instance.
#define QSizePolicy_SpinBox                       0x00001000   // A QAbstractSpinBox instance.
#define QSizePolicy_TabWidget                     0x00002000   // A QTabWidget instance.
#define QSizePolicy_ToolButton                    0x00004000   // A QToolButton instance.
// The ControlTypes type is a typedef for QFlags<ControlType>. It stores an OR combination of ControlType values.

// enum QSizePolicy::Policy
// This enum describes the various per-dimension sizing types used when constructing a QSizePolicy.
//
#define QSizePolicy_Fixed                         0   // The QWidget::sizeHint() is the only acceptable alternative, so the widget can never grow or shrink (e.g. the vertical direction of a push button).
#define QSizePolicy_Minimum                       QSizePolicy_GrowFlag                                                     // The sizeHint() is minimal, and sufficient. The widget can be expanded, but there is no advantage to it being larger (e.g. the horizontal direction of a push button). It cannot be smaller than the size provided by sizeHint().
#define QSizePolicy_Maximum                       QSizePolicy_ShrinkFlag                                                   // The sizeHint() is a maximum. The widget can be shrunk any amount without detriment if other widgets need the space (e.g. a separator line). It cannot be larger than the size provided by sizeHint().
#define QSizePolicy_Preferred                     hb_bitOR( QSizePolicy_GrowFlag, QSizePolicy_ShrinkFlag )                 // The sizeHint() is best, but the widget can be shrunk and still be useful. The widget can be expanded, but there is no advantage to it being larger than sizeHint() (the default QWidget policy).
#define QSizePolicy_Expanding                     hb_bitOR( QSizePolicy_GrowFlag, QSizePolicy_ShrinkFlag, QSizePolicy_ExpandFlag )  // The sizeHint() is a sensible size, but the widget can be shrunk and still be useful. The widget can make use of extra space, so it should get as much space as possible (e.g. the horizontal direction of a horizontal slider).
#define QSizePolicy_MinimumExpanding              hb_bitOR( QSizePolicy_GrowFlag, QSizePolicy_ExpandFlag )                 // The sizeHint() is minimal, and sufficient. The widget can make use of extra space, so it should get as much space as possible (e.g. the horizontal direction of a horizontal slider).
#define QSizePolicy_Ignored                       hb_bitOR( QSizePolicy_ShrinkFlag, QSizePolicy_GrowFlag, QSizePolicy_IgnoreFlag )  // The sizeHint() is ignored. The widget will get as much space as possible.

// enum QSizePolicy::PolicyFlag
// These flags are combined together to form the various Policy values:
//
#define QSizePolicy_GrowFlag                      1   // The widget can grow beyond its size hint if necessary.
#define QSizePolicy_ExpandFlag                    2   // The widget should get as much space as possible.
#define QSizePolicy_ShrinkFlag                    4   // The widget can shrink below its size hint if necessary.
#define QSizePolicy_IgnoreFlag                    8   // The widget's size hint is ignored. The widget will get as much space as possible.


// This enum controls the types of events processed by the processEvents() functions.
//
#define QEventLoop_AllEvents                      0x00   // All events. Note that DeferredDelete events are processed specially. See QObject::deleteLater() for more details.
#define QEventLoop_ExcludeUserInputEvents         0x01   // Do not process user input events, such as ButtonPress and KeyPress. Note that the events are not discarded; they will be delivered the next time processEvents() is called without the ExcludeUserInputEvents flag.
#define QEventLoop_ExcludeSocketNotifiers         0x02   // Do not process socket notifier events. Note that the events are not discarded; they will be delivered the next time processEvents() is called without the ExcludeSocketNotifiers flag.
#define QEventLoop_WaitForMoreEvents              0x04   // Wait for events if no pending events are available.
#define QEventLoop_DeferredDeletion               0x10   // deprecated - do not use.
// The ProcessEventsFlags type is a typedef for QFlags<ProcessEventsFlag>. It stores an OR combination of ProcessEventsFlag values.

#define QTextEdit_NoWrap                          0
#define QTextEdit_WidgetWidth                     1
#define QTextEdit_FixedPixelWidth                 2
#define QTextEdit_FixedColumnWidth                3

#define QDockWidget_DockWidgetClosable            0x01   // The dock widget can be closed. On some systems the dock widget always has a close button when it's floating (for example on MacOS 10.5).
#define QDockWidget_DockWidgetMovable             0x02   // The dock widget can be moved between docks by the user.
#define QDockWidget_DockWidgetFloatable           0x04   // The dock widget can be detached from the main window, and floated as an independent window.
#define QDockWidget_DockWidgetVerticalTitleBar    0x08   // The dock widget displays a vertical title bar on its left side. This can be used to increase the amount of vertical space in a QMainWindow.
#define QDockWidget_NoDockWidgetFeatures          0x00   // The dock widget cannot be closed, moved, or floated.

#define QMainWindow_AnimatedDocks                 0x01   // Identical to the animated property.
#define QMainWindow_AllowNestedDocks              0x02   // Identical to the dockNestingEnabled property.
#define QMainWindow_AllowTabbedDocks              0x04   // The user can drop one dock widget "on top" of another. The two widgets are stacked and a tab bar appears for selecting which one is visible.
#define QMainWindow_ForceTabbedDocks              0x08   // Each dock area contains a single stack of tabbed dock widgets. In other words, dock widgets cannot be placed next to each other in a dock area. If this option is set, AllowNestedDocks has no effect.
#define QMainWindow_VerticalTabs                  0x10   // The two vertical dock areas on the sides of the main window show their tabs vertically. If this option is not set, all dock areas show their tabs at the bottom. Implies AllowTabbedDocks. See also setTabPosition().

#define QTabWidget_North                          0      // The tabs are drawn above the pages.
#define QTabWidget_South                          1      // The tabs are drawn below the pages.
#define QTabWidget_West                           2      // The tabs are drawn to the left of the pages.
#define QTabWidget_East                           3      // The tabs are drawn to the right of the pages.
#define QTabWidget_Rounded                        0      // The tabs are drawn with a rounded look. This is the default shape.
#define QTabWidget_Triangular                     1      // The tabs are drawn with a triangular look.

#define QTextDocument_FindBackward                0x00001   // Search backwards instead of forwards.
#define QTextDocument_FindCaseSensitively         0x00002   // By default find works case insensitive. Specifying this option changes the behaviour to a case sensitive find operation.
#define QTextDocument_FindWholeWords              0x00004   // Makes find match only complete words.
#define QTextDocument_DocumentTitle               0         // The title of the document.
#define QTextDocument_DocumentUrl                 1         // The url of the document. The loadResource() function uses this url as the base when loading relative resources.
#define QTextDocument_HtmlResource                1         // The resource contains HTML.
#define QTextDocument_ImageResource               2         // The resource contains image data. Currently supported data types are QVariant::Pixmap and QVariant::Image. If the corresponding variant is of type QVariant::ByteArray then Qt attempts to load the image using QImage::loadFromData. QVariant::Icon is currently not supported. The icon needs to be converted to one of the supported types first, for example using QIcon::pixmap.
#define QTextDocument_StyleSheetResource          3         // The resource contains CSS.
#define QTextDocument_UserResource                100       // The first available value for user defined resource types.

#define QPlainTextEdit_NoWrap                     0
#define QPlainTextEdit_WidgetWidth                1

#define QLayout_SetDefaultConstraint              0        // The main widget's minimum size is set to minimumSize(), unless the widget already has a minimum size.
#define QLayout_SetFixedSize                      3        // The main widget's size is set to sizeHint(); it cannot be resized at all.
#define QLayout_SetMinimumSize                    2        // The main widget's minimum size is set to minimumSize(); it cannot be smaller.
#define QLayout_SetMaximumSize                    4        // The main widget's maximum size is set to maximumSize(); it cannot be larger.
#define QLayout_SetMinAndMaxSize                  5        // The main widget's minimum size is set to minimumSize() and its maximum size is set to maximumSize().
#define QLayout_SetNoConstraint                   1        // The widget is not constrained.

#define QCompleter_PopupCompletion                0        // Current completions are displayed in a popup window.
#define QCompleter_InlineCompletion               2        // Completions appear inline (as selected text).
#define QCompleter_UnfilteredPopupCompletion      1        // All possible completions are displayed in a popup window with the most likely suggestion indicated as current.

#define QCompleter_UnsortedModel                  0        // The model is unsorted.
#define QCompleter_CaseSensitivelySortedModel     1        // The model is sorted case sensitively.
#define QCompleter_CaseInsensitivelySortedModel   2        // The model is sorted case insensitively.

#define QToolButton_DelayedPopup                  0        // After pressing and holding the tool button down for a certain amount of time (the timeout is style dependant, see QStyle::SH_ToolButton_PopupDelay), the menu is displayed. A typical application example is the "back" button in some web browsers's tool bars. If the user clicks it, the browser simply browses back to the previous page. If the user presses and holds the button down for a while, the tool button shows a menu containing the current history list
#define QToolButton_MenuButtonPopup               1        // In this mode the tool button displays a special arrow to indicate that a menu is present. The menu is displayed when the arrow part of the button is pressed.
#define QToolButton_InstantPopup                  2        // The menu is displayed, without delay, when the tool button is pressed. In this mode, the button's own action is not triggered.

#define QSystemTrayIcon_Unknown                   0        // Unknown reason
#define QSystemTrayIcon_Context                   1        // The context menu for the system tray entry was requested
#define QSystemTrayIcon_DoubleClick               2        // The system tray entry was double clicked
#define QSystemTrayIcon_Trigger                   3        // The system tray entry was clicked
#define QSystemTrayIcon_MiddleClick               4        // The system tray entry was clicked with the middle mouse button

/* QMdiArea */
#define QMdiArea_SubWindowView                    0
#define QMdiArea_TabbedView                       1

#define QMdiArea_CreationOrder                    0
#define QMdiArea_StackingOrder                    1
#define QMdiArea_ActivationHistoryOrder           2

#define QMdiArea_DontMaximizeSubWindowOnActivation  1

#define QMdiSubWindow_RubberBandResize            0x04
#define QMdiSubWindow_RubberBandMove              0x08

/* QAbstractItemDelegate */
#define QAbstractItemDelegate_NoHint              0   // There is no recommended action to be performed.

//These hints let the delegate influence the behavior of the view:
#define QAbstractItemDelegate_EditNextItem        1   // The view should use the delegate to open an editor on the next item in the view.
#define QAbstractItemDelegate_EditPreviousItem    2   // The view should use the delegate to open an editor on the previous item in the view.

//The following hints are most useful when models are used that cache data, such as those that manipulate data locally in order to increase performance or conserve network bandwidth.
#define QAbstractItemDelegate_SubmitModelCache    3   // If the model caches data, it should write out cached data to the underlying data store.
#define QAbstractItemDelegate_RevertModelCache    4   // If the model caches data, it should discard cached data and replace it with data from the underlying data store.

#define QTabBar_LeftSide                          0   // Left side of the tab.
#define QTabBar_RightSide                         1   // Right side of the tab.
//This enum was introduced in Qt 4.5.

#define QTabBar_SelectLeftTab                     0   // Select the tab to the left of the one being removed.
#define QTabBar_SelectRightTab                    1   // Select the tab to the right of the one being removed.
#define QTabBar_SelectPreviousTab                 2   // Select the previously selected tab.
//This enum was introduced in Qt 4.5.

//enum QTabBar::Shape
//This enum type lists the built-in shapes supported by QTabBar. Treat these as hints as some styles may not render some of the shapes. However, position should be honored.
#define QTabBar_RoundedNorth                      0   // The normal rounded look above the pages
#define QTabBar_RoundedSouth                      1   // The normal rounded look below the pages
#define QTabBar_RoundedWest                       2   // The normal rounded look on the left side of the pages
#define QTabBar_RoundedEast                       3   // The normal rounded look on the right side the pages
#define QTabBar_TriangularNorth                   4   // Triangular tabs above the pages.
#define QTabBar_TriangularSouth                   5   // Triangular tabs similar to those used in the Excel spreadsheet, for example
#define QTabBar_TriangularWest                    6   // Triangular tabs on the left of the pages.
#define QTabBar_TriangularEast                    7   // Triangular tabs on the right of the pages.

// This enum specifies where the tick marks are to be drawn relative to the slider's groove and the handle the user moves.
#define QSlider_NoTicks                           0  // Do not draw any tick marks.
#define QSlider_TicksBothSides                    3  // Draw tick marks on both sides of the groove.
#define QSlider_TicksAbove                        1  // Draw tick marks above the (horizontal) slider
#define QSlider_TicksBelow                        2  // Draw tick marks below the (horizontal) slider
#define QSlider_TicksLeft                         QSlider_TicksAbove   // Draw tick marks to the left of the (vertical) slider
#define QSlider_TicksRight                        QSlider_TicksBelow   // Draw tick marks to the right of the (vertical) slider

//  This enum type defines the types of variable that a QVariant can contain.
#define QVariant_Invalid                          0     // no type
#define QVariant_BitArray                         13    // a QBitArray
#define QVariant_Bitmap                           73    // a QBitmap
#define QVariant_Bool                             1     // a bool
#define QVariant_Brush                            66    // a QBrush
#define QVariant_ByteArray                        12    // a QByteArray
#define QVariant_Char                             7     // a QChar
#define QVariant_Color                            67    // a QColor
#define QVariant_Cursor                           74    // a QCursor
#define QVariant_Date                             14    // a QDate
#define QVariant_DateTime                         16    // a QDateTime
#define QVariant_Double                           6     // a double
#define QVariant_EasingCurve                      29    // a QEasingCurve
#define QVariant_Font                             64    // a QFont
#define QVariant_Hash                             28    // a QVariantHash
#define QVariant_Icon                             69    // a QIcon
#define QVariant_Image                            70    // a QImage
#define QVariant_Int                              2     // an int
#define QVariant_KeySequence                      76    // a QKeySequence
#define QVariant_Line                             23    // a QLine
#define QVariant_LineF                            24    // a QLineF
#define QVariant_List                             9     // a QVariantList
#define QVariant_Locale                           18    // a QLocale
#define QVariant_LongLong                         4     // a qlonglong
#define QVariant_Map                              8     // a QVariantMap
#define QVariant_Matrix                           80    // a QMatrix(obsolete)
#define QVariant_Transform                        81    // a QTransform
#define QVariant_Matrix4x4                        82    // a QMatrix4x4
#define QVariant_Palette                          68    // a QPalette
#define QVariant_Pen                              77    // a QPen
#define QVariant_Pixmap                           65    // a QPixmap
#define QVariant_Point                            25    // a QPoint
#define QVariant_PointArray                       71    // a QPointArray as the same Polygon
#define QVariant_PointF                           26    // a QPointF
#define QVariant_Polygon                          71    // a QPolygon
#define QVariant_Quaternion                       86    // a QQuaternion
#define QVariant_Rect                             19    // a QRect
#define QVariant_RectF                            20    // a QRectF
#define QVariant_RegExp                           27    // a QRegExp
#define QVariant_Region                           72    // a QRegion
#define QVariant_Size                             21    // a QSize
#define QVariant_SizeF                            22    // a QSizeF
#define QVariant_SizePolicy                       75    // a QSizePolicy
#define QVariant_String                           10    // a QString
#define QVariant_StringList                       11    // a QStringList
#define QVariant_TextFormat                       79    // a QTextFormat
#define QVariant_TextLength                       78    // a QTextLength
#define QVariant_Time                             15    // a QTime
#define QVariant_UInt                             3     // a uint
#define QVariant_ULongLong                        5     // a qulonglong
#define QVariant_Url                              17    // a QUrl
#define QVariant_Vector2D                         83    // a QVector2D
#define QVariant_Vector3D                         84    // a QVector3D
#define QVariant_Vector4D                         85    // a QVector4D
#define QVariant_UserType                         127   // Base value for user-defined types.

// describes the icon that is shown when a balloon message is displayed.
#define QSystemTrayIcon_NoIcon                    0  // No icon is shown.
#define QSystemTrayIcon_Information               1  // An information icon is shown.
#define QSystemTrayIcon_Warning                   2  // A standard warning icon is shown.
#define QSystemTrayIcon_Critical                  3  // A critical warning icon is shown.

// This type is used to determine the direction of a box layout.
#define QBoxLayout_LeftToRight                    0  // Horizontal from left to right.
#define QBoxLayout_RightToLeft                    1  // Horizontal from right to left.
#define QBoxLayout_TopToBottom                    2  // Vertical from top to bottom.
#define QBoxLayout_BottomToTop                    3  // Vertical from bottom to top.

// These enums describe flags for standard buttons. Each button has a defined ButtonRole.
#define QDialogButtonBox_Ok                       0x00000400  // An "OK" button defined with the AcceptRole.
#define QDialogButtonBox_Open                     0x00002000  // A "Open" button defined with the AcceptRole.
#define QDialogButtonBox_Save                     0x00000800  // A "Save" button defined with the AcceptRole.
#define QDialogButtonBox_Cancel                   0x00400000  // A "Cancel" button defined with the RejectRole.
#define QDialogButtonBox_Close                    0x00200000  // A "Close" button defined with the RejectRole.
#define QDialogButtonBox_Discard                  0x00800000  // A "Discard" or "Don't Save" button, depending on the platform, defined with the DestructiveRole.
#define QDialogButtonBox_Apply                    0x02000000  // An "Apply" button defined with the ApplyRole.
#define QDialogButtonBox_Reset                    0x04000000  // A "Reset" button defined with the ResetRole.
#define QDialogButtonBox_RestoreDefaults          0x08000000  // A "Restore Defaults" button defined with the ResetRole.
#define QDialogButtonBox_Help                     0x01000000  // A "Help" button defined with the HelpRole.
#define QDialogButtonBox_SaveAll                  0x00001000  // A "Save All" button defined with the AcceptRole.
#define QDialogButtonBox_Yes                      0x00004000  // A "Yes" button defined with the YesRole.
#define QDialogButtonBox_YesToAll                 0x00008000  // A "Yes to All" button defined with the YesRole.
#define QDialogButtonBox_No                       0x00010000  // A "No" button defined with the NoRole.
#define QDialogButtonBox_NoToAll                  0x00020000  // A "No to All" button defined with the NoRole.
#define QDialogButtonBox_Abort                    0x00040000  // An "Abort" button defined with the RejectRole.
#define QDialogButtonBox_Retry                    0x00080000  // A "Retry" button defined with the AcceptRole.
#define QDialogButtonBox_Ignore                   0x00100000  // An "Ignore" button defined with the AcceptRole.
#define QDialogButtonBox_NoButton                 0x00000000  // An invalid button.

// This enum describes the roles that can be used to describe buttons in the button box. Combinations of these roles are as flags used to describe different aspects of their behavior.
#define QDialogButtonBox_InvalidRole              -1 // The button is invalid.
#define QDialogButtonBox_AcceptRole               0  // Clicking the button causes the dialog to be accepted (e.g. OK).
#define QDialogButtonBox_RejectRole               1  // Clicking the button causes the dialog to be rejected (e.g. Cancel).
#define QDialogButtonBox_DestructiveRole          2  // Clicking the button causes a destructive change (e.g. for Discarding Changes) and closes the dialog.
#define QDialogButtonBox_ActionRole               3  // Clicking the button causes changes to the elements within the dialog.
#define QDialogButtonBox_HelpRole                 4  // The button can be clicked to request help.
#define QDialogButtonBox_YesRole                  5  // The button is a "Yes"-like button.
#define QDialogButtonBox_NoRole                   6  // The button is a "No"-like button.
#define QDialogButtonBox_ApplyRole                8  // The button applies current changes.
#define QDialogButtonBox_ResetRole                7  // The button resets the dialog's fields to default values.

// enum QClipboard::Mode
#define QClipboard_Clipboard                      0  // indicates that data should be stored and retrieved from the global clipboard.
#define QClipboard_Selection                      1  // indicates that data should be stored and retrieved from the global mouse selection. Support for Selection is provided only on systems with a global mouse selection (e.g. X11).
#define QClipboard_FindBuffer                     2  // indicates that data should be stored and retrieved from the Find buffer. This mode is used for holding search strings on Mac OS X.

// enum    #define QKeySequence_SequenceFormat
#define QKeySequence_NativeText                   0  // The key sequence as a platform specific string. This means that it will be shown translated and on the Mac it will resemble a key sequence from the menu bar. This enum is best used when you want to display the string to the user.
#define QKeySequence_PortableText                 1  // The key sequence is given in a "portable" format, suitable for reading and writing to a file. In many cases, it will look similar to the native text on Windows and X11.

// enum    #define QKeySequence_SequenceMatch
#define QKeySequence_NoMatch                      0  // The key sequences are different; not even partially matching.
#define QKeySequence_PartialMatch                 1  // The key sequences match partially, but are not the same.
#define QKeySequence_ExactMatch                   2  // The key sequences are the same.

// enum    #define QKeySequence_StandardKey
#define QKeySequence_AddTab                       19 // Add new tab.
#define QKeySequence_Back                         13 // Navigate back.
#define QKeySequence_Bold                         27 // Bold text.
#define QKeySequence_Close                        4  // Close document/tab.
#define QKeySequence_Copy                         9  // Copy.
#define QKeySequence_Cut                          8  // Cut.
#define QKeySequence_Delete                       7  // Delete.
#define QKeySequence_DeleteEndOfLine              60 // Delete end of line.
#define QKeySequence_DeleteEndOfWord              59 // Delete word from the end of the cursor.
#define QKeySequence_DeleteStartOfWord            58 // Delete the beginning of a word up to the cursor.
#define QKeySequence_Find                         22 // Find in document.
#define QKeySequence_FindNext                     23 // Find next result.
#define QKeySequence_FindPrevious                 24 // Find previous result.
#define QKeySequence_Forward                      14 // Navigate forward.
#define QKeySequence_HelpContents                 1  // Open help contents.
#define QKeySequence_InsertLineSeparator          62 // Insert a new line.
#define QKeySequence_InsertParagraphSeparator     61 // Insert a new paragraph.
#define QKeySequence_Italic                       28 // Italic text.
#define QKeySequence_MoveToEndOfBlock             41 // Move cursor to end of block. This shortcut is only used on the OS X.
#define QKeySequence_MoveToEndOfDocument          43 // Move cursor to end of document.
#define QKeySequence_MoveToEndOfLine              39 // Move cursor to end of line.
#define QKeySequence_MoveToNextChar               30 // Move cursor to next character.
#define QKeySequence_MoveToNextLine               34 // Move cursor to next line.
#define QKeySequence_MoveToNextPage               36 // Move cursor to next page.
#define QKeySequence_MoveToNextWord               32 // Move cursor to next word.
#define QKeySequence_MoveToPreviousChar           31 // Move cursor to previous character.
#define QKeySequence_MoveToPreviousLine           35 // Move cursor to previous line.
#define QKeySequence_MoveToPreviousPage           37 // Move cursor to previous page.
#define QKeySequence_MoveToPreviousWord           33 // Move cursor to previous word.
#define QKeySequence_MoveToStartOfBlock           40 // Move cursor to start of a block. This shortcut is only used on OS X.
#define QKeySequence_MoveToStartOfDocument        42 // Move cursor to start of document.
#define QKeySequence_MoveToStartOfLine            38 // Move cursor to start of line.
#define QKeySequence_New                          6  // Create new document.
#define QKeySequence_NextChild                    20 // Navigate to next tab or child window.
#define QKeySequence_Open                         3  // Open document.
#define QKeySequence_Paste                        10 // Paste.
#define QKeySequence_Preferences                  64 // Open the preferences dialog.
#define QKeySequence_PreviousChild                21 // Navigate to previous tab or child window.
#define QKeySequence_Print                        18 // Print document.
#define QKeySequence_Quit                         65 // Quit the application.
#define QKeySequence_Redo                         12 // Redo.
#define QKeySequence_Refresh                      15 // Refresh or reload current document.
#define QKeySequence_Replace                      25 // Find and replace.
#define QKeySequence_SaveAs                       63 // Save document after prompting the user for a file name.
#define QKeySequence_Save                         5  // Save document.
#define QKeySequence_SelectAll                    26 // Select all text.
#define QKeySequence_SelectEndOfBlock             55 // Extend selection to the end of a text block. This shortcut is only used on OS X.
#define QKeySequence_SelectEndOfDocument          57 // Extend selection to end of document.
#define QKeySequence_SelectEndOfLine              53 // Extend selection to end of line.
#define QKeySequence_SelectNextChar               44 // Extend selection to next character.
#define QKeySequence_SelectNextLine               48 // Extend selection to next line.
#define QKeySequence_SelectNextPage               50 // Extend selection to next page.
#define QKeySequence_SelectNextWord               46 // Extend selection to next word.
#define QKeySequence_SelectPreviousChar           45 // Extend selection to previous character.
#define QKeySequence_SelectPreviousLine           49 // Extend selection to previous line.
#define QKeySequence_SelectPreviousPage           51 // Extend selection to previous page.
#define QKeySequence_SelectPreviousWord           47 // Extend selection to previous word.
#define QKeySequence_SelectStartOfBlock           54 // Extend selection to the start of a text block. This shortcut is only used on OS X.
#define QKeySequence_SelectStartOfDocument        56 // Extend selection to start of document.
#define QKeySequence_SelectStartOfLine            52 // Extend selection to start of line.
#define QKeySequence_Underline                    29 // Underline text.
#define QKeySequence_Undo                         11 // Undo.
#define QKeySequence_UnknownKey                   0  // Unbound key.
#define QKeySequence_WhatsThis                    2  // Activate whats this.
#define QKeySequence_ZoomIn                       16 // Zoom in.
#define QKeySequence_ZoomOut                      17 // Zoom out.
#define QKeySequence_Backspace                    69 // Delete previous character.
#define QKeySequence_DeleteCompleteLine           68 // Delete the entire line.
#define QKeySequence_Deselect                     67 // Deselect text. Since 5.1
#define QKeySequence_FullScreen                   66 // Toggle the window state to/from full screen.
#define QKeySequence_Cancel                       70 // Cancel the current operation.

//enum QDateTimeEdit::Section
#define QDateTimeEdit_NoSection                   0x0000
#define QDateTimeEdit_AmPmSection                 0x0001
#define QDateTimeEdit_MSecSection                 0x0002
#define QDateTimeEdit_SecondSection               0x0004
#define QDateTimeEdit_MinuteSection               0x0008
#define QDateTimeEdit_HourSection                 0x0010
#define QDateTimeEdit_DaySection                  0x0100
#define QDateTimeEdit_MonthSection                0x0200
#define QDateTimeEdit_YearSection                 0x0400

// enum QProgressBar::Direction
#define QProgressBar_TopToBottom                  0  // The text is rotated 90 degrees clockwise.
#define QProgressBar_BottomToTop                  1  // The text is rotated 90 degrees counter-clockwise.

//enum QItemSelectionModel::SelectionFlag
#define QItemSelectionModel_NoUpdate              0x0000   // No selection will be made.
#define QItemSelectionModel_Clear                 0x0001   // The complete selection will be cleared.
#define QItemSelectionModel_Select                0x0002   // All specified indexes will be selected.
#define QItemSelectionModel_Deselect              0x0004   // All specified indexes will be deselected.
#define QItemSelectionModel_Toggle                0x0008   // All specified indexes will be selected or deselected depending on their current state.
#define QItemSelectionModel_Current               0x0010   // The current selection will be updated.
#define QItemSelectionModel_Rows                  0x0020   // All indexes will be expanded to span rows.
#define QItemSelectionModel_Columns               0x0040   // All indexes will be expanded to span columns.
#define QItemSelectionModel_SelectCurrent         hb_bitOr(QItemSelectionModel_Select, QItemSelectionModel_Current) // A combination of Select and Current, provided for convenience.
#define QItemSelectionModel_ToggleCurrent         hb_bitOr(QItemSelectionModel_Toggle, QItemSelectionModel_Current) // A combination of Toggle and Current, provided for convenience.
#define QItemSelectionModel_ClearAndSelect        hb_bitOr(QItemSelectionModel_Clear, QItemSelectionModel_Select)   // A combination of Clear and Select, provided for convenience.


#define QGraphicsScene_BspTreeIndex                          0
#define QGraphicsScene_NoIndex                               -1

#define QGraphicsScene_ItemLayer                             0x1
#define QGraphicsScene_BackgroundLayer                       0x2
#define QGraphicsScene_ForegroundLayer                       0x4
#define QGraphicsScene_AllLayers                             0xffff

#define QGraphicsView_CacheNone                              0x0
#define QGraphicsView_CacheBackground                        0x1

#define QGraphicsView_NoDrag                                 0
#define QGraphicsView_ScrollHandDrag                         1
#define QGraphicsView_RubberBandDrag                         2

#define QGraphicsView_DontClipPainter                        0x1
#define QGraphicsView_DontSavePainterState                   0x2
#define QGraphicsView_DontAdjustForAntialiasing              0x4

#define QGraphicsView_NoAnchor                               0
#define QGraphicsView_AnchorViewCenter                       1
#define QGraphicsView_AnchorUnderMouse                       2

#define QGraphicsView_FullViewportUpdate                     0
#define QGraphicsView_MinimalViewportUpdate                  1
#define QGraphicsView_SmartViewportUpdate                    2
#define QGraphicsView_BoundingRectViewportUpdate             4
#define QGraphicsView_NoViewportUpdate                       3

#define QGraphicsItem_NoCache                                0
#define QGraphicsItem_ItemCoordinateCache                    1
#define QGraphicsItem_DeviceCoordinateCache                  2
#define QGraphicsItem_ItemEnabledChange                      3
#define QGraphicsItem_ItemEnabledHasChanged                  13
#define QGraphicsItem_ItemMatrixChange                       1
#define QGraphicsItem_ItemPositionChange                     0
#define QGraphicsItem_ItemPositionHasChanged                 9
#define QGraphicsItem_ItemTransformChange                    8
#define QGraphicsItem_ItemTransformHasChanged                10
#define QGraphicsItem_ItemSelectedChange                     4
#define QGraphicsItem_ItemSelectedHasChanged                 14
#define QGraphicsItem_ItemVisibleChange                      2
#define QGraphicsItem_ItemVisibleHasChanged                  12
#define QGraphicsItem_ItemParentChange                       5
#define QGraphicsItem_ItemParentHasChanged                   15
#define QGraphicsItem_ItemChildAddedChange                   6
#define QGraphicsItem_ItemChildRemovedChange                 7
#define QGraphicsItem_ItemSceneChange                        11
#define QGraphicsItem_ItemSceneHasChanged                    16
#define QGraphicsItem_ItemCursorChange                       17
#define QGraphicsItem_ItemCursorHasChanged                   18
#define QGraphicsItem_ItemToolTipChange                      19
#define QGraphicsItem_ItemToolTipHasChanged                  20
#define QGraphicsItem_ItemFlagsChange                        21
#define QGraphicsItem_ItemFlagsHaveChanged                   22
#define QGraphicsItem_ItemZValueChange                       23
#define QGraphicsItem_ItemZValueHasChanged                   24
#define QGraphicsItem_ItemOpacityChange                      25
#define QGraphicsItem_ItemOpacityHasChanged                  26
#define QGraphicsItem_ItemIsMovable                          0x1
#define QGraphicsItem_ItemIsSelectable                       0x2
#define QGraphicsItem_ItemIsFocusable                        0x4
#define QGraphicsItem_ItemClipsToShape                       0x8
#define QGraphicsItem_ItemClipsChildrenToShape               0x10
#define QGraphicsItem_ItemIgnoresTransformations             0x20
#define QGraphicsItem_ItemIgnoresParentOpacity               0x40
#define QGraphicsItem_ItemDoesntPropagateOpacityToChildren   0x80
#define QGraphicsItem_ItemStacksBehindParent                 0x100

#define QGraphicsPixmapItem_MaskShape                        0
#define QGraphicsPixmapItem_BoundingRectShape                1
#define QGraphicsPixmapItem_HeuristicMaskShape               2


#define QGraphicsSceneContextMenuEvent_Mouse                 0
#define QGraphicsSceneContextMenuEvent_Keyboard              1
#define QGraphicsSceneContextMenuEvent_Other                 2

#define QGradient_LogicalMode                                0   // This is the default mode. The gradient coordinates are specified logical space just like the object coordinates.
#define QGradient_StretchToDeviceMode                        1   // In this mode the gradient coordinates are relative to the bounding rectangle of the paint device, with (0,0) in the top left corner, and (1,1) in the bottom right corner of the paint device.
#define QGradient_ObjectBoundingMode                         2   // In this mode the gradient coordinates are relative to the bounding rectangle of the object being drawn, with (0,0) in the top left corner, and (1,1) in the bottom right corner of the object's bounding rectangle.

#define QGradient_PadSpread                                  0   // The area is filled with the closest stop color. This is the default.
#define QGradient_RepeatSpread                               2   // The gradient is repeated outside the gradient area.
#define QGradient_ReflectSpread                              1   // The gradient is reflected outside the gradient area.

#define QGradient_LinearGradient                             0   // Interpolates colors between start and end points (QLinearGradient).
#define QGradient_RadialGradient                             1   // Interpolate colors between a focal point and end points on a circle surrounding it (QRadialGradient).
#define QGradient_ConicalGradient                            2   // Interpolate colors around a center point (QConicalGradient).
#define QGradient_NoGradient                                 3   // No gradient is used.


#define QPainter_CompositionMode_SourceOver                  0
#define QPainter_CompositionMode_DestinationOver             1
#define QPainter_CompositionMode_Clear                       2
#define QPainter_CompositionMode_Source                      3
#define QPainter_CompositionMode_Destination                 4
#define QPainter_CompositionMode_SourceIn                    5
#define QPainter_CompositionMode_DestinationIn               6
#define QPainter_CompositionMode_SourceOut                   7
#define QPainter_CompositionMode_DestinationOut              8
#define QPainter_CompositionMode_SourceAtop                  9
#define QPainter_CompositionMode_DestinationAtop             10
#define QPainter_CompositionMode_Xor                         11
#define QPainter_CompositionMode_Plus                        12
#define QPainter_CompositionMode_Multiply                    13
#define QPainter_CompositionMode_Screen                      14
#define QPainter_CompositionMode_Overlay                     15
#define QPainter_CompositionMode_Darken                      16
#define QPainter_CompositionMode_Lighten                     17
#define QPainter_CompositionMode_ColorDodge                  18
#define QPainter_CompositionMode_ColorBurn                   19
#define QPainter_CompositionMode_HardLight                   20
#define QPainter_CompositionMode_SoftLight                   21
#define QPainter_CompositionMode_Difference                  22
#define QPainter_CompositionMode_Exclusion                   23
#define QPainter_RasterOp_SourceOrDestination                24
#define QPainter_RasterOp_SourceAndDestination               25
#define QPainter_RasterOp_SourceXorDestination               26
#define QPainter_RasterOp_NotSourceAndNotDestination         27
#define QPainter_RasterOp_NotSourceOrNotDestination          28
#define QPainter_RasterOp_NotSourceXorDestination            29
#define QPainter_RasterOp_NotSource                          30
#define QPainter_RasterOp_NotSourceAndDestination            31
#define QPainter_RasterOp_SourceAndNotDestination            32

#define QPainter_Antialiasing                                0x01
#define QPainter_TextAntialiasing                            0x02
#define QPainter_SmoothPixmapTransform                       0x04
#define QPainter_HighQualityAntialiasing                     0x08
#define QPainter_NonCosmeticDefaultPen                       0x10

#define QComboBox_NoInsert                                   0    // The string will not be inserted into the combobox.
#define QComboBox_InsertAtTop                                1    // The string will be inserted as the first item in the combobox.
#define QComboBox_InsertAtCurrent                            2    // The current item will be replaced by the string.
#define QComboBox_InsertAtBottom                             3    // The string will be inserted after the last item in the combobox.
#define QComboBox_InsertAfterCurrent                         4    // The string is inserted after the current item in the combobox.
#define QComboBox_InsertBeforeCurrent                        5    // The string is inserted before the current item in the combobox.
#define QComboBox_InsertAlphabetically                       6    // The string is inserted in the alphabetic order in the combobox.

#define QComboBox_AdjustToContents                           0    // The combobox will always adjust to the contents
#define QComboBox_AdjustToContentsOnFirstShow                1    // The combobox will adjust to its contents the first time it is shown.
#define QComboBox_AdjustToMinimumContentsLength              2    // Use AdjustToContents or AdjustToContentsOnFirstShow instead.
#define QComboBox_AdjustToMinimumContentsLengthWithIcon      3    // The combobox will adjust to minimumContentsLength plus space for an icon. For performance reasons use this policy on large models.

#define QDesktopServices_DesktopLocation                     0    // Returns the user's desktop directory.
#define QDesktopServices_DocumentsLocation                   1    // Returns the user's document.
#define QDesktopServices_FontsLocation                       2    // Returns the user's fonts.
#define QDesktopServices_ApplicationsLocation                3    // Returns the user's applications.
#define QDesktopServices_MusicLocation                       4    // Returns the users music.
#define QDesktopServices_MoviesLocation                      5    // Returns the user's movies.
#define QDesktopServices_PicturesLocation                    6    // Returns the user's pictures.
#define QDesktopServices_TempLocation                        7    // Returns the system's temporary directory.
#define QDesktopServices_HomeLocation                        8    // Returns the user's home directory.
#define QDesktopServices_DataLocation                        9    // Returns a directory location where persistent application data can be stored. QCoreApplication::applicationName and QCoreApplication::organizationName should work on all platforms.
#define QDesktopServices_CacheLocation                       10   // Returns a directory location where user-specific non-essential (cached) data should be written.


#define QFormLayout_FieldsStayAtSizeHint                     0    // The fields never grow beyond their effective size hint. This is the default for QMacStyle.
#define QFormLayout_ExpandingFieldsGrow                      1    // Fields with an horizontal size policy of Expanding or MinimumExpanding will grow to fill the available space. The other fields will not grow beyond their effective size hint. This is the default policy for Plastique.
#define QFormLayout_AllNonFixedFieldsGrow                    2    // All fields with a size policy that allows them to grow will grow to fill the available space. This is the default policy for most styles.
#define QFormLayout_LabelRole                                0    // A label widget.
#define QFormLayout_FieldRole                                1    // A field widget.
#define QFormLayout_SpanningRole                             2    // A widget that spans label and field columns.
#define QFormLayout_DontWrapRows                             0    // Fields are always laid out next to their label. This is the default policy for all styles except Qt Extended styles and QS60Style.
#define QFormLayout_WrapLongRows                             1    // Labels are given enough horizontal space to fit the widest label, and the rest of the space is given to the fields. If the minimum size of a field pair is wider than the available space, the field is wrapped to the next line. This is the default policy for Qt Extended styles and and QS60Style.
#define QFormLayout_WrapAllRows                              2    // Fields are always laid out below their label.

// Extracted by Luigi Ferraris
//
#define QTextOption_NoWrap                                   0    // Text is not wrapped at all.
#define QTextOption_WordWrap                                 1    // Text is wrapped at word boundaries.
#define QTextOption_ManualWrap                               2    // Same as QTextOption_NoWrap
#define QTextOption_WrapAnywhere                             3    // Text can be wrapped at any point on a line, even if it occurs in the middle of a word.
#define QTextOption_WrapAtWordBoundaryOrAnywhere             4    // If possible, wrapping occurs at a word boundary; otherwise it will occur at the appropriate point on the line, even in the middle of a word.

// Extracted by Luigi Ferraris
//
#define QImage_Format_Invalid                                0     // The image is invalid.
#define QImage_Format_Mono                                   1     // The image is stored using 1-bit per pixel. Bytes are packed with the most significant bit (MSB) first.
#define QImage_Format_MonoLSB                                2     // The image is stored using 1-bit per pixel. Bytes are packed with the less significant bit (LSB) first.
#define QImage_Format_Indexed8                               3     // The image is stored using 8-bit indexes into a colormap.
#define QImage_Format_RGB32                                  4     // The image is stored using a 32-bit RGB format (0xffRRGGBB).
#define QImage_Format_ARGB32                                 5     // The image is stored using a 32-bit ARGB format (0xAARRGGBB).
#define QImage_Format_ARGB32_Premultiplied                   6     // The image is stored using a premultiplied 32-bit ARGB format (0xAARRGGBB), i.e&#x2e; the red, green, and blue channels are multiplied by the alpha component divided by 255. (If RR, GG, or BB has a higher value than the alpha channel, the results are undefined.) Certain operations (such as image composition using alpha blending) are faster using premultiplied ARGB32 than with plain ARGB32.
#define QImage_Format_RGB16                                  7     // The image is stored using a 16-bit RGB format (5-6-5).
#define QImage_Format_ARGB8565_Premultiplied                 8     // The image is stored using a premultiplied 24-bit ARGB format (8-5-6-5).
#define QImage_Format_RGB666                                 9     // The image is stored using a 24-bit RGB format (6-6-6). The unused most significant bits is always zero.
#define QImage_Format_ARGB6666_Premultiplied                 10    // The image is stored using a premultiplied 24-bit ARGB format (6-6-6-6).
#define QImage_Format_RGB555                                 11    // The image is stored using a 16-bit RGB format (5-5-5). The unused most significant bit is always zero.
#define QImage_Format_ARGB8555_Premultiplied                 12    // The image is stored using a premultiplied 24-bit ARGB format (8-5-5-5).
#define QImage_Format_RGB888                                 13    // The image is stored using a 24-bit RGB format (8-8-8).
#define QImage_Format_RGB444                                 14    // The image is stored using a 16-bit RGB format (4-4-4). The unused bits are always zero.
#define QImage_Format_ARGB4444_Premultiplied                 15    // The image is stored using a premultiplied 16-bit ARGB format (4-4-4-4).

#define QAbstractSpinBox_UpDownArrows                        0     // Little arrows in the classic style.
#define QAbstractSpinBox_PlusMinus                           1     // + and - symbols.
#define QAbstractSpinBox_NoButtons                           2     // Don't display buttons.

/* QtDeclarative Constants */
#define QDeclarativeView_SizeViewToRootObject                0     // The view resizes with the root item in the QML.
#define QDeclarativeView_SizeRootObjectToView                1     // The view will automatically resize the root item to the size of the view.

#define QDeclarativeView_Null                                0     // This QDeclarativeView has no source set.
#define QDeclarativeView_Ready                               1     // This QDeclarativeView has loaded and created the QML component.
#define QDeclarativeView_Loading                             2     // This QDeclarativeView is loading network data.
#define QDeclarativeView_Error                               3     // One or more errors has occurred. Call errors() to retrieve a list of errors.

#define QDeclarativeComponent_Null                           0     // This QDeclarativeComponent has no data. Call loadUrl() or setData() to add QML content.
#define QDeclarativeComponent_Ready                          1     // This QDeclarativeComponent is ready and create() may be called.
#define QDeclarativeComponent_Loading                        2     // This QDeclarativeComponent is loading network data.
#define QDeclarativeComponent_Error                          3     // An error has occurred. Call errors() to retrieve a list of {QDeclarativeError}{errors}.

#define QDeclarativeEngine_CppOwnership                      0     // The object is owned by C++ code, and will never be deleted by QML. The JavaScript destroy() method cannot be used on objects with CppOwnership. This option is similar to QScriptEngine::QtOwnership.
#define QDeclarativeEngine_JavaScriptOwnership               1     // The object is owned by JavaScript. When the object is returned to QML as the return value of a method call or property access, QML will delete the object if there are no remaining JavaScript references to it and it has no QObject::parent(). This option is similar to QScriptEngine::ScriptOwnership.


//MenuRole of Qaction
#define QAction_NoRole                                       0     // This action should not be put into the application menu
#define QAction_TextHeuristicRole                            1     // This action should be put in the application menu based on the action's text as described in the QMenuBar documentation.
#define QAction_ApplicationSpecificRole                      2     // This action should be put in the application menu with an application specific role
#define QAction_AboutQtRole                                  3     // This action matches handles the "About Qt" menu item.
#define QAction_AboutRole                                    4     // This action should be placed where the "About" menu item is in the application menu. The text of the menu item will be set to "About <application name>". The application name is fetched from the Info.plist file in the application's bundle (See Deploying an Application on Mac OS X).
#define QAction_PreferencesRole                              5     // This action should be placed where the "Preferences..." menu item is in the application menu.
#define QAction_QuitRole                                     6     // This action should be placed where the Quit menu item is in the application menu.

//QApplication:Translate
#define QApplication_CodecForTr                              0     // The encoding specified by QTextCodec::codecForTr() (Latin-1 if none has been set).
#define QApplication_UnicodeUTF8                             1     // UTF-8

#define QLCDNumber_Hex                                       0     // Hexadecimal
#define QLCDNumber_Dec                                       1     // Decimal
#define QLCDNumber_Oct                                       2     // Octal
#define QLCDNumber_Bin                                       3     // Binary

#define QLCDNumber_Outline                                   0     // gives raised segments filled with the background color.
#define QLCDNumber_Filled                                    1     // gives raised segments filled with the windowText color.
#define QLCDNumber_Flat                                      2     // gives flat segments filled with the windowText color.

#define QValidator_Invalid                                   0     // The string is clearly invalid.
#define QValidator_Intermediate                              1     // The string is a plausible intermediate value.
#define QValidator_Acceptable                                2     // The string is acceptable as a final result; i.e. it is valid.

#define QTreeWidgetItem_ShowIndicator                        0     // The controls for expanding and collapsing will be shown for this item even if there are no children.
#define QTreeWidgetItem_DontShowIndicator                    1     // The controls for expanding and collapsing will never be shown even if there are children. If the node is forced open the user will not be able to expand or collapse the item.
#define QTreeWidgetItem_DontShowIndicatorWhenChildless       2     // The controls for expanding and collapsing will be shown if the item contains children.

#define QTreeWidgetItem_Type                                 0     // The default type for tree widget items.
#define QTreeWidgetItem_UserType                             1000  // The minimum value for custom types. Values below UserType are reserved by Qt.

#define QSettings_NativeFormat                               0     // Store the settings using the most appropriate storage format for the platform. On Windows, this means the system registry; on Mac OS X, this means the CFPreferences API; on Unix, this means textual configuration files in INI format.
#define QSettings_IniFormat                                  1     // Store the settings in INI files.
#define QSettings_InvalidFormat                              16    // Special value returned by registerFormat().

#define QSettings_UserScope                                  0     // Store settings in a location specific to the current user (e.g., in the user's home directory).
#define QSettings_SystemScope                                1     // Store settings in a global location, so that all users on the same machine access the same set of settings.

#define QSettings_NoError                                    0     // No error occurred.
#define QSettings_AccessError                                1     // An access error occurred (e.g. trying to write to a read-only file).
#define QSettings_FormatError                                2     // A format error occurred (e.g. loading a malformed INI file).

#define QIODevice_NotOpen                                    0x0000   // The device is not open.
#define QIODevice_ReadOnly                                   0x0001   // The device is open for reading.
#define QIODevice_WriteOnly                                  0x0002   // The device is open for writing.
#define QIODevice_ReadWrite                                  hb_bitOr( QIODevice_ReadOnly, QIODevice_WriteOnly ) // The device is open for reading and writing.
#define QIODevice_Append                                     0x0004   // The device is opened in append mode, so that all data is written to the end of the file.
#define QIODevice_Truncate                                   0x0008   // If possible, the device is truncated before it is opened. All earlier contents of the device are lost.
#define QIODevice_Text                                       0x0010   // When reading, the end-of-line terminators are translated to '\n'. When writing, the end-of-line terminators are translated to the local encoding, for example '\r\n' for Win32.
#define QIODevice_Unbuffered                                 0x0020   // Any buffer in the device is bypassed.

#define QDir_Dirs                                            0x001   // List directories that match the filters.
#define QDir_AllDirs                                         0x400   // List all directories; i.e. don't apply the filters to directory names.
#define QDir_Files                                           0x002   // List files.
#define QDir_Drives                                          0x004   // List disk drives (ignored under Unix).
#define QDir_NoSymLinks                                      0x008   // Do not list symbolic links (ignored by operating systems that don't support symbolic links).
#define QDir_NoDotAndDotDot                                  0x1000  // Do not list the special entries "." and "..".
#define QDir_NoDot                                           0x2000  // Do not list the special entry ".".
#define QDir_NoDotDot                                        0x4000  // Do not list the special entry "..".
#define QDir_AllEntries                                      hb_bitOr( QDir_Dirs, QDir_Files, QDir_Drives ) // List directories, files, drives and symlinks (this does not list broken symlinks unless you specify System).
#define QDir_Readable                                        0x010   // List files for which the application has read access. The Readable value needs to be combined with Dirs or Files.
#define QDir_Writable                                        0x020   // List files for which the application has write access. The Writable value needs to be combined with Dirs or Files.
#define QDir_Executable                                      0x040   // List files for which the application has execute access. The Executable value needs to be combined with Dirs or Files.
#define QDir_Modified                                        0x080   // Only list files that have been modified (ignored on Unix).
#define QDir_Hidden                                          0x100   // List hidden files (on Unix, files starting with a ".").
#define QDir_System                                          0x200   // List system files (on Unix, FIFOs, sockets and device files are included; on Windows, .lnk files are included)
#define QDir_CaseSensitive                                   0x800   // The filter should be case sensitive.
#define QDir_Name                                            0x00    // Sort by name.
#define QDir_Time                                            0x01    // Sort by time (modification time).
#define QDir_Size                                            0x02    // Sort by file size.
#define QDir_Type                                            0x80    // Sort by file type (extension).
#define QDir_Unsorted                                        0x03    // Do not sort.
#define QDir_NoSort                                          -1      // Not sorted by default.
#define QDir_DirsFirst                                       0x04    // Put the directories first, then the files.
#define QDir_DirsLast                                        0x20    // Put the files first, then the directories.
#define QDir_Reversed                                        0x08    // Reverse the sort order.
#define QDir_IgnoreCase                                      0x10    // Sort case-insensitively.
#define QDir_LocaleAware                                     0x40    // Sort items appropriately using the current locale settings.

// QWidget::grabGesture( QGesture::Type, QGesture::Flags )
#define Qt_DontStartGestureOnChildren                        0x01    // By default gestures can start on the widget or over any of its children. Use this flag to disable this and allow a gesture to start on the widget only.
#define Qt_ReceivePartialGestures                            0x02    // Allows any ignored gesture events to be propagated to parent widgets which have specified this hint. By default only gestures that are in the Qt_GestureStarted state are propagated and the widget always gets the full gesture sequence starting with a gesture in the Qt_GestureStarted state and ending with a gesture in the Qt_GestureFinished or Qt_GestureCanceled states.
#define Qt_IgnoredGesturesPropagateToParent                  0x04    // Since Qt 4.7, this flag allows you to fine-tune gesture event propagation. By setting the flag when grabbing a gesture all ignored partial gestures will propagate to their parent items.

// enum Qt_GestureState : describes the state of a gesture.
#define Qt_GestureStarted                                    1       // A continuous gesture has started.
#define Qt_GestureUpdated                                    2       // A gesture continues.
#define Qt_GestureFinished                                   3       // A gesture has finished.
#define Qt_GestureCanceled                                   4       // A gesture was canceled.enum Qt_GestureType

// This enum type describes the standard gestures.
#define Qt_TapGesture                                        1       // A Tap gesture.
#define Qt_TapAndHoldGesture                                 2       // A Tap-And-Hold (Long-Tap) gesture.
#define Qt_PanGesture                                        3       // A Pan gesture.
#define Qt_PinchGesture                                      4       // A Pinch gesture.
#define Qt_SwipeGesture                                      5       // A Swipe gesture.
#define Qt_CustomGesture                                     0x0100  // A flag that can be used to test if the gesture is a user-defined gesture ID.

// enum QGraphicsEffect::ChangeFlag
// flags QGraphicsEffect::ChangeFlags
// This enum describes what has changed in QGraphicsEffectSource.
#define QGraphicsEffect_SourceAttached                       0x1     // The effect is installed on a source.
#define QGraphicsEffect_SourceDetached                       0x2     // The effect is uninstalled on a source.
#define QGraphicsEffect_SourceBoundingRectChanged            0x4     // The bounding rect of the source has changed.
#define QGraphicsEffect_SourceInvalidated                    0x8     // The visual appearance of the source has changed.

// enum QGraphicsEffect::PixmapPadMode
// This enum describes how the pixmap returned from sourcePixmap should be padded.
#define QGraphicsEffect_NoPad                                0       // The pixmap should not receive any additional padding.
#define QGraphicsEffect_PadToTransparentBorder               1       // The pixmap should be padded to ensure it has a completely transparent border.
#define QGraphicsEffect_PadToEffectiveBoundingRect           2       // The pixmap should be padded to match the effective bounding rectangle of the effect.

// enum QGraphicsBlurEffect::BlurHint
// flags QGraphicsBlurEffect::BlurHints
// This enum describes the possible hints that can be used to control how blur effects are applied. The hints might not have an effect in all the paint engines.
#define QGraphicsBlurEffect_PerformanceHint                  0x00    // Indicates that rendering performance is the most important factor, at the potential cost of lower quality.
#define QGraphicsBlurEffect_QualityHint                      0x01    // Indicates that rendering quality is the most important factor, at the potential cost of lower performance.
#define QGraphicsBlurEffect_AnimationHint                    0x02    // Indicates that the blur radius is going to be animated, hinting that the implementation can keep a cache of blurred verisons of the source. Do not use this hint if the source is going to be dynamically changing.

// enum QGesture::GestureCancelPolicy
// This enum describes how accepting a gesture can cancel other gestures automatically.
#define QGesture_CancelNone                                  0       // On accepting this gesture no other gestures will be affected.
#define QGesture_CancelAllInContext                          1       // On accepting this gesture all gestures that are active in the context (respecting the #define Qt_GestureFlag that were specified when subscribed to the gesture) will be cancelled.

// enum QPinchGesture::ChangeFlag
// flags QPinchGesture::ChangeFlags
// This enum describes the changes that can occur to the properties of the gesture object.
#define QPinchGesture_ScaleFactorChanged                     0x1     // The scale factor held by scaleFactor changed.
#define QPinchGesture_RotationAngleChanged                   0x2     // The rotation angle held by rotationAngle changed.
#define QPinchGesture_CenterPointChanged                     0x4     // The center point held by centerPoint changed.

// enum QSwipeGesture::SwipeDirection
// This enum describes the possible directions for the gesture's motion along the horizontal and vertical axes.
#define QSwipeGesture_NoDirection                            0       // The gesture had no motion associated with it on a particular axis.
#define QSwipeGesture_Left                                   1       // The gesture involved a horizontal motion to the left.
#define QSwipeGesture_Right                                  2       // The gesture involved a horizontal motion to the right.
#define QSwipeGesture_Up                                     3       // The gesture involved an upward vertical motion.
#define QSwipeGesture_Down                                   4       // The gesture involved a downward vertical motion.


#define QLineF_NoIntersection                                0       // Indicates that the lines do not intersect; i.e. they are parallel.
#define QLineF_UnboundedIntersection                         2       // The two lines intersect, but not within the range defined by their lengths. This will be the case if the lines are not parallel.
#define QLineF_BoundedIntersection                           1       // The two lines intersect with each other within the start and end points of each line.

#define QSurface_Window                                      0       // The surface is an instance of QWindow.
#define QSurface_Offscreen                                   1       // The surface is an instance of QOffscreenSurface.

#define QSurface_RasterSurface                               0       // The surface is is composed of pixels and can be rendered to using a software rasterizer like Qt's raster paint engine.
#define QSurface_OpenGLSurface                               1       // The surface is an OpenGL compatible surface and can be used in conjunction with QOpenGLContext.

#define QSurfaceFormat_StereoBuffers                         0x0001  // Used to request stereo buffers in the surface format.
#define QSurfaceFormat_DebugContext                          0x0002  // Used to request a debug context with extra debugging information.
#define QSurfaceFormat_DeprecatedFunctions                   0x0004  // Used to request that deprecated functions be included in the OpenGL context profile. If not specified, you should get a forward compatible context without support functionality marked as deprecated. This requires OpenGL version 3.0 or higher.

#define QSurfaceFormat_NoProfile                             0       // OpenGL version is lower than 3.2.
#define QSurfaceFormat_CoreProfile                           1       // Functionality deprecated in OpenGL version 3.0 is not available.
#define QSurfaceFormat_CompatibilityProfile                  2       // Functionality from earlier OpenGL versions is available.

#define QSurfaceFormat_DefaultRenderableType                 0x0     // The default, unspecified rendering method
#define QSurfaceFormat_OpenGL                                0x1     // Desktop OpenGL rendering
#define QSurfaceFormat_OpenGLES                              0x2     // OpenGL ES 2.0 rendering
#define QSurfaceFormat_OpenVG                                0x4     // Open Vector Graphics rendering

#define QSurfaceFormat_DefaultSwapBehavior                   0       // The default, unspecified swap behaviour of the platform.
#define QSurfaceFormat_SingleBuffer                          1       // Used to request single buffering, which might result in flickering when OpenGL rendering is done directly to screen without an intermediate offscreen buffer.
#define QSurfaceFormat_DoubleBuffer                          2       // This is typically the default swap behaviour on desktop platforms, consisting of one back buffer and one front buffer. Rendering is done to the back buffer, and then the back buffer and front buffer are swapped, or the contents of the back buffer are copied to the front buffer, depending on the implementation.
#define QSurfaceFormat_TripleBuffer                          3       // This swap behaviour is sometimes used in order to decrease the risk of skipping a frame when the rendering rate is just barely keeping up with the screen refresh rate. Depending on the platform it might also lead to slightly more efficient use of the GPU due to improved pipelining behaviour. Triple buffering comes at the cost of an extra frame of memory usage and latency, and might not be supported depending on the underlying platform.

#define QWindow_ExcludeTransients                            0       // Transient parents are not considered ancestors.
#define QWindow_IncludeTransients                            1       // Transient parents are considered ancestors.

#define QWindow_Windowed                                     2       // The window occupies part of the screen, but not necessarily the entire screen. This state will occur only on windowing systems which support showing multiple windows simultaneously. In this state it is possible for the user to move and resize the window manually, if WindowFlags permit it and if it is supported by the windowing system.
#define QWindow_Minimized                                    3       // The window is reduced to an entry or icon on the task bar, dock, task list or desktop, depending on how the windowing system handles minimized windows.
#define QWindow_Maximized                                    4       // The window occupies one entire screen, and the titlebar is still visible. On most windowing systems this is the state achieved by clicking the maximize button on the toolbar.
#define QWindow_FullScreen                                   5       // The window occupies one entire screen, is not resizable, and there is no titlebar. On some platforms which do not support showing multiple simultaneous windows, this can be the usual visibility when the window is not hidden.
#define QWindow_AutomaticVisibility                          1       // This means to give the window a default visible state, which might be fullscreen or windowed depending on the platform. It can be given as a parameter to setVisibility but will never be read back from the visibility accessor.
#define QWindow_Hidden                                       0       // The window is not visible in any way, however it may remember a latent visibility which can be restored by setting AutomaticVisibility.

#define QFontDialog_NoButtons                                0x00000001  // Don't display OK and Cancel buttons. (Useful for "live dialogs".)
#define QFontDialog_DontUseNativeDialog                      0x00000002  // Use Qt's standard font dialog on the Mac instead of Apple's native font panel. (Currently, the native dialog is never used, but this is likely to change in future Qt releases.)

#define QColorDialog_ShowAlphaChannel                        0x00000001  // Allow the user to select the alpha component of a color.
#define QColorDialog_NoButtons                               0x00000002  // Don't display OK and Cancel buttons. (Useful for "live dialogs".)
#define QColorDialog_DontUseNativeDialog                     0x00000004  // Use Qt's standard color dialog on the Mac instead of Apple's native color panel.

#ifdef __HB_QT_MAJOR_VERSION_5__
   #define QLibraryInfo_PrefixPath                           0       // The default prefix for all paths.
   #define QLibraryInfo_DocumentationPath                    1       // The location for documentation upon install.
   #define QLibraryInfo_HeadersPath                          2       // The location for all headers.
   #define QLibraryInfo_LibrariesPath                        3       // The location of installed libraries.
   #define QLibraryInfo_LibraryExecutablesPath               4       // The location of installed executables required by libraries at runtime.
   #define QLibraryInfo_BinariesPath                         5       // The location of installed Qt binaries (tools and applications).
   #define QLibraryInfo_PluginsPath                          6       // The location of installed Qt plugins.
   #define QLibraryInfo_ImportsPath                          7       // The location of installed QML extensions to import (QML 1.x).
   #define QLibraryInfo_Qml2ImportsPath                      8       // The location of installed QML extensions to import (QML 2.x).
   #define QLibraryInfo_ArchDataPath                         9       // The location of general architecture-dependent Qt data.
   #define QLibraryInfo_DataPath                             10      // The location of general architecture-independent Qt data.
   #define QLibraryInfo_TranslationsPath                     11      // The location of translation information for Qt strings.
   #define QLibraryInfo_ExamplesPath                         12      // The location for examples upon install.
   #define QLibraryInfo_TestsPath                            13      // The location of installed Qt testcases.
   #define QLibraryInfo_SettingsPath                         100     // The location for Qt settings. Not applicable on Windows.
#else
   #define QLibraryInfo_PrefixPath                           0       // The default prefix for all paths.
   #define QLibraryInfo_DocumentationPath                    1       // The location for documentation upon install.
   #define QLibraryInfo_HeadersPath                          2       // The location for all headers.
   #define QLibraryInfo_LibrariesPath                        3       // The location of installed libraries.
   #define QLibraryInfo_BinariesPath                         4       // The location of installed Qt binaries (tools and applications).
   #define QLibraryInfo_PluginsPath                          5       // The location of installed Qt plugins.
   #define QLibraryInfo_ImportsPath                          11      // The location of installed QML extensions to import.
   #define QLibraryInfo_DataPath                             6       // The location of general Qt data.
   #define QLibraryInfo_TranslationsPath                     7       // The location of translation information for Qt strings.
   #define QLibraryInfo_SettingsPath                         8       // The location for Qt settings.
   #define QLibraryInfo_ExamplesPath                         10      //  The location for examples upon install.
   #define QLibraryInfo_DemosPath                            9       // The location for demos upon install.
#endif


//enum QStyle::ComplexControl
//This enum describes the available complex controls. Complex controls have different behavior depending upon where the user clicks on them or which keys are pressed.
#define QStyle_CC_SpinBox                                    0       // A spinbox, like QSpinBox.
#define QStyle_CC_ComboBox                                   1       // A combobox, like QComboBox.
#define QStyle_CC_ScrollBar                                  2       // A scroll bar, like QScrollBar.
#define QStyle_CC_Slider                                     3       // A slider, like QSlider.
#define QStyle_CC_ToolButton                                 4       // A tool button, like QToolButton.
#define QStyle_CC_TitleBar                                   5       // A Title bar, like those used in QMdiSubWindow.
#define QStyle_CC_GroupBox                                   7       // A group box, like QGroupBox.
#define QStyle_CC_Dial                                       6       // A dial, like QDial.
#define QStyle_CC_MdiControls                                8       // The minimize, close, and normal button in the menu bar for a maximized MDI subwindow.
#define QStyle_CC_CustomBase                                 0xf0000000   // Base value for custom complex controls. Custom values must be greater than this value.


//enum #define QStyle_ContentsType
//This enum describes the available contents types. These are used to calculate sizes for the contents of various widgets.
#define QStyle_CT_CheckBox                                   1       // A check box, like QCheckBox.
#define QStyle_CT_ComboBox                                   4       // A combo box, like QComboBox.
#define QStyle_CT_HeaderSection                              19      // A header section, like QHeader.
#define QStyle_CT_LineEdit                                   14      // A line edit, like QLineEdit.
#define QStyle_CT_Menu                                       10      // A menu, like QMenu.
#define QStyle_CT_MenuBar                                    9       // A menu bar, like QMenuBar.
#define QStyle_CT_MenuBarItem                                8       // A menu bar item, like the buttons in a QMenuBar.
#define QStyle_CT_MenuItem                                   7       // A menu item, like QMenuItem.
#define QStyle_CT_ProgressBar                                6       // A progress bar, like QProgressBar.
#define QStyle_CT_PushButton                                 0       // A push button, like QPushButton.
#define QStyle_CT_RadioButton                                2       // A radio button, like QRadioButton.
#define QStyle_CT_SizeGrip                                   16      // A size grip, like QSizeGrip.
#define QStyle_CT_Slider                                     12      // A slider, like QSlider.
#define QStyle_CT_ScrollBar                                  13      // A scroll bar, like QScrollBar.
#define QStyle_CT_SpinBox                                    15      // A spin box, like QSpinBox.
#define QStyle_CT_Splitter                                   5       // A splitter, like QSplitter.
#define QStyle_CT_TabBarTab                                  11      // A tab on a tab bar, like QTabBar.
#define QStyle_CT_TabWidget                                  17      // A tab widget, like QTabWidget.
#define QStyle_CT_ToolButton                                 3       // A tool button, like QToolButton.
#define QStyle_CT_GroupBox                                   20      // A group box, like QGroupBox.
#define QStyle_CT_ItemViewItem                               22      // An item inside an item view.
#define QStyle_CT_MdiControls                                21      // The minimize, normal, and close button in the menu bar for a maximized MDI subwindow.
#define QStyle_CT_CustomBase                                 0xf0000000   // Base value for custom contents types. Custom values must be greater than this value.

//enum #define QStyle_ControlElement
//This enum represents a control element. A control element is a part of a widget that performs some action or displays information to the user.
#define QStyle_CE_PushButton                                 0       // A QPushButton, draws CE_PushButtonBevel, CE_PushButtonLabel and PE_FrameFocusRect.
#define QStyle_CE_PushButtonBevel                            1       // The bevel and default indicator of a QPushButton.
#define QStyle_CE_PushButtonLabel                            2       // The label (an icon with text or pixmap) of a QPushButton.
#define QStyle_CE_DockWidgetTitle                            30      // Dock window title.
#define QStyle_CE_Splitter                                   28      // Splitter handle; see also QSplitter.
#define QStyle_CE_CheckBox                                   3       // A QCheckBox, draws a PE_IndicatorCheckBox, a CE_CheckBoxLabel and a PE_FrameFocusRect.
#define QStyle_CE_CheckBoxLabel                              4       // The label (text or pixmap) of a QCheckBox.
#define QStyle_CE_RadioButton                                5       // A QRadioButton, draws a PE_IndicatorRadioButton, a CE_RadioButtonLabel and a PE_FrameFocusRect.
#define QStyle_CE_RadioButtonLabel                           6       // The label (text or pixmap) of a QRadioButton.
#define QStyle_CE_TabBarTab                                  7       // The tab and label within a QTabBar.
#define QStyle_CE_TabBarTabShape                             8       // The tab shape within a tab bar.
#define QStyle_CE_TabBarTabLabel                             9       // The label within a tab.
#define QStyle_CE_ProgressBar                                10      // A QProgressBar, draws CE_ProgressBarGroove, CE_ProgressBarContents and CE_ProgressBarLabel.
#define QStyle_CE_ProgressBarGroove                          11      // The groove where the progress indicator is drawn in a QProgressBar.
#define QStyle_CE_ProgressBarContents                        12      // The progress indicator of a QProgressBar.
#define QStyle_CE_ProgressBarLabel                           13      // The text label of a QProgressBar.
#define QStyle_CE_ToolButtonLabel                            22      // A tool button's label.
#define QStyle_CE_MenuBarItem                                20      // A menu item in a QMenuBar.
#define QStyle_CE_MenuBarEmptyArea                           21      // The empty area of a QMenuBar.
#define QStyle_CE_MenuItem                                   14      // A menu item in a QMenu.
#define QStyle_CE_MenuScroller                               15      // Scrolling areas in a QMenu when the style supports scrolling.
#define QStyle_CE_MenuTearoff                                18      // A menu item representing the tear off section of a QMenu.
#define QStyle_CE_MenuEmptyArea                              19      // The area in a menu without menu items.
#define QStyle_CE_MenuHMargin                                17      // The horizontal extra space on the left/right of a menu.
#define QStyle_CE_MenuVMargin                                16      // The vertical extra space on the top/bottom of a menu.
#define QStyle_CE_ToolBoxTab                                 26      // The toolbox's tab and label within a QToolBox.
#define QStyle_CE_SizeGrip                                   27      // Window resize handle; see also QSizeGrip.
#define QStyle_CE_Header                                     23      // A header.
#define QStyle_CE_HeaderSection                              24      // A header section.
#define QStyle_CE_HeaderLabel                                25      // The header's label.
#define QStyle_CE_ScrollBarAddLine                           31      // Scroll bar line increase indicator. (i.e., scroll down); see also QScrollBar.
#define QStyle_CE_ScrollBarSubLine                           32      // Scroll bar line decrease indicator (i.e., scroll up).
#define QStyle_CE_ScrollBarAddPage                           33      // Scolllbar page increase indicator (i.e., page down).
#define QStyle_CE_ScrollBarSubPage                           34      // Scroll bar page decrease indicator (i.e., page up).
#define QStyle_CE_ScrollBarSlider                            35      // Scroll bar slider.
#define QStyle_CE_ScrollBarFirst                             36      // Scroll bar first line indicator (i.e., home).
#define QStyle_CE_ScrollBarLast                              37      // Scroll bar last line indicator (i.e., end).
#define QStyle_CE_RubberBand                                 29      // Rubber band used in for example an icon view.
#define QStyle_CE_FocusFrame                                 38      // Focus frame that is style controlled.
#define QStyle_CE_ItemViewItem                               45      // An item inside an item view.
#define QStyle_CE_ComboBoxLabel                              39      // The label of a non-editable QComboBox.
#define QStyle_CE_ToolBar                                    40      // A toolbar like QToolBar.
#define QStyle_CE_ToolBoxTabShape                            41      // The toolbox's tab shape.
#define QStyle_CE_ToolBoxTabLabel                            42      // The toolbox's tab label.
#define QStyle_CE_HeaderEmptyArea                            43      // The area of a header view where there are no header sections.
#define QStyle_CE_ShapedFrame                                46      // The frame with the shape specified in the QStyleOptionFrameV3; see QFrame.
#define QStyle_CE_CustomBase                                 0xf0000000   // Base value for custom control elements; custom values must be greater than this value.


//enum #define QStyle_PixelMetric
//This enum describes the various available pixel metrics. A pixel metric is a style dependent size represented by a single pixel value.
#define QStyle_PM_ButtonMargin                               0
#define QStyle_PM_ButtonDefaultIndicator                     1
#define QStyle_PM_MenuButtonIndicator                        2
#define QStyle_PM_ButtonShiftHorizontal                      3
#define QStyle_PM_ButtonShiftVertical                        4
#define QStyle_PM_DefaultFrameWidth                          5
#define QStyle_PM_SpinBoxFrameWidth                          6
#define QStyle_PM_ComboBoxFrameWidth                         7
#define QStyle_PM_MaximumDragDistance                        8
#define QStyle_PM_ScrollBarExtent                            9
#define QStyle_PM_ScrollBarSliderMin                         10
#define QStyle_PM_SliderThickness                            11
#define QStyle_PM_SliderControlThickness                     12
#define QStyle_PM_SliderLength                               13
#define QStyle_PM_SliderTickmarkOffset                       14
#define QStyle_PM_SliderSpaceAvailable                       15
#define QStyle_PM_DockWidgetSeparatorExtent                  16
#define QStyle_PM_DockWidgetHandleExtent                     17
#define QStyle_PM_DockWidgetFrameWidth                       18
#define QStyle_PM_TabBarTabOverlap                           19
#define QStyle_PM_TabBarTabHSpace                            20
#define QStyle_PM_TabBarTabVSpace                            21
#define QStyle_PM_TabBarBaseHeight                           22
#define QStyle_PM_TabBarBaseOverlap                          23
#define QStyle_PM_ProgressBarChunkWidth                      24
#define QStyle_PM_SplitterWidth                              25
#define QStyle_PM_TitleBarHeight                             26
#define QStyle_PM_MenuScrollerHeight                         27
#define QStyle_PM_MenuHMargin                                28
#define QStyle_PM_MenuVMargin                                29
#define QStyle_PM_MenuPanelWidth                             30
#define QStyle_PM_MenuTearoffHeight                          31
#define QStyle_PM_MenuDesktopFrameWidth                      32
#define QStyle_PM_MenuBarPanelWidth                          33
#define QStyle_PM_MenuBarItemSpacing                         34
#define QStyle_PM_MenuBarVMargin                             35
#define QStyle_PM_MenuBarHMargin                             36
#define QStyle_PM_IndicatorWidth                             37
#define QStyle_PM_IndicatorHeight                            38
#define QStyle_PM_ExclusiveIndicatorWidth                    39
#define QStyle_PM_ExclusiveIndicatorHeight                   40
#define QStyle_PM_DialogButtonsSeparator                     41
#define QStyle_PM_DialogButtonsButtonWidth                   42
#define QStyle_PM_DialogButtonsButtonHeight                  43
#define QStyle_PM_MdiSubWindowFrameWidth                     44
#define QStyle_PM_MDIFrameWidth                              QStyle_PM_MdiSubWindowFrameWidth
#define QStyle_PM_MdiSubWindowMinimizedWidth                 45
#define QStyle_PM_MDIMinimizedWidth                          QStyle_PM_MdiSubWindowMinimizedWidth
#define QStyle_PM_HeaderMargin                               46
#define QStyle_PM_HeaderMarkSize                             47
#define QStyle_PM_HeaderGripMargin                           48
#define QStyle_PM_TabBarTabShiftHorizontal                   49
#define QStyle_PM_TabBarTabShiftVertical                     50
#define QStyle_PM_TabBarScrollButtonWidth                    51
#define QStyle_PM_ToolBarFrameWidth                          52
#define QStyle_PM_ToolBarHandleExtent                        53
#define QStyle_PM_ToolBarItemSpacing                         54
#define QStyle_PM_ToolBarItemMargin                          55
#define QStyle_PM_ToolBarSeparatorExtent                     56
#define QStyle_PM_ToolBarExtensionExtent                     57
#define QStyle_PM_SpinBoxSliderHeight                        58
#define QStyle_PM_DefaultTopLevelMargin                      59
#define QStyle_PM_DefaultChildMargin                         60
#define QStyle_PM_DefaultLayoutSpacing                       61
#define QStyle_PM_ToolBarIconSize                            62
#define QStyle_PM_ListViewIconSize                           63
#define QStyle_PM_IconViewIconSize                           64
#define QStyle_PM_SmallIconSize                              65
#define QStyle_PM_LargeIconSize                              66
#define QStyle_PM_FocusFrameVMargin                          67
#define QStyle_PM_FocusFrameHMargin                          68
#define QStyle_PM_ToolTipLabelFrameWidth                     69
#define QStyle_PM_CheckBoxLabelSpacing                       70
#define QStyle_PM_TabBarIconSize                             71
#define QStyle_PM_SizeGripSize                               72
#define QStyle_PM_DockWidgetTitleMargin                      73
#define QStyle_PM_MessageBoxIconSize                         74
#define QStyle_PM_ButtonIconSize                             75
#define QStyle_PM_DockWidgetTitleBarButtonMargin             76
#define QStyle_PM_RadioButtonLabelSpacing                    77
#define QStyle_PM_LayoutLeftMargin                           78
#define QStyle_PM_LayoutTopMargin                            79
#define QStyle_PM_LayoutRightMargin                          80
#define QStyle_PM_LayoutBottomMargin                         81
#define QStyle_PM_LayoutHorizontalSpacing                    82
#define QStyle_PM_LayoutVerticalSpacing                      83
#define QStyle_PM_TabBar_ScrollButtonOverlap                 84
#define QStyle_PM_TextCursorWidth                            85
#define QStyle_PM_TabCloseIndicatorWidth                     86
#define QStyle_PM_TabCloseIndicatorHeight                    87
#define QStyle_PM_ScrollView_ScrollBarSpacing                88
#define QStyle_PM_ScrollView_ScrollBarOverlap                89
#define QStyle_PM_SubMenuOverlap                             90
#define QStyle_PM_CustomBase                                 0xf0000000


//enum #define QStyle_PrimitiveElement
//This enum describes the various primitive elements. A primitive element is a common GUI element, such as a checkbox indicator or button bevel.
#define QStyle_PE_Frame                                      0
#define QStyle_PE_FrameDefaultButton                         1
#define QStyle_PE_FrameDockWidget                            2
#define QStyle_PE_FrameFocusRect                             3
#define QStyle_PE_FrameGroupBox                              4
#define QStyle_PE_FrameLineEdit                              5
#define QStyle_PE_FrameMenu                                  6
#define QStyle_PE_FrameStatusBar                             7
#define QStyle_PE_FrameStatusBarItem                         QStyle_PE_FrameStatusBar
#define QStyle_PE_FrameTabWidget                             8
#define QStyle_PE_FrameWindow                                9
#define QStyle_PE_FrameButtonBevel                           10
#define QStyle_PE_FrameButtonTool                            11
#define QStyle_PE_FrameTabBarBase                            12
#define QStyle_PE_PanelButtonCommand                         13
#define QStyle_PE_PanelButtonBevel                           14
#define QStyle_PE_PanelButtonTool                            15
#define QStyle_PE_PanelMenuBar                               16
#define QStyle_PE_PanelToolBar                               17
#define QStyle_PE_PanelLineEdit                              18
#define QStyle_PE_IndicatorArrowDown                         19
#define QStyle_PE_IndicatorArrowLeft                         20
#define QStyle_PE_IndicatorArrowRight                        21
#define QStyle_PE_IndicatorArrowUp                           22
#define QStyle_PE_IndicatorBranch                            23
#define QStyle_PE_IndicatorButtonDropDown                    24
#define QStyle_PE_IndicatorViewItemCheck                     25
#define QStyle_PE_IndicatorItemViewItemCheck                 QStyle_PE_IndicatorViewItemCheck
#define QStyle_PE_IndicatorCheckBox                          26
#define QStyle_PE_IndicatorDockWidgetResizeHandle            27
#define QStyle_PE_IndicatorHeaderArrow                       28
#define QStyle_PE_IndicatorMenuCheckMark                     29
#define QStyle_PE_IndicatorProgressChunk                     30
#define QStyle_PE_IndicatorRadioButton                       31
#define QStyle_PE_IndicatorSpinDown                          32
#define QStyle_PE_IndicatorSpinMinus                         33
#define QStyle_PE_IndicatorSpinPlus                          34
#define QStyle_PE_IndicatorSpinUp                            35
#define QStyle_PE_IndicatorToolBarHandle                     36
#define QStyle_PE_IndicatorToolBarSeparator                  37
#define QStyle_PE_PanelTipLabel                              38
#define QStyle_PE_IndicatorTabTear                           39
#define QStyle_PE_PanelScrollAreaCorner                      40
#define QStyle_PE_Widget                                     41
#define QStyle_PE_IndicatorColumnViewArrow                   42
#define QStyle_PE_IndicatorItemViewItemDrop                  43
#define QStyle_PE_PanelItemViewItem                          44
#define QStyle_PE_PanelItemViewRow                           45
#define QStyle_PE_PanelStatusBar                             46
#define QStyle_PE_IndicatorTabClose                          47
#define QStyle_PE_PanelMenu                                  48
#define QStyle_PE_CustomBase                                 0xf000000


//enum #define QStyle_RequestSoftwareInputPanel
//This enum describes under what circumstances a software input panel will be requested by input capable widgets.
#define QStyle_RSIP_OnMouseClickAndAlreadyFocused            0       // Requests an input panel if the user clicks on the widget, but only if it is already focused.
#define QStyle_RSIP_OnMouseClick                             1       // Requests an input panel if the user clicks on the widget.


//enum #define QStyle_StandardPixmap
//This enum describes the available standard pixmaps. A standard pixmap is a pixmap that can follow some existing GUI style or guideline.
#define QStyle_SP_TitleBarMinButton                          1       // Minimize button on title bars (e.g., in QMdiSubWindow).
#define QStyle_SP_TitleBarMenuButton                         0       // Menu button on a title bar.
#define QStyle_SP_TitleBarMaxButton                          2       // Maximize button on title bars.
#define QStyle_SP_TitleBarCloseButton                        3       // Close button on title bars.
#define QStyle_SP_TitleBarNormalButton                       4       // Normal (restore) button on title bars.
#define QStyle_SP_TitleBarShadeButton                        5       // Shade button on title bars.
#define QStyle_SP_TitleBarUnshadeButton                      6       // Unshade button on title bars.
#define QStyle_SP_TitleBarContextHelpButton                  7       // The Context help button on title bars.
#define QStyle_SP_MessageBoxInformation                      9       // The "information" icon.
#define QStyle_SP_MessageBoxWarning                          10      // The "warning" icon.
#define QStyle_SP_MessageBoxCritical                         11      // The "critical" icon.
#define QStyle_SP_MessageBoxQuestion                         12      // The "question" icon.
#define QStyle_SP_DesktopIcon                                13      // The "desktop" icon.
#define QStyle_SP_TrashIcon                                  14      // The "trash" icon.
#define QStyle_SP_ComputerIcon                               15      // The "My computer" icon.
#define QStyle_SP_DriveFDIcon                                16      // The floppy icon.
#define QStyle_SP_DriveHDIcon                                17      // The harddrive icon.
#define QStyle_SP_DriveCDIcon                                18      // The CD icon.
#define QStyle_SP_DriveDVDIcon                               19      // The DVD icon.
#define QStyle_SP_DriveNetIcon                               20      // The network icon.
#define QStyle_SP_DirHomeIcon                                56      // The home directory icon.
#define QStyle_SP_DirOpenIcon                                21      // The open directory icon.
#define QStyle_SP_DirClosedIcon                              22      // The closed directory icon.
#define QStyle_SP_DirIcon                                    38      // The directory icon.
#define QStyle_SP_DirLinkIcon                                23      // The link to directory icon.
#define QStyle_SP_DirLinkOpenIcon                            24      // The link to open directory icon.
#define QStyle_SP_FileIcon                                   25      // The file icon.
#define QStyle_SP_FileLinkIcon                               26      // The link to file icon.
#define QStyle_SP_FileDialogStart                            29      // The "start" icon in a file dialog.
#define QStyle_SP_FileDialogEnd                              30      // The "end" icon in a file dialog.
#define QStyle_SP_FileDialogToParent                         31      // The "parent directory" icon in a file dialog.
#define QStyle_SP_FileDialogNewFolder                        32      // The "create new folder" icon in a file dialog.
#define QStyle_SP_FileDialogDetailedView                     33      // The detailed view icon in a file dialog.
#define QStyle_SP_FileDialogInfoView                         34      // The file info icon in a file dialog.
#define QStyle_SP_FileDialogContentsView                     35      // The contents view icon in a file dialog.
#define QStyle_SP_FileDialogListView                         36      // The list view icon in a file dialog.
#define QStyle_SP_FileDialogBack                             37      // The back arrow in a file dialog.
#define QStyle_SP_DockWidgetCloseButton                      8       // Close button on dock windows (see also QDockWidget).
#define QStyle_SP_ToolBarHorizontalExtensionButton           27      // Extension button for horizontal toolbars.
#define QStyle_SP_ToolBarVerticalExtensionButton             28      // Extension button for vertical toolbars.
#define QStyle_SP_DialogOkButton                             39      // Icon for a standard OK button in a QDialogButtonBox.
#define QStyle_SP_DialogCancelButton                         40      // Icon for a standard Cancel button in a QDialogButtonBox.
#define QStyle_SP_DialogHelpButton                           41      // Icon for a standard Help button in a QDialogButtonBox.
#define QStyle_SP_DialogOpenButton                           42      // Icon for a standard Open button in a QDialogButtonBox.
#define QStyle_SP_DialogSaveButton                           43      // Icon for a standard Save button in a QDialogButtonBox.
#define QStyle_SP_DialogCloseButton                          44      // Icon for a standard Close button in a QDialogButtonBox.
#define QStyle_SP_DialogApplyButton                          45      // Icon for a standard Apply button in a QDialogButtonBox.
#define QStyle_SP_DialogResetButton                          46      // Icon for a standard Reset button in a QDialogButtonBox.
#define QStyle_SP_DialogDiscardButton                        47      // Icon for a standard Discard button in a QDialogButtonBox.
#define QStyle_SP_DialogYesButton                            48      // Icon for a standard Yes button in a QDialogButtonBox.
#define QStyle_SP_DialogNoButton                             49      // Icon for a standard No button in a QDialogButtonBox.
#define QStyle_SP_ArrowUp                                    50      // Icon arrow pointing up.
#define QStyle_SP_ArrowDown                                  51      // Icon arrow pointing down.
#define QStyle_SP_ArrowLeft                                  52      // Icon arrow pointing left.
#define QStyle_SP_ArrowRight                                 53      // Icon arrow pointing right.
#define QStyle_SP_ArrowBack                                  54      // Equivalent to SP_ArrowLeft when the current layout direction is #define Qt_LeftToRight, otherwise SP_ArrowRight.
#define QStyle_SP_ArrowForward                               55      // Equivalent to SP_ArrowRight when the current layout direction is #define Qt_LeftToRight, otherwise SP_ArrowLeft.
#define QStyle_SP_CommandLink                                57      // Icon used to indicate a Vista style command link glyph.
#define QStyle_SP_VistaShield                                58      // Icon used to indicate UAC prompts on Windows Vista. This will return a null pixmap or icon on all other platforms.
#define QStyle_SP_BrowserReload                              59      // Icon indicating that the current page should be reloaded.
#define QStyle_SP_BrowserStop                                60      // Icon indicating that the page loading should stop.
#define QStyle_SP_MediaPlay                                  61      // Icon indicating that media should begin playback.
#define QStyle_SP_MediaStop                                  62      // Icon indicating that media should stop playback.
#define QStyle_SP_MediaPause                                 63      // Icon indicating that media should pause playback.
#define QStyle_SP_MediaSkipForward                           64      // Icon indicating that media should skip forward.
#define QStyle_SP_MediaSkipBackward                          65      // Icon indicating that media should skip backward.
#define QStyle_SP_MediaSeekForward                           66      // Icon indicating that media should seek forward.
#define QStyle_SP_MediaSeekBackward                          67      // Icon indicating that media should seek backward.
#define QStyle_SP_MediaVolume                                68      // Icon indicating a volume control.
#define QStyle_SP_MediaVolumeMuted                           69      // Icon indicating a muted volume control.
#define QStyle_SP_CustomBase                                 0xf0000000   //Base value for custom standard pixmaps; custom values must be greater than this value.


//enum #define QStyle_StateFlag
//flags #define QStyle_State
//This enum describes flags that are used when drawing primitive elements.
//Note that not all primitives use all of these flags, and that the flags may mean different things to different items.
#define QStyle_State_None                                    0x00000000   // Indicates that the widget does not have a state.
#define QStyle_State_Active                                  0x00010000   // Indicates that the widget is active.
#define QStyle_State_AutoRaise                               0x00001000   // Used to indicate if auto-raise appearance should be usd on a tool button.
#define QStyle_State_Children                                0x00080000   // Used to indicate if an item view branch has children.
#define QStyle_State_DownArrow                               0x00000040   // Used to indicate if a down arrow should be visible on the widget.
#define QStyle_State_Editing                                 0x00400000   // Used to indicate if an editor is opened on the widget.
#define QStyle_State_Enabled                                 0x00000001   // Used to indicate if the widget is enabled.
#define QStyle_State_HasEditFocus                            0x01000000   // Used to indicate if the widget currently has edit focus.
#define QStyle_State_HasFocus                                0x00000100   // Used to indicate if the widget has focus.
#define QStyle_State_Horizontal                              0x00000080   // Used to indicate if the widget is laid out horizontally, for example. a tool bar.
#define QStyle_State_KeyboardFocusChange                     0x00800000   // Used to indicate if the focus was changed with the keyboard, e.g., tab, backtab or shortcut.
#define QStyle_State_MouseOver                               0x00002000   // Used to indicate if the widget is under the mouse.
#define QStyle_State_NoChange                                0x00000010   // Used to indicate a tri-state checkbox.
#define QStyle_State_Off                                     0x00000008   // Used to indicate if the widget is not checked.
#define QStyle_State_On                                      0x00000020   // Used to indicate if the widget is checked.
#define QStyle_State_Raised                                  0x00000002   // Used to indicate if a button is raised.
#define QStyle_State_ReadOnly                                0x02000000   // Used to indicate if a widget is read-only.
#define QStyle_State_Selected                                0x00008000   // Used to indicate if a widget is selected.
#define QStyle_State_Item                                    0x00100000   // Used by item views to indicate if a horizontal branch should be drawn.
#define QStyle_State_Open                                    0x00040000   // Used by item views to indicate if the tree branch is open.
#define QStyle_State_Sibling                                 0x00200000   // Used by item views to indicate if a vertical line needs to be drawn (for siblings).
#define QStyle_State_Sunken                                  0x00000004   // Used to indicate if the widget is sunken or pressed.
#define QStyle_State_UpArrow                                 0x00004000   // Used to indicate if an up arrow should be visible on the widget.
#define QStyle_State_Mini                                    0x08000000   // Used to indicate a mini style Mac widget or button.
#define QStyle_State_Small                                   0x04000000   // Used to indicate a small style Mac widget or button.


//enum #define QStyle_StyleHint
//This enum describes the available style hints. A style hint is a general look and/or feel hint.
#define QStyle_SH_EtchDisabledText                               0
#define QStyle_SH_DitherDisabledText                             1
#define QStyle_SH_ScrollBar_MiddleClickAbsolutePosition          2
#define QStyle_SH_ScrollBar_ScrollWhenPointerLeavesControl       3
#define QStyle_SH_TabBar_SelectMouseType                         4
#define QStyle_SH_TabBar_Alignment                               5
#define QStyle_SH_Header_ArrowAlignment                          6
#define QStyle_SH_Slider_SnapToValue                             7
#define QStyle_SH_Slider_SloppyKeyEvents                         8
#define QStyle_SH_ProgressDialog_CenterCancelButton              9
#define QStyle_SH_ProgressDialog_TextLabelAlignment              10
#define QStyle_SH_PrintDialog_RightAlignButtons                  11
#define QStyle_SH_MainWindow_SpaceBelowMenuBar                   12
#define QStyle_SH_FontDialog_SelectAssociatedText                13
#define QStyle_SH_Menu_AllowActiveAndDisabled                    14
#define QStyle_SH_Menu_SpaceActivatesItem                        15
#define QStyle_SH_Menu_SubMenuPopupDelay                         16
#define QStyle_SH_ScrollView_FrameOnlyAroundContents             17
#define QStyle_SH_MenuBar_AltKeyNavigation                       18
#define QStyle_SH_ComboBox_ListMouseTracking                     19
#define QStyle_SH_Menu_MouseTracking                             20
#define QStyle_SH_MenuBar_MouseTracking                          21
#define QStyle_SH_ItemView_ChangeHighlightOnFocus                22
#define QStyle_SH_Widget_ShareActivation                         23
#define QStyle_SH_Workspace_FillSpaceOnMaximize                  24
#define QStyle_SH_ComboBox_Popup                                 25
#define QStyle_SH_TitleBar_NoBorder                              26
#define QStyle_SH_Slider_StopMouseOverSlider                     27
#define QStyle_SH_ScrollBar_StopMouseOverSlider                  QStyle_SH_Slider_StopMouseOverSlider
#define QStyle_SH_BlinkCursorWhenTextSelected                    28
#define QStyle_SH_RichText_FullWidthSelection                    29
#define QStyle_SH_Menu_Scrollable                                30
#define QStyle_SH_GroupBox_TextLabelVerticalAlignment            31
#define QStyle_SH_GroupBox_TextLabelColor                        32
#define QStyle_SH_Menu_SloppySubMenus                            33
#define QStyle_SH_Table_GridLineColor                            34
#define QStyle_SH_LineEdit_PasswordCharacter                     35
#define QStyle_SH_DialogButtons_DefaultButton                    36
#define QStyle_SH_ToolBox_SelectedPageTitleBold                  37
#define QStyle_SH_TabBar_PreferNoArrows                          38
#define QStyle_SH_ScrollBar_LeftClickAbsolutePosition            39
#define QStyle_SH_ListViewExpand_SelectMouseType                 40
#define QStyle_SH_UnderlineShortcut                              41
#define QStyle_SH_SpinBox_AnimateButton                          42
#define QStyle_SH_SpinBox_KeyPressAutoRepeatRate                 43
#define QStyle_SH_SpinBox_ClickAutoRepeatRate                    44
#define QStyle_SH_Menu_FillScreenWithScroll                      45
#define QStyle_SH_ToolTipLabel_Opacity                           46
#define QStyle_SH_DrawMenuBarSeparator                           47
#define QStyle_SH_TitleBar_ModifyNotification                    48
#define QStyle_SH_Button_FocusPolicy                             49
#define QStyle_SH_MessageBox_UseBorderForButtonSpacing           50
#define QStyle_SH_TitleBar_AutoRaise                             51
#define QStyle_SH_ToolButton_PopupDelay                          52
#define QStyle_SH_FocusFrame_Mask                                53
#define QStyle_SH_RubberBand_Mask                                54
#define QStyle_SH_WindowFrame_Mask                               55
#define QStyle_SH_SpinControls_DisableOnBounds                   56
#define QStyle_SH_Dial_BackgroundRole                            57
#define QStyle_SH_ComboBox_LayoutDirection                       58
#define QStyle_SH_ItemView_EllipsisLocation                      59
#define QStyle_SH_ItemView_ShowDecorationSelected                60
#define QStyle_SH_ItemView_ActivateItemOnSingleClick             61
#define QStyle_SH_ScrollBar_ContextMenu                          62
#define QStyle_SH_ScrollBar_RollBetweenButtons                   63
#define QStyle_SH_Slider_AbsoluteSetButtons                      64
#define QStyle_SH_Slider_PageSetButtons                          65
#define QStyle_SH_Menu_KeyboardSearch                            66
#define QStyle_SH_TabBar_ElideMode                               67
#define QStyle_SH_DialogButtonLayout                             68
#define QStyle_SH_ComboBox_PopupFrameStyle                       69
#define QStyle_SH_MessageBox_TextInteractionFlags                70
#define QStyle_SH_DialogButtonBox_ButtonsHaveIcons               71
#define QStyle_SH_SpellCheckUnderlineStyle                       72
#define QStyle_SH_MessageBox_CenterButtons                       73
#define QStyle_SH_Menu_SelectionWrap                             74
#define QStyle_SH_ItemView_MovementWithoutUpdatingSelection      75
#define QStyle_SH_ToolTip_Mask                                   76
#define QStyle_SH_FocusFrame_AboveWidget                         77
#define QStyle_SH_TextControl_FocusIndicatorTextCharFormat       78
#define QStyle_SH_WizardStyle                                    79
#define QStyle_SH_ItemView_ArrowKeysNavigateIntoChildren         80
#define QStyle_SH_Menu_Mask                                      81
#define QStyle_SH_Menu_FlashTriggeredItem                        82
#define QStyle_SH_Menu_FadeOutOnHide                             83
#define QStyle_SH_SpinBox_ClickAutoRepeatThreshold               84
#define QStyle_SH_ItemView_PaintAlternatingRowColorsForEmptyArea 85
#define QStyle_SH_FormLayoutWrapPolicy                           86
#define QStyle_SH_TabWidget_DefaultTabPosition                   87
#define QStyle_SH_ToolBar_Movable                                88
#define QStyle_SH_FormLayoutFieldGrowthPolicy                    89
#define QStyle_SH_FormLayoutFormAlignment                        90
#define QStyle_SH_FormLayoutLabelAlignment                       91
#define QStyle_SH_ItemView_DrawDelegateFrame                     92
#define QStyle_SH_TabBar_CloseButtonPosition                     93
#define QStyle_SH_DockWidget_ButtonsHaveFrame                    94
#define QStyle_SH_ToolButtonStyle                                95
#define QStyle_SH_RequestSoftwareInputPanel                      96
#define QStyle_SH_ScrollBar_Transient                            97
#define QStyle_SH_Menu_SupportsSections                          98
#define QStyle_SH_CustomBase                                     0xf0000000


//enum #define QStyle_SubControl
//flags #define QStyle_SubControls
//This enum describes the available sub controls. A subcontrol is a control element within a complex control (ComplexControl).
#define QStyle_SC_None                                       0x00000000   // Special value that matches no other sub control.
#define QStyle_SC_ScrollBarAddLine                           0x00000001   // Scroll bar add line (i.e., down/right arrow); see also QScrollBar.
#define QStyle_SC_ScrollBarSubLine                           0x00000002   // Scroll bar sub line (i.e., up/left arrow).
#define QStyle_SC_ScrollBarAddPage                           0x00000004   // Scroll bar add page (i.e., page down).
#define QStyle_SC_ScrollBarSubPage                           0x00000008   // Scroll bar sub page (i.e., page up).
#define QStyle_SC_ScrollBarFirst                             0x00000010   // Scroll bar first line (i.e., home).
#define QStyle_SC_ScrollBarLast                              0x00000020   // Scroll bar last line (i.e., end).
#define QStyle_SC_ScrollBarSlider                            0x00000040   // Scroll bar slider handle.
#define QStyle_SC_ScrollBarGroove                            0x00000080   // Special sub-control which contains the area in which the slider handle may move.
#define QStyle_SC_SpinBoxUp                                  0x00000001   // Spin widget up/increase; see also QSpinBox.
#define QStyle_SC_SpinBoxDown                                0x00000002   // Spin widget down/decrease.
#define QStyle_SC_SpinBoxFrame                               0x00000004   // Spin widget frame.
#define QStyle_SC_SpinBoxEditField                           0x00000008   // Spin widget edit field.
#define QStyle_SC_ComboBoxEditField                          0x00000002   // Combobox edit field; see also QComboBox.
#define QStyle_SC_ComboBoxArrow                              0x00000004   // Combobox arrow button.
#define QStyle_SC_ComboBoxFrame                              0x00000001   // Combobox frame.
#define QStyle_SC_ComboBoxListBoxPopup                       0x00000008   // The reference rectangle for the combobox popup. Used to calculate the position of the popup.
#define QStyle_SC_SliderGroove                               0x00000001   // Special sub-control which contains the area in which the slider handle may move.
#define QStyle_SC_SliderHandle                               0x00000002   // Slider handle.
#define QStyle_SC_SliderTickmarks                            0x00000004   // Slider tickmarks.
#define QStyle_SC_ToolButton                                 0x00000001   // Tool button (see also QToolButton).
#define QStyle_SC_ToolButtonMenu                             0x00000002   // Sub-control for opening a popup menu in a tool button.
#define QStyle_SC_TitleBarSysMenu                            0x00000001   // System menu button (i.e., restore, close, etc.).
#define QStyle_SC_TitleBarMinButton                          0x00000002   // Minimize button.
#define QStyle_SC_TitleBarMaxButton                          0x00000004   // Maximize button.
#define QStyle_SC_TitleBarCloseButton                        0x00000008   // Close button.
#define QStyle_SC_TitleBarLabel                              0x00000100   // Window title label.
#define QStyle_SC_TitleBarNormalButton                       0x00000010   // Normal (restore) button.
#define QStyle_SC_TitleBarShadeButton                        0x00000020   // Shade button.
#define QStyle_SC_TitleBarUnshadeButton                      0x00000040   // Unshade button.
#define QStyle_SC_TitleBarContextHelpButton                  0x00000080   // Context Help button.
#define QStyle_SC_DialHandle                                 0x00000002   // The handle of the dial (i.e. what you use to control the dial).
#define QStyle_SC_DialGroove                                 0x00000001   // The groove for the dial.
#define QStyle_SC_DialTickmarks                              0x00000004   // The tickmarks for the dial.
#define QStyle_SC_GroupBoxFrame                              0x00000008   // The frame of a group box.
#define QStyle_SC_GroupBoxLabel                              0x00000002   // The title of a group box.
#define QStyle_SC_GroupBoxCheckBox                           0x00000001   // The optional check box of a group box.
#define QStyle_SC_GroupBoxContents                           0x00000004   // The group box contents.
#define QStyle_SC_MdiNormalButton                            0x00000002   // The normal button for a MDI subwindow in the menu bar.
#define QStyle_SC_MdiMinButton                               0x00000001   // The minimize button for a MDI subwindow in the menu bar.
#define QStyle_SC_MdiCloseButton                             0x00000004   // The close button for a MDI subwindow in the menu bar.
#define QStyle_SC_All                                        0xffffffff   // Special value that matches all sub-controls.


//enum #define QStyle_SubElement
//This enum represents a sub-area of a widget. Style implementations use these areas to draw the different parts of a widget.
#define QStyle_SE_PushButtonContents                         0
#define QStyle_SE_PushButtonFocusRect                        1
#define QStyle_SE_CheckBoxIndicator                          2
#define QStyle_SE_CheckBoxContents                           3
#define QStyle_SE_CheckBoxFocusRect                          4
#define QStyle_SE_CheckBoxClickRect                          5
#define QStyle_SE_RadioButtonIndicator                       6
#define QStyle_SE_RadioButtonContents                        7
#define QStyle_SE_RadioButtonFocusRect                       8
#define QStyle_SE_RadioButtonClickRect                       9
#define QStyle_SE_ComboBoxFocusRect                          10
#define QStyle_SE_SliderFocusRect                            11
#define QStyle_SE_ProgressBarGroove                          12
#define QStyle_SE_ProgressBarContents                        13
#define QStyle_SE_ProgressBarLabel                           14
#define QStyle_SE_ToolBoxTabContents                         15
#define QStyle_SE_HeaderLabel                                16
#define QStyle_SE_HeaderArrow                                17
#define QStyle_SE_TabWidgetTabBar                            18
#define QStyle_SE_TabWidgetTabPane                           19
#define QStyle_SE_TabWidgetTabContents                       20
#define QStyle_SE_TabWidgetLeftCorner                        21
#define QStyle_SE_TabWidgetRightCorner                       22
#define QStyle_SE_ViewItemCheckIndicator                     23
#define QStyle_SE_ItemViewItemCheckIndicator                 QStyle_SE_ViewItemCheckIndicator
#define QStyle_SE_TabBarTearIndicator                        24
#define QStyle_SE_TreeViewDisclosureItem                     25
#define QStyle_SE_LineEditContents                           26
#define QStyle_SE_FrameContents                              27
#define QStyle_SE_DockWidgetCloseButton                      28
#define QStyle_SE_DockWidgetFloatButton                      29
#define QStyle_SE_DockWidgetTitleBarText                     30
#define QStyle_SE_DockWidgetIcon                             31
#define QStyle_SE_CheckBoxLayoutItem                         32
#define QStyle_SE_ComboBoxLayoutItem                         33
#define QStyle_SE_DateTimeEditLayoutItem                     34
#define QStyle_SE_DialogButtonBoxLayoutItem                  35     // ### Qt 6: remove   ????
#define QStyle_SE_LabelLayoutItem                            36
#define QStyle_SE_ProgressBarLayoutItem                      37
#define QStyle_SE_PushButtonLayoutItem                       38
#define QStyle_SE_RadioButtonLayoutItem                      39
#define QStyle_SE_SliderLayoutItem                           40
#define QStyle_SE_SpinBoxLayoutItem                          41
#define QStyle_SE_ToolButtonLayoutItem                       42
#define QStyle_SE_FrameLayoutItem                            43
#define QStyle_SE_GroupBoxLayoutItem                         44
#define QStyle_SE_TabWidgetLayoutItem                        45
#define QStyle_SE_ItemViewItemDecoration                     46
#define QStyle_SE_ItemViewItemText                           47
#define QStyle_SE_ItemViewItemFocusRect                      48
#define QStyle_SE_TabBarTabLeftButton                        49
#define QStyle_SE_TabBarTabRightButton                       50
#define QStyle_SE_TabBarTabText                              51
#define QStyle_SE_ShapedFrameContents                        52
#define QStyle_SE_ToolBarHandle                              53
#define QStyle_SE_CustomBase                                 0xf0000000

#define QDirIterator_NoIteratorFlags                         0x0     // The default value, representing no flags. The iterator will return entries for the assigned path.
#define QDirIterator_Subdirectories                          0x2     // List entries inside all subdirectories as well.
#define QDirIterator_FollowSymlinks                          0x1     // When combined with Subdirectories, this flag enables iterating through all subdirectories of the assigned path, following all symbolic links. Symbolic link loops (e.g., "link" => "." or "link" => "..") are automatically detected and ignored.

#define QHostAddress_Null                                    0       // The null address object. Equivalent to QHostAddress().
#define QHostAddress_LocalHost                               2       // The IPv4 localhost address. Equivalent to QHostAddress("127.0.0.1").
#define QHostAddress_LocalHostIPv6                           3       // The IPv6 localhost address. Equivalent to QHostAddress("_1").
#define QHostAddress_Broadcast                               1       // The IPv4 broadcast address. Equivalent to QHostAddress("255.255.255.255").
#define QHostAddress_AnyIPv4                                 6       // The IPv4 any-address. Equivalent to QHostAddress("0.0.0.0"). A socket bound with this address will listen only on IPv4 interaces.
#define QHostAddress_AnyIPv6                                 5       // The IPv6 any-address. Equivalent to QHostAddress("_"). A socket bound with this address will listen only on IPv6 interaces.
#define QHostAddress_Any                                     4       // The dual stack any-address. A socket bound with this address will listen on both IPv4 and IPv6 interfaces.

#define QNetworkAccessManager_UnknownAccessibility           -1      // The network accessibility cannot be determined.
#define QNetworkAccessManager_NotAccessible                  0       // The network is not currently accessible, either because there is currently no network coverage or network access has been explicitly disabled by a call to setNetworkAccessible().
#define QNetworkAccessManager_Accessible                     1       // The network is accessible.

#define QNetworkAccessManager_HeadOperation                  1       // retrieve headers operation (created with head())
#define QNetworkAccessManager_GetOperation                   2       // retrieve headers and download contents (created with get())
#define QNetworkAccessManager_PutOperation                   3       // upload contents operation (created with put())
#define QNetworkAccessManager_PostOperation                  4       // send the contents of an HTML form for processing via HTTP POST (created with post())
#define QNetworkAccessManager_DeleteOperation                5       // delete contents operation (created with deleteResource())
#define QNetworkAccessManager_CustomOperation                6       // custom operation (created with sendCustomRequest())

#define QNetworkConfiguration_BearerUnknown                  0       // The type of bearer is unknown or unspecified. The bearerTypeName() function may return additional information.
#define QNetworkConfiguration_BearerEthernet                 1       // The configuration is for an Ethernet interfaces.
#define QNetworkConfiguration_BearerWLAN                     2       // The configuration is for a Wireless LAN interface.
#define QNetworkConfiguration_Bearer2G                       3       // The configuration is for a CSD, GPRS, HSCSD, EDGE or cdmaOne interface.
#define QNetworkConfiguration_Bearer3G                       11      // The configuration is for a 3G interface.
#define QNetworkConfiguration_Bearer4G                       12      // The configuration is for a 4G interface.
#define QNetworkConfiguration_BearerCDMA2000                 4       // The configuration is for CDMA interface.
#define QNetworkConfiguration_BearerWCDMA                    5       // The configuration is for W-CDMA/UMTS interface.
#define QNetworkConfiguration_BearerHSPA                     6       // The configuration is for High Speed Packet Access (HSPA) interface.
#define QNetworkConfiguration_BearerBluetooth                7       // The configuration is for a Bluetooth interface.
#define QNetworkConfiguration_BearerWiMAX                    8       // The configuration is for a WiMAX interface.
#define QNetworkConfiguration_BearerEVDO                     9       // The configuration is for an EVDO (3G) interface.
#define QNetworkConfiguration_BearerLTE                      10      // The configuration is for a LTE (4G) interface.

#define QNetworkConfiguration_UnknownPurpose                 0       // The configuration doesn't specify any purpose. This is the default value.
#define QNetworkConfiguration_PublicPurpose                  1       // The configuration can be used for general purpose internet access.
#define QNetworkConfiguration_PrivatePurpose                 2       // The configuration is suitable to access a private network such as an office Intranet.
#define QNetworkConfiguration_ServiceSpecificPurpose         3       // The configuration can be used for operator specific services (e.g. receiving MMS messages or content streaming).

#define QNetworkConfiguration_Undefined                      0x0000001   // This state is used for transient configurations such as newly discovered WLANs for which the user has not actually created a configuration yet.
#define QNetworkConfiguration_Defined                        0x0000002   // Defined configurations are known to the system but are not immediately usable (e.g. a configured WLAN is not within range or the Ethernet cable is currently not plugged into the machine).
#define QNetworkConfiguration_Discovered                     0x0000006   // A discovered configuration can be immediately used to create a new QNetworkSession. An example of a discovered configuration could be a WLAN which is within in range. If the device moves out of range the discovered flag is dropped. A second example is a GPRS configuration which generally remains discovered for as long as the device has network coverage. A configuration that has this state is also in state #define QNetworkConfiguration_Defined. If the configuration is a service network this flag is set if at least one of the underlying access points configurations has the Discovered state.
#define QNetworkConfiguration_Active                         0x000000e   // The configuration is currently used by an open network session (see QNetworkSession::isOpen()). However this does not mean that the current process is the entity that created the open session. It merely indicates that if a new QNetworkSession were to be constructed based on this configuration QNetworkSession::state() would return QNetworkSession::Connected. This state implies the #define QNetworkConfiguration_Discovered state.

#define QNetworkConfiguration_InternetAccessPoint            0       // The configuration specifies the details for a single access point. Note that configurations of type InternetAccessPoint may be part of other QNetworkConfigurations of type ServiceNetwork.
#define QNetworkConfiguration_ServiceNetwork                 1       // The configuration is based on a group of QNetworkConfigurations of type InternetAccessPoint. All group members can reach the same target network. This type of configuration is a mandatory requirement for roaming enabled network sessions. On some platforms this form of configuration may also be called Service Network Access Point (SNAP).
#define QNetworkConfiguration_UserChoice                     2       // The configuration is a placeholder which will be resolved to an actual configuration by the platform when a session is opened. Depending on the platform the selection may generate a popup dialog asking the user for his preferred choice.
#define QNetworkConfiguration_Invalid                        3       // The configuration is invalid.

#define QNetworkCookie_NameAndValueOnly                      0       // makes toRawForm() return only the "NAME=VALUE" part of the cookie, as suitable for sending back to a server in a client request's "Cookie:" header. Multiple cookies are separated by a semi-colon in the "Cookie:" header field.
#define QNetworkCookie_Full                                  1       // makes toRawForm() return the full cookie contents, as suitable for sending to a client in a server's "Set-Cookie:" header.#define QNetworkInterface_IsUp                               0x1     // the network interface is active

#define QNetworkInterface_IsUp                               0x1     // the network interface is active
#define QNetworkInterface_IsRunning                          0x2     // the network interface has resources allocated
#define QNetworkInterface_CanBroadcast                       0x4     // the network interface works in broadcast mode
#define QNetworkInterface_IsLoopBack                         0x8     // the network interface is a loopback interface
#define QNetworkInterface_IsPointToPoint                     0x10    // the network interface is a point-to-point interface: that is, there is one, single other address that can be directly reached by it.
#define QNetworkInterface_CanMulticast                       0x20    // the network interface supports multicasting

#define QNetworkProxy_TunnelingCapability                    0x0001  // Ability to open transparent, tunneled TCP connections to a remote host. The proxy server relays the transmission verbatim from one side to the other and does no caching.
#define QNetworkProxy_ListeningCapability                    0x0002  // Ability to create a listening socket and wait for an incoming TCP connection from a remote host.
#define QNetworkProxy_UdpTunnelingCapability                 0x0004  // Ability to relay UDP datagrams via the proxy server to and from a remote host.
#define QNetworkProxy_CachingCapability                      0x0008  // Ability to cache the contents of the transfer. This capability is specific to each protocol and proxy type. For example, HTTP proxies can cache the contents of web data transferred with "GET" commands.
#define QNetworkProxy_HostNameLookupCapability               0x0010  // Ability to connect to perform the lookup on a remote host name and connect to it, as opposed to requiring the application to perform the name lookup and request connection to IP addresses only.

#define QNetworkProxy_NoProxy                                2       // No proxying is used
#define QNetworkProxy_DefaultProxy                           0       // Proxy is determined based on the application proxy set using setApplicationProxy()
#define QNetworkProxy_Socks5Proxy                            1       // Socks5 proxying is used
#define QNetworkProxy_HttpProxy                              3       // HTTP transparent proxying is used
#define QNetworkProxy_HttpCachingProxy                       4       // Proxying for HTTP requests only
#define QNetworkProxy_FtpCachingProxy                        5       // Proxying for FTP requests only

#define QNetworkProxyQuery_TcpSocket                         0       // a normal, outgoing TCP socket
#define QNetworkProxyQuery_UdpSocket                         1       // a datagram-based UDP socket, which could send to multiple destinations
#define QNetworkProxyQuery_TcpServer                         100     // a TCP server that listens for incoming connections from the network
#define QNetworkProxyQuery_UrlRequest                        101     // a more complex request which involves loading of a URL

#define QNetworkReply_NoError                                0       // no error condition.
#define QNetworkReply_ConnectionRefusedError                 1       // the remote server refused the connection (the server is not accepting requests)
#define QNetworkReply_RemoteHostClosedError                  2       // the remote server closed the connection prematurely, before the entire reply was received and processed
#define QNetworkReply_HostNotFoundError                      3       // the remote host name was not found (invalid hostname)
#define QNetworkReply_TimeoutError                           4       // the connection to the remote server timed out
#define QNetworkReply_OperationCanceledError                 5       // the operation was canceled via calls to abort() or close() before it was finished.
#define QNetworkReply_SslHandshakeFailedError                6       // the SSL/TLS handshake failed and the encrypted channel could not be established. The sslErrors() signal should have been emitted.
#define QNetworkReply_TemporaryNetworkFailureError           7       // the connection was broken due to disconnection from the network, however the system has initiated roaming to another access point. The request should be resubmitted and will be processed as soon as the connection is re-established.
#define QNetworkReply_NetworkSessionFailedError              8       // the connection was broken due to disconnection from the network or failure to start the network.
#define QNetworkReply_BackgroundRequestNotAllowedError       9       // the background request is not currently allowed due to platform policy.
#define QNetworkReply_ProxyConnectionRefusedError            101     // the connection to the proxy server was refused (the proxy server is not accepting requests)
#define QNetworkReply_ProxyConnectionClosedError             102     // the proxy server closed the connection prematurely, before the entire reply was received and processed
#define QNetworkReply_ProxyNotFoundError                     103     // the proxy host name was not found (invalid proxy hostname)
#define QNetworkReply_ProxyTimeoutError                      104     // the connection to the proxy timed out or the proxy did not reply in time to the request sent
#define QNetworkReply_ProxyAuthenticationRequiredError       105     // the proxy requires authentication in order to honour the request but did not accept any credentials offered (if any)
#define QNetworkReply_ContentAccessDenied                    201     // the access to the remote content was denied (similar to HTTP error 401)
#define QNetworkReply_ContentOperationNotPermittedError      202     // the operation requested on the remote content is not permitted
#define QNetworkReply_ContentNotFoundError                   203     // the remote content was not found at the server (similar to HTTP error 404)
#define QNetworkReply_AuthenticationRequiredError            204     // the remote server requires authentication to serve the content but the credentials provided were not accepted (if any)
#define QNetworkReply_ContentReSendError                     205     // the request needed to be sent again, but this failed for example because the upload data could not be read a second time.
#define QNetworkReply_ProtocolUnknownError                   301     // the Network Access API cannot honor the request because the protocol is not known
#define QNetworkReply_ProtocolInvalidOperationError          302     // the requested operation is invalid for this protocol
#define QNetworkReply_UnknownNetworkError                    99      // an unknown network-related error was detected
#define QNetworkReply_UnknownProxyError                      199     // an unknown proxy-related error was detected
#define QNetworkReply_UnknownContentError                    299     // an unknown error related to the remote content was detected

#define QNetworkRequest_HttpStatusCodeAttribute              0       // Replies only, type: QMetaType::Int (no default) Indicates the HTTP status code received from the HTTP server (like 200, 304, 404, 401, etc.). If the connection was not HTTP-based, this attribute will not be present.
#define QNetworkRequest_HttpReasonPhraseAttribute            1       // Replies only, type: QMetaType::QByteArray (no default) Indicates the HTTP reason phrase as received from the HTTP server (like "Ok", "Found", "Not Found", "Access Denied", etc.) This is the human-readable representation of the status code (see above). If the connection was not HTTP-based, this attribute will not be present.
#define QNetworkRequest_RedirectionTargetAttribute           2       // Replies only, type: QMetaType::QUrl (no default) If present, it indicates that the server is redirecting the request to a different URL. The Network Access API does not by default follow redirections: it's up to the application to determine if the requested redirection should be allowed, according to its security policies. The returned URL might be relative. Use QUrl::resolved() to create an absolute URL out of it.
#define QNetworkRequest_ConnectionEncryptedAttribute         3       // Replies only, type: QMetaType::Bool (default: false) Indicates whether the data was obtained through an encrypted (secure) connection.
#define QNetworkRequest_CacheLoadControlAttribute            4       // Requests only, type: QMetaType::Int (default: #define QNetworkRequest_PreferNetwork) Controls how the cache should be accessed. The possible values are those of #define QNetworkRequest_CacheLoadControl. Note that the default QNetworkAccessManager implementation does not support caching. However, this attribute may be used by certain backends to modify their requests (for example, for caching proxies).
#define QNetworkRequest_CacheSaveControlAttribute            5       // Requests only, type: QMetaType::Bool (default: true) Controls if the data obtained should be saved to cache for future uses. If the value is false, the data obtained will not be automatically cached. If true, data may be cached, provided it is cacheable (what is cacheable depends on the protocol being used).
#define QNetworkRequest_SourceIsFromCacheAttribute           6       // Replies only, type: QMetaType::Bool (default: false) Indicates whether the data was obtained from cache or not.
#define QNetworkRequest_DoNotBufferUploadDataAttribute       7       // Requests only, type: QMetaType::Bool (default: false) Indicates whether the QNetworkAccessManager code is allowed to buffer the upload data, e.g. when doing a HTTP POST. When using this flag with sequential upload data, the ContentLengthHeader header must be set.
#define QNetworkRequest_HttpPipeliningAllowedAttribute       8       // Requests only, type: QMetaType::Bool (default: false) Indicates whether the QNetworkAccessManager code is allowed to use HTTP pipelining with this request.
#define QNetworkRequest_HttpPipeliningWasUsedAttribute       9       // Replies only, type: QMetaType::Bool Indicates whether the HTTP pipelining was used for receiving this reply.
#define QNetworkRequest_CustomVerbAttribute                  10      // Requests only, type: QMetaType::QByteArray Holds the value for the custom HTTP verb to send (destined for usage of other verbs than GET, POST, PUT and DELETE). This verb is set when calling QNetworkAccessManager::sendCustomRequest().
#define QNetworkRequest_CookieLoadControlAttribute           11      // Requests only, type: QMetaType::Int (default: #define QNetworkRequest_Automatic) Indicates whether to send 'Cookie' headers in the request. This attribute is set to false by Qt WebKit when creating a cross-origin XMLHttpRequest where withCredentials has not been set explicitly to true by the Javascript that created the request. See here for more information. (This value was introduced in 4.7.)
#define QNetworkRequest_CookieSaveControlAttribute           13      // Requests only, type: QMetaType::Int (default: #define QNetworkRequest_Automatic) Indicates whether to save 'Cookie' headers received from the server in reply to the request. This attribute is set to false by Qt WebKit when creating a cross-origin XMLHttpRequest where withCredentials has not been set explicitly to true by the Javascript that created the request. See here for more information. (This value was introduced in 4.7.)
#define QNetworkRequest_AuthenticationReuseAttribute         12      // Requests only, type: QMetaType::Int (default: #define QNetworkRequest_Automatic) Indicates whether to use cached authorization credentials in the request, if available. If this is set to #define QNetworkRequest_Manual and the authentication mechanism is 'Basic' or 'Digest', Qt will not send an an 'Authorization' HTTP header with any cached credentials it may have for the request's URL. This attribute is set to #define QNetworkRequest_Manual by Qt WebKit when creating a cross-origin XMLHttpRequest where withCredentials has not been set explicitly to true by the Javascript that created the request. See here for more information. (This value was introduced in 4.7.)
#define QNetworkRequest_BackgroundRequestAttribute           17      // Type: QMetaType::Bool (default: false) Indicates that this is a background transfer, rather than a user initiated transfer. Depending on the platform, background transfers may be subject to different policies. The QNetworkSession ConnectInBackground property will be set according to this attribute.
#define QNetworkRequest_User                                 1000    // Special type. Additional information can be passed in QVariants with types ranging from User to UserMax. The default implementation of Network Access will ignore any request attributes in this range and it will not produce any attributes in this range in replies. The range is reserved for extensions of QNetworkAccessManager.
#define QNetworkRequest_UserMax                              32767   // Special type. See User.

#define QNetworkRequest_AlwaysNetwork                        0       // always load from network and do not check if the cache has a valid entry (similar to the "Reload" feature in browsers); in addition, force intermediate caches to re-validate.
#define QNetworkRequest_PreferNetwork                        1       // default value; load from the network if the cached entry is older than the network entry. This will never return stale data from the cache, but revalidate resources that have become stale.
#define QNetworkRequest_PreferCache                          2       // load from cache if available, otherwise load from network. Note that this can return possibly stale (but not expired) items from cache.
#define QNetworkRequest_AlwaysCache                          3       // only load from cache, indicating error if the item was not cached (i.e., off-line mode)
                                                                     //
#define QNetworkRequest_ContentDispositionHeader             6       // Corresponds to the HTTP Content-Disposition header and contains a string containing the disposition type (for instance, attachment) and a parameter (for instance, filename).
#define QNetworkRequest_ContentTypeHeader                    0       // Corresponds to the HTTP Content-Type header and contains a string containing the media (MIME) type and any auxiliary data (for instance, charset).
#define QNetworkRequest_ContentLengthHeader                  1       // Corresponds to the HTTP Content-Length header and contains the length in bytes of the data transmitted.
#define QNetworkRequest_LocationHeader                       2       // Corresponds to the HTTP Location header and contains a URL representing the actual location of the data, including the destination URL in case of redirections.
#define QNetworkRequest_LastModifiedHeader                   3       // Corresponds to the HTTP Last-Modified header and contains a QDateTime representing the last modification date of the contents.
#define QNetworkRequest_CookieHeader                         4       // Corresponds to the HTTP Cookie header and contains a QList<QNetworkCookie> representing the cookies to be sent back to the server.
#define QNetworkRequest_SetCookieHeader                      5       // Corresponds to the HTTP Set-Cookie header and contains a QList<QNetworkCookie> representing the cookies sent by the server to be stored locally.
#define QNetworkRequest_UserAgentHeader                      7       // The User-Agent header sent by HTTP clients.
#define QNetworkRequest_ServerHeader                         8       // The Server header received by HTTP clients.

#define QNetworkRequest_Automatic                            0       // default value: indicates default behaviour.
#define QNetworkRequest_Manual                               1       // indicates behaviour has been manually overridden.

#define QNetworkRequest_HighPriority                         1       // High priority
#define QNetworkRequest_NormalPriority                       3       // Normal priority
#define QNetworkRequest_LowPriority                          5       // Low priority

#define QNetworkSession_UnknownSessionError                  0       // An unidentified error occurred.
#define QNetworkSession_SessionAbortedError                  1       // The session was aborted by the user or system.
#define QNetworkSession_RoamingError                         2       // The session cannot roam to a new configuration.
#define QNetworkSession_OperationNotSupportedError           3       // The operation is not supported for current configuration.
#define QNetworkSession_InvalidConfigurationError            4       // The operation cannot currently be performed for the current configuration.

#define QNetworkSession_Invalid                              0       // The session is invalid due to an invalid configuration. This may happen due to a removed access point or a configuration that was invalid to begin with.
#define QNetworkSession_NotAvailable                         1       // The session is based on a defined but not yet discovered QNetworkConfiguration (see QNetworkConfiguration_StateFlag).
#define QNetworkSession_Connecting                           2       // The network session is being established.
#define QNetworkSession_Connected                            3       // The network session is connected. If the current process wishes to use this session it has to register its interest by calling open(). A network session is considered to be ready for socket operations if it isOpen() and connected.
#define QNetworkSession_Closing                              4       // The network session is in the process of being shut down.
#define QNetworkSession_Disconnected                         5       // The network session is not connected. The associated QNetworkConfiguration has the state QNetworkConfiguration_Discovered.
#define QNetworkSession_Roaming                              6       // The network session is roaming from one access point to another access point.

#define QNetworkSession_NoPolicy                             0       // No policy in force, usage is unrestricted.
#define QNetworkSession_NoBackgroundTrafficPolicy            1       // Background network traffic (not user initiated) should be avoided for example to save battery or data charges

#define QSslCertificate_Organization                         0       // "O" The name of the organization.
#define QSslCertificate_CommonName                           1       // "CN" The common name; most often this is used to store the host name.
#define QSslCertificate_LocalityName                         2       // "L" The locality.
#define QSslCertificate_OrganizationalUnitName               3       // "OU" The organizational unit name.
#define QSslCertificate_CountryName                          4       // "C" The country.
#define QSslCertificate_StateOrProvinceName                  5       // "ST" The state or province.
#define QSslCertificate_DistinguishedNameQualifier           6       // The distinguished name qualifier
#define QSslCertificate_SerialNumber                         7       // The certificate's serial number
#define QSslCertificate_EmailAddress                         8       // The email address associated with the certificate

#define QSslSocket_VerifyNone                                0       // QSslSocket will not request a certificate from the peer. You can set this mode if you are not interested in the identity of the other side of the connection. The connection will still be encrypted, and your socket will still send its local certificate to the peer if it's requested.
#define QSslSocket_QueryPeer                                 1       // QSslSocket will request a certificate from the peer, but does not require this certificate to be valid. This is useful when you want to display peer certificate details to the user without affecting the actual SSL handshake. This mode is the default for servers.
#define QSslSocket_VerifyPeer                                2       // QSslSocket will request a certificate from the peer during the SSL handshake phase
#define QSslSocket_AutoVerifyPeer                            3       // QSslSocket will automatically use QueryPeer for server sockets and VerifyPeer for client sockets.

#define QSslSocket_UnencryptedMode                           0       // The socket is unencrypted. Its behavior is identical to QTcpSocket.
#define QSslSocket_SslClientMode                             1       // The socket is a client-side SSL socket. It is either alreayd encrypted, or it is in the SSL handshake phase (see QSslSocket_isEncrypted()).
#define QSslSocket_SslServerMode                             2       // The socket is a server-side SSL socket. It is either already encrypted, or it is in the SSL handshake phase (see QSslSocket::isEncrypted()).

// This enum describes the different flags that can be used for controlling the behavior of QStandardPaths::locate and QStandardPaths::locateAll.
#define QStandardPaths_LocateFile                            0x0     // return only files
#define QStandardPaths_LocateDirectory                       0x1     // return only directories

// This enum describes the different locations that can be queried using methods such as QStandardPaths::writableLocation, QStandardPaths::standardLocations, and QStandardPaths::displayName.
#define QStandardPaths_DesktopLocation                       0       // Returns the user's desktop directory.
#define QStandardPaths_DocumentsLocation                     1       // Returns the user's document.
#define QStandardPaths_FontsLocation                         2       // Returns the user's fonts.
#define QStandardPaths_ApplicationsLocation                  3       // Returns the user's applications.
#define QStandardPaths_MusicLocation                         4       // Returns the user's music.
#define QStandardPaths_MoviesLocation                        5       // Returns the user's movies.
#define QStandardPaths_PicturesLocation                      6       // Returns the user's pictures.
#define QStandardPaths_TempLocation                          7       // Returns the system's temporary directory.
#define QStandardPaths_HomeLocation                          8       // Returns the user's home directory.
#define QStandardPaths_DataLocation                          9       // Returns a directory location where persistent application data can be stored. QCoreApplication::organizationName and QCoreApplication::applicationName are appended to the directory location returned for GenericDataLocation.
#define QStandardPaths_CacheLocation                         10      // Returns a directory location where user-specific non-essential (cached) data should be written.
#define QStandardPaths_GenericDataLocation                   11      // Returns a directory location where persistent data shared across applications can be stored.
#define QStandardPaths_RuntimeLocation                       12      // Returns a directory location where runtime communication files should be written. For instance unix local sockets.
#define QStandardPaths_ConfigLocation                        13      // Returns a directory location where user-specific configuration files should be written.
#define QStandardPaths_DownloadLocation                      14      // Returns a directory for user's downloaded files.
#define QStandardPaths_GenericCacheLocation                  15      // Returns a directory location where user-specific non-essential (cached) data, shared across applications, should be written.
#define QStandardPaths_GenericConfigLocation                 16      // Returns a directory location where user-specific configuration files shared between multiple applications should be written. This is a generic value and the returned path is never empty.
#define QStandardPaths_AppDataLocation                       17      // Returns a directory location where persistent application data can be stored. This is an application-specific directory. To obtain a path to store data to be shared with other applications, use QStandardPaths::GenericDataLocation. The returned path is never empty. On the Windows operating system, this returns the roaming path. This enum value was added in Qt 5.4.
#define QStandardPaths_AppLocalDataLocation                  QStandardPaths_DataLocation      // Returns the local settings path on the Windows operating system. On all other platforms, it returns the same value as AppDataLocation. This enum value was added in Qt 5.4.
#define QStandardPaths_AppConfigLocation                     18      // Returns a directory location where user-specific configuration files should be written. This is an application-specific directory, and the returned path is never empty. This enum value was added in Qt 5.5.

#define Qt_ImhNone                                           0x0          // No hints.
#define Qt_ImhHiddenText                                     0x1          // Characters should be hidden, as is typically used when entering passwords. This is automatically set when setting QLineEdit::echoMode to Password.
#define Qt_ImhSensitiveData                                  0x2          // Typed text should not be stored by the active input method in any persistent storage like predictive user dictionary.
#define Qt_ImhNoAutoUppercase                                0x4          // The input method should not try to automatically switch to upper case when a sentence ends.
#define Qt_ImhPreferNumbers                                  0x8          // Numbers are preferred (but not required).
#define Qt_ImhPreferUppercase                                0x10         // Upper case letters are preferred (but not required).
#define Qt_ImhPreferLowercase                                0x20         // Lower case letters are preferred (but not required).
#define Qt_ImhNoPredictiveText                               0x40         // Do not use predictive text (i.e. dictionary lookup) while typing.
#define Qt_ImhDate                                           0x80         // The text editor functions as a date field.
#define Qt_ImhTime                                           0x100        // The text editor functions as a time field.
#define Qt_ImhPreferLatin                                    0x200        // Latin characters are preferred (but not required).
#define Qt_ImhMultiLine                                      0x400        // Multiple lines can be entered into the text field.
#define Qt_ImhDigitsOnly                                     0x10000      // Only digits are allowed.
#define Qt_ImhFormattedNumbersOnly                           0x20000      // Only number input is allowed. This includes decimal point and minus sign.
#define Qt_ImhUppercaseOnly                                  0x40000      // Only upper case letter input is allowed.
#define Qt_ImhLowercaseOnly                                  0x80000      // Only lower case letter input is allowed.
#define Qt_ImhDialableCharactersOnly                         0x100000     // Only characters suitable for phone dialing are allowed.
#define Qt_ImhEmailCharactersOnly                            0x200000     // Only characters suitable for email addresses are allowed.
#define Qt_ImhUrlCharactersOnly                              0x400000     // Only characters suitable for URLs are allowed.
#define Qt_ImhLatinOnly                                      0x800000     // Only latin based input is allowed.
#define Qt_ImhExclusiveInputMask                             0xffff0000   // This mask yields nonzero if any of the exclusive flags are used.

#define Qt_ImEnabled                                         0x1          // The widget accepts input method input.
#define Qt_ImMicroFocus                                      0x2          // This query is obsolete. Use ImCursorRectangle instead.
#define Qt_ImCursorRectangle                                 0x2          // The rectangle covering the area of the input cursor in widget coordinates.
#define Qt_ImFont                                            0x4          // The currently used font for text input.
#define Qt_ImCursorPosition                                  0x8          // The logical position of the cursor within the text surrounding the input area (see ImSurroundingText).
#define Qt_ImSurroundingText                                 0x10         // The plain text around the input area, for example the current paragraph.
#define Qt_ImCurrentSelection                                0x20         // The currently selected text.
#define Qt_ImMaximumTextLength                               0x40         // The maximum number of characters that the widget can hold. If there is no limit, QVariant() is returned.
#define Qt_ImAnchorPosition                                  0x80         // The position of the selection anchor. This may be less or greater than ImCursorPosition, depending on which side of selection the cursor is. If there is no selection, it returns the same as ImCursorPosition.
#define Qt_ImHints                                           0x100        // The hints for input method on expected input. (See #define Qt_InputMethodHints)
#define Qt_ImPreferredLanguage                               0x200        // The preferred input language.
#define Qt_ImPlatformData                                    0x80000000   // Platform specific data for input method.
#define Qt_ImAbsolutePosition                                0x400        // The logical position of the cursor within the entire document.
#define Qt_ImTextBeforeCursor                                0x800        // The plain text before the cursor. The widget can decide how much text to return, but must not return an empty string unless the cursor is at the start of the document.
#define Qt_ImTextAfterCursor                                 0x1000       // The plain text after the cursor. The widget can decide how much text to return, but must not return an empty string unless the cursor is at the end of the document.

//#define Qt_ImQueryInput                                      ImCursorRectangle | ImCursorPosition | ImSurroundingText | ImCurrentSelection | ImAnchorPosition   Commonly changed properties on input.
#define Qt_ImQueryAll                                        0xffffffff   //Query for all input method properties.


//enum #define QScroller::Input
//This enum contains an input device agnostic view of input events that are relevant for QScroller.
#define QScroller_InputPress                                 1   // The user pressed the input device (e.g. QEvent::MouseButtonPress, QEvent::GraphicsSceneMousePress, QEvent::TouchBegin)
#define QScroller_InputMove                                  2   // The user moved the input device (e.g. QEvent::MouseMove, QEvent::GraphicsSceneMouseMove, QEvent::TouchUpdate)
#define QScroller_InputRelease                               3   // The user released the input device (e.g. QEvent::MouseButtonRelease, QEvent::GraphicsSceneMouseRelease, QEvent::TouchEnd)

//enum #define QScroller_ScrollerGestureType
//This enum contains the different gesture types that are supported by the QScroller gesture recognizer.
#define QScroller_TouchGesture                               0   // The gesture recognizer will only trigger on touch events. Specifically it will react on single touch points when using a touch screen and dual touch points when using a touchpad.
#define QScroller_LeftMouseButtonGesture                     1   // The gesture recognizer will only trigger on left mouse button events.
#define QScroller_MiddleMouseButtonGesture                   3   // The gesture recognizer will only trigger on middle mouse button events.
#define QScroller_RightMouseButtonGesture                    2   // The gesture recognizer will only trigger on right mouse button events.

//enum #define QScroller_State
//This enum contains the different QScroller states.
#define QScroller_Inactive                                   0   // The scroller is not scrolling and nothing is pressed.
#define QScroller_Pressed                                    1   // A touch event was received or the mouse button was pressed but the scroll area is currently not dragged.
#define QScroller_Dragging                                   2   // The scroll area is currently following the touch point or mouse.
#define QScroller_Scrolling                                  3   // The scroll area is moving on it's own.

//enum #define QScrollerProperties_FrameRates
//This enum describes the available frame rates used while dragging or scrolling.

#define QScrollerProperties_Fps60                            1   // 60 frames per second
#define QScrollerProperties_Fps30                            2   // 30 frames per second
#define QScrollerProperties_Fps20                            3   // 20 frames per second
#define QScrollerProperties_Standard                         0   // the default value is 60 frames per second (which corresponds to QAbstractAnimation).

//enum #define QScrollerProperties_OvershootPolicy
//This enum describes the various modes of overshooting.
#define QScrollerProperties_OvershootWhenScrollable          0   // Overshooting is possible when the content is scrollable. This is the default.
#define QScrollerProperties_OvershootAlwaysOff               1   // Overshooting is never enabled, even when the content is scrollable.
#define QScrollerProperties_OvershootAlwaysOn                2   // Overshooting is always enabled, even when the content is not scrollable.

//enum #define QScrollerProperties_ScrollMetric
//This enum contains the different scroll metric types. When not indicated otherwise the setScrollMetric function expects a QVariant of type qreal.
#define QScrollerProperties_MousePressEventDelay             0   // This is the time a mouse press event is delayed when starting a flick gesture in [s]. If the gesture is triggered within that time, no mouse press or release is sent to the scrolled object. If it triggers after that delay the delayed mouse press plus a faked release event at global position QPoint(-QWIDGETSIZE_MAX, -QWIDGETSIZE_MAX) is sent. If the gesture is canceled, then both the delayed mouse press plus the real release event are delivered.
#define QScrollerProperties_DragStartDistance                1   // This is the minimum distance the touch or mouse point needs to be moved before the flick gesture is triggered in m.
#define QScrollerProperties_DragVelocitySmoothingFactor      2   // A value that describes to which extent new drag velocities are included in the final scrolling velocity. This value should be in the range between 0 and 1. The lower the value, the more smoothing is applied to the dragging velocity.
#define QScrollerProperties_AxisLockThreshold                3   // Restricts the movement to one axis if the movement is inside an angle around the axis. The threshold must be in the range 0 to 1.
#define QScrollerProperties_ScrollingCurve                   4   // The QEasingCurve used when decelerating the scrolling velocity after an user initiated flick. Please note that this is the easing curve for the positions, not the velocity: the default is QEasingCurve::OutQuad, which results in a linear decrease in velocity (1st derivative) and a constant deceleration (2nd derivative).
#define QScrollerProperties_DecelerationFactor               5   // This factor influences how long it takes the scroller to decelerate to 0 velocity. The actual value depends on the chosen ScrollingCurve. For most types the value should be in the range from 0.1 to 2.0
#define QScrollerProperties_MinimumVelocity                  6   // The minimum velocity that is needed after ending the touch or releasing the mouse to start scrolling in m/s.
#define QScrollerProperties_MaximumVelocity                  7   // This is the maximum velocity that can be reached in m/s.
#define QScrollerProperties_MaximumClickThroughVelocity      8   // This is the maximum allowed scroll speed for a click-through in m/s. This means that a click on a currently (slowly) scrolling object will not only stop the scrolling but the click event will also be delivered to the UI control. This is useful when using exponential-type scrolling curves.
#define QScrollerProperties_AcceleratingFlickMaximumTime     9   // This is the maximum time in seconds that a flick gesture can take to be recognized as an accelerating flick. If set to zero no such gesture is detected. An "accelerating flick" is a flick gesture executed on an already scrolling object. In such cases the scrolling speed is multiplied by AcceleratingFlickSpeedupFactor in order to accelerate it.
#define QScrollerProperties_AcceleratingFlickSpeedupFactor   10  // The current speed is multiplied by this number if an accelerating flick is detected. Should be >= 1.
#define QScrollerProperties_SnapPositionRatio                11  // This is the distance that the user must drag the area beween two snap points in order to snap it to the next position. 0.33 means that the scroll must only reach one third of the distance between two snap points to snap to the next one. The ratio must be between 0 and 1.
#define QScrollerProperties_SnapTime                         12  // This is the time factor for the scrolling curve. A lower value means that the scrolling will take longer. The scrolling distance is independet of this value.
#define QScrollerProperties_OvershootDragResistanceFactor    13  // This value is the factor between the mouse dragging and the actual scroll area movement (during overshoot). The factor must be between 0 and 1.
#define QScrollerProperties_OvershootDragDistanceFactor      14  // This is the maximum distance for overshoot movements while dragging. The actual overshoot distance is calculated by multiplying this value with the viewport size of the scrolled object. The factor must be between 0 and 1.
#define QScrollerProperties_OvershootScrollDistanceFactor    15  // This is the maximum distance for overshoot movements while scrolling. The actual overshoot distance is calculated by multiplying this value with the viewport size of the scrolled object. The factor must be between 0 and 1.
#define QScrollerProperties_OvershootScrollTime              16  // This is the time in seconds that is used to play the complete overshoot animation.
#define QScrollerProperties_HorizontalOvershootPolicy        17  // This is the horizontal overshooting policy (see OvershootPolicy).
#define QScrollerProperties_VerticalOvershootPolicy          18  // This is the horizontal overshooting policy (see OvershootPolicy).
#define QScrollerProperties_FrameRate                        19  // This is the frame rate which should be used while dragging or scrolling. QScroller uses a QAbstractAnimation timer internally to sync all scrolling operations to other animations that might be active at the same time. If the standard value of 60 frames per second is too fast, it can be lowered with this setting, while still being in-sync with QAbstractAnimation. Please note that only the values of the FrameRates enum are allowed here.
#define QScrollerProperties_ScrollMetricCount                20  // This is always the last entry.


//enum #define QGeoAreaMonitorSource_AreaMonitorFeature
//flags #define QGeoAreaMonitorSource_AreaMonitorFeatures
#define QGeoAreaMonitorSource_PersistentAreaMonitorFeature   0x00000001   // QGeoAreaMonitorInfo instances can be made persistent. A persistent monitor continues to be active even when the application managing the monitor is not running.
#define QGeoAreaMonitorSource_AnyAreaMonitorFeature          0xffffffff   // Matches all possible area monitoring features.

//enum #define QGeoAreaMonitorSource_Error
//Defines the types of positioning methods.
#define QGeoAreaMonitorSource_AccessError                    0   // The connection setup to the remote area monitoring backend failed because the application lacked the required privileges.
#define QGeoAreaMonitorSource_InsufficientPositionInfo       1   // The area monitoring source could not retrieve a location fix or the accuracy of the fix is not high enough to provide an effective area monitoring.
#define QGeoAreaMonitorSource_NoError                        3   // No error has occurred.
#define QGeoAreaMonitorSource_UnknownSourceError             2   // An unidentified error occurred.

//enum QGeoPositionInfo::Attribute
//Defines the attributes for positional information.
#define QGeoPositionInfo_Direction                           0   // The bearing measured in degrees clockwise from true north to the direction of travel.
#define QGeoPositionInfo_GroundSpeed                         1   // The ground speed, in meters/sec.
#define QGeoPositionInfo_VerticalSpeed                       2   // The vertical speed, in meters/sec.
#define QGeoPositionInfo_MagneticVariation                   3   // The angle between the horizontal component of the magnetic field and true north, in degrees. Also known as magnetic declination. A positive value indicates a clockwise direction from true north and a negative value indicates a counter-clockwise direction.
#define QGeoPositionInfo_HorizontalAccuracy                  4   // The accuracy of the provided latitude-longitude value, in meters.
#define QGeoPositionInfo_VerticalAccuracy                    5   // The accuracy of the provided altitude value, in meters.

//enum QGeoCoordinate::CoordinateFormat
//Defines the possible formatting options for toString().
#define QGeoCoordinate_Degrees                               0   // Returns a string representation of the coordinates in decimal degrees format.
#define QGeoCoordinate_DegreesWithHemisphere                 1   // Returns a string representation of the coordinates in decimal degrees format, using 'N', 'S', 'E' or 'W' to indicate the hemispheres of the coordinates.
#define QGeoCoordinate_DegreesMinutes                        2   // Returns a string representation of the coordinates in degrees-minutes format.
#define QGeoCoordinate_DegreesMinutesWithHemisphere          3   // Returns a string representation of the coordinates in degrees-minutes format, using 'N', 'S', 'E' or 'W' to indicate the hemispheres of the coordinates.
#define QGeoCoordinate_DegreesMinutesSeconds                 4   // Returns a string representation of the coordinates in degrees-minutes-seconds format.
#define QGeoCoordinate_DegreesMinutesSecondsWithHemisphere   5   // Returns a string representation of the coordinates in degrees-minutes-seconds format, using 'N', 'S', 'E' or 'W' to indicate the hemispheres of the coordinates.

//enum QGeoCoordinate::CoordinateType
//Defines the types of a coordinate.
#define QGeoCoordinate_InvalidCoordinate                     0   // An invalid coordinate. A coordinate is invalid if its latitude or longitude values are invalid.
#define QGeoCoordinate_Coordinate2D                          1   // A coordinate with valid latitude and longitude values.
#define QGeoCoordinate_Coordinate3D                          2   // A coordinate with valid latitude and longitude values, and also an altitude value.

//enum QGeoPositionInfoSource::Error
//The Error enumeration represents the errors which can occur.
#define QGeoPositionInfoSource_AccessError                   0   // The connection setup to the remote positioning backend failed because the application lacked the required privileges.
#define QGeoPositionInfoSource_ClosedError                   1   // The remote positioning backend closed the connection, which happens for example in case the user is switching location services to off. As soon as the location service is re-enabled regular updates will resume.
#define QGeoPositionInfoSource_NoError                       3   // No error has occurred.
#define QGeoPositionInfoSource_UnknownSourceError            2   // An unidentified error occurred.

//enum #define QGeoPositionInfoSource_PositioningMethod
//flags #define QGeoPositionInfoSource_PositioningMethods
//Defines the types of positioning methods.
#define QGeoPositionInfoSource_NoPositioningMethods           0x00000000   // None of the positioning methods.
#define QGeoPositionInfoSource_SatellitePositioningMethods    0x000000ff   // Satellite-based positioning methods such as GPS or GLONASS.
#define QGeoPositionInfoSource_NonSatellitePositioningMethods 0xffffff00   // Other positioning methods such as 3GPP cell identifier or WiFi based positioning.
#define QGeoPositionInfoSource_AllPositioningMethods          0xffffffff   // Satellite-based positioning methods as soon as available. Otherwise non-satellite based methods.

//enum QGeoSatelliteInfo::Attribute
//Defines the attributes for the satellite information.
#define QGeoSatelliteInfo_Elevation                          0      // The elevation of the satellite, in degrees.
#define QGeoSatelliteInfo_Azimuth                            1      // The azimuth to true north, in degrees.

//enum #define QGeoSatelliteInfo_SatelliteSystem
//Defines the GNSS system of the satellite.
#define QGeoSatelliteInfo_Undefined                          0x00   // Not defined.
#define QGeoSatelliteInfo_GPS                                0x01   // Global Positioning System (USA).
#define QGeoSatelliteInfo_GLONASS                            0x02   // Global Positioning System (Russia).

//enum QGeoSatelliteInfoSource::Error
//The Error enumeration represents the errors which can occur.
#define QGeoSatelliteInfoSource_AccessError                  0      // The connection setup to the satellite backend failed because the application lacked the required privileges.
#define QGeoSatelliteInfoSource_ClosedError                  1      // The satellite backend closed the connection, which happens for example in case the user is switching location services to off. This object becomes invalid and should be deleted. A new satellite source can be created by calling createDefaultSource() later on.
#define QGeoSatelliteInfoSource_NoError                      2      // No error has occurred.
#define QGeoSatelliteInfoSource_UnknownSourceError           -1     // An unidentified error occurred.

//enum QGeoShape::ShapeType
//Describes the type of the shape.
#define QGeoShape_UnknownType                                0      // A shape of unknown type.
#define QGeoShape_RectangleType                              1      // A rectangular shape.
#define QGeoShape_CircleType                                 2      // A circular shape.

//enum QNmeaPositionInfoSource::UpdateMode
//Defines the available update modes.
#define QNmeaPositionInfoSource_RealTimeMode                 1      // Positional data is read and distributed from the data source as it becomes available. Use this mode if you are using a live source of positional data (for example, a GPS hardware device).
#define QNmeaPositionInfoSource_SimulationMode               2      // The data and time information in the NMEA source data is used to provide positional updates at the rate at which the data was originally recorded. Use this mode if the data source contains previously recorded NMEA data and you want to replay the data for simulation purposes.

//enum QWebSocketServer::SslMode
//Indicates whether the server operates over wss (SecureMode) or ws (NonSecureMode)
#define QWebSocketServer_SecureMode                          0   // The server operates in secure mode (over wss)
#define QWebSocketServer_NonSecureMode                       1   // The server operates in non-secure mode (over ws)

//enum QWebSocketProtocol::CloseCode
//The close codes supported by WebSockets V13
#define QWebSocketProtocol_CloseCodeNormal                   1000   // Normal closure
#define QWebSocketProtocol_CloseCodeGoingAway                1001   // Going away
#define QWebSocketProtocol_CloseCodeProtocolError            1002   // Protocol error
#define QWebSocketProtocol_CloseCodeDatatypeNotSupported     1003   // Unsupported data
#define QWebSocketProtocol_CloseCodeReserved                 1004   // 1004   Reserved
#define QWebSocketProtocol_CloseCodeMissingStatusCode        1005   // No status received
#define QWebSocketProtocol_CloseCodeAbnormalDisconnection    1006   // Abnormal closure
#define QWebSocketProtocol_CloseCodeWrongDatatype            1007   // Invalid frame payload data
#define QWebSocketProtocol_CloseCodePolicyViolated           1008   // Policy violation
#define QWebSocketProtocol_CloseCodeTooMuchData              1009   // Message too big
#define QWebSocketProtocol_CloseCodeMissingExtension         1010   // Mandatory extension missing
#define QWebSocketProtocol_CloseCodeBadOperation             1011   // Internal server error
#define QWebSocketProtocol_CloseCodeTlsHandshakeFailed       1015   // TLS handshake failed

//enum QWebSocketProtocol::Version
//The different defined versions of the Websocket protocol.
#define QWebSocketProtocol_VersionUnknown                    -1     // Unknown or unspecified version.
#define QWebSocketProtocol_Version0                          0      // hixie76: http://tools.ietf.org/html/draft-hixie-thewebsocketprotocol-76 & hybi-00: http://tools.ietf.org/html/draft-ietf-hybi-thewebsocketprotocol-00. Works with key1, key2 and a key in the payload. Attribute: Sec-WebSocket-Draft value 0. Not supported by QtWebSockets.
#define QWebSocketProtocol_Version4                          4      // hybi-04: http://tools.ietf.org/id/draft-ietf-hybi-thewebsocketprotocol-04.txt. Changed handshake: key1, key2, key3 ==> Sec-WebSocket-Key, Sec-WebSocket-Nonce, Sec-WebSocket-Accept Sec-WebSocket-Draft renamed to Sec-WebSocket-Version Sec-WebSocket-Version = 4. Not supported by QtWebSockets.
#define QWebSocketProtocol_Version5                          5      // hybi-05: http://tools.ietf.org/id/draft-ietf-hybi-thewebsocketprotocol-05.txt. Sec-WebSocket-Version = 5 Removed Sec-WebSocket-Nonce Added Sec-WebSocket-Accept. Not supported by QtWebSockets.
#define QWebSocketProtocol_Version6                          6      // Sec-WebSocket-Version = 6. Not supported by QtWebSockets.
#define QWebSocketProtocol_Version7                          7      // hybi-07: http://tools.ietf.org/html/draft-ietf-hybi-thewebsocketprotocol-07. Sec-WebSocket-Version = 7. Not supported by QtWebSockets.
#define QWebSocketProtocol_Version8                          8      // hybi-8, hybi-9, hybi-10, hybi-11 and hybi-12. Status codes 1005 and 1006 are added and all codes are now unsigned Internal error results in 1006. Not supported by QtWebSockets.
#define QWebSocketProtocol_Version13                         13     // hybi-13, hybi14, hybi-15, hybi-16, hybi-17 and RFC 6455. Sec-WebSocket-Version = 13 Status code 1004 is now reserved Added 1008, 1009 and 1010 Must support TLS Clarify multiple version support. Supported by QtWebSockets.
#define QWebSocketProtocol_VersionLatest                     QWebSocketProtocol_Version13   //Refers to the latest known version to QtWebSockets.

//enum QBluetooth::Security
//flags QBluetooth::SecurityFlags
#define QBluetooth_NoSecurity                                0x00   // The service does not require any security.
#define QBluetooth_Authorization                             0x01   // The service requires authorization by the user, unless the device is Authorized-Paired.
#define QBluetooth_Authentication                            0x02   // The service requires authentication. Device must be paired, and the user is prompted on connection unless the device is Authorized-Paired.
#define QBluetooth_Encryption                                0x04   // The service requires the communication link to be encrypted. This requires the device to be paired.
#define QBluetooth_Secure                                    0x08   // The service requires the communication link to be secure. Simple Pairing from Bluetooth 2.1 or greater is required. Legacy pairing is not permitted.

//enum QBluetoothDeviceDiscoveryAgent::Error
//Indicates all possible error conditions found during Bluetooth device discovery.
#define QBluetoothDeviceDiscoveryAgent_NoError                      0   // No error has occurred.
#define QBluetoothDeviceDiscoveryAgent_PoweredOffError              2   // The Bluetooth adaptor is powered off, power it on before doing discovery.
#define QBluetoothDeviceDiscoveryAgent_InputOutputError             1   // Writing or reading from the device resulted in an error.
#define QBluetoothDeviceDiscoveryAgent_InvalidBluetoothAdapterError 3   // The passed local adapter address does not match the physical adapter address of any local Bluetooth device.
#define QBluetoothDeviceDiscoveryAgent_UnknownError                 100 // An unknown error has occurred.

//enum QBluetoothDeviceDiscoveryAgent::InquiryType
//This enum describes the inquiry type used while discovering Bluetooth devices.
#define QBluetoothDeviceDiscoveryAgent_GeneralUnlimitedInquiry 0   // A general unlimited inquiry. Discovers all visible Bluetooth devices in the local vicinity.
#define QBluetoothDeviceDiscoveryAgent_LimitedInquiry          1   // A limited inquiry discovers devices that are in limited inquiry mode.

//enum QBluetoothDeviceInfo::DataCompleteness
//This enum describes the completeness of the received data.
#define QBluetoothDeviceInfo_DataComplete                    0   // The data is complete.
#define QBluetoothDeviceInfo_DataIncomplete                  1   // The data is incomplete. Addition datum is available via other interfaces.
#define QBluetoothDeviceInfo_DataUnavailable                 2   // No data is available.

//enum #define QBluetoothDeviceInfo_MajorDeviceClass
//This enum describes a Bluetooth device's major device class.
#define QBluetoothDeviceInfo_MiscellaneousDevice             0    // A miscellaneous device.
#define QBluetoothDeviceInfo_ComputerDevice                  1    // A computer device or PDA.
#define QBluetoothDeviceInfo_PhoneDevice                     2    // A telephone device.
#define QBluetoothDeviceInfo_LANAccessDevice                 3    // A device that provides access to a local area network.
#define QBluetoothDeviceInfo_AudioVideoDevice                4    // A device capable of playback or capture of audio and/or video.
#define QBluetoothDeviceInfo_PeripheralDevice                5    // A peripheral device such as a keyboard, mouse, and so on.
#define QBluetoothDeviceInfo_ImagingDevice                   6    // An imaging device such as a display, printer, scanner or camera.
#define QBluetoothDeviceInfo_WearableDevice                  7    // A wearable device such as a watch or pager.
#define QBluetoothDeviceInfo_ToyDevice                       8    // A toy.
#define QBluetoothDeviceInfo_HealthDevice                    9    // A health reated device such as heart rate or temperature monitor.
#define QBluetoothDeviceInfo_UncategorizedDevice             31   // A device that does not fit into any of the other device classes.

//enum #define QBluetoothDeviceInfo_MinorAudioVideoClass
//This enum describes the minor device classes for audio/video devices.
#define QBluetoothDeviceInfo_UncategorizedAudioVideoDevice   0    // An uncategorized audio/video device.
#define QBluetoothDeviceInfo_WearableHeadsetDevice           1    // A wearable headset device.
#define QBluetoothDeviceInfo_HandsFreeDevice                 2    // A handsfree device.
#define QBluetoothDeviceInfo_Microphone                      4    // A microphone.
#define QBluetoothDeviceInfo_Loudspeaker                     5    // A loudspeaker.
#define QBluetoothDeviceInfo_Headphones                      6    // Headphones.
#define QBluetoothDeviceInfo_PortableAudioDevice             7    // A portable audio device.
#define QBluetoothDeviceInfo_CarAudio                        8    // A car audio device.
#define QBluetoothDeviceInfo_SetTopBox                       9    // A settop box.
#define QBluetoothDeviceInfo_HiFiAudioDevice                 10   // A HiFi audio device.
#define QBluetoothDeviceInfo_Vcr                             11   // A video cassette recorder.
#define QBluetoothDeviceInfo_VideoCamera                     12   // A video camera.
#define QBluetoothDeviceInfo_Camcorder                       13   // A video camera.
#define QBluetoothDeviceInfo_VideoMonitor                    14   // A video monitor.
#define QBluetoothDeviceInfo_VideoDisplayAndLoudspeaker      15   // A video display with built-in loudspeaker.
#define QBluetoothDeviceInfo_VideoConferencing               16   // A video conferencing device.
#define QBluetoothDeviceInfo_GamingDevice                    18   // A gaming device.

//enum #define QBluetoothDeviceInfo_MinorComputerClass
//This enum describes the minor device classes for computer devices.
#define QBluetoothDeviceInfo_UncategorizedComputer           0   // An uncategorized computer device.
#define QBluetoothDeviceInfo_DesktopComputer                 1   // A desktop computer.
#define QBluetoothDeviceInfo_ServerComputer                  2   // A server computer.
#define QBluetoothDeviceInfo_LaptopComputer                  3   // A laptop computer.
#define QBluetoothDeviceInfo_HandheldClamShellComputer       4   // A clamshell handheld computer or PDA.
#define QBluetoothDeviceInfo_HandheldComputer                5   // A handheld computer or PDA.
#define QBluetoothDeviceInfo_WearableComputer                6   // A wearable computer.

//enum #define QBluetoothDeviceInfo_MinorHealthClass
//This enum describes the minor device classes for health devices.
#define QBluetoothDeviceInfo_UncategorizedHealthDevice       0     // An uncategorized health device.
#define QBluetoothDeviceInfo_HealthBloodPressureMonitor      0x1   // A blood pressure monitor.
#define QBluetoothDeviceInfo_HealthThermometer               0x2   // A Thermometer.
#define QBluetoothDeviceInfo_HealthWeightScale               0x3   // A scale.
#define QBluetoothDeviceInfo_HealthGlucoseMeter              0x4   // A glucose meter.
#define QBluetoothDeviceInfo_HealthPulseOximeter             0x5   // A blood oxygen saturation meter.
#define QBluetoothDeviceInfo_HealthDataDisplay               0x7   // A data display.
#define QBluetoothDeviceInfo_HealthStepCounter               0x8   // A pedometer.

//enum #define QBluetoothDeviceInfo_MinorImagingClass
//This enum describes the minor device classes for imaging devices.
#define QBluetoothDeviceInfo_UncategorizedImagingDevice      0      // An uncategorized imaging device.
#define QBluetoothDeviceInfo_ImageDisplay                    0x04   // A device capable of displaying images.
#define QBluetoothDeviceInfo_ImageCamera                     0x08   // A camera.
#define QBluetoothDeviceInfo_ImageScanner                    0x10   // An image scanner.
#define QBluetoothDeviceInfo_ImagePrinter                    0x20   // A printer.

//enum #define QBluetoothDeviceInfo_MinorMiscellaneousClass
//This enum describes the minor device classes for miscellaneous Bluetooth devices.
#define QBluetoothDeviceInfo_UncategorizedMiscellaneous      0      // An uncategorized miscellaneous device.

//enum #define QBluetoothDeviceInfo_MinorNetworkClass
//This enum describes the minor device classes for local area network access devices. Local area network access devices use the minor device class to specify the current network utilization.
#define QBluetoothDeviceInfo_NetworkFullService              0x00   // 100% of the total bandwidth is available.
#define QBluetoothDeviceInfo_NetworkLoadFactorOne            0x08   // 0 - 17% of the total bandwidth is currently being used.
#define QBluetoothDeviceInfo_NetworkLoadFactorTwo            0x10   // 17 - 33% of the total bandwidth is currently being used.
#define QBluetoothDeviceInfo_NetworkLoadFactorThree          0x18   // 33 - 50% of the total bandwidth is currently being used.
#define QBluetoothDeviceInfo_NetworkLoadFactorFour           0x20   // 50 - 67% of the total bandwidth is currently being used.
#define QBluetoothDeviceInfo_NetworkLoadFactorFive           0x28   // 67 - 83% of the total bandwidth is currently being used.
#define QBluetoothDeviceInfo_NetworkLoadFactorSix            0x30   // 83 - 99% of the total bandwidth is currently being used.
#define QBluetoothDeviceInfo_NetworkNoService                0x38   // No network service available.

//enum #define QBluetoothDeviceInfo_MinorPeripheralClass
//This enum describes the minor device classes for peripheral devices.
#define QBluetoothDeviceInfo_UncategorizedPeripheral              0   An uncategorized peripheral device.
#define QBluetoothDeviceInfo_KeyboardPeripheral                   0x10   A keyboard.
#define QBluetoothDeviceInfo_PointingDevicePeripheral             0x20   A pointing device, for example a mouse.
#define QBluetoothDeviceInfo_KeyboardWithPointingDevicePeripheral 0x30   A keyboard with built-in pointing device.
#define QBluetoothDeviceInfo_JoystickPeripheral                   0x01   A joystick.
#define QBluetoothDeviceInfo_GamepadPeripheral                    0x02   A game pad.
#define QBluetoothDeviceInfo_RemoteControlPeripheral              0x03   A remote control.
#define QBluetoothDeviceInfo_SensingDevicePeripheral              0x04   A sensing device.
#define QBluetoothDeviceInfo_DigitizerTabletPeripheral            0x05   A digitizer tablet peripheral.
#define QBluetoothDeviceInfo_CardReaderPeripheral                 0x06   A card reader peripheral.

//enum #define QBluetoothDeviceInfo_MinorPhoneClass
//This enum describes the minor device classes for phone devices.
#define QBluetoothDeviceInfo_UncategorizedPhone              0   // An uncategorized phone device.
#define QBluetoothDeviceInfo_CellularPhone                   1   // A cellular phone.
#define QBluetoothDeviceInfo_CordlessPhone                   2   // A cordless phone.
#define QBluetoothDeviceInfo_SmartPhone                      3   // A smart phone.
#define QBluetoothDeviceInfo_WiredModemOrVoiceGatewayPhone   4   // A wired modem or voice gateway.
#define QBluetoothDeviceInfo_CommonIsdnAccessPhone           5   // A device that provides ISDN access.

//enum #define QBluetoothDeviceInfo_MinorToyClass
//This enum describes the minor device classes for toy devices.
#define QBluetoothDeviceInfo_UncategorizedToy                0   // An uncategorized toy.
#define QBluetoothDeviceInfo_ToyRobot                        1   // A toy robot.
#define QBluetoothDeviceInfo_ToyVehicle                      2   // A toy vehicle.
#define QBluetoothDeviceInfo_ToyDoll                         3   // A toy doll or action figure.
#define QBluetoothDeviceInfo_ToyController                   4   // A controller.
#define QBluetoothDeviceInfo_ToyGame                         5   // A game.

//enum #define QBluetoothDeviceInfo_MinorWearableClass
//This enum describes the minor device classes for wearable devices.
#define QBluetoothDeviceInfo_UncategorizedWearableDevice     0   // An uncategorized wearable device.
#define QBluetoothDeviceInfo_WearableWristWatch              1   // A wristwatch.
#define QBluetoothDeviceInfo_WearablePager                   2   // A pager.
#define QBluetoothDeviceInfo_WearableJacket                  3   // A jacket.
#define QBluetoothDeviceInfo_WearableHelmet                  4   // A helmet.
#define QBluetoothDeviceInfo_WearableGlasses                 5   // A pair of glasses.

//enum #define QBluetoothDeviceInfo_ServiceClass
//flags #define QBluetoothDeviceInfo_ServiceClasses
#define QBluetoothDeviceInfo_NoService                       0x0000   // The device does not provide any services.
#define QBluetoothDeviceInfo_PositioningService              0x0001   // The device provides positioning services.
#define QBluetoothDeviceInfo_NetworkingService               0x0002   // The device provides networking services.
#define QBluetoothDeviceInfo_RenderingService                0x0004   // The device provides rendering services.
#define QBluetoothDeviceInfo_CapturingService                0x0008   // The device provides capturing services.
#define QBluetoothDeviceInfo_ObjectTransferService           0x0010   // The device provides object transfer services.
#define QBluetoothDeviceInfo_AudioService                    0x0020   // The device provides audio services.
#define QBluetoothDeviceInfo_TelephonyService                0x0040   // The device provides telephony services.
#define QBluetoothDeviceInfo_InformationService              0x0080   // The device provides information services.
#define QBluetoothDeviceInfo_AllServices                     0x07ff   // The device provides services of all types.

//enum #define QBluetoothLocalDevice_Error
//This enum describes errors that maybe returned
#define QBluetoothLocalDevice_NoError                        0     // No known error
#define QBluetoothLocalDevice_PairingError                   1     // Error in pairing
#define QBluetoothLocalDevice_UnknownError                   100   // Unknown error

//enum #define QBluetoothLocalDevice_HostMode
//This enum describes the most of the local Bluetooth device.
#define QBluetoothLocalDevice_HostPoweredOff                 0   // Power off the device
#define QBluetoothLocalDevice_HostConnectable                1   // Remote Bluetooth devices can connect to the local Bluetooth device if they have previously been paired with it or otherwise know its address. This powers up the device if it was powered off.
#define QBluetoothLocalDevice_HostDiscoverable               2   // Remote Bluetooth devices can discover the presence of the local Bluetooth device. The device will also be connectable, and powered on. On Android, this mode can only be active for a maximum of 5 minutes.
#define QBluetoothLocalDevice_HostDiscoverableLimitedInquiry 3   // Remote Bluetooth devices can discover the presence of the local Bluetooth device when performing a limited inquiry. This should be used for locating services that are only made discoverable for a limited period of time. This can speed up discovery between gaming devices, as service discovery can be skipped on devices not in LimitedInquiry mode. In this mode, the device will be connectable and powered on, if required. This mode is is not supported on Android.

//enum #define QBluetoothLocalDevice_Pairing
//This enum describes the pairing state between the two Bluetooth devices.
#define QBluetoothLocalDevice_Unpaired                       0   // The Bluetooth devices are not paired.
#define QBluetoothLocalDevice_Paired                         1   // The Bluetooth devices are paired. The system will prompt the user for authorization when the remote device initiates a connection to the local device.
#define QBluetoothLocalDevice_AuthorizedPaired               2   // The Bluetooth devices are paired. The system will not prompt the user for authorization when the remote device initiates a connection to the local device.

//enum #define QBluetoothServer_Error
//This enum describes Bluetooth server error types.
#define QBluetoothServer_NoError                             0   // No error.
#define QBluetoothServer_UnknownError                        1   // An unknown error occurred.
#define QBluetoothServer_PoweredOffError                     2   // The Bluetooth adapter is powered off.
#define QBluetoothServer_InputOutputError                    3   // An input output error occurred.
#define QBluetoothServer_ServiceAlreadyRegisteredError       4   // The service or port was already registered
#define QBluetoothServer_UnsupportedProtocolError            5   // The Protocol is not supported on this platform.

//enum #define QBluetoothServiceDiscoveryAgent_DiscoveryMode
//This enum describes the service discovery mode.
#define QBluetoothServiceDiscoveryAgent_MinimalDiscovery     0   // Performs a minimal service discovery. The QBluetoothServiceInfo objects returned may be incomplete and are only guaranteed to contain device and service UUID information.
#define QBluetoothServiceDiscoveryAgent_FullDiscovery        1   // Performs a full service discovery.

//enum #define QBluetoothServiceDiscoveryAgent_Error
//This enum describes errors that can occur during service discovery.
#define QBluetoothServiceDiscoveryAgent_NoError                      QBluetoothDeviceDiscoveryAgent_NoError                        // No error has occurred.
#define QBluetoothServiceDiscoveryAgent_PoweredOffError              QBluetoothDeviceDiscoveryAgent_PoweredOffError                // The Bluetooth adaptor is powered off, power it on before doing discovery.
#define QBluetoothServiceDiscoveryAgent_InputOutputError             QBluetoothDeviceDiscoveryAgent_InputOutputError               // Writing or reading from the device resulted in an error.
#define QBluetoothServiceDiscoveryAgent_InvalidBluetoothAdapterError QBluetoothDeviceDiscoveryAgent_InvalidBluetoothAdapterError   // The passed local adapter address does not match the physical adapter address of any local Bluetooth device.
#define QBluetoothServiceDiscoveryAgent_UnknownError                 QBluetoothDeviceDiscoveryAgent_UnknownError                   // An unknown error has occurred.

//enum #define QBluetoothServiceInfo_AttributeId
//Bluetooth service attributes. Please check the Bluetooth Core Specification for a more detailed description of these attributes.
#define QBluetoothServiceInfo_ServiceRecordHandle              0x0000   // Specifies a service record from which attributes can be retrieved.
#define QBluetoothServiceInfo_ServiceClassIds                  0x0001   // UUIDs of service classes that the service conforms to. The most common service classes are defined in (QBluetoothUuid::ServiceClassUuid)
#define QBluetoothServiceInfo_ServiceRecordState               0x0002   // Attibute changes when any other service attribute is added, deleted or modified.
#define QBluetoothServiceInfo_ServiceId                        0x0003   // UUID that uniquely identifies the service.
#define QBluetoothServiceInfo_ProtocolDescriptorList           0x0004   // List of protocols used by the service. The most common protocol Uuids are defined in QBluetoothUuid::ProtocolUuid
#define QBluetoothServiceInfo_BrowseGroupList                  0x0005   // List of browse groups the service is in.
#define QBluetoothServiceInfo_LanguageBaseAttributeIdList      0x0006   // List of language base attribute IDs to support human-readable attributes.
#define QBluetoothServiceInfo_ServiceInfoTimeToLive            0x0007   // Number of seconds for which the service record is expected to remain valid and unchanged.
#define QBluetoothServiceInfo_ServiceAvailability              0x0008   // Value indicating the availability of the service.
#define QBluetoothServiceInfo_BluetoothProfileDescriptorList   0x0009   // List of profiles to which the service conforms.
#define QBluetoothServiceInfo_DocumentationUrl                 0x000A   // URL that points to the documentation on the service..
#define QBluetoothServiceInfo_ClientExecutableUrl              0x000B   // URL that refers to the location of an application that can be used to utilize the service.
#define QBluetoothServiceInfo_IconUrl                          0x000C   // URL to the location of the icon representing the service.
#define QBluetoothServiceInfo_AdditionalProtocolDescriptorList 0x000D   // Additional protocols used by the service. This attribute extends ProtocolDescriptorList.
#define QBluetoothServiceInfo_PrimaryLanguageBase              0x0100   // Base index for primary language text descriptors.
#define QBluetoothServiceInfo_ServiceName                      QBluetoothServiceInfo_PrimaryLanguageBase + 0x0000   // Name of the Bluetooth service in the primary language.
#define QBluetoothServiceInfo_ServiceDescription               QBluetoothServiceInfo_PrimaryLanguageBase + 0x0001   // Description of the Bluetooth service in the primary language.
#define QBluetoothServiceInfo_ServiceProvider                  QBluetoothServiceInfo_PrimaryLanguageBase + 0x0002   // Name of the company / entity that provides the Bluetooth service primary language.

//enum #define QBluetoothServiceInfo_Protocol
//This enum describes the socket protocol used by the service.
#define QBluetoothServiceInfo_UnknownProtocol                0   // The service uses an unknown socket protocol.
#define QBluetoothServiceInfo_L2capProtocol                  1   // The service uses the L2CAP socket protocol. This protocol is not supported for direct socket connections on Android and BlackBerry.
#define QBluetoothServiceInfo_RfcommProtocol                 2   // The service uses the RFCOMM socket protocol.

//enum QBluetoothSocket::SocketError
//This enum describes Bluetooth socket error types.
#define QBluetoothSocket_UnknownSocketError                  QAbstractSocket_UnknownSocketError               // An unknown error has occurred.
#define QBluetoothSocket_NoSocketError                       -2                                               // No error. Used for testing.
#define QBluetoothSocket_HostNotFoundError                   QAbstractSocket_HostNotFoundError                // Could not find the remote host.
#define QBluetoothSocket_ServiceNotFoundError                QAbstractSocket_SocketAddressNotAvailableError   // Could not find the service UUID on remote host.
#define QBluetoothSocket_NetworkError                        QAbstractSocket_NetworkError                     // Attempt to read or write from socket returned an error
#define QBluetoothSocket_UnsupportedProtocolError            8                                                // The Protocol is not supported on this platform.
#define QBluetoothSocket_OperationError                      QAbstractSocket_OperationError                   // An operation was attempted while the socket was in a state that did not permit it.

//enum #define QBluetoothSocket_SocketState
//This enum describes the state of the Bluetooth socket.
#define QBluetoothSocket_UnconnectedState                    QAbstractSocket_UnconnectedState  // Socket is not connected.
#define QBluetoothSocket_ServiceLookupState                  QAbstractSocket_HostLookupState   // Socket is querying connection parameters.
#define QBluetoothSocket_ConnectingState                     QAbstractSocket_ConnectingState   // Socket is attempting to connect to a device.
#define QBluetoothSocket_ConnectedState                      QAbstractSocket_ConnectedState    // Socket is connected to a device.
#define QBluetoothSocket_BoundState                          QAbstractSocket_BoundState        // Socket is bound to a local address and port.
#define QBluetoothSocket_ClosingState                        QAbstractSocket_ClosingState      // Socket is connected and will be closed once all pending data is written to the socket.
#define QBluetoothSocket_ListeningState                      QAbstractSocket_ListeningState    // Socket is listening for incoming connections.

//enum QBluetoothTransferReply::TransferError
//This enum describes the type of error that occurred
#define QBluetoothTransferReply_NoError                      0   // No error.
#define QBluetoothTransferReply_UnknownError                 1   // Unknown error, no better enum available
#define QBluetoothTransferReply_FileNotFoundError            2   // Unable to open the file specified
#define QBluetoothTransferReply_HostNotFoundError            3   // Unable to connect to the target host
#define QBluetoothTransferReply_UserCanceledTransferError    4   // User terminated the transfer

//enum QBluetoothTransferRequest::Attribute
//Attribute codes for QBluetoothTransferRequest and QBluetoothTransferReply.
#define QBluetoothTransferRequest_DescriptionAttribute       0   // A textual description of the object being transferred. May be displayed in the UI of the remote device.
#define QBluetoothTransferRequest_TimeAttribute              1   // Time attribute of the object being transferred.
#define QBluetoothTransferRequest_TypeAttribute              2   // MIME type of the object being transferred.
#define QBluetoothTransferRequest_LengthAttribute            3   // Length in bytes of the object being transferred.
#define QBluetoothTransferRequest_NameAttribute              4   // Name of the object being transferred. May be displayed in the UI of the remote device.

//enum QBluetoothUuid::ProtocolUuid
//This enum is a convienience type for Bluetooth protocol UUIDs. Values of this type will be implicitly converted into a QBluetoothUuid when necessary.
#define QBluetoothUuid_Sdp                                   0x0001   // SDP protocol UUID
#define QBluetoothUuid_Udp                                   0x0002   // UDP protocol UUID
#define QBluetoothUuid_Rfcomm                                0x0003   // RFCOMM protocol UUID
#define QBluetoothUuid_Tcp                                   0x0004   // TCP protocol UUID
#define QBluetoothUuid_TcsBin                                0x0005   // Telephony Control Specification UUID
#define QBluetoothUuid_TcsAt                                 0x0006   // Telephony Control Specification AT UUID
#define QBluetoothUuid_Att                                   0x0007   // Attribute protocol UUID
#define QBluetoothUuid_Obex                                  0x0008   // OBEX protocol UUID
#define QBluetoothUuid_Ip                                    0x0009   // IP protocol UUID
#define QBluetoothUuid_Ftp                                   0x000A   // FTP protocol UUID
#define QBluetoothUuid_Http                                  0x000C   // HTTP protocol UUID
#define QBluetoothUuid_Wsp                                   0x000E   // WSP UUID
#define QBluetoothUuid_Bnep                                  0x000F   // Bluetooth Network Encapsulation Protocol UUID
#define QBluetoothUuid_Upnp                                  0x0010   // Extended Service Discovery Profile UUID
#define QBluetoothUuid_Hidp                                  0x0011   // Human Interface Device Profile UUID
#define QBluetoothUuid_HardcopyControlChannel                0x0012   // Hardcopy Cable Replacement Profile UUID
#define QBluetoothUuid_HardcopyDataChannel                   0x0014   // Hardcopy Cable Replacement Profile UUID
#define QBluetoothUuid_HardcopyNotification                  0x0016   // Hardcopy Cable Replacement Profile UUID
#define QBluetoothUuid_Avctp                                 0x0017   // Audio/Video Control Transport Protocol UUID
#define QBluetoothUuid_Avdtp                                 0x0019   // Audio/Video Distribution Transport Protocol UUID
#define QBluetoothUuid_Cmtp                                  0x001B   // Common ISDN Access Profile
#define QBluetoothUuid_UdiCPlain                             0x001D   // UDI protocol UUID
#define QBluetoothUuid_McapControlChannel                    0x001E   // Multi-Channel Adaptation Protocol UUID
#define QBluetoothUuid_McapDataChannel                       0x001F   // Multi-Channel Adaptation Protocol UUID
#define QBluetoothUuid_L2cap                                 0x0100   // L2CAP protocol UUID

//enum #define QBluetoothUuid_ServiceClassUuid
//This enum is a convienience type for Bluetooth service class and profile UUIDs. Values of this type will be implicitly converted into a QBluetoothUuid when necessary. Some UUIDs refer to service class ids, others to profile ids and some can be used as both. In general, profile UUIDs shall only be used in a QBluetoothServiceInfo::BluetoothProfileDescriptorList attribute and service class UUIDs shall only be used in a QBluetoothServiceInfo::ServiceClassIds attribute. If the UUID is marked as profile and service class UUID it can be used as a value for either of the above service attributes. Such a dual use has historical reasons but is no longer permissible for newer UUIDs.
#define QBluetoothUuid_ServiceDiscoveryServer                0x1000   // Service discovery server UUID (service)
#define QBluetoothUuid_BrowseGroupDescriptor                 0x1001   // Browser group descriptor (service)
#define QBluetoothUuid_PublicBrowseGroup                     0x1002   // Public browse group service class. Services which have the public browse group in their browse group list are discoverable by the remote devices.
#define QBluetoothUuid_SerialPort                            0x1101   // Serial Port Profile UUID (service & profile)
#define QBluetoothUuid_LANAccessUsingPPP                     0x1102   // LAN Access Profile UUID (service & profile)
#define QBluetoothUuid_DialupNetworking                      0x1103   // Dial-up Networking Profile UUID (service & profile)
#define QBluetoothUuid_IrMCSync                              0x1104   // Synchronization Profile UUID (service & profile)
#define QBluetoothUuid_ObexObjectPush                        0x1105   // OBEX object push service UUID (service & profile)
#define QBluetoothUuid_OBEXFileTransfer                      0x1106   // File Transfer Profile (FTP) UUID (service & profile)
#define QBluetoothUuid_IrMCSyncCommand                       0x1107   // Synchronization Profile UUID (profile)
#define QBluetoothUuid_Headset                               0x1108   // Headset Profile (HSP) UUID (service & profile)
#define QBluetoothUuid_AudioSource                           0x110a   // Advanced Audio Distribution Profile (A2DP) UUID (service)
#define QBluetoothUuid_AudioSink                             0x110b   // Advanced Audio Distribution Profile (A2DP) UUID (service)
#define QBluetoothUuid_AV_RemoteControlTarget                0x110c   // Audio/Video Remote Control Profile (AVRCP) UUID (service)
#define QBluetoothUuid_AdvancedAudioDistribution             0x110d   // Advanced Audio Distribution Profile (A2DP) UUID (profile)
#define QBluetoothUuid_AV_RemoteControl                      0x110e   // Audio/Video Remote Control Profile (AVRCP) UUID (service & profile)
#define QBluetoothUuid_AV_RemoteControlController            0x110f   // Audio/Video Remote Control Profile UUID (service)
#define QBluetoothUuid_HeadsetAG                             0x1112   // Headset Profile (HSP) UUID (service)
#define QBluetoothUuid_PANU                                  0x1115   // Personal Area Networking Profile (PAN) UUID (service & profile)
#define QBluetoothUuid_NAP                                   0x1116   // Personal Area Networking Profile (PAN) UUID (service & profile)
#define QBluetoothUuid_GN                                    0x1117   // Personal Area Networking Profile (PAN) UUID (service & profile)
#define QBluetoothUuid_DirectPrinting                        0x1118   // Basic Printing Profile (BPP) UUID (service)
#define QBluetoothUuid_ReferencePrinting                     0x1119   // Related to Basic Printing Profile (BPP) UUID (service)
#define QBluetoothUuid_BasicImage                            0x111a   // Basic Imaging Profile (BIP) UUID (profile)
#define QBluetoothUuid_ImagingResponder                      0x111b   // Basic Imaging Profile (BIP) UUID (service)
#define QBluetoothUuid_ImagingAutomaticArchive               0x111c   // Basic Imaging Profile (BIP) UUID (service)
#define QBluetoothUuid_ImagingReferenceObjects               0x111d   // Basic Imaging Profile (BIP) UUID (service)
#define QBluetoothUuid_Handsfree                             0x111e   // Hands-Free Profile (HFP) UUID (service & profile)
#define QBluetoothUuid_HandsfreeAudioGateway                 0x111f   // Hands-Free Audio Gateway (HFP) UUID (service)
#define QBluetoothUuid_DirectPrintingReferenceObjectsService 0x1120   // Basic Printing Profile (BPP) UUID (service)
#define QBluetoothUuid_ReflectedUI                           0x1121   // Basic Printing Profile (BPP) UUID (service)
#define QBluetoothUuid_BasicPrinting                         0x1122   // Basic Printing Profile (BPP) UUID (profile)
#define QBluetoothUuid_PrintingStatus                        0x1123   // Basic Printing Profile (BPP) UUID (service)
#define QBluetoothUuid_HumanInterfaceDeviceService           0x1124   // Human Interface Device (HID) UUID (service & profile)
#define QBluetoothUuid_HardcopyCableReplacement              0x1125   // Hardcopy Cable Replacement Profile (HCRP) (profile)
#define QBluetoothUuid_HCRPrint                              0x1126   // Hardcopy Cable Replacement Profile (HCRP) (service)
#define QBluetoothUuid_HCRScan                               0x1127   // Hardcopy Cable Replacement Profile (HCRP) (service)
#define QBluetoothUuid_SIMAccess                             0x112d   // SIM Access Profile (SAP) UUID (service and profile)
#define QBluetoothUuid_PhonebookAccessPCE                    0x112e   // Phonebook Access Profile (PBAP) UUID (service)
#define QBluetoothUuid_PhonebookAccessPSE                    0x112f   // Phonebook Access Profile (PBAP) UUID (service)
#define QBluetoothUuid_PhonebookAccess                       0x1130   // Phonebook Access Profile (PBAP) (profile)
#define QBluetoothUuid_HeadsetHS                             0x1131   // Headset Profile (HSP) UUID (service)
#define QBluetoothUuid_MessageAccessServer                   0x1132   // Message Access Profile (MAP) UUID (service)
#define QBluetoothUuid_MessageNotificationServer             0x1133   // Message Access Profile (MAP) UUID (service)
#define QBluetoothUuid_MessageAccessProfile                  0x1134   // Message Access Profile (MAP) UUID (profile)
#define QBluetoothUuid_GNSS                                  0x1135   // Global Navigation Satellite System UUID (profile)
#define QBluetoothUuid_GNSSServer                            0x1136   // Global Navigation Satellite System Server (UUID) (service)
#define QBluetoothUuid_Display3D                             0x1137   // 3D Synchronization Display UUID (service)
#define QBluetoothUuid_Glasses3D                             0x1138   // 3D Synchronization Glasses UUID (service)
#define QBluetoothUuid_Synchronization3D                     0x1139   // 3D Synchronization UUID (profile)
#define QBluetoothUuid_MPSProfile                            0x113a   // Multi-Profile Specification UUID (profile)
#define QBluetoothUuid_MPSService                            0x113b   // Multi-Profile Specification UUID (service)
#define QBluetoothUuid_PnPInformation                        0x1200   // Device Identification (DID) UUID (service & profile)
#define QBluetoothUuid_GenericNetworking                     0x1201   // Generic networking UUID (service)
#define QBluetoothUuid_GenericFileTransfer                   0x1202   // Generic file transfer UUID (service)
#define QBluetoothUuid_GenericAudio                          0x1203   // Generic audio UUID (service)
#define QBluetoothUuid_GenericTelephony                      0x1204   // Generic telephone UUID (service)
#define QBluetoothUuid_VideoSource                           0x1303   // Video Distribution Profile (VDP) UUID (service)
#define QBluetoothUuid_VideoSink                             0x1304   // Video Distribution Profile (VDP) UUID (service)
#define QBluetoothUuid_VideoDistribution                     0x1305   // Video Distribution Profile (VDP) UUID (profile)
#define QBluetoothUuid_HDP                                   0x1400   // Health Device Profile (HDP) UUID (profile)
#define QBluetoothUuid_HDPSource                             0x1401   // Health Device Profile Source (HDP) UUID (service)
#define QBluetoothUuid_HDPSink                               0x1402   // Health Device Profile Sink (HDP) UUID (service)

//enum QUuid::Variant
//This enum defines the values used in the variant field of the UUID. The value in the variant field determines the layout of the 128-bit value.
#define QUuid_VarUnknown                                     -1  // Variant is unknown
#define QUuid_NCS                                            0   // Reserved for NCS (Network Computing System) backward compatibility
#define QUuid_DCE                                            2   // Distributed Computing Environment, the scheme used by QUuid
#define QUuid_Microsoft                                      6   // Reserved for Microsoft backward compatibility (GUID)
#define QUuid_Reserved                                       7   // Reserved for future definition

//enum #define QUuid_Version
//This enum defines the values used in the version field of the UUID. The version field is meaningful only if the value in the variant field is #define QUuid_DCE.
#define QUuid_VerUnknown                                     -1  // Version is unknown
#define QUuid_Time                                           1   // Time-based, by using timestamp, clock sequence, and MAC network card address (if available) for the node sections
#define QUuid_EmbeddedPOSIX                                  2   // DCE Security version, with embedded POSIX UUIDs
#define QUuid_Name   Md                                      5   // Name-based, by using values from a name for all sections
#define QUuid_Md                                             5   // 3   Alias for Name
#define QUuid_Random                                         4   // Random-based, by using random numbers for all sections
#define QUuid_Sha                                            1   // 5

//enum QPageSize_PageSizeId
//This enum type lists the available page sizes as defined in the Postscript PPD standard. These values are duplicated in QPagedPaintDevice and QPrinter.
#define QPageSize_A0                                         5    // 841 x 1189 mm
#define QPageSize_A1                                         6    // 594 x 841 mm
#define QPageSize_A2                                         7    // 420 x 594 mm
#define QPageSize_A3                                         8    // 297 x 420 mm
#define QPageSize_A4                                         0    // 210 x 297 mm, 8.26 x 11.69 inches
#define QPageSize_A5                                         9    // 148 x 210 mm
#define QPageSize_A6                                         10   // 105 x 148 mm
#define QPageSize_A7                                         11   // 74 x 105 mm
#define QPageSize_A8                                         12   // 52 x 74 mm
#define QPageSize_A9                                         13   // 37 x 52 mm
#define QPageSize_B0                                         14   // 1000 x 1414 mm
#define QPageSize_B1                                         15   // 707 x 1000 mm
#define QPageSize_B2                                         17   // 500 x 707 mm
#define QPageSize_B3                                         18   // 353 x 500 mm
#define QPageSize_B4                                         19   // 250 x 353 mm
#define QPageSize_B5                                         1    // 176 x 250 mm, 6.93 x 9.84 inches
#define QPageSize_B6                                         20   // 125 x 176 mm
#define QPageSize_B7                                         21   // 88 x 125 mm
#define QPageSize_B8                                         22   // 62 x 88 mm
#define QPageSize_B9                                         23   // 44 x 62 mm
#define QPageSize_B10                                        16   // 31 x 44 mm
#define QPageSize_C5E                                        24   // 163 x 229 mm
#define QPageSize_Comm10E                                    25   // 105 x 241 mm, U.S. Common 10 Envelope
#define QPageSize_DLE                                        26   // 110 x 220 mm
#define QPageSize_Executive                                  4    // 7.5 x 10 inches, 190.5 x 254 mm
#define QPageSize_Folio                                      27   // 210 x 330 mm
#define QPageSize_Ledger                                     28   // 431.8 x 279.4 mm
#define QPageSize_Legal                                      3    // 8.5 x 14 inches, 215.9 x 355.6 mm
#define QPageSize_Letter                                     2    // 8.5 x 11 inches, 215.9 x 279.4 mm
#define QPageSize_Tabloid                                    29   // 279.4 x 431.8 mm
#define QPageSize_Custom                                     30   // Unknown, or a user defined size.
#define QPageSize_A10                                        31
#define QPageSize_A3Extra                                    32
#define QPageSize_A4Extra                                    33
#define QPageSize_A4Plus                                     34
#define QPageSize_A4Small                                    35
#define QPageSize_A5Extra                                    36
#define QPageSize_B5Extra                                    37
#define QPageSize_JisB0                                      38
#define QPageSize_JisB1                                      39
#define QPageSize_JisB2                                      40
#define QPageSize_JisB3                                      41
#define QPageSize_JisB4                                      42
#define QPageSize_JisB5                                      43
#define QPageSize_JisB6                                      44   ,
#define QPageSize_JisB7                                      45
#define QPageSize_JisB8                                      46
#define QPageSize_JisB9                                      47
#define QPageSize_JisB10                                     48
#define QPageSize_AnsiA                                      QPageSize_Letter
#define QPageSize_AnsiB                                      QPageSize_Ledger
#define QPageSize_AnsiC                                      49
#define QPageSize_AnsiD                                      50
#define QPageSize_AnsiE                                      51
#define QPageSize_LegalExtra                                 52
#define QPageSize_LetterExtra                                53
#define QPageSize_LetterPlus                                 54
#define QPageSize_LetterSmall                                55
#define QPageSize_TabloidExtra                               56
#define QPageSize_ArchA                                      57
#define QPageSize_ArchB                                      58
#define QPageSize_ArchC                                      59
#define QPageSize_ArchD                                      60
#define QPageSize_ArchE                                      61
#define QPageSize_Imperial7x9                                62
#define QPageSize_Imperial8x10                               63
#define QPageSize_Imperial9x11                               64
#define QPageSize_Imperial9x12                               65
#define QPageSize_Imperial10x11                              66
#define QPageSize_Imperial10x13                              67
#define QPageSize_Imperial10x14                              68
#define QPageSize_Imperial12x11                              69
#define QPageSize_Imperial15x11                              70
#define QPageSize_ExecutiveStandard                          71
#define QPageSize_Note                                       72
#define QPageSize_Quarto                                     73
#define QPageSize_Statement                                  74
#define QPageSize_SuperA                                     75
#define QPageSize_SuperB                                     76
#define QPageSize_Postcard                                   77
#define QPageSize_DoublePostcard                             78
#define QPageSize_Prc16K                                     79
#define QPageSize_Prc32K                                     80
#define QPageSize_Prc32KBig                                  81
#define QPageSize_FanFoldUS                                  82
#define QPageSize_FanFoldGerman                              83
#define QPageSize_FanFoldGermanLegal                         84
#define QPageSize_EnvelopeB4                                 85
#define QPageSize_EnvelopeB5                                 86
#define QPageSize_EnvelopeB6                                 87
#define QPageSize_EnvelopeC0                                 88
#define QPageSize_EnvelopeC1                                 89
#define QPageSize_EnvelopeC2                                 90
#define QPageSize_EnvelopeC3                                 91
#define QPageSize_EnvelopeC4                                 92
#define QPageSize_EnvelopeC5                                 QPageSize_C5E
#define QPageSize_EnvelopeC6                                 93
#define QPageSize_EnvelopeC65                                94
#define QPageSize_EnvelopeC7                                 95
#define QPageSize_EnvelopeDL                                 QPageSize_DLE
#define QPageSize_Envelope9                                  96
#define QPageSize_Envelope10                                 QPageSize_Comm10E
#define QPageSize_Envelope11                                 97
#define QPageSize_Envelope12                                 98
#define QPageSize_Envelope14                                 99
#define QPageSize_EnvelopeMonarch                            100
#define QPageSize_EnvelopePersonal                           101
#define QPageSize_EnvelopeChou3                              102
#define QPageSize_EnvelopeChou4                              103
#define QPageSize_EnvelopeInvite                             104
#define QPageSize_EnvelopeItalian                            105
#define QPageSize_EnvelopeKaku2                              106
#define QPageSize_EnvelopeKaku3                              107
#define QPageSize_EnvelopePrc1                               108
#define QPageSize_EnvelopePrc2                               109
#define QPageSize_EnvelopePrc3                               110
#define QPageSize_EnvelopePrc4                               111
#define QPageSize_EnvelopePrc5                               112
#define QPageSize_EnvelopePrc6                               113
#define QPageSize_EnvelopePrc7                               114
#define QPageSize_EnvelopePrc8                               115
#define QPageSize_EnvelopePrc9                               116
#define QPageSize_EnvelopePrc10                              117
#define QPageSize_EnvelopeYou4                               118
#define QPageSize_LastPageSize                               QPageSize_EnvelopeYou4

//enum QPageSize_SizeMatchPolicy
#define QPageSize_FuzzyMatch                                 0   // Match to a standard page size if within the margin of tolerance.
#define QPageSize_FuzzyOrientationMatch                      1   // Match to a standard page size if within the margin of tolerance regardless of orientation.
#define QPageSize_ExactMatch                                 2   // Only match to a standard page size if the sizes match exactly.

//enum QPageSize_Unit
//This enum type is used to specify the measurement unit for page sizes.
#define QPageSize_Millimeter                                 0
#define QPageSize_Point                                      1   // 1/72th of an inch
#define QPageSize_Inch                                       2   //
#define QPageSize_Pica                                       3   // 1/72th of a foot, 1/6th of an inch, 12 Points
#define QPageSize_Didot                                      4   // 1/72th of a French inch, 0.375 mm
#define QPageSize_Cicero                                     5   // 1/6th of a French inch, 12 Didot, 4.5mm

//enum #define QPageLayout_Mode
//Defines the page layout mode
#define QPageLayout_StandardMode                             0   // Paint Rect includes margins, margins must fall between the minimum and maximum.
#define QPageLayout_FullPageMode                             1   // Paint Rect excludes margins, margins can be any value and must be managed manually.

//enum #define QPageLayout_Orientation
//This enum type defines the page orientation
#define QPageLayout_Portrait                                 0   // The page size is used in its default orientation
#define QPageLayout_Landscape                                1   // The page size is rotated through 90 degrees

//enum #define QPageLayout_Unit
//This enum type is used to specify the measurement unit for page layout and margins.
#define QPageLayout_Millimeter                               0   //
#define QPageLayout_Point                                    1   // 1/72th of an inch
#define QPageLayout_Inch                                     2   //
#define QPageLayout_Pica                                     3   // 1/72th of a foot, 1/6th of an inch, 12 Points
#define QPageLayout_Didot                                    4   // 1/72th of a French inch, 0.375 mm
#define QPageLayout_Cicero                                   5   // 1/6th of a French inch, 12 Didot, 4.5mm


//enum #define QCamera_CaptureMode
#define QCamera_CaptureViewfinder                            0      // Camera is only configured to display viewfinder.
#define QCamera_CaptureStillImage                            0x01   // Camera is configured for still frames capture.
#define QCamera_CaptureVideo                                 0x02   // Camera is configured for video capture.

//enum #define QCamera_Error
#define QCamera_NoError                                      0      // No errors have occurred.
#define QCamera_CameraError                                  1      // An error has occurred.
#define QCamera_InvalidRequestError                          2      // System resource doesn't support requested functionality.
#define QCamera_ServiceMissingError                          3      // No camera service available.
#define QCamera_NotSupportedFeatureError                     4      // The feature is not supported.
                                                                    //
//enum #define QCamera_LockChangeReason                             //
#define QCamera_UserRequest                                  0      // The lock status changed in result of user request, usually to unlock camera settings.
#define QCamera_LockAcquired                                 1      // The lock status successfuly changed to #define QCamera_Locked.
#define QCamera_LockFailed                                   2      // The camera failed to acquire the requested lock in result of autofocus failure, exposure out of supported range, etc.
#define QCamera_LockLost                                     3      // The camera is not able to maintain the requested lock any more. Lock status is changed to #define QCamera_Unlocked.
#define QCamera_LockTemporaryLost                            4      // The lock is lost, but the camera is working hard to reacquire it. This value may be used in continuous focusing mode, when the camera loses the focus, the focus lock state is changed to #define QCamera_Searching with LockTemporaryLost reason.
                                                                    //
//enum #define QCamera_LockStatus                                   //
#define QCamera_Unlocked                                     0      // The application is not interested in camera settings value. The camera may keep this parameter without changes, this is common with camera focus, or adjust exposure and white balance constantly to keep the viewfinder image nice.
#define QCamera_Searching                                    1      // The application has requested the camera focus, exposure or white balance lock with #define QCamera_searchAndLock(). This state indicates the camera is focusing or calculating exposure and white balance.
#define QCamera_Locked                                       2      // The camera focus, exposure or white balance is locked. The camera is ready to capture, application may check the exposure parameters.

//enum #define QCamera_LockType
#define QCamera_NoLock                                       0      //
#define QCamera_LockExposure                                 0x01   // Lock camera exposure.
#define QCamera_LockWhiteBalance                             0x02   // Lock the white balance.
#define QCamera_LockFocus                                    0x04   // Lock camera focus.

//enum #define QCamera_Position
#define QCamera_UnspecifiedPosition                          0      // The camera position is unspecified or unknown.
#define QCamera_BackFace                                     1      // The camera is on the back face of the system hardware. For example on a mobile device, it means it is on the opposite side to that of the screen.
#define QCamera_FrontFace                                    2      // The camera is on the front face of the system hardware. For example on a mobile device, it means it is on the same side as that of the screen. Viewfinder frames of front-facing cameras are mirrored horizontally, so the users can see themselves as looking into a mirror. Captured images or videos are not mirrored.

//enum #define QCamera_State
#define QCamera_UnloadedState                                0      // The initial camera state, with camera not loaded, the camera capabilities except of supported capture modes are unknown.
#define QCamera_LoadedState                                  1      // The camera is loaded and ready to be configured.
#define QCamera_ActiveState                                  2      // In the active state as soon as camera is started the viewfinder displays video frames and the camera is ready for capture.
                                                                    //
//enum #define QCamera_Status                                       //
#define QCamera_ActiveStatus                                 8      // The camera has been started and can produce data. The viewfinder displays video frames in active state.
#define QCamera_StartingStatus                               6      // The camera is starting in result of state transition to #define QCamera_ActiveState. The camera service is not ready to capture yet.
#define QCamera_StoppingStatus                               7      // The camera is stopping in result of state transition from #define QCamera_ActiveState to #define QCamera_LoadedState or #define QCamera_UnloadedState.
#define QCamera_StandbyStatus                                5      // The camera is in the power saving standby mode. The camera may come to the standby mode after some time of inactivity in the #define QCamera_LoadedState state.
#define QCamera_LoadedStatus                                 4      // The camera is loaded and ready to be configured. This status indicates the camera device is opened and it's possible to query for supported image and video capture settings, like resolution, framerate and codecs.
#define QCamera_LoadingStatus                                2      // The camera device loading in result of state transition from #define QCamera_UnloadedState to #define QCamera_LoadedState or #define QCamera_ActiveState.
#define QCamera_UnloadingStatus                              3      // The camera device is unloading in result of state transition from #define QCamera_LoadedState or #define QCamera_ActiveState to #define QCamera_UnloadedState.
#define QCamera_UnloadedStatus                               1      // The initial camera status, with camera not loaded. The camera capabilities including supported capture settings may be unknown.
#define QCamera_UnavailableStatus                            0      // The camera or camera backend is not available.

//enum #define QCameraControl_PropertyChangeType
#define QCameraControl_CaptureMode                           1      // Indicates the capture mode is changed.
#define QCameraControl_ImageEncodingSettings                 2      // Image encoder settings are changed, including resolution.
#define QCameraControl_VideoEncodingSettings                 3      // Video encoder settings are changed, including audio, video and container settings.
#define QCameraControl_Viewfinder                            4      // Viewfinder is changed.


//enum #define QCameraExposure_ExposureMode
#define QCameraExposure_ExposureAuto                         0      // Automatic mode.
#define QCameraExposure_ExposureManual                       1      // Manual mode.
#define QCameraExposure_ExposurePortrait                     2      // Portrait exposure mode.
#define QCameraExposure_ExposureNight                        3      // Night mode.
#define QCameraExposure_ExposureBacklight                    4      // Backlight exposure mode.
#define QCameraExposure_ExposureSpotlight                    5      // Spotlight exposure mode.
#define QCameraExposure_ExposureSports                       6      // Spots exposure mode.
#define QCameraExposure_ExposureSnow                         7      // Snow exposure mode.
#define QCameraExposure_ExposureBeach                        8      // Beach exposure mode.
#define QCameraExposure_ExposureLargeAperture                9      // Use larger aperture with small depth of field.
#define QCameraExposure_ExposureSmallAperture                10     // Use smaller aperture.
#define QCameraExposure_ExposureModeVendor                   1000   //  The base value for device specific exposure modes.

//enum #define QCameraExposure_FlashMode
#define QCameraExposure_FlashAuto                            0x1    // Automatic flash.
#define QCameraExposure_FlashOff                             0x2    // Flash is Off.
#define QCameraExposure_FlashOn                              0x4    // Flash is On.
#define QCameraExposure_FlashRedEyeReduction                 0x8    // Red eye reduction flash.
#define QCameraExposure_FlashFill                            0x10   // Use flash to fillin shadows.
#define QCameraExposure_FlashTorch                           0x20   // Constant light source. If supported, torch can be enabled without loading the camera.
#define QCameraExposure_FlashVideoLight                      0x40   // Constant light source, useful for video capture. The light is turned on only while camera is active.
#define QCameraExposure_FlashSlowSyncFrontCurtain            0x80   // Use the flash in conjunction with a slow shutter speed. This mode allows better exposure of distant objects and/or motion blur effect.
#define QCameraExposure_FlashSlowSyncRearCurtain             0x100  // The similar mode to FlashSlowSyncFrontCurtain but flash is fired at the end of exposure.
#define QCameraExposure_FlashManual                          0x200  // Flash power is manualy set.

//enum  QCameraExposure_MeteringMode
#define QCameraExposure_MeteringMatrix                       1      // Matrix metering mode.
#define QCameraExposure_MeteringAverage                      2      // Center weighted average metering mode.
#define QCameraExposure_MeteringSpot                         3      // Spot metering mode.

//enum QCameraExposureControl_ExposureParameter
#define QCameraExposureControl_ISO                           0      // Camera ISO sensitivity, specified as integer value.
#define QCameraExposureControl_Aperture                      1      // Lens aperture is specified as an qreal F number. The supported apertures list can change depending on the focal length, in such a case the exposureParameterRangeChanged() signal is emitted.
#define QCameraExposureControl_ShutterSpeed                  2      // Shutter speed in seconds, specified as qreal.
#define QCameraExposureControl_ExposureCompensation          3      // Exposure compensation, specified as qreal EV value.
#define QCameraExposureControl_FlashPower                    4      // Manual flash power, specified as qreal value. Accepted power range is [0..1.0], with 0 value means no flash and 1.0 corresponds to full flash power.
#define QCameraExposureControl_TorchPower                    6      // Manual torch power, specified as qreal value. Accepted power range is [0..1.0], with 0 value means no light and 1.0 corresponds to full torch power.
#define QCameraExposureControl_FlashCompensation             5      // Flash compensation, specified as qreal EV value.
#define QCameraExposureControl_SpotMeteringPoint             7      // The relative frame coordinate of the point to use for exposure metering in spot metering mode, specified as a QPointF.
#define QCameraExposureControl_ExposureMode                  8      // Camera exposure mode.
#define QCameraExposureControl_MeteringMode                  9      // Camera metering mode.
#define QCameraExposureControl_ExtendedExposureParameter     1000   // The base value for platform specific extended parameters. For such parameters the sequential values starting from ExtendedExposureParameter shuld be used.

//enum QCameraFeedbackControl_EventType
#define QCameraFeedbackControl_ViewfinderStarted             1      // The viewfinder stream was started (even if not visible)
#define QCameraFeedbackControl_ViewfinderStopped             2      // The viewfinder stream was stopped
#define QCameraFeedbackControl_ImageCaptured                 3      // An image was captured but not yet fully processed
#define QCameraFeedbackControl_ImageSaved                    4      // An image is fully available and saved somewhere.
#define QCameraFeedbackControl_ImageError                    5      // An error occurred while capturing an image
#define QCameraFeedbackControl_RecordingStarted              6      // Video recording has started
#define QCameraFeedbackControl_RecordingInProgress           7      // Video recording is in progress
#define QCameraFeedbackControl_RecordingStopped              8      // Video recording has stopped
#define QCameraFeedbackControl_AutoFocusInProgress           9      // The camera is trying to automatically focus
#define QCameraFeedbackControl_AutoFocusLocked               10     // The camera has automatically focused successfully
#define QCameraFeedbackControl_AutoFocusFailed               11     // The camera was unable to focus automatically

//enum QCameraFocus::FocusMode
#define QCameraFocus_ManualFocus                             0x1    // Manual or fixed focus mode.
#define QCameraFocus_HyperfocalFocus                         0x02   // Focus to hyperfocal distance, with the maximum depth of field achieved. All objects at distances from half of this distance out to infinity will be acceptably sharp.
#define QCameraFocus_InfinityFocus                           0x04   // Focus strictly to infinity.
#define QCameraFocus_AutoFocus                               0x8    // One-shot auto focus mode.
#define QCameraFocus_ContinuousFocus                         0x10   // Continuous auto focus mode.
#define QCameraFocus_MacroFocus                              0x20   // One shot auto focus to objects close to camera.

//enum QCameraFocus::FocusPointMode
#define QCameraFocus_FocusPointAuto                          0      // Automatically select one or multiple focus points.
#define QCameraFocus_FocusPointCenter                        1      // Focus to the frame center.
#define QCameraFocus_FocusPointFaceDetection                 2      // Focus on faces in the frame.
#define QCameraFocus_FocusPointCustom                        3      // Focus to the custom point, defined by QCameraFocus::customFocusPoint property.

//enum QCameraFocusZone::FocusZoneStatus
#define QCameraFocusZone_Invalid                             0      // This zone is not valid
#define QCameraFocusZone_Unused                              1      // This zone may be used for autofocusing, but is not currently.
#define QCameraFocusZone_Selected                            2      // This zone is currently being used for autofocusing, but is not in focus.
#define QCameraFocusZone_Focused                             3      // This zone is being used for autofocusing and is currently in focus.

//enum QCameraImageProcessing::WhiteBalanceMode
#define QCameraImageProcessing_WhiteBalanceAuto              0      // Auto white balance mode.
#define QCameraImageProcessing_WhiteBalanceManual            1      // Manual white balance. In this mode the white balance should be set with setManualWhiteBalance()
#define QCameraImageProcessing_WhiteBalanceSunlight          2      // Sunlight white balance mode.
#define QCameraImageProcessing_WhiteBalanceCloudy            3      // Cloudy white balance mode.
#define QCameraImageProcessing_WhiteBalanceShade             4      // Shade white balance mode.
#define QCameraImageProcessing_WhiteBalanceTungsten          5      // Tungsten (incandescent) white balance mode.
#define QCameraImageProcessing_WhiteBalanceFluorescent       6      // Fluorescent white balance mode.
#define QCameraImageProcessing_WhiteBalanceFlash             7      // Flash white balance mode.
#define QCameraImageProcessing_WhiteBalanceSunset            8      // Sunset white balance mode.
#define QCameraImageProcessing_WhiteBalanceVendor            1000   // Base value for vendor defined white balance modes.

//enum QCameraImageProcessingControl::ProcessingParameter
#define QCameraImageProcessingControl_WhiteBalancePreset     0      // The white balance preset.
#define QCameraImageProcessingControl_ColorTemperature       1      // Color temperature in K. This value is used when the manual white balance mode is selected.
#define QCameraImageProcessingControl_Contrast               2      // Image contrast.
#define QCameraImageProcessingControl_Saturation             3      // Image saturation.
#define QCameraImageProcessingControl_Brightness             4      // Image brightness.
#define QCameraImageProcessingControl_Sharpening             5      // Amount of sharpening applied.
#define QCameraImageProcessingControl_Denoising              6      // Amount of denoising applied.
#define QCameraImageProcessingControl_ContrastAdjustment     7      // Image contrast adjustment.
#define QCameraImageProcessingControl_SaturationAdjustment   8      // Image saturation adjustment.
#define QCameraImageProcessingControl_BrightnessAdjustment   9      // Image brightness adjustment.
#define QCameraImageProcessingControl_SharpeningAdjustment   10     // Adjustment of sharpening applied.
#define QCameraImageProcessingControl_DenoisingAdjustment    11     // Adjustment of denoising applied.
#define QCameraImageProcessingControl_ExtendedParameter      1000   // The base value for platform specific extended parameters.

//enum QCameraViewfinderSettingsControl::ViewfinderParameter
#define QCameraViewfinderSettingsControl_Resolution          0      // Viewfinder resolution, QSize.
#define QCameraViewfinderSettingsControl_PixelAspectRatio    1      // Pixel aspect ratio, QSize as in QVideoSurfaceFormat::pixelAspectRatio
#define QCameraViewfinderSettingsControl_MinimumFrameRate    2      // Minimum viewfinder frame rate, qreal
#define QCameraViewfinderSettingsControl_MaximumFrameRate    3      // Maximum viewfinder frame rate, qreal
#define QCameraViewfinderSettingsControl_PixelFormat         4      // Viewfinder pixel format, QVideoFrame::PixelFormat
#define QCameraViewfinderSettingsControl_UserParameter       1000   // The base value for platform specific extended parameters. For such parameters the sequential values starting from UserParameter shuld be used.

//enum QMediaPlaylist::Error
#define QMediaPlaylist_NoError                               0      // No errors.
#define QMediaPlaylist_FormatError                           1      // Format error.
#define QMediaPlaylist_FormatNotSupportedError               2      // Format not supported.
#define QMediaPlaylist_NetworkError                          3      // Network error.
#define QMediaPlaylist_AccessDeniedError                     4      // Access denied error.

//enum #defineQMediaPlaylist_PlaybackMode
#define QMediaPlaylist_CurrentItemOnce                       0      // The current item is played only once.
#define QMediaPlaylist_CurrentItemInLoop                     1      // The current item is played repeatedly in a loop.
#define QMediaPlaylist_Sequential                            2      // Playback starts from the current and moves through each successive item until the last is reached and then stops. The next item is a null item when the last one is currently playing.
#define QMediaPlaylist_Loop                                  3      // Playback restarts at the first item after the last has finished playing.
#define QMediaPlaylist_Random                                4      // Play items in random order.

//enum QMediaRecorder::Error
#define QMediaRecorder_NoError                               0      // No Errors.
#define QMediaRecorder_ResourceError                         1      // Device is not ready or not available.
#define QMediaRecorder_FormatError                           2      // Current format is not supported.
#define QMediaRecorder_OutOfSpaceError                       3      // No space left on device.
                                                                    //
//enum #define QMediaRecorder_State                                 //
#define QMediaRecorder_StoppedState                          0      // The recorder is not active.
#define QMediaRecorder_RecordingState                        1      // The recording is requested.
#define QMediaRecorder_PausedState                           2      // The recorder is paused.
                                                                    //
//enum #define QMediaRecorder_Status                                //
#define QMediaRecorder_UnavailableStatus                     0      // The recorder is not available or not supported by connected media object.
#define QMediaRecorder_UnloadedStatus                        1      // The recorder is avilable but not loaded.
#define QMediaRecorder_LoadingStatus                         2      // The recorder is initializing.
#define QMediaRecorder_LoadedStatus                          3      // The recorder is initialized and ready to record media.
#define QMediaRecorder_StartingStatus                        4      // Recording is requested but not active yet.
#define QMediaRecorder_RecordingStatus                       5      // Recording is active.
#define QMediaRecorder_PausedStatus                          6      // Recording is paused.
#define QMediaRecorder_FinalizingStatus                      7      // Recording is stopped with media being finalized.
                                                                    //
//enum QMediaStreamsControl::StreamType                             //
#define QMediaStreamsControl_AudioStream                     2      // Audio stream.
#define QMediaStreamsControl_VideoStream                     1      // Video stream.
#define QMediaStreamsControl_SubPictureStream                3      // Subpicture or teletext stream.
#define QMediaStreamsControl_UnknownStream                   0      // The stream type is unknown.
#define QMediaStreamsControl_DataStream                      4      //

//enum QRadioTuner::Band
#define QRadioTuner_AM                                       0      // 520 to 1610 kHz, 9 or 10kHz channel spacing, extended 1610 to 1710 kHz
#define QRadioTuner_FM                                       1      // 87.5 to 108.0 MHz, except Japan 76-90 MHz
#define QRadioTuner_SW                                       2      // 1.711 to 30.0 MHz, divided into 15 bands. 5kHz channel spacing
#define QRadioTuner_LW                                       3      // 148.5 to 283.5 kHz, 9kHz channel spacing (Europe, Africa, Asia)
#define QRadioTuner_FM2                                      4      // range not defined, used when area supports more than one FM range.
                                                                    //
//enum #define QRadioTuner_Error                                    //
#define QRadioTuner_NoError                                  0      // No errors have occurred.
#define QRadioTuner_ResourceError                            1      // There is no radio service available.
#define QRadioTuner_OpenError                                2      // Unable to open radio device.
#define QRadioTuner_OutOfRangeError                          3      // An attempt to set a frequency or band that is not supported by radio device.

//enum #define QRadioTuner_SearchMode
#define QRadioTuner_SearchFast                               0      // Use only signal strength when searching.
#define QRadioTuner_SearchGetStationId                       1      // After finding a strong signal, wait for the RDS station id (PI) before continuing.
                                                                    //
//enum #define QRadioTuner_State                                    //
#define QRadioTuner_ActiveState                              0      // The tuner is started and active.
#define QRadioTuner_StoppedState                             1      // The tuner device is stopped.

//enum #define QRadioTuner_StereoMode
#define QRadioTuner_ForceStereo                              0      // Provide stereo mode, converting if required.
#define QRadioTuner_ForceMono                                1      // Provide mono mode, converting if required.
#define QRadioTuner_Auto                                     2      // Uses the stereo mode matching the station.
                                                                    //
//enum QSoundEffect::Loop                                           //
#define QSoundEffect_Infinite                                -2     // Used as a parameter to setLoopCount() for infinite looping

//enum QSoundEffect::Status
#define QSoundEffect_Null                                    0      // No source has been set or the source is null.
#define QSoundEffect_Loading                                 1      // The SoundEffect is trying to load the source.
#define QSoundEffect_Ready                                   2      // The source is loaded and ready for play.
#define QSoundEffect_Error                                   3      // An error occurred during operation, such as failure of loading the source.
                                                                    //
//enum QVideoFrame::FieldType                                       //
#define QVideoFrame_ProgressiveFrame                         0      // The frame is not interlaced.
#define QVideoFrame_TopField                                 1      // The frame contains a top field.
#define QVideoFrame_BottomField                              2      // The frame contains a bottom field.
#define QVideoFrame_InterlacedFrame                          3      // The frame contains a merged top and bottom field.

//enum #define QVideoFrame_PixelFormat
#define QVideoFrame_Format_Invalid                           0      // The frame is invalid.
#define QVideoFrame_Format_ARGB32                            1      // The frame is stored using a 32-bit ARGB format (0xAARRGGBB). This is equivalent to QImage::Format_ARGB32.
#define QVideoFrame_Format_ARGB32_Premultiplied              2      // The frame stored using a premultiplied 32-bit ARGB format (0xAARRGGBB). This is equivalent to QImage::Format_ARGB32_Premultiplied.
#define QVideoFrame_Format_RGB32                             3      // The frame stored using a 32-bit RGB format (0xffRRGGBB). This is equivalent to QImage::Format_RGB32
#define QVideoFrame_Format_RGB24                             4      // The frame is stored using a 24-bit RGB format (8-8-8). This is equivalent to QImage::Format_RGB888
#define QVideoFrame_Format_RGB565                            5      // The frame is stored using a 16-bit RGB format (5-6-5). This is equivalent to QImage::Format_RGB16.
#define QVideoFrame_Format_RGB555                            6      // The frame is stored using a 16-bit RGB format (5-5-5). This is equivalent to QImage::Format_RGB555.
#define QVideoFrame_Format_ARGB8565_Premultiplied            7      // The frame is stored using a 24-bit premultiplied ARGB format (8-5-6-5).
#define QVideoFrame_Format_BGRA32                            8      // The frame is stored using a 32-bit BGRA format (0xBBGGRRAA).
#define QVideoFrame_Format_BGRA32_Premultiplied              9      // The frame is stored using a premultiplied 32bit BGRA format.
#define QVideoFrame_Format_BGR32                             10     // The frame is stored using a 32-bit BGR format (0xBBGGRRff).
#define QVideoFrame_Format_BGR24                             11     // The frame is stored using a 24-bit BGR format (0xBBGGRR).
#define QVideoFrame_Format_BGR565                            12     // The frame is stored using a 16-bit BGR format (5-6-5).
#define QVideoFrame_Format_BGR555                            13     // The frame is stored using a 16-bit BGR format (5-5-5).
#define QVideoFrame_Format_BGRA5658_Premultiplied            14     // The frame is stored using a 24-bit premultiplied BGRA format (5-6-5-8).
#define QVideoFrame_Format_AYUV444                           15     // The frame is stored using a packed 32-bit AYUV format (0xAAYYUUVV).
#define QVideoFrame_Format_AYUV444_Premultiplied             16     // The frame is stored using a packed premultiplied 32-bit AYUV format (0xAAYYUUVV).
#define QVideoFrame_Format_YUV444                            17     // The frame is stored using a 24-bit packed YUV format (8-8-8).
#define QVideoFrame_Format_YUV420P                           18     // The frame is stored using an 8-bit per component planar YUV format with the U and V planes horizontally and vertically sub-sampled, i.e. the height and width of the U and V planes are half that of the Y plane.
#define QVideoFrame_Format_YV12                              19     // The frame is stored using an 8-bit per component planar YVU format with the V and U planes horizontally and vertically sub-sampled, i.e. the height and width of the V and U planes are half that of the Y plane.
#define QVideoFrame_Format_UYVY                              20     // The frame is stored using an 8-bit per component packed YUV format with the U and V planes horizontally sub-sampled (U-Y-V-Y), i.e. two horizontally adjacent pixels are stored as a 32-bit macropixel which has a Y value for each pixel and common U and V values.
#define QVideoFrame_Format_YUYV                              21     // The frame is stored using an 8-bit per component packed YUV format with the U and V planes horizontally sub-sampled (Y-U-Y-V), i.e. two horizontally adjacent pixels are stored as a 32-bit macropixel which has a Y value for each pixel and common U and V values.
#define QVideoFrame_Format_NV12                              22     // The frame is stored using an 8-bit per component semi-planar YUV format with a Y plane (Y) followed by a horizontally and vertically sub-sampled, packed UV plane (U-V).
#define QVideoFrame_Format_NV21                              23     // The frame is stored using an 8-bit per component semi-planar YUV format with a Y plane (Y) followed by a horizontally and vertically sub-sampled, packed VU plane (V-U).
#define QVideoFrame_Format_IMC1                              24     // The frame is stored using an 8-bit per component planar YUV format with the U and V planes horizontally and vertically sub-sampled. This is similar to the Format_YUV420P type, except that the bytes per line of the U and V planes are padded out to the same stride as the Y plane.
#define QVideoFrame_Format_IMC2                              25     // The frame is stored using an 8-bit per component planar YUV format with the U and V planes horizontally and vertically sub-sampled. This is similar to the Format_YUV420P type, except that the lines of the U and V planes are interleaved, i.e. each line of U data is followed by a line of V data creating a single line of the same stride as the Y data.
#define QVideoFrame_Format_IMC3                              26     // The frame is stored using an 8-bit per component planar YVU format with the V and U planes horizontally and vertically sub-sampled. This is similar to the Format_YV12 type, except that the bytes per line of the V and U planes are padded out to the same stride as the Y plane.
#define QVideoFrame_Format_IMC4                              27     // The frame is stored using an 8-bit per component planar YVU format with the V and U planes horizontally and vertically sub-sampled. This is similar to the Format_YV12 type, except that the lines of the V and U planes are interleaved, i.e. each line of V data is followed by a line of U data creating a single line of the same stride as the Y data.
#define QVideoFrame_Format_Y8                                28     // The frame is stored using an 8-bit greyscale format.
#define QVideoFrame_Format_Y16                               29     // The frame is stored using a 16-bit linear greyscale format. Little endian.
#define QVideoFrame_Format_Jpeg                              30     // The frame is stored in compressed Jpeg format.
#define QVideoFrame_Format_CameraRaw                         31     // The frame is stored using a device specific camera raw format.
#define QVideoFrame_Format_AdobeDng                          32     // The frame is stored using raw Adobe Digital Negative (DNG) format.
#define QVideoFrame_Format_User                              1000   // Start value for user defined pixel formats.

//enum QAudioDecoder::Error
#define QAudioDecoder_NoError                                0      // No error has occurred.
#define QAudioDecoder_ResourceError                          1      // A media resource couldn't be resolved.
#define QAudioDecoder_FormatError                            2      // The format of a media resource isn't supported.
#define QAudioDecoder_AccessDeniedError                      3      // There are not the appropriate permissions to play a media resource.
#define QAudioDecoder_ServiceMissingError                    4      // A valid playback service was not found, playback cannot proceed.

//enum #define QAudioDecoder_State                                  //
#define QAudioDecoder_StoppedState                           0      // The decoder is not decoding. Decoding will start at the start of the media.
#define QAudioDecoder_DecodingState                          1      // The audio player is currently decoding media.

//enum QMultimedia::AvailabilityStatus
#define QMultimedia_Available                                0      // The service is operating correctly.
#define QMultimedia_ServiceMissing                           1      // There is no service available to provide the requested functionality.
#define QMultimedia_ResourceError                            3      // The service could not allocate resources required to function correctly.
#define QMultimedia_Busy                                     2      // The service must wait for access to necessary resources.

//enum #define QMultimedia_EncodingMode
#define QMultimedia_ConstantQualityEncoding                  0      // Encoding will aim to have a constant quality, adjusting bitrate to fit.
#define QMultimedia_ConstantBitRateEncoding                  1      // Encoding will use a constant bit rate, adjust quality to fit.
#define QMultimedia_AverageBitRateEncoding                   2      // Encoding will try to keep an average bitrate setting, but will use more or less as needed.
#define QMultimedia_TwoPassEncoding                          3      // The media will first be processed to determine the characteristics, and then processed a second time allocating more bits to the areas that need it.

//enum #define QMultimedia_EncodingQuality
#define QMultimedia_VeryLowQuality                           0
#define QMultimedia_LowQuality                               1
#define QMultimedia_NormalQuality                            2
#define QMultimedia_HighQuality                              3
#define QMultimedia_VeryHighQuality                          4

//enum #define QMultimedia_SupportEstimate
#define QMultimedia_NotSupported                             0      // The feature is not supported.
#define QMultimedia_MaybeSupported                           1      // The feature may be supported.
#define QMultimedia_ProbablySupported                        2      // The feature is probably supported.
#define QMultimedia_PreferredService                         3      // The service is the preferred provider of a service.

//enum QQuickItem_Flag
#define QQuickItem_ItemClipsChildrenToShape                  0x01   // Indicates this item should visually clip its children so that they are rendered only within the boundaries of this item.
#define QQuickItem_ItemAcceptsInputMethod                    0x02   // Indicates the item supports text input methods.
#define QQuickItem_ItemIsFocusScope                          0x04   // Indicates the item is a focus scope. See Keyboard Focus in Qt Quick for more information.
#define QQuickItem_ItemHasContents                           0x08   // Indicates the item has visual content and should be rendered by the scene graph.
#define QQuickItem_ItemAcceptsDrops                          0x10   // Indicates the item accepts drag and drop events.

//enum QQuickItem_ItemChange                                        //
#define QQuickItem_ItemChildAddedChange                      0      // A child was added. ItemChangeData::item contains the added child.
#define QQuickItem_ItemChildRemovedChange                    1      // A child was removed. ItemChangeData::item contains the removed child.
#define QQuickItem_ItemSceneChange                           2      // The item was added to or removed from a scene. The QQuickWindow rendering the scene is specified in using ItemChangeData::window. The window parameter is null when the item is removed from a scene.
#define QQuickItem_ItemVisibleHasChanged                     3      // The item's visibility has changed. ItemChangeData::boolValue contains the new visibility.
#define QQuickItem_ItemParentHasChanged                      4      // The item's parent has changed. ItemChangeData::item contains the new parent.
#define QQuickItem_ItemOpacityHasChanged                     5      // The item's opacity has changed. ItemChangeData::realValue contains the new opacity.
#define QQuickItem_ItemActiveFocusHasChanged                 6      // The item's focus has changed. ItemChangeData::boolValue contains whether the item has focus or not.
#define QQuickItem_ItemRotationHasChanged                    7      // The item's rotation has changed. ItemChangeData::realValue contains the new rotation.

//enum QQuickItem_TransformOrigin                                   //
#define QQuickItem_TopLeft                                   0      // The top-left corner of the item.
#define QQuickItem_Top                                       1      // The center point of the top of the item.
#define QQuickItem_TopRight                                  2      // The top-right corner of the item.
#define QQuickItem_Left                                      3      // The left most point of the vertical middle.
#define QQuickItem_Center                                    4      // The center of the item.
#define QQuickItem_Right                                     5      // The right most point of the vertical middle.
#define QQuickItem_BottomLeft                                6      // The bottom-left corner of the item.
#define QQuickItem_Bottom                                    7      // The center point of the bottom of the item.
#define QQuickItem_BottomRight                               8      // The bottom-right corner of the item.

//enum QQuickPaintedItem::PerformanceHint                           //
#define QQuickPaintedItem_FastFBOResizing                    0x1    // If your item gets resized often and you are using the #define QQuickPaintedItem_FramebufferObject render target, set this flag to true to reduce the item resizing time at the cost of using more graphics memory. Resizing a Framebuffer object is a costly operation, by enabling this property the Framebuffer Object will use a texture larger than the actual size of the item to avoid as much as possible resizing it.

//enum #define QQuickPaintedItem_RenderTarget                       //
#define QQuickPaintedItem_Image                              0      // The default; QPainter paints into a QImage using the raster paint engine. The image's content needs to be uploaded to graphics memory afterward, this operation can potentially be slow if the item is large. This render target allows high quality anti-aliasing and fast item resizing.
#define QQuickPaintedItem_FramebufferObject                  1      // QPainter paints into a QOpenGLFramebufferObject using the GL paint engine. Painting can be faster as no texture upload is required, but anti-aliasing quality is not as good as if using an image. This render target allows faster rendering in some cases, but you should avoid using it if the item is resized often.
#define QQuickPaintedItem_InvertedYFramebufferObject         2      // Exactly as for FramebufferObject above, except once the painting is done, prior to rendering the painted image is flipped about the x-axis so that the top-most pixels are now at the bottom. Since this is done with the OpenGL texture coordinates it is a much faster way to achieve this effect than using a painter transform.

//enum #define QQuickView_ResizeMode
#define QQuickView_SizeViewToRootObject                      0      // The view resizes with the root item in the QML.
#define QQuickView_SizeRootObjectToView                      1      // The view will automatically resize the root item to the size of the view.

//enum #define QQuickView_Status                                    //
#define QQuickView_Null                                      0      // This QQuickView has no source set.
#define QQuickView_Ready                                     1      // This QQuickView has loaded and created the QML component.
#define QQuickView_Loading                                   2      // This QQuickView is loading network data.
#define QQuickView_Error                                     3      // One or more errors has occurred. Call errors() to retrieve a list of errors.

//enum #define QQuickWindow_CreateTextureOption
#define QQuickWindow_TextureHasAlphaChannel                  0x0001 // The texture has an alpha channel and should be drawn using blending.
#define QQuickWindow_TextureHasMipmaps                       0x0002 // The texture has mipmaps and can be drawn with mipmapping enabled.
#define QQuickWindow_TextureOwnsGLTexture                    0x0004 // The texture object owns the texture id and will delete the GL texture when the texture object is deleted.
#define QQuickWindow_TextureCanUseAtlas                      0x0008 // The image can be uploaded into a texture atlas.

//enum #define QQuickWindow_SceneGraphError
#define QQuickWindow_ContextNotAvailable                     1      // OpenGL context creation failed. This typically means that no suitable OpenGL implementation was found, for example because no graphics drivers are installed and so no OpenGL 2 support is present. On mobile and embedded boards that use OpenGL ES such an error is likely to indicate issues in the windowing system integration and possibly an incorrect configuration of Qt.
                                                                    //
//enum #define QQuickWidget_ResizeMode                              //
#define QQuickWidget_SizeViewToRootObject                    0      // The view resizes with the root item in the QML.
#define QQuickWidget_SizeRootObjectToView                    1      // The view will automatically resize the root item to the size of the view.

//enum #define QQuickWidget_Status                                  //
#define QQuickWidget_Null                                    0      // This QQuickWidget has no source set.
#define QQuickWidget_Ready                                   1      // This QQuickWidget has loaded and created the QML component.
#define QQuickWidget_Loading                                 2      // This QQuickWidget is loading network data.
#define QQuickWidget_Error                                   3      // One or more errors occurred. Call errors() to retrieve a list of errors.

//enum #define QSGTexture_Filtering                                 //
#define QSGTexture_None                                      0      // No filtering should occur. This value is only used together with setMipmapFiltering().
#define QSGTexture_Nearest                                   1      // Sampling returns the nearest texel.
#define QSGTexture_Linear                                    2      // Sampling returns a linear interpolation of the neighboring texels.

//enum #define QSGTexture_WrapMode                                  //
#define QSGTexture_Repeat                                    0      // Only the factional part of the texture coordiante is used, causing values above 1 and below 0 to repeat.
#define QSGTexture_ClampToEdge                               1      // Values above 1 are clamped to 1 and values below 0 are clamped to 0.

//enum #define QSGNode_DirtyStateBit
#define QSGNode_DirtyMatrix                                  0x0100 // The matrix in a QSGTransformNode has changed.
#define QSGNode_DirtyNodeAdded                               0x0400 // A node was added.
#define QSGNode_DirtyNodeRemoved                             0x0800 // A node was removed.
#define QSGNode_DirtyGeometry                                0x1000 // The geometry of a QSGGeometryNode has changed.
#define QSGNode_DirtyMaterial                                0x2000 // The material of a QSGGeometryNode has changed.
#define QSGNode_DirtyOpacity                                 0x4000 // The opacity of a QSGOpacityNode has changed.

//enum #define QSGNode_Flag
#define QSGNode_OwnedByParent                                0x0001       // The node is owned by its parent and will be deleted when the parent is deleted.
#define QSGNode_UsePreprocess                                0x0002       // The node's virtual preprocess() function will be called before rendering starts.
#define QSGNode_OwnsGeometry                                 0x00010000   // Only valid for QSGGeometryNode and QSGClipNode. The node has ownership over the QSGGeometry instance and will delete it when the node is destroyed or a geometry is assigned.
#define QSGNode_OwnsMaterial                                 0x00020000   // Only valid for QSGGeometryNode. The node has ownership over the material and will delete it when the node is destroyed or a material is assigned.
#define QSGNode_OwnsOpaqueMaterial                           0x00040000   // Only valid for QSGGeometryNode. The node has ownership over the opaque material and will delete it when the node is destroyed or a material is assigned.

//enum #define QSGNode_NodeType
#define QSGNode_BasicNodeType                                0      // The type of QSGNode
#define QSGNode_GeometryNodeType                             1      // The type of QSGGeometryNode
#define QSGNode_TransformNodeType                            2      // The type of QSGTransformNode
#define QSGNode_ClipNodeType                                 3      // The type of QSGClipNode
#define QSGNode_OpacityNodeType                              4      // The type of QSGOpacityNode

//enum #define QSGGeometry_DataPattern                              //
#define QSGGeometry_AlwaysUploadPattern                      0      // The data is always uploaded. This means that the user does not need to explicitly mark index and vertex data as dirty after changing it. This is the default.
#define QSGGeometry_DynamicPattern                           2      // The data is modified repeatedly and drawn many times. This is a hint that may provide better performance. When set the user must make sure to mark the data as dirty after changing it.
#define QSGGeometry_StaticPattern                            3      // The data is modified once and drawn many times. This is a hint that may provide better performance. When set the user must make sure to mark the data as dirty after changing it.
#define QSGGeometry_StreamPattern                            1      // The data is modified for almost every time it is drawn. This is a hint that may provide better performance. When set, the user must make sure to mark the data as dirty after changing it.

//enum #define QSGMaterial_Flag
#define QSGMaterial_Blending                                 0x0001 // Set this flag to true if the material requires GL_BLEND to be enabled during rendering.
#define QSGMaterial_RequiresDeterminant                      0x0002 // Set this flag to true if the material relies on the determinant of the matrix of the geometry nodes for rendering.
#define QSGMaterial_RequiresFullMatrixExceptTranslate        hb_bitOr( 0x0004, QSGMaterial_RequiresDeterminant )                 // Set this flag to true if the material relies on the full matrix of the geometry nodes for rendering, except the translation part.
#define QSGMaterial_RequiresFullMatrix                       hb_bitOr( 0x0008, QSGMaterial_RequiresFullMatrixExceptTranslate )   // Set this flag to true if the material relies on the full matrix of the geometry nodes for rendering.
#define QSGMaterial_CustomCompileStep                        0x0010 // Starting with Qt 5.2, the scene graph will not always call

//enum #define QSGSimpleTextureNode_TextureCoordinatesTransfomFlag
#define QSGSimpleTextureNode_NoTransform                     0x00   // Texture coordinates are oriented with window coordinates i.e. with origin at top-left.
#define QSGSimpleTextureNode_MirrorHorizontally              0x01   // Texture coordinates are inverted in the horizontal axis with respect to window coordinates
#define QSGSimpleTextureNode_MirrorVertically                0x02   // Texture coordinates are inverted in the vertical axis with respect to window coordinates

//enum #define QQmlComponent_CompilationMode
#define QQmlComponent_PreferSynchronous                      0      // Prefer loading/compiling the component immediately, blocking the thread. This is not always possible; for example, remote URLs will always load asynchronously.
#define QQmlComponent_Asynchronous                           1      // Load/compile the component in a background thread.

//enum #define QQmlComponent_Status
#define QQmlComponent_Null                                   0      // This QQmlComponent has no data. Call loadUrl() or setData() to add QML content.
#define QQmlComponent_Ready                                  1      // This QQmlComponent is ready and create() may be called.
#define QQmlComponent_Loading                                2      // This QQmlComponent is loading network data.
#define QQmlComponent_Error                                  3      // An error has occurred. Call errors() to retrieve a list of {QQmlError}{errors}.

//enum #define QQmlEngine_ObjectOwnership
#define QQmlEngine_CppOwnership                              0      // The object is owned by C++ code, and will never be deleted by QML. The JavaScript destroy() method cannot be used on objects with CppOwnership. This option is similar to QScriptEngine::QtOwnership.
#define QQmlEngine_JavaScriptOwnership                       1      // The object is owned by JavaScript. When the object is returned to QML as the return value of a method call or property access, QML will track it, and delete the object if there are no remaining JavaScript references to it and it has no QObject::parent(). An object tracked by one QQmlEngine will be deleted during that QQmlEngine's destructor, and thus JavaScript references between objects with JavaScriptOwnership from two different engines will not be valid after the deletion of one of those engines. This option is similar to QScriptEngine::ScriptOwnership.

//enum #define QQmlImageProviderBase_Flag
#define QQmlImageProviderBase_ForceAsynchronousImageLoading  0x01   // Ensures that image requests to the provider are run in a separate thread, which allows the provider to spend as much time as needed on producing the image without blocking the main thread.

//enum #define QQmlImageProviderBase_ImageType
#define QQmlImageProviderBase_Image                          0      // The Image Provider provides QImage images. The QQuickImageProvider::requestImage() method will be called for all image requests.
#define QQmlImageProviderBase_Pixmap                         1      // The Image Provider provides QPixmap images. The QQuickImageProvider::requestPixmap() method will be called for all image requests.
#define QQmlImageProviderBase_Texture                        2      // The Image Provider provides QSGTextureProvider based images. The QQuickImageProvider::requestTexture() method will be called for all image requests.

//enum #define QQmlIncubator_IncubationMode
#define QQmlIncubator_Asynchronous                           0      // The object will be created asynchronously.
#define QQmlIncubator_AsynchronousIfNested                   1      // If the object is being created in a context that is already part of an asynchronous creation, this incubator will join that existing incubation and execute asynchronously. The existing incubation will not become Ready until both it and this incubation have completed. Otherwise, the incubation will execute synchronously.
#define QQmlIncubator_Synchronous                            2      // The object will be created synchronously.

//enum #define QQmlIncubator_Status
#define QQmlIncubator_Null                                   0      // Incubation is not in progress. Call #define QQmlComponent_create() to begin incubating.
#define QQmlIncubator_Ready                                  1      // The object is fully created and can be accessed by calling object().
#define QQmlIncubator_Loading                                2      // The object is in the process of being created.
#define QQmlIncubator_Error                                  3      // An error occurred. The errors can be access by calling errors().

//enum #define QQmlProperty_PropertyTypeCategory
#define QQmlProperty_InvalidCategory                         0      // The property is invalid, or is a signal property.
#define QQmlProperty_List                                    1      // The property is a QQmlListProperty list property
#define QQmlProperty_Object                                  2      // The property is a QObject derived type pointer
#define QQmlProperty_Normal                                  3      // The property is a normal value property.

//enum #define QQmlProperty_Type
#define QQmlProperty_Invalid                                 0      // The property is invalid.
#define QQmlProperty_Property                                1      // The property is a regular Qt property.
#define QQmlProperty_SignalProperty                          2      // The property is a signal property.


//enum QListView::Flow
#define QListView_LeftToRight                                0      // The items are laid out in the view from the left to the right.
#define QListView_TopToBottom                                1      // The items are laid out in the view from the top to the bottom.

//enum #define QListView_LayoutMode
#define QListView_SinglePass                                 0      // The items are laid out all at once.
#define QListView_Batched                                    1      // The items are laid out in batches of batchSize items.

//enum #define QListView_Movement
#define QListView_Static                                     0      // The items cannot be moved by the user.
#define QListView_Free                                       1      // The items can be moved freely by the user.
#define QListView_Snap                                       2      // The items snap to the specified grid when moved; see setGridSize().

//enum #define QListView_ResizeMode
#define QListView_Fixed                                      0      // The items will only be laid out the first time the view is shown.
#define QListView_Adjust                                     1      // The items will be laid out every time the view is resized.

//enum #define QListView_ViewMode
#define QListView_ListMode                                   0      // The items are laid out using TopToBottom flow, with Small size and Static movement
#define QListView_IconMode                                   1      // The items are laid out using LeftToRight flow, with Large size and Free movement

//enum QInputMethod::Action
#define QInputMethod_Click                                   0      // A normal click/tap
#define QInputMethod_ContextMenu                             1      // A context menu click/tap (e.g. right-button or tap-and-hold)

#define QSensor_FixedOrientation                             0      // No automatic rotation is applied to the reading values.
#define QSensor_AutomaticOrientation                         1      // The reading values are automatically rotated based on the screen orientation.
#define QSensor_UserOrientation                              2      // The reading values are rotated based on the angle of the userOrientation property.
#define QSensor_Buffering                                    0      // The backend supports buffering of readings, controlled by the #define QSensor_bufferSize property.
#define QSensor_AlwaysOn                                     1      // The backend supports changing the policy on whether to suspend when idle, controlled by the #define QSensor_alwaysOn property.
#define QSensor_SkipDuplicates                               5      // The backend supports skipping of same or very similar successive readings. This can be enabled by setting the #define QSensor_skipDuplicates property to true.
#define QSensor_GeoValues                                    2      // The backend supports returning geo values, which can be controlled with the QMagnetometer::returnGeoValues property.
#define QSensor_FieldOfView                                  3      // The backend specifies its field of view, which can be read from the QLightSensor::fieldOfView property.
#define QSensor_AccelerationMode                             4      // The backend supports switching the acceleration mode of the acceleromter with the #define QAccelerometer_accelerationMode property.
#define QSensor_PressureSensorTemperature                    7      // The backend provides the pressure sensor's die temperature
#define QSensor_AxesOrientation                              6      // The backend supports changing the axes orientation from the default of #define QSensor_FixedOrientation to something else.

#define QAmbientLightReading_Undefined                       0      // The light level is unknown.
#define QAmbientLightReading_Dark                            1      // It is dark.
#define QAmbientLightReading_Twilight                        2      // It is moderately dark.
#define QAmbientLightReading_Light                           3      // It is light (eg. internal lights).
#define QAmbientLightReading_Bright                          4      // It is bright (eg. shade).
#define QAmbientLightReading_Sunny                           5      // It is very bright (eg. direct sunlight).

#define QOrientationReading_Undefined                        0      // The orientation is unknown.
#define QOrientationReading_TopUp                            1      // The Top edge of the device is pointing up.
#define QOrientationReading_TopDown                          2      // The Top edge of the device is pointing down.
#define QOrientationReading_LeftUp                           3      // The Left edge of the device is pointing up.
#define QOrientationReading_RightUp                          4      // The Right edge of the device is pointing up.
#define QOrientationReading_FaceUp                           5      // The Face of the device is pointing up.
#define QOrientationReading_FaceDown                         6      // The Face of the device is pointing down.

#define QTapReading_Undefined                                0      // This value means that the direction is unknown.
#define QTapReading_X                                        0x0001 // This flag is set if the tap was along the X axis.
#define QTapReading_Y                                        0x0002 // This flag is set if the tap was along the Y axis.
#define QTapReading_Z                                        0x0004 // This flag is set if the tap was along the Z axis.
#define QTapReading_X_Pos                                    0x0011 // This flag is set if the tap was towards the positive X direction.
#define QTapReading_Y_Pos                                    0x0022 // This flag is set if the tap was towards the positive Y direction.
#define QTapReading_Z_Pos                                    0x0044 // This flag is set if the tap was towards the positive Z direction.
#define QTapReading_X_Neg                                    0x0101 // This flag is set if the tap was towards the negative X direction.
#define QTapReading_Y_Neg                                    0x0202 // This flag is set if the tap was towards the negative Y direction.
#define QTapReading_Z_Neg                                    0x0404 // This flag is set if the tap was towards the negative Z direction.
#define QTapReading_X_Both                                   0x0111 // Equivalent to X_Pos|X_Neg. Returned by devices that cannot detect the direction of a tap.
#define QTapReading_Y_Both                                   0x0222 // Equivalent to Y_Pos|Y_Neg. Returned by devices that cannot detect the direction of a tap.
#define QTapReading_Z_Both                                   0x0444 // Equivalent to Z_Pos|Z_Neg. Returned by devices that cannot detect the direction of a tap.

#define QAccelerometer_Combined                              0      // Both the acceleration caused by gravity and the acceleration caused by the user moving the device is reported combined.
#define QAccelerometer_Gravity                               1      // Only the acceleration caused by gravity is reported. Movements of the device caused by the user have no effect other than changing the direction when the device is rotated.
#define QAccelerometer_User                                  2      // Only the acceleration caused by the user moving the device is reported, the effect of gravity is canceled out. A device at rest therefore should report values of, or close to, zero. In other APIs, this mode might be known as linear acceleration.

#define Qt_TouchPointPressed                                 0x01   // The touch point is now pressed.
#define Qt_TouchPointMoved                                   0x02   // The touch point moved.
#define Qt_TouchPointStationary                              0x04   // The touch point did not move.
#define Qt_TouchPointReleased                                0x08   // The touch point was released.

//enum QRegularExpression::MatchOption
//flags QRegularExpression::MatchOptions
#define QRegularExpression_NoMatchOption                       0x0000   // No match options are set.
#define QRegularExpression_AnchoredMatchOption                 0x0001   // The match is constrained to start exactly at the offset passed to match() in order to be successful, even if the pattern string does not contain any metacharacter that anchors the match at that point.
#define QRegularExpression_DontCheckSubjectStringMatchOption   0x0002   // The subject string is not checked for UTF-16 validity before attempting a match. Use this option with extreme caution, as attempting to match an invalid string may crash the program and/or constitute a security issue. This enum value has been introduced in Qt 5.4.

//enum QRegularExpression::MatchType
//The MatchType enum defines the type of the match that should be attempted against the subject string.
#define QRegularExpression_NormalMatch                       0   // A normal match is done.
#define QRegularExpression_PartialPreferCompleteMatch        1   // The pattern string is matched partially against the subject string. If a partial match is found, then it is recorded, and other matching alternatives are tried as usual. If a complete match is then found, then it's preferred to the partial match; in this case only the complete match is reported. If instead no complete match is found (but only the partial one), then the partial one is reported.
#define QRegularExpression_PartialPreferFirstMatch           2   // The pattern string is matched partially against the subject string. If a partial match is found, then matching stops and the partial match is reported. In this case, other matching alternatives (potentially leading to a complete match) are not tried. Moreover, this match type assumes that the subject string only a substring of a larger text, and that (in this text) there are other characters beyond the end of the subject string. This can lead to surprising results; see the discussion in the partial matching section for more details.
#define QRegularExpression_NoMatch                           3   // No matching is done. This value is returned as the match type by a default constructed QRegularExpressionMatch or QRegularExpressionMatchIterator. Using this match type is not very useful for the user, as no matching ever happens. This enum value has been introduced in Qt 5.1.

//enum QRegularExpression::PatternOption
//flags QRegularExpression::PatternOptions
#define QRegularExpression_NoPatternOption                   0x0000   // No pattern options are set.
#define QRegularExpression_CaseInsensitiveOption             0x0001   // The pattern should match against the subject string in a case insensitive way. This option corresponds to the /i modifier in Perl regular expressions.
#define QRegularExpression_DotMatchesEverythingOption        0x0002   // The dot metacharacter (.) in the pattern string is allowed to match any character in the subject string, including newlines (normally, the dot does not match newlines). This option corresponds to the /s modifier in Perl regular expressions.
#define QRegularExpression_MultilineOption                   0x0004   // The caret (^) and the dollar ($) metacharacters in the pattern string are allowed to match, respectively, immediately after and immediately before any newline in the subject string, as well as at the very beginning and at the very end of the subject string. This option corresponds to the /m modifier in Perl regular expressions.
#define QRegularExpression_ExtendedPatternSyntaxOption       0x0008   // Any whitespace in the pattern string which is not escaped and outside a character class is ignored. Moreover, an unescaped sharp (#) outside a character class causes all the following characters, until the first newline (included), to be ignored. This can be used to increase the readability of a pattern string as well as put comments inside regular expressions; this is particulary useful if the pattern string is loaded from a file or written by the user, because in C++ code it is always possible to use the rules for string literals to put comments outside the pattern string. This option corresponds to the /x modifier in Perl regular expressions.
#define QRegularExpression_InvertedGreedinessOption          0x0010   // The greediness of the quantifiers is inverted: *, +, ?, {m,n}, etc. become lazy, while their lazy versions (*?, +?, ??, {m,n}?, etc.) become greedy. There is no equivalent for this option in Perl regular expressions.
#define QRegularExpression_DontCaptureOption                 0x0020   // The non-named capturing groups do not capture substrings; named capturing groups still work as intended, as well as the implicit capturing group number 0 corresponding to the entire match. There is no equivalent for this option in Perl regular expressions.
#define QRegularExpression_UseUnicodePropertiesOption        0x0040   // The meaning of the \w, \d, etc., character classes, as well as the meaning of their counterparts (\W, \D, etc.), is changed from matching ASCII characters only to matching any character with the corresponding Unicode property. For instance, \d is changed to match any character with the Unicode Nd (decimal digit) property; \w to match any character with either the Unicode L (letter) or N (digit) property, plus underscore, and so on. This option corresponds to the /u modifier in Perl regular expressions.
#define QRegularExpression_OptimizeOnFirstUsageOption        0x0080   // The regular expression will be optimized (and possibly JIT-compiled) on its first usage, instead of after a certain (undefined) number of usages. See also optimize(). This enum value has been introduced in Qt 5.4.
#define QRegularExpression_DontAutomaticallyOptimizeOption   0x0100   // Regular expressions are automatically optimized after a certain number of usages; setting this option prevents such optimizations, therefore avoiding possible unpredictable spikes in CPU and memory usage. If both this option and the OptimizeOnFirstUsageOption option are set, then this option takes precedence. Note: this option will still let the regular expression to be optimized by manually calling optimize(). This enum value has been introduced in Qt 5.4.

#define Qt_PrimaryOrientation                                0x00000000   // The display's primary orientation.
#define Qt_LandscapeOrientation                              0x00000002   // Landscape orientation, display width is greater than display height.
#define Qt_PortraitOrientation                               0x00000001   // Portrait orientation, display height is greater than display width, rotated 90 degree clockwise relative to landscape.
#define Qt_InvertedLandscapeOrientation                      0x00000008   // Inverted landscape orientation, rotated 180 degrees relative to landscape.
#define Qt_InvertedPortraitOrientation                       0x00000004   // Inverted portrait orientation, rotated 180 degrees relative to portrait.

#define QOpenGLBuffer_ReadOnly                               0x88B8   // The buffer will be mapped for reading only.
#define QOpenGLBuffer_WriteOnly                              0x88B9   // The buffer will be mapped for writing only.
#define QOpenGLBuffer_ReadWrite                              0x88BA   // The buffer will be mapped for reading and writing.
                                                                      //
#define QOpenGLBuffer_RangeRead                              0x0001   // The buffer will be mapped for reading.
#define QOpenGLBuffer_RangeWrite                             0x0002   // The buffer will be mapped for writing.
#define QOpenGLBuffer_RangeInvalidate                        0x0004   // Discard the previous contents of the specified range.
#define QOpenGLBuffer_RangeInvalidateBuffer                  0x0008   // Discard the previous contents of the entire buffer.
#define QOpenGLBuffer_RangeFlushExplicit                     0x0010   // Indicates that modifications are to be flushed explicitly via glFlushMappedBufferRange.
#define QOpenGLBuffer_RangeUnsynchronized                    0x0020   // Indicates that pending operations should not be synchronized before returning from mapRange().
                                                                      //
#define QOpenGLBuffer_VertexBuffer                           0x8892   // Vertex buffer object for use when specifying vertex arrays.
#define QOpenGLBuffer_IndexBuffer                            0x8893   // Index buffer object for use with glDrawElements().
#define QOpenGLBuffer_PixelPackBuffer                        0x88EB   // Pixel pack buffer object for reading pixel data from the OpenGL server (for example, with glReadPixels()). Not supported under OpenGL/ES.
#define QOpenGLBuffer_PixelUnpackBuffer                      0x88EC   // Pixel unpack buffer object for writing pixel data to the OpenGL server (for example, with glTexImage2D()). Not supported under OpenGL/ES.
                                                                      //
#define QOpenGLBuffer_StreamDraw                             0x88E0   // The data will be set once and used a few times for drawing operations. Under OpenGL/ES 1.1 this is identical to StaticDraw.
#define QOpenGLBuffer_StreamRead                             0x88E1   // The data will be set once and used a few times for reading data back from the OpenGL server. Not supported under OpenGL/ES.
#define QOpenGLBuffer_StreamCopy                             0x88E2   // The data will be set once and used a few times for reading data back from the OpenGL server for use in further drawing operations. Not supported under OpenGL/ES.
#define QOpenGLBuffer_StaticDraw                             0x88E4   // The data will be set once and used many times for drawing operations.
#define QOpenGLBuffer_StaticRead                             0x88E5   // The data will be set once and used many times for reading data back from the OpenGL server. Not supported under OpenGL/ES.
#define QOpenGLBuffer_StaticCopy                             0x88E6   // The data will be set once and used many times for reading data back from the OpenGL server for use in further drawing operations. Not supported under OpenGL/ES.
#define QOpenGLBuffer_DynamicDraw                            0x88E8   // The data will be modified repeatedly and used many times for drawing operations.
#define QOpenGLBuffer_DynamicRead                            0x88E9   // The data will be modified repeatedly and used many times for reading data back from the OpenGL server. Not supported under OpenGL/ES.
#define QOpenGLBuffer_DynamicCopy                            0x88EA   // The data will be modified repeatedly and used many times for reading data back from the OpenGL server for use in further drawing operations. Not supported under OpenGL/ES.

#define QScrollEvent_ScrollStarted                           0        // Set for the first scroll event of a scroll activity.
#define QScrollEvent_ScrollUpdated                           1        // Set for all but the first and the last scroll event of a scroll activity.
#define QScrollEvent_ScrollFinished                          2        // Set for the last scroll event of a scroll activity.

#define Qt_ApplicationSuspended                              0x00000000  // The application is about to suspend. When entering this state, the application should save its state, cease all activities, and be prepared for code execution to stop. While suspended, the application can be killed at any time without further warnings (e.g. when low memory forces the OS to purge suspended applications).
#define Qt_ApplicationHidden                                 0x00000001  // The application is hidden and runs in the background. This is the normal state for applications that need to do background processing, like playing music, while the user interacts with other applications. The application should free up all graphical resources when entering this state.
#define Qt_ApplicationInactive                               0x00000002  // The application is visible, but not selected to be in front. On desktop platforms, this typically means that the user activated another application. On mobile platforms, it is more common to enter this state when the OS is interrupting the user with e.g. incoming calls or SMS-messages. While in this state, consider reducing CPU-intensive tasks.
#define Qt_ApplicationActive                                 0x00000004  // The application is visible and selected to be in front.

#define QLocation_UnspecifiedVisibility                      0x00   // No explicit visibility has been defined.
#define QLocation_DeviceVisibility                           0x01   // Places and categories with DeviceVisibility are only stored on the local device.
#define QLocation_PrivateVisibility                          0x02   // Places and categories with PrivateVisibility are only visible to the current user. The data may be stored either locally or on a remote service or both.
#define QLocation_PublicVisibility                           0x04   // Places and categories with PublicVisibility are visible to everyone.

//enum QGeoCodeReply::Error
//Describes an error which prevented the completion of the operation.
#define QGeoCodeReply_NoError                                0   // No error has occurred.
#define QGeoCodeReply_EngineNotSetError                      1   // The geocoding manager that was used did not have a QGeoCodingManagerEngine instance associated with it.
#define QGeoCodeReply_CommunicationError                     2   // An error occurred while communicating with the service provider.
#define QGeoCodeReply_ParseError                             3   // The response from the service provider was in an unrecognizable format.
#define QGeoCodeReply_UnsupportedOptionError                 4   // The requested operation or one of the options for the operation are not supported by the service provider.
#define QGeoCodeReply_CombinationError                       5   // An error occurred while results where being combined from multiple sources.
#define QGeoCodeReply_UnknownError                           6   // An error occurred which does not fit into any of the other categories.


//enum QGeoManeuver::InstructionDirection
//Describes the change in direction associated with the instruction text that is associated with a QGeoManaeuver.
#define QGeoManeuver_NoDirection                             0   // There is no direction associated with the instruction text.
#define QGeoManeuver_DirectionForward                        1   // The instruction indicates that the direction of travel does not need to change.
#define QGeoManeuver_DirectionBearRight                      2   // The instruction indicates that the direction of travel should bear to the right.
#define QGeoManeuver_DirectionLightRight                     3   // The instruction indicates that a light turn to the right is required.
#define QGeoManeuver_DirectionRight                          4   // The instruction indicates that a turn to the right is required.
#define QGeoManeuver_DirectionHardRight                      5   // The instruction indicates that a hard turn to the right is required.
#define QGeoManeuver_DirectionUTurnRight                     6   // The instruction indicates that a u-turn to the right is required.
#define QGeoManeuver_DirectionUTurnLeft                      7   // The instruction indicates that a u-turn to the left is required.
#define QGeoManeuver_DirectionHardLeft                       8   // The instruction indicates that a hard turn to the left is required.
#define QGeoManeuver_DirectionLeft                           9   // The instruction indicates that a turn to the left is required.
#define QGeoManeuver_DirectionLightLeft                      10  // The instruction indicates that a light turn to the left is required.
#define QGeoManeuver_DirectionBearLeft                       11  // The instruction indicates that the direction of travel should bear to the left.

//enum QGeoRouteReply::Error
//Describes an error which prevented the completion of the operation.
#define QGeoRouteReply_NoError                               0   // No error has occurred.
#define QGeoRouteReply_EngineNotSetError                     1   // The routing manager that was used did not have a QGeoRoutingManagerEngine instance associated with it.
#define QGeoRouteReply_CommunicationError                    2   // An error occurred while communicating with the service provider.
#define QGeoRouteReply_ParseError                            3   // The response from the service provider was in an unrecognizable format.
#define QGeoRouteReply_UnsupportedOptionError                4   // The requested operation or one of the options for the operation are not supported by the service provider.
#define QGeoRouteReply_UnknownError                          5   // An error occurred which does not fit into any of the other categories.

//enum QGeoRouteRequest::FeatureType
//Defines a feature which is important to the planning of a route.
//These values will be used in combination with QGeoRouteRequest::FeatureWeight to determine if they should or should not be part of the route.
#define QGeoRouteRequest_NoFeature                           0x00000000   // Used by QGeoRoutingManager::supportedFeatureTypes() to indicate that no features will be taken into account when planning the route.
#define QGeoRouteRequest_TollFeature                         0x00000001   // Consdier tollways when planning the route.
#define QGeoRouteRequest_HighwayFeature                      0x00000002   // Consider highways when planning the route.
#define QGeoRouteRequest_PublicTransitFeature                0x00000004   // Consider public transit when planning the route.
#define QGeoRouteRequest_FerryFeature                        0x00000008   // Consider ferries when planning the route.
#define QGeoRouteRequest_TunnelFeature                       0x00000010   // Consider tunnels when planning the route.
#define QGeoRouteRequest_DirtRoadFeature                     0x00000020   // Consider dirt roads when planning the route.
#define QGeoRouteRequest_ParksFeature                        0x00000040   // Consider parks when planning the route.
#define QGeoRouteRequest_MotorPoolLaneFeature                0x00000080   // Consider motor pool lanes when planning the route.


//enum #define QGeoRouteRequest_FeatureWeight
//Defines the weight to associate with a feature during the planning of a route.
//These values will be used in combination with #define QGeoRouteRequest_Feature to determine if they should or should not be part of the route.
#define QGeoRouteRequest_NeutralFeatureWeight                0x00000000   // The presence or absence of the feature will not affect the planning of the route.
#define QGeoRouteRequest_PreferFeatureWeight                 0x00000001   // Routes which contain the feature will be preferred over those that do not.
#define QGeoRouteRequest_RequireFeatureWeight                0x00000002   // Only routes which contain the feature will be considered, otherwise no route will be returned.
#define QGeoRouteRequest_AvoidFeatureWeight                  0x00000004   // Routes which do not contain the feature will be preferred over those that do.
#define QGeoRouteRequest_DisallowFeatureWeight               0x00000008   // Only routes which do not contain the feature will be considered, otherwise no route will be returned.

//enum #define QGeoRouteRequest_ManeuverDetail
//Defines the amount of maneuver information that should be included with the route.
#define QGeoRouteRequest_NoManeuvers                         0x0000       // No maneuvers should be included with the route.
#define QGeoRouteRequest_BasicManeuvers                      0x0001       // Basic manevuers will be included with the route. This will include #define QGeoManeuver_instructionText().

//enum #define QGeoRouteRequest_RouteOptimization
//Defines the type of optimization which is applied to the planning of the route.
#define QGeoRouteRequest_ShortestRoute                       0x0001       // Minimize the length of the journey.
#define QGeoRouteRequest_FastestRoute                        0x0002       // Minimize the traveling time for the journey.
#define QGeoRouteRequest_MostEconomicRoute                   0x0004       // Minimize the cost of the journey.
#define QGeoRouteRequest_MostScenicRoute                     0x0008       // Maximize the scenic potential of the journey.

//enum #define QGeoRouteRequest_SegmentDetail
//Defines the amount of route segment information that should be included with the route.
#define QGeoRouteRequest_NoSegmentData                       0x0000       // No segment data should be included with the route. A route requested with this level of segment detail will initialize QGeoRouteSegment::path() as a straight line between the positions of the previous and next QGeoManeuver instances.
#define QGeoRouteRequest_BasicSegmentData                    0x0001       // Basic segment data will be included with the route. This will include QGeoRouteSegment::path().

//enum #define QGeoRouteRequest_TravelMode
//Defines modes of travel to be used for a route.
#define QGeoRouteRequest_CarTravel                           0x0001       // The route will be optimized for someone who is driving a car.
#define QGeoRouteRequest_PedestrianTravel                    0x0002       // The route will be optimized for someone who is walking.
#define QGeoRouteRequest_BicycleTravel                       0x0004       // The route will be optimized for someone who is riding a bicycle.
#define QGeoRouteRequest_PublicTransitTravel                 0x0008       // The route will be optimized for someone who is making use of public transit.
#define QGeoRouteRequest_TruckTravel                         0x0010       // The route will be optimized for someone who is driving a truck.

//enum #define QGeoServiceProvider_Error
//Describes an error related to the loading and setup of a service provider plugin.
#define QGeoServiceProvider_NoError                          0   // No error has occurred.
#define QGeoServiceProvider_NotSupportedError                1   // The plugin does not support this functionality.
#define QGeoServiceProvider_UnknownParameterError            2   // The plugin did not recognize one of the parameters it was given.
#define QGeoServiceProvider_MissingRequiredParameterError    3   // The plugin did not find one of the parameters it was expecting.
#define QGeoServiceProvider_ConnectionError                  4   // The plugin could not connect to its backend service or database.

//enum #define QGeoServiceProvider_GeocodingFeature
//Describes the geocoding features supported by the geo service provider.
#define QGeoServiceProvider_NoGeocodingFeatures              0          // No geocoding features are supported.
#define QGeoServiceProvider_OnlineGeocodingFeature           ( 1<<0 )   // Online geocoding is supported.
#define QGeoServiceProvider_OfflineGeocodingFeature          ( 1<<1 )   // Offline geocoding is supported.
#define QGeoServiceProvider_ReverseGeocodingFeature          ( 1<<2 )   // Reverse geocoding is supported.
#define QGeoServiceProvider_LocalizedGeocodingFeature        ( 1<<3 )   // Supports returning geocoding results with localized addresses.
#define QGeoServiceProvider_AnyGeocodingFeatures             ~( 0 )     // Matches a geo service provider that provides any geocoding features.


//enum #define QGeoServiceProvider_MappingFeature
//Describes the mapping features supported by the geo service provider.
#define QGeoServiceProvider_NoMappingFeatures                0          // No mapping features are supported.
#define QGeoServiceProvider_OnlineMappingFeature             ( 1<<0 )   // Online mapping is supported.
#define QGeoServiceProvider_OfflineMappingFeature            ( 1<<1 )   // Offline mapping is supported.
#define QGeoServiceProvider_LocalizedMappingFeature          ( 1<<2 )   // Supports returning localized map data.
#define QGeoServiceProvider_AnyMappingFeatures               ~( 0 )     // Matches a geo service provider that provides any mapping features.


//enum #define QGeoServiceProvider_PlacesFeature
//Describes the places features supported by the geo service provider.
#define QGeoServiceProvider_NoPlacesFeatures                 0          // No places features are supported.
#define QGeoServiceProvider_OnlinePlacesFeature              ( 1<<0 )   // Online places is supported.
#define QGeoServiceProvider_OfflinePlacesFeature             ( 1<<1 )   // Offline places is supported.
#define QGeoServiceProvider_SavePlaceFeature                 ( 1<<2 )   // Saving places is supported.
#define QGeoServiceProvider_RemovePlaceFeature               ( 1<<3 )   // Removing or deleting places is supported.
#define QGeoServiceProvider_SaveCategoryFeature              ( 1<<4 )   // Saving categories is supported.
#define QGeoServiceProvider_RemoveCategoryFeature            ( 1<<5 )   // Removing or deleting categories is supported.
#define QGeoServiceProvider_PlaceRecommendationsFeature      ( 1<<6 )   // Searching for recommended places similar to another place is supported.
#define QGeoServiceProvider_SearchSuggestionsFeature         ( 1<<7 )   // Search suggestions is supported.
#define QGeoServiceProvider_LocalizedPlacesFeature           ( 1<<8 )   // Supports returning localized place data.
#define QGeoServiceProvider_NotificationsFeature             ( 1<<9 )   // Notifications of place and category changes is supported.
#define QGeoServiceProvider_PlaceMatchingFeature             ( 1<<10 )  // Supports matching places from two different geo service providers.
#define QGeoServiceProvider_AnyPlacesFeatures                ~( 0 )     // Matches a geo service provider that provides any places features.

//enum #define QGeoServiceProvider_RoutingFeature
//Describes the routing features supported by the geo service provider.
#define QGeoServiceProvider_NoRoutingFeatures                0          // No routing features are supported.
#define QGeoServiceProvider_OnlineRoutingFeature             ( 1<<0 )   // Online routing is supported.
#define QGeoServiceProvider_OfflineRoutingFeature            ( 1<<1 )   // Offline routing is supported.
#define QGeoServiceProvider_LocalizedRoutingFeature          ( 1<<2 )   // Supports returning routes with localized addresses and instructions.
#define QGeoServiceProvider_RouteUpdatesFeature              ( 1<<3 )   // Updating an existing route based on the current position is supported.
#define QGeoServiceProvider_AlternativeRoutesFeature         ( 1<<4 )   // Supports returning alternative routes.
#define QGeoServiceProvider_ExcludeAreasRoutingFeature       ( 1<<5 )   // Supports specifying a areas which the returned route must not cross.
#define QGeoServiceProvider_AnyRoutingFeatures               ~( 0 )     // Matches a geo service provider that provides any routing features.

//enum #define QPlaceContent_Type
//Defines the type of content.
#define QPlaceContent_NoType                                 0   // The content object is default constructed, any other content type may be assigned to this content object.
#define QPlaceContent_ImageType                              1   // The content object is an image.
#define QPlaceContent_ReviewType                             2   // The content object is a review.
#define QPlaceContent_EditorialType                          3   // The content object is an editorial

//enum #define QPlaceReply_Error
//Describes an error which occurred during an operation.
#define QPlaceReply_NoError                                  0   // No error has occurred
#define QPlaceReply_PlaceDoesNotExistError                   1   // A specified place could not be found
#define QPlaceReply_CategoryDoesNotExistError                2   // A specified category could not be found
#define QPlaceReply_CommunicationError                       3   // An error occurred communicating with the service provider.
#define QPlaceReply_ParseError                               4   // The response from the service provider or an import file was in an unrecognizable format
#define QPlaceReply_PermissionsError                         5   // The operation failed because of insufficient permissions.
#define QPlaceReply_UnsupportedError                         6   // The operation was not supported by the service provider.
#define QPlaceReply_BadArgumentError                         7   // . A parameter that was provided was invalid.
#define QPlaceReply_CancelError                              8   // The operation was canceled.
#define QPlaceReply_UnknownError                             9   // An error occurred which does not fit into any of the other categories.

//enum #define QPlaceReply_Type
//Describes the reply's type.
#define QPlaceReply_Reply                                    0   // This is a generic reply.
#define QPlaceReply_DetailsReply                             1   // This is a reply for the retrieval of place details
#define QPlaceReply_SearchReply                              2   // This is a reply for the place search operation.
#define QPlaceReply_SearchSuggestionReply                    3   // This is a reply for a search suggestion operation.
#define QPlaceReply_ContentReply                             4   // This is a reply for content associated with a place.
#define QPlaceReply_IdReply                                  5   // This is a reply that returns an identifier of a place or category. Typically used for place or category save and remove operations.
#define QPlaceReply_MatchReply                               6   // This is a reply that returns places that match those from another provider.

//enum #define QPlaceSearchRequest_RelevanceHint
//Defines hints to help rank place results.
#define QPlaceSearchRequest_UnspecifiedHint                  0   // No explicit hint has been specified.
#define QPlaceSearchRequest_DistanceHint                     1   // Distance to a search center is relevant for the user. Closer places are more highly weighted. This hint is only useful if a circular search area is used in the query.
#define QPlaceSearchRequest_LexicalPlaceNameHint             2   // Alphabetic ordering of places according to name is relevant to the user.

//enum #define QPlaceSearchResult_SearchResultType
//Defines the type of search result
#define QPlaceSearchResult_UnknownSearchResult               0   // The contents of the search result are unknown.
#define QPlaceSearchResult_PlaceResult                       1   // The search result contains a place.
#define QPlaceSearchResult_ProposedSearchResult              2   // The search result contains a proposed search which may be relevant.

//enum #define QPlaceIdReply_OperationType
//Defines the type of operation that was used to generate this reply.
#define QPlaceIdReply_SavePlace                              0   // The reply was created for a save place operation
#define QPlaceIdReply_RemovePlace                            2   // The reply was created for a remove place operation.
#define QPlaceIdReply_SaveCategory                           1   // The reply was created for a save category operation
#define QPlaceIdReply_RemoveCategory                         3   // The reply was created for a remove category operation.

//enum QCalendarWidget::HorizontalHeaderFormat
//This enum type defines the various formats the horizontal header can display.
#define QCalendarWidget_SingleLetterDayNames                 1   // The header displays a single letter abbreviation for day names (e.g. M for Monday).
#define QCalendarWidget_ShortDayNames                        2   // The header displays a short abbreviation for day names (e.g. Mon for Monday).
#define QCalendarWidget_LongDayNames                         3   // The header displays complete day names (e.g. Monday).
#define QCalendarWidget_NoHorizontalHeader                   0   // The header is hidden.

//enum QCalendarWidget::SelectionMode
//This enum describes the types of selection offered to the user for selecting dates in the calendar.
#define QCalendarWidget_NoSelection                          0   // Dates cannot be selected.
#define QCalendarWidget_SingleSelection                      1   // Single dates can be selected.

//enum QCalendarWidget::VerticalHeaderFormat
//This enum type defines the various formats the vertical header can display.
#define QCalendarWidget_ISOWeekNumbers                       1   // The header displays ISO week numbers as described by QDate::weekNumber().
#define QCalendarWidget_NoVerticalHeader                     0   // The header is hidden.

//enum QJsonDocument::DataValidation
//This value is used to tell QJsonDocument whether to validate the binary data when converting to a QJsonDocument using fromBinaryData() or fromRawData().
#define QJsonDocument_Validate                               0   // Validate the data before using it. This is the default.
#define QJsonDocument_BypassValidation                       1   // Bypasses data validation. Only use if you received the data from a trusted place and know it's valid, as using of invalid data can crash the application.

//enum QJsonDocument::JsonFormat
//This value defines the format of the JSON byte array produced when converting to a QJsonDocument using toJson().
#define QJsonDocument_Indented                               0   // Defines human readable output as follows:
#define QJsonDocument_Compact                                1   // Defines a compact output as follows: {"Array":[true,999,"string"],"Key":"Value","null":null}

//enum QTextFrameFormat::BorderStyle
//This enum describes different border styles for the text frame.
#define QTextFrameFormat_BorderStyle_None                    0
#define QTextFrameFormat_BorderStyle_Dotted                  1
#define QTextFrameFormat_BorderStyle_Dashed                  2
#define QTextFrameFormat_BorderStyle_Solid                   3
#define QTextFrameFormat_BorderStyle_Double                  4
#define QTextFrameFormat_BorderStyle_DotDash                 5
#define QTextFrameFormat_BorderStyle_DotDotDash              6
#define QTextFrameFormat_BorderStyle_Groove                  7
#define QTextFrameFormat_BorderStyle_Ridge                   8
#define QTextFrameFormat_BorderStyle_Inset                   9
#define QTextFrameFormat_BorderStyle_Outset                  10

//enum #define QTextFrameFormat_Position
//This enum describes how a frame is located relative to the surrounding text.
#define QTextFrameFormat_InFlow                              0
#define QTextFrameFormat_FloatLeft                           1
#define QTextFrameFormat_FloatRight                          2

//enum QTextFormat::FormatType
//This enum describes the text item a QTextFormat object is formatting.
#define QTextFormat_InvalidFormat                            -1  // An invalid format as created by the default constructor
#define QTextFormat_BlockFormat                              1   // The object formats a text block
#define QTextFormat_CharFormat                               2   // The object formats a single character
#define QTextFormat_ListFormat                               3   // The object formats a list Unused Value, a table's FormatType is FrameFormat.
#define QTextFormat_FrameFormat                              5   // The object formats a frame
#define QTextFormat_UserFormat                               100

//enum #define QTextFormat_ObjectTypes
//This enum describes what kind of QTextObject this format is associated with.
#define QTextFormat_NoObject                                 0
#define QTextFormat_ImageObject                              1
#define QTextFormat_TableObject                              2
#define QTextFormat_TableCellObject                          3
#define QTextFormat_UserObject                               0x1000   // The first object that can be used for application-specific purposes.

//enum #define QTextFormat_PageBreakFlag
//This enum describes how page breaking is performed when printing. It maps to the corresponding css properties.
#define QTextFormat_PageBreak_Auto                           0        // The page break is determined automatically depending on the available space on the current page
#define QTextFormat_PageBreak_AlwaysBefore                   0x001    // The page is always broken before the paragraph/table
#define QTextFormat_PageBreak_AlwaysAfter                    0x010    // A new page is always started after the paragraph/table

//enum #define QTextFormat_Property
//This enum describes the different properties a format can have.
#define QTextFormat_ObjectIndex                              0x0      // The index of the formatted object. See objectIndex().

// Paragraph and character properties
#define QTextFormat_CssFloat                                 0x0800   // How a frame is located relative to the surrounding text
#define QTextFormat_LayoutDirection                          0x0801   // The layout direction of the text in the document (Qt::LayoutDirection).
#define QTextFormat_OutlinePen                               0x810
#define QTextFormat_ForegroundBrush                          0x821
#define QTextFormat_BackgroundBrush                          0x820
#define QTextFormat_BackgroundImageUrl                       0x823

//Paragraph properties
#define QTextFormat_BlockAlignment                           0x1010
#define QTextFormat_BlockTopMargin                           0x1030
#define QTextFormat_BlockBottomMargin                        0x1031
#define QTextFormat_BlockLeftMargin                          0x1032
#define QTextFormat_BlockRightMargin                         0x1033
#define QTextFormat_TextIndent                               0x1034
#define QTextFormat_TabPositions                             0x1035   // Specifies the tab positions. The tab positions are structs of QTextOption::Tab which are stored in a QList (internally, in a QList<QVariant>).
#define QTextFormat_BlockIndent                              0x1040
#define QTextFormat_LineHeight                               0x1048
#define QTextFormat_LineHeightType                           0x1049
#define QTextFormat_BlockNonBreakableLines                   0x1050
#define QTextFormat_BlockTrailingHorizontalRulerWidth        0x1060   // The width of a horizontal ruler element.

// Character properties
#define QTextFormat_FontFamily                               0x2000
#define QTextFormat_FontPointSize                            0x2001
#define QTextFormat_FontPixelSize                            0x2009
#define QTextFormat_FontSizeAdjustment                       0x2002   // Specifies the change in size given to the fontsize already set using FontPointSize or FontPixelSize.
#define QTextFormat_FontFixedPitch                           0x2008
#define QTextFormat_FontWeight                               0x2003
#define QTextFormat_FontItalic                               0x2004
#define QTextFormat_FontUnderline                            0x2005   // This property has been deprecated. Use #define QTextFormat_TextUnderlineStyle instead.
#define QTextFormat_FontOverline                             0x2006
#define QTextFormat_FontStrikeOut                            0x2007
#define QTextFormat_FontCapitalization                       QTextFormat_FirstFontProperty   // Specifies the capitalization type that is to be applied to the text.
#define QTextFormat_FontLetterSpacingType                    0x2033   // Specifies the meaning of the FontLetterSpacing property. The default is QFont::PercentageSpacing.
#define QTextFormat_FontLetterSpacing                        0x1FE1   // Changes the default spacing between individual letters in the font. The value is specified as a percentage or absolute value, depending on FontLetterSpacingType. The default value is 100%.
#define QTextFormat_FontWordSpacing                          0x1FE2   // Changes the default spacing between individual words. A positive value increases the word spacing by the corresponding pixels; a negative value decreases the spacing.
#define QTextFormat_FontStretch                              0x2034   // Corresponds to the QFont::Stretch property
#define QTextFormat_FontStyleHint                            0x1FE3   // Corresponds to the QFont::StyleHint property
#define QTextFormat_FontStyleStrategy                        0x1FE4   // Corresponds to the QFont::StyleStrategy property
#define QTextFormat_FontKerning                              0x1FE5   // Specifies whether the font has kerning turned on.
#define QTextFormat_FontHintingPreference                    0x1FE6   // Controls the use of hinting according to values of the QFont::HintingPreference enum.
#define QTextFormat_TextUnderlineColor                       0x2010
#define QTextFormat_TextVerticalAlignment                    0x2021
#define QTextFormat_TextOutline                              0x2022
#define QTextFormat_TextUnderlineStyle                       0x2023
#define QTextFormat_TextToolTip                              0x2024   // Specifies the (optional) tool tip to be displayed for a fragment of text.
#define QTextFormat_IsAnchor                                 0x2030
#define QTextFormat_AnchorHref                               0x2031
#define QTextFormat_AnchorName                               0x2032
#define QTextFormat_ObjectType                               0x2f00

//List properties
#define QTextFormat_ListStyle                                0x3000   // Specifies the style used for the items in a list, described by values of the QTextListFormat::Style enum.
#define QTextFormat_ListIndent                               0x3001   // Specifies the amount of indentation used for a list.
#define QTextFormat_ListNumberPrefix                         0x3002   // Defines the text which is prepended to item numbers in numeric lists.
#define QTextFormat_ListNumberSuffix                         0x3003   // Defines the text which is appended to item numbers in numeric lists.

// Table and frame properties
#define QTextFormat_FrameBorder                              0x4000
#define QTextFormat_FrameBorderBrush                         0x4009
#define QTextFormat_FrameBorderStyle                         0x4010   // See the BorderStyle enum.
#define QTextFormat_FrameBottomMargin                        0x4006
#define QTextFormat_FrameHeight                              0x4004
#define QTextFormat_FrameLeftMargin                          0x4007
#define QTextFormat_FrameMargin                              0x4001
#define QTextFormat_FramePadding                             0x4002
#define QTextFormat_FrameRightMargin                         0x4008
#define QTextFormat_FrameTopMargin                           0x4005
#define QTextFormat_FrameWidth                               0x4003
#define QTextFormat_TableCellSpacing                         0x4102
#define QTextFormat_TableCellPadding                         0x4103
#define QTextFormat_TableColumns                             0x4100
#define QTextFormat_TableColumnWidthConstraints              0x4101
#define QTextFormat_TableHeaderRowCount                      0x4104

// Table cell properties
#define QTextFormat_TableCellRowSpan                         0x4810
#define QTextFormat_TableCellColumnSpan                      0x4811
#define QTextFormat_TableCellLeftPadding                     0x4814
#define QTextFormat_TableCellRightPadding                    0x4815
#define QTextFormat_TableCellTopPadding                      0x4812
#define QTextFormat_TableCellBottomPadding                   0x4813

//Image properties
#define QTextFormat_ImageName                                0x5000
#define QTextFormat_ImageWidth                               0x5010
#define QTextFormat_ImageHeight                              0x5011

//Selection properties
#define QTextFormat_FullWidthSelection                       0x06000   // When set on the characterFormat of a selection, the whole width of the text will be shown selected.

//Page break properties
#define QTextFormat_PageBreakPolicy                          0x7000    // Specifies how pages are broken. See the PageBreakFlag enum.
#define QTextFormat_UserProperty                             0x100000

#define QTextLength_VariableLength                           0         // the width of the object is variable
#define QTextLength_FixedLength                              1         // the width of the object is fixed
#define QTextLength_PercentageLength                         2         // the width of the object is in percentage of the maximum width

#define QAbstractAxis_AxisTypeNoAxis                         0x0
#define QAbstractAxis_AxisTypeValue                          0x1
#define QAbstractAxis_AxisTypeBarCategory                    0x2
#define QAbstractAxis_AxisTypeCategory                       0x4
#define QAbstractAxis_AxisTypeDateTime                       0x8
#define QAbstractAxis_AxisTypeLogValue                       0x10

#define QAbstractBarSeries_LabelsCenter                      0         // Label is in the center of the bar.
#define QAbstractBarSeries_LabelsInsideEnd                   1         // Label is inside the bar at the high end of it.
#define QAbstractBarSeries_LabelsInsideBase                  2         // Label is inside the bar at the low end of it.
#define QAbstractBarSeries_LabelsOutsideEnd                  3         // Label is outside the bar at the high end of it.

#define QAbstractSeries_SeriesTypeLine                       0
#define QAbstractSeries_SeriesTypeArea                       1
#define QAbstractSeries_SeriesTypeBar                        2
#define QAbstractSeries_SeriesTypeStackedBar                 3
#define QAbstractSeries_SeriesTypePercentBar                 4
#define QAbstractSeries_SeriesTypePie                        5
#define QAbstractSeries_SeriesTypeScatter                    6
#define QAbstractSeries_SeriesTypeSpline                     7
#define QAbstractSeries_SeriesTypeHorizontalBar              8
#define QAbstractSeries_SeriesTypeHorizontalStackedBar       9
#define QAbstractSeries_SeriesTypeHorizontalPercentBar       10
#define QAbstractSeries_SeriesTypeBoxPlot                    11

#define QBoxSet_LowerExtreme                                 0
#define QBoxSet_LowerQuartile                                1
#define QBoxSet_Median                                       2
#define QBoxSet_UpperQuartile                                3
#define QBoxSet_UpperExtreme                                 4

#define QCategoryAxis_AxisLabelsPositionCenter               0x0       // Labels are centered to category.
#define QCategoryAxis_AxisLabelsPositionOnValue              0x1       // Labels are positioned to the high end limit of the category.

#define QChart_NoAnimation                                   0x0
#define QChart_GridAxisAnimations                            0x1
#define QChart_SeriesAnimations                              0x2
#define QChart_AllAnimations                                 0x3

#define QChart_ChartThemeLight                               0
#define QChart_ChartThemeBlueCerulean                        1
#define QChart_ChartThemeDark                                2
#define QChart_ChartThemeBrownSand                           3
#define QChart_ChartThemeBlueNcs                             4
#define QChart_ChartThemeHighContrast                        5
#define QChart_ChartThemeBlueIcy                             6
#define QChart_ChartThemeQt                                  7

#define QChart_ChartTypeUndefined                            0
#define QChart_ChartTypeCartesian                            1
#define QChart_ChartTypePolar                                2

#define QChartView_NoRubberBand                              0x0
#define QChartView_VerticalRubberBand                        0x1
#define QChartView_HorizontalRubberBand                      0x2
#define QChartView_RectangleRubberBand                       0x3

#define QLegendMarker_LegendMarkerTypeArea                   0
#define QLegendMarker_LegendMarkerTypeBar                    1
#define QLegendMarker_LegendMarkerTypePie                    2
#define QLegendMarker_LegendMarkerTypeXY                     3
#define QLegendMarker_LegendMarkerTypeBoxPlot                4

#define QPieSlice_LabelOutside                               0         // Label is outside the slice with an arm.
#define QPieSlice_LabelInsideHorizontal                      1         // Label is centered inside the slice and laid out horizontally.
#define QPieSlice_LabelInsideTangential                      2         // Label is centered inside the slice and rotated to be parallel to the tangential of the slice's arc.
#define QPieSlice_LabelInsideNormal                          3         // Label is centered inside the slice rotated to be parallel to the normal of the slice's arc.

#define QPolarChart_PolarOrientationRadial                   0x1
#define QPolarChart_PolarOrientationAngular                  0x2

#define QScatterSeries_MarkerShapeCircle                     0
#define QScatterSeries_MarkerShapeRectangle                  1

#define QColor_Rgb                                           1
#define QColor_Hsv                                           2
#define QColor_Cmyk                                          3
#define QColor_Hsl                                           4
#define QColor_Invalid                                       0

#define QListWidgetItem_Type                                 0         // The default type for list widget items.
#define QListWidgetItem_UserType                             1000      // The minimum value for custom types. Values below UserType are reserved by Qt.

#define QDBus_NoBlock                                        0         // Place the call but don't wait for the reply (the reply's contents will be discarded).
#define QDBus_Block                                          1         // Don't use an event loop to wait for a reply, but instead block on network operations while waiting. This means the user-interface may not be updated until the function returns.
#define QDBus_BlockWithGui                                   2         // Use the Qt event loop to wait for a reply. This means that the user-interface will stay responsive (processing input events), but it also means other events may happen, like signal delivery and other D-Bus method calls.
#define QDBus_AutoDetect                                     3         // Automatically detect if the called function has a reply.
                                                                       //
#define QDBusArgument_BasicType                              0         // A basic element, which is understood by QVariant. The following types are considered basic: bool, byte, short, ushort, int, uint, qint64, quint64, double, QString, QByteArray, QDBusObjectPath, QDBusSignature
#define QDBusArgument_VariantType                            1         // The variant element (QDBusVariant)
#define QDBusArgument_ArrayType                              2         // An array element, usually represented by QList<T> or QVector<T>. Note: QByteArray and associative maps are not considered arrays, even if the D-Bus protocol transports them as such.
#define QDBusArgument_StructureType                          3         // A custom type represented by a structure, like QDateTime, QPoint, etc.
#define QDBusArgument_MapType                                4         // An associative container, like QMap<Key, Value> or QHash<Key, Value>
#define QDBusArgument_MapEntryType                           5         // One entry in an associative container: both the key and the value form one map-entry type.
#define QDBusArgument_UnknownType   -                        1         // The type is unknown or we have reached the end of the list.
                                                                       //
#define QDBusConnection_SessionBus                           0         // the session bus, associated with the running desktop session
#define QDBusConnection_SystemBus                            1         // the system bus, used to communicate with system-wide processes
#define QDBusConnection_ActivationBus                        2         // the activation bus, the "alias" for the bus that started the service
                                                                       //
#define QDBusConnection_UnixFileDescriptorPassing            0x0001    // enables passing of Unix file descriptors to other processes (see QDBusUnixFileDescriptor)
                                                                       //
#define QDBusConnection_ExportAdaptors                       0x01      // export the contents of adaptors found in this object
#define QDBusConnection_ExportScriptableSlots                0x10      // export this object's scriptable slots
#define QDBusConnection_ExportScriptableSignals              0x20      // export this object's scriptable signals
#define QDBusConnection_ExportScriptableProperties           0x40      // export this object's scriptable properties
#define QDBusConnection_ExportScriptableInvokables           0x80      // export this object's scriptable invokables
#define QDBusConnection_ExportScriptableContents             0xf0      // shorthand form for ExportScriptableSlots | ExportScriptableSignals | ExportScriptableProperties
#define QDBusConnection_ExportNonScriptableSlots             0x100     // export this object's non-scriptable slots
#define QDBusConnection_ExportNonScriptableSignals           0x200     // export this object's non-scriptable signals
#define QDBusConnection_ExportNonScriptableProperties        0x400     // export this object's non-scriptable properties
#define QDBusConnection_ExportNonScriptableInvokables        0x800     // export this object's non-scriptable invokables
#define QDBusConnection_ExportNonScriptableContents          0xf00     // shorthand form for ExportNonScriptableSlots | ExportNonScriptableSignals | ExportNonScriptableProperties
#define QDBusConnection_ExportAllSlots                       hb_bitOr( QBusConnection_ExportScriptableSlots      , QBusConnection_ExportNonScriptableSlots      ) // export all of this object's slots
#define QDBusConnection_ExportAllSignals                     hb_bitOr( QBusConnection_ExportScriptableSignals    , QBusConnection_ExportNonScriptableSignals    ) // export all of this object's signals
#define QDBusConnection_ExportAllProperties                  hb_bitOr( QBusConnection_ExportScriptableProperties , QBusConnection_ExportNonScriptableProperties ) // export all of this object's properties
#define QDBusConnection_ExportAllInvokables                  hb_bitOr( QBusConnection_ExportScriptableInvokables , QBusConnection_ExportNonScriptableInvokables ) // export all of this object's invokables
#define QDBusConnection_ExportAllContents                    hb_bitOr( QBusConnection_ExportScriptableContents   , QBusConnection_ExportNonScriptableContents   ) // export all of this object's contents
#define QDBusConnection_ExportChildObjects                   0x1000

#define QDBusConnection_UnregisterNode                       0         // unregister this node only: do not unregister child objects
#define QDBusConnection_UnregisterTree                       1         // unregister this node and all its sub-tree
                                                                       //
#define QDBusConnectionInterface_ServiceNotRegistered        0         // The call failed and the service name was not registered.
#define QDBusConnectionInterface_ServiceRegistered           1         // The caller is now the owner of the service name.
#define QDBusConnectionInterface_ServiceQueued               2         // The caller specified the QueueService flag and the service was already registered, so we are in queue.
                                                                       //
#define QDBusConnectionInterface_DontQueueService            0         // If an application requests a name that is already owned, no queueing will be performed. The registeredService() call will simply fail. This is the default.
#define QDBusConnectionInterface_QueueService                1         // Attempts to register the requested service, but do not try to replace it if another application already has it registered. Instead, simply put this application in queue, until it is given up. The serviceRegistered() signal will be emitted when that happens.
#define QDBusConnectionInterface_ReplaceExistingService      2         // If another application already has the service name registered, attempt to replace it.
                                                                       //
#define QDBusConnectionInterface_DontAllowReplacement        0         // Do not allow another application to replace us. The service must be explicitly unregistered with unregisterService() for another application to acquire it. This is the default.
#define QDBusConnectionInterface_AllowReplacement            1         // Allow other applications to replace us with the ReplaceExistingService option to registerService() without intervention. If that happens, the serviceUnregistered() signal will be emitted.
                                                                       //
#define QDBusError_NoError                                   0         // QDBusError is invalid (i.e., the call succeeded)
#define QDBusError_Other                                     1         // QDBusError contains an error that is one of the well-known ones
#define QDBusError_Failed                                    2         // The call failed (org.freedesktop.DBus.Error.Failed)
#define QDBusError_NoMemory                                  3         // Out of memory (org.freedesktop.DBus.Error.NoMemory)
#define QDBusError_ServiceUnknown                            4         // The called service is not known (org.freedesktop.DBus.Error.ServiceUnknown)
#define QDBusError_NoReply                                   5         // The called method did not reply within the specified timeout (org.freedesktop.DBus.Error.NoReply)
#define QDBusError_BadAddress                                6         // The address given is not valid (org.freedesktop.DBus.Error.BadAddress)
#define QDBusError_NotSupported                              7         // The call/operation is not supported (org.freedesktop.DBus.Error.NotSupported)
#define QDBusError_LimitsExceeded                            8         // The limits allocated to this process/call/connection exceeded the pre-defined values (org.freedesktop.DBus.Error.LimitsExceeded)
#define QDBusError_AccessDenied                              9         // The call/operation tried to access a resource it isn't allowed to (org.freedesktop.DBus.Error.AccessDenied)
#define QDBusError_NoServer                                  10        // Documentation doesn't say what this is for (org.freedesktop.DBus.Error.NoServer)
#define QDBusError_Timeout                                   11        // Documentation doesn't say what this is for or how it's used (org.freedesktop.DBus.Error.Timeout)
#define QDBusError_NoNetwork                                 12        // Documentation doesn't say what this is for (org.freedesktop.DBus.Error.NoNetwork)
#define QDBusError_AddressInUse                              13        // QDBusServer tried to bind to an address that is already in use (org.freedesktop.DBus.Error.AddressInUse)
#define QDBusError_Disconnected                              14        // The call/process/message was sent after QDBusConnection disconnected (org.freedesktop.DBus.Error.Disconnected)
#define QDBusError_InvalidArgs                               15        // The arguments passed to this call/operation are not valid (org.freedesktop.DBus.Error.InvalidArgs)
#define QDBusError_UnknownMethod                             16        // The method called was not found in this object/interface with the given parameters (org.freedesktop.DBus.Error.UnknownMethod)
#define QDBusError_TimedOut                                  17        // Documentation doesn't say... (org.freedesktop.DBus.Error.TimedOut)
#define QDBusError_InvalidSignature                          18        // The type signature is not valid or compatible (org.freedesktop.DBus.Error.InvalidSignature)
#define QDBusError_UnknownInterface                          19        // The interface is not known
#define QDBusError_InternalError                             20        // An internal error occurred (com.trolltech.QtDBus.Error.InternalError)
#define QDBusError_InvalidObjectPath                         23        // The object path provided is invalid.
#define QDBusError_InvalidService                            22        // The service requested is invalid.
#define QDBusError_InvalidMember                             25        // The member is invalid.
#define QDBusError_InvalidInterface                          24        // The interface is invalid.
#define QDBusError_UnknownObject                             21        // The remote object could not be found.
                                                                       //
#define QDBusMessage_MethodCallMessage                       1         // a message representing an outgoing or incoming method call
#define QDBusMessage_SignalMessage                           4         // a message representing an outgoing or incoming signal emission
#define QDBusMessage_ReplyMessage                            2         // a message representing the return values of a method call
#define QDBusMessage_ErrorMessage                            3         // a message representing an error condition in response to a method call
#define QDBusMessage_InvalidMessage                          0         // an invalid message: this is never set on messages received from D-Bus
                                                                       //
#define QDBusServiceWatcher_WatchForRegistration             0x01      // watch for service registration only, ignoring any signals related to other service ownership change.
#define QDBusServiceWatcher_WatchForUnregistration           0x02      // watch for service unregistration only, ignoring any signals related to other service ownership change.
#define QDBusServiceWatcher_WatchForOwnerChange              0x03      // watch for any kind of service ownership change.

#define QSharedMemory_ReadOnly                               0         // The shared memory segment is read-only. Writing to the shared memory segment is not allowed. An attempt to write to a shared memory segment created with ReadOnly causes the program to abort.
#define QSharedMemory_ReadWrite                              1         // Reading and writing the shared memory segment are both allowed.

#define QSharedMemory_NoError                                0         // No error occurred.
#define QSharedMemory_PermissionDenied                       1         // The operation failed because the caller didn't have the required permissions.
#define QSharedMemory_InvalidSize                            2         // A create operation failed because the requested size was invalid.
#define QSharedMemory_KeyError                               3         // The operation failed because of an invalid key.
#define QSharedMemory_AlreadyExists                          4         // A create() operation failed because a shared memory segment with the specified key already existed.
#define QSharedMemory_NotFound                               5         // An attach() failed because a shared memory segment with the specified key could not be found.
#define QSharedMemory_LockError                              6         // The attempt to lock() the shared memory segment failed because create() or attach() failed and returned false, or because a system error occurred in QSystemSemaphore_acquire().
#define QSharedMemory_OutOfResources                         7         // A create() operation failed because there was not enough memory available to fill the request.
#define QSharedMemory_UnknownError                           8         // Something else happened and it was bad.

#define QSqlTableModel_OnFieldChange                         0
#define QSqlTableModel_OnRowChange                           1
#define QSqlTableModel_OnManualSubmit                        2

#endif

