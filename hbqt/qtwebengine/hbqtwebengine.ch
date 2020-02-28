/*
 * $Id$
 */

/*
 * Harbour Project source code:
 *
 * Copyright 2020 Pritpal Bedi <bedipritpal/hotmail/com>
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

#ifndef _HBQTWEBENGINE_CH
#define _HBQTWEBENGINE_CH


//enum QQuickWebEngineProfile_HttpCacheType
#define QQuickWebEngineProfile_MemoryHttpCache                           0  // Use an in-memory cache. This is the only setting possible if off-the-record is set or no cache path is available.
#define QQuickWebEngineProfile_DiskHttpCache                             1  // Use a disk cache. This is the default.
#define QQuickWebEngineProfile_NoCache                                   2  // Disable both in-memory and disk caching. (Added in Qt 5.7)

//enum QQuickWebEngineProfile_PersistentCookiesPolicy
#define QQuickWebEngineProfile_NoPersistentCookies                       0  // Both session and persistent cookies are stored in memory. This is the only setting possible if off-the-record is set or no persistent data path is available.
#define QQuickWebEngineProfile_AllowPersistentCookies                    1  // Cookies marked persistent are saved to and restored from disk, whereas session cookies are only stored to disk for crash recovery. This is the default setting.
#define QQuickWebEngineProfile_ForcePersistentCookies                    2  // Both session and persistent cookies are saved to and restored from disk.

//enum QWebEngineUrlRequestInfo_NavigationType
#define QWebEngineUrlRequestInfo_NavigationTypeLink                      0  // Navigation initiated by clicking a link.
#define QWebEngineUrlRequestInfo_NavigationTypeTyped                     1  // Navigation explicitly initiated by typing a URL.
#define QWebEngineUrlRequestInfo_NavigationTypeFormSubmitted             2  // Navigation submits a form.
#define QWebEngineUrlRequestInfo_NavigationTypeBackForward               3  // Navigation initiated by a history action.
#define QWebEngineUrlRequestInfo_NavigationTypeReload                    4  // Navigation initiated by refreshing the page.
#define QWebEngineUrlRequestInfo_NavigationTypeRedirect                  6  // Navigation triggered automatically by page content or remote server. (Added in Qt 5.14)
#define QWebEngineUrlRequestInfo_NavigationTypeOther                     5  // None of the above.

//enum QWebEngineUrlRequestInfo_ResourceType
#define QWebEngineUrlRequestInfo_ResourceTypeMainFrame                   0  // Top level page.
#define QWebEngineUrlRequestInfo_ResourceTypeSubFrame                    1  // Frame or iframe.
#define QWebEngineUrlRequestInfo_ResourceTypeStylesheet                  2  // A CSS stylesheet.
#define QWebEngineUrlRequestInfo_ResourceTypeScript                      3  // An external script.
#define QWebEngineUrlRequestInfo_ResourceTypeImage                       4  // An image (JPG, GIF, PNG, and so on).
#define QWebEngineUrlRequestInfo_ResourceTypeFontResource                5  // A font.
#define QWebEngineUrlRequestInfo_ResourceTypeSubResource                 6  // An "other" subresource.
#define QWebEngineUrlRequestInfo_ResourceTypeObject                      7  // An object (or embed) tag for a plugin or a resource that a plugin requested.
#define QWebEngineUrlRequestInfo_ResourceTypeMedia                       8  // A media resource.
#define QWebEngineUrlRequestInfo_ResourceTypeWorker                      9  // The main resource of a dedicated worker.
#define QWebEngineUrlRequestInfo_ResourceTypeSharedWorker                10 // The main resource of a shared worker.
#define QWebEngineUrlRequestInfo_ResourceTypePrefetch                    11 // An explicitly requested prefetch.
#define QWebEngineUrlRequestInfo_ResourceTypeFavicon                     12 // A favicon.
#define QWebEngineUrlRequestInfo_ResourceTypeXhr                         13 // An XMLHttpRequest.
#define QWebEngineUrlRequestInfo_ResourceTypePing                        14 // A ping request for <a ping>.
#define QWebEngineUrlRequestInfo_ResourceTypeServiceWorker               15 // The main resource of a service worker.
#define QWebEngineUrlRequestInfo_ResourceTypeCspReport                   16 // A report of Content Security Policy (CSP) violations. CSP reports are in JSON format and they are delivered by HTTP POST requests to specified servers. (Added in Qt 5.7)
#define QWebEngineUrlRequestInfo_ResourceTypePluginResource              17 // A resource requested by a plugin. (Added in Qt 5.7)
#define QWebEngineUrlRequestInfo_ResourceTypeNavigationPreloadMainFrame  19 // A main-frame service worker navigation preload request. (Added in Qt 5.14)
#define QWebEngineUrlRequestInfo_ResourceTypeNavigationPreloadSubFrame   20 // A sub-frame service worker navigation preload request. (Added in Qt 5.14)
#define QWebEngineUrlRequestInfo_ResourceTypeUnknown                     255 // Unknown request type.

//enum QWebEngineUrlRequestJob_Error
#define QWebEngineUrlRequestJob_NoError                                  0  // The request was successful.
#define QWebEngineUrlRequestJob_UrlNotFound                              1  // The requested URL was not found.
#define QWebEngineUrlRequestJob_UrlInvalid                               2  // The requested URL is invalid.
#define QWebEngineUrlRequestJob_RequestAborted                           3  // The request was canceled.
#define QWebEngineUrlRequestJob_RequestDenied                            4  // The request was denied.
#define QWebEngineUrlRequestJob_RequestFailed

//enum QWebEngineCertificateError_Error
#define QWebEngineCertificateError_SslPinnedKeyNotInCertificateChain    -150  // The certificate did not match the built-in public keys pinned for the host name.
#define QWebEngineCertificateError_CertificateCommonNameInvalid         -200  // The certificate's common name did not match the host name.
#define QWebEngineCertificateError_CertificateDateInvalid               -201  // The certificate is not valid at the current date and time.
#define QWebEngineCertificateError_CertificateAuthorityInvalid          -202  // The certificate is not signed by a trusted authority.
#define QWebEngineCertificateError_CertificateContainsErrors            -203  // The certificate contains errors.
#define QWebEngineCertificateError_CertificateNoRevocationMechanism     -204  // The certificate has no mechanism for determining if it has been revoked.
#define QWebEngineCertificateError_CertificateUnableToCheckRevocation   -205  // Revocation information for the certificate is not available.
#define QWebEngineCertificateError_CertificateRevoked                   -206  // The certificate has been revoked.
#define QWebEngineCertificateError_CertificateInvalid                   -207  // The certificate is invalid.
#define QWebEngineCertificateError_CertificateWeakSignatureAlgorithm    -208  // The certificate is signed using a weak signature algorithm.
#define QWebEngineCertificateError_CertificateNonUniqueName             -210  // The host name specified in the certificate is not unique.
#define QWebEngineCertificateError_CertificateWeakKey                   -211  // The certificate contains a weak key.
#define QWebEngineCertificateError_CertificateNameConstraintViolation   -212  // The certificate claimed DNS names that are in violation of name constraints.
#define QWebEngineCertificateError_CertificateValidityTooLong           -213  // The certificate has a validity period that is too long. (Added in Qt 5.7)
#define QWebEngineCertificateError_CertificateTransparencyRequired      -214  // Certificate Transparency was required for this connection, but the server did not provide CT information that complied with the policy. (Added in Qt 5.8)

//flags QWebEngineContextMenuData_EditFlags
#define QWebEngineContextMenuData_CanUndo                                0x1   // Undo is available.
#define QWebEngineContextMenuData_CanRedo                                0x2   // Redo is available.
#define QWebEngineContextMenuData_CanCut                                 0x4   // Cut is available.
#define QWebEngineContextMenuData_CanCopy                                0x8   // Copy is available.
#define QWebEngineContextMenuData_CanPaste                               0x10  // Paste is available.
#define QWebEngineContextMenuData_CanDelete                              0x20  // Delete is available.
#define QWebEngineContextMenuData_CanSelectAll                           0x40  // Select All is available.
#define QWebEngineContextMenuData_CanTranslate                           0x80  // Translate is available.
#define QWebEngineContextMenuData_CanEditRichly                          0x100 // Context is richly editable.

//enum QWebEngineContextMenuData_MediaFlag
//flags QWebEngineContextMenuData_MediaFlags
#define QWebEngineContextMenuData_MediaInError                           0x1   // An error occurred.
#define QWebEngineContextMenuData_MediaPaused                            0x2   // Media is paused.
#define QWebEngineContextMenuData_MediaMuted                             0x4   // Media is muted.
#define QWebEngineContextMenuData_MediaLoop                              0x8   // Media can be looped.
#define QWebEngineContextMenuData_MediaCanSave                           0x10  // Media can be saved.
#define QWebEngineContextMenuData_MediaHasAudio                          0x20  // Media has audio.
#define QWebEngineContextMenuData_MediaCanToggleControls                 0x40  // Media can show controls.
#define QWebEngineContextMenuData_MediaControls                          0x80  // Media controls are shown.
#define QWebEngineContextMenuData_MediaCanPrint                          0x100 // Media is printable.
#define QWebEngineContextMenuData_MediaCanRotate                         0x200 // Media is rotatable.

//enum QWebEngineContextMenuData_MediaType
#define QWebEngineContextMenuData_MediaTypeNone                          0  // The context is not a media type.
#define QWebEngineContextMenuData_MediaTypeImage                         1  // The context is an image element.
#define QWebEngineContextMenuData_MediaTypeVideo                         2  // The context is a video element.
#define QWebEngineContextMenuData_MediaTypeAudio                         3  // The context is an audio element.
#define QWebEngineContextMenuData_MediaTypeCanvas                        4  // The context is a canvas element.
#define QWebEngineContextMenuData_MediaTypeFile                          5  // The context is a file.
#define QWebEngineContextMenuData_MediaTypePlugin                        6  // The context is a plugin element.

//enum QWebEngineDownloadItem_DownloadInterruptReason
#define QWebEngineDownloadItem_NoReason                                  0  // Unknown reason or not interrupted.
#define QWebEngineDownloadItem_FileFailed                                1  // General file operation failure.
#define QWebEngineDownloadItem_FileAccessDenied                          2  // The file cannot be written locally, due to access restrictions.
#define QWebEngineDownloadItem_FileNoSpace                               3  // Insufficient space on the target drive.
#define QWebEngineDownloadItem_FileNameTooLong                           5  // The directory or file name is too long.
#define QWebEngineDownloadItem_FileTooLarge                              6  // The file size exceeds the file system limitation.
#define QWebEngineDownloadItem_FileVirusInfected                         7  // The file is infected with a virus.
#define QWebEngineDownloadItem_FileTransientError                        10 // Temporary problem (for example the file is in use, out of memory, or too many files are opened at once).
#define QWebEngineDownloadItem_FileBlocked                               11 // The file was blocked due to local policy.
#define QWebEngineDownloadItem_FileSecurityCheckFailed                   12 // An attempt to check the safety of the download failed due to unexpected reasons.
#define QWebEngineDownloadItem_FileTooShort                              13 // An attempt was made to seek past the end of a file when opening a file (as part of resuming a previously interrupted download).
#define QWebEngineDownloadItem_FileHashMismatch                          14 // The partial file did not match the expected hash.
#define QWebEngineDownloadItem_NetworkFailed                             20 // General network failure.
#define QWebEngineDownloadItem_NetworkTimeout                            21 // The network operation has timed out.
#define QWebEngineDownloadItem_NetworkDisconnected                       22 // The network connection has been terminated.
#define QWebEngineDownloadItem_NetworkServerDown                         23 // The server has gone down.
#define QWebEngineDownloadItem_NetworkInvalidRequest                     24 // The network request was invalid (for example, the original or redirected URL is invalid, has an unsupported scheme, or is disallowed by policy).
#define QWebEngineDownloadItem_ServerFailed                              30 // General server failure.
#define QWebEngineDownloadItem_ServerBadContent                          33 // The server does not have the requested data.
#define QWebEngineDownloadItem_ServerUnauthorized                        34 // The server did not authorize access to the resource.
#define QWebEngineDownloadItem_ServerCertProblem                         35 // A problem with the server certificate occurred.
#define QWebEngineDownloadItem_ServerForbidden                           36 // Access forbidden by the server.
#define QWebEngineDownloadItem_ServerUnreachable                         37 // Unexpected server response (might indicate that the responding server may not be the intended server).
#define QWebEngineDownloadItem_UserCanceled                              40 // The user canceled the download.

//enum QWebEngineDownloadItem_DownloadState
#define QWebEngineDownloadItem_DownloadRequested                         0  // Download has been requested, but has not been accepted yet.
#define QWebEngineDownloadItem_DownloadInProgress                        1  // Download is in progress.
#define QWebEngineDownloadItem_DownloadCompleted                         2  // Download completed successfully.
#define QWebEngineDownloadItem_DownloadCancelled                         3  // Download has been cancelled.
#define QWebEngineDownloadItem_DownloadInterrupted                       4  // Download has been interrupted (by the server or because of lost connectivity).

//enum QWebEngineDownloadItem_DownloadType
#define QWebEngineDownloadItem_Attachment                                0  // The web server's response includes a Content-Disposition header with the attachment directive. If Content-Disposition is present in the reply, the web server is indicating that the client should prompt the user to save the content regardless of the content type. See RFC 2616 section 19.5.1 for details.
#define QWebEngineDownloadItem_DownloadAttribute                         1  // The user clicked a link with the download attribute. See HTML download attribute for details.
#define QWebEngineDownloadItem_UserRequested                             2  // The user initiated the download, for example by selecting a web action.
#define QWebEngineDownloadItem_SavePage                                  3  // Saving of the current page was requested (for example by the QWebEnginePage_SavePage web action).

//enum QWebEngineDownloadItem_SavePageFormat
#define QWebEngineDownloadItem_UnknownSaveFormat                        -1  // This is not a request for downloading a complete web page.
#define QWebEngineDownloadItem_SingleHtmlSaveFormat                      0  // The page is saved as a single HTML page. Resources such as images are not saved.
#define QWebEngineDownloadItem_CompleteHtmlSaveFormat                    1  // The page is saved as a complete HTML page, for example a directory containing the single HTML page and the resources.
#define QWebEngineDownloadItem_MimeHtmlSaveFormat                        2  // The page is saved as a complete web page in the MIME HTML format.

//enum QWebEnginePage_Feature
#define QWebEnginePage_Notifications                                     0  // Web notifications for the end-user.
#define QWebEnginePage_Geolocation                                       1  // Location hardware or service.
#define QWebEnginePage_MediaAudioCapture                                 2  // Audio capture devices, such as microphones.
#define QWebEnginePage_MediaVideoCapture                                 3  // Video devices, such as cameras.
#define QWebEnginePage_MediaAudioVideoCapture                            4  // Both audio and video capture devices.
#define QWebEnginePage_MouseLock                                         5  // Mouse locking, which locks the mouse pointer to the web view and is typically used in games.
#define QWebEnginePage_DesktopVideoCapture                               6  // Video output capture, that is, the capture of the user's display, for screen sharing purposes for example. (Added in Qt 5.10)
#define QWebEnginePage_DesktopAudioVideoCapture                          7  // Both audio and video output capture. (Added in Qt 5.10)

//enum QWebEnginePage_FileSelectionMode
#define QWebEnginePage_FileSelectOpen                                    0  // Return only one file name.
#define QWebEnginePage_FileSelectOpenMultiple                            1  // Return multiple file names.

//enum QWebEnginePage_FindFlag
//flags QWebEnginePage_FindFlags
#define QWebEnginePage_FindBackward                                      1  // Searches backwards instead of forwards.
#define QWebEnginePage_FindCaseSensitively                               2  // By default findText() works case insensitive. Specifying this option changes the behavior to a case sensitive find operation.

//enum QWebEnginePage_JavaScriptConsoleMessageLevel
#define QWebEnginePage_InfoMessageLevel                                  0  // The message is purely informative and can safely be ignored.
#define QWebEnginePage_WarningMessageLevel                               1  // The message informs about unexpected behavior or errors that may need attention.
#define QWebEnginePage_ErrorMessageLevel                                 2  // The message indicates there has been an error.

//enum QWebEnginePage_LifecycleState
#define QWebEnginePage_Active                                            0  // Normal state.
#define QWebEnginePage_Frozen                                            1  // Low CPU usage state where most HTML task sources are suspended.
#define QWebEnginePage_Discarded                                         2  // Very low resource usage state where the entire browsing context is discarded.

//enum QWebEnginePage_NavigationType
#define QWebEnginePage_NavigationTypeLinkClicked                         0  // The navigation request resulted from a clicked link.
#define QWebEnginePage_NavigationTypeTyped                               1  // The navigation request resulted from an explicitly loaded URL.
#define QWebEnginePage_NavigationTypeFormSubmitted                       2  // The navigation request resulted from a form submission.
#define QWebEnginePage_NavigationTypeBackForward                         3  // The navigation request resulted from a back or forward action.
#define QWebEnginePage_NavigationTypeReload                              4  // The navigation request resulted from a reload action.
#define QWebEnginePage_NavigationTypeRedirect                            6  // The navigation request resulted from a content or server controlled redirect. This also includes automatic reloads. (Added in Qt 5.14)
#define QWebEnginePage_NavigationTypeOther                               5  // The navigation request was triggered by other means not covered by the above.

//enum QWebEnginePage_PermissionPolicy
#define QWebEnginePage_PermissionUnknown                                 0  // It is unknown whether the user grants or denies permission.
#define QWebEnginePage_PermissionGrantedByUser                           1  // The user has granted permission.
#define QWebEnginePage_PermissionDeniedByUser                            2  // The user has denied permission.

//enum QWebEnginePage_RenderProcessTerminationStatus
#define QWebEnginePage_NormalTerminationStatus                           0  // The render process terminated normally.
#define QWebEnginePage_AbnormalTerminationStatus                         1  // The render process terminated with with a non-zero exit status.
#define QWebEnginePage_CrashedTerminationStatus                          2  // The render process crashed, for example because of a segmentation fault.
#define QWebEnginePage_KilledTerminationStatus                           3  // The render process was killed, for example by SIGKILL or task manager kill.

//enum QWebEnginePage_WebAction
#define QWebEnginePage_NoWebAction                                      -1  //  No action is triggered.
#define QWebEnginePage_Back                                              0  // Navigate back in the history of navigated links.
#define QWebEnginePage_Forward                                           1  // Navigate forward in the history of navigated links.
#define QWebEnginePage_Stop                                              2  // Stop loading the current page.
#define QWebEnginePage_Reload                                            3  // Reload the current page.
#define QWebEnginePage_ReloadAndBypassCache                              10 // Reload the current page, but do not use any local cache.
#define QWebEnginePage_Cut                                               4  // Cut the content currently selected into the clipboard.
#define QWebEnginePage_Copy                                              5  // Copy the content currently selected into the clipboard.
#define QWebEnginePage_Paste                                             6  // Paste content from the clipboard.
#define QWebEnginePage_Undo                                              7  // Undo the last editing action.
#define QWebEnginePage_Redo                                              8  // Redo the last editing action.
#define QWebEnginePage_SelectAll                                         9  // Select all content. This action is only enabled when the page's content is focused. The focus can be forced by the JavaScript window.focus() call, or the FocusOnNavigationEnabled setting should be enabled to get automatic focus.
#define QWebEnginePage_PasteAndMatchStyle                                11 // Paste content from the clipboard with current style.
#define QWebEnginePage_OpenLinkInThisWindow                              12 // Open the current link in the current window. (Added in Qt 5.6)
#define QWebEnginePage_OpenLinkInNewWindow                               13 // Open the current link in a new window. Requires implementation of createWindow(). (Added in Qt 5.6)
#define QWebEnginePage_OpenLinkInNewTab                                  14 // Open the current link in a new tab. Requires implementation of createWindow(). (Added in Qt 5.6)
#define QWebEnginePage_OpenLinkInNewBackgroundTab                        31 // Open the current link in a new background tab. Requires implementation of createWindow(). (Added in Qt 5.7)
#define QWebEnginePage_CopyLinkToClipboard                               15 // Copy the current link to the clipboard. (Added in Qt 5.6)
#define QWebEnginePage_CopyImageToClipboard                              17 // Copy the clicked image to the clipboard. (Added in Qt 5.6)
#define QWebEnginePage_CopyImageUrlToClipboard                           18 // Copy the clicked image's URL to the clipboard. (Added in Qt 5.6)
#define QWebEnginePage_CopyMediaUrlToClipboard                           20 // Copy the hovered audio or video's URL to the clipboard. (Added in Qt 5.6)
#define QWebEnginePage_ToggleMediaControls                               21 // Toggle between showing and hiding the controls for the hovered audio or video element. (Added in Qt 5.6)
#define QWebEnginePage_ToggleMediaLoop                                   22 // Toggle whether the hovered audio or video should loop on completetion or not. (Added in Qt 5.6)
#define QWebEnginePage_ToggleMediaPlayPause                              23 // Toggle the play/pause state of the hovered audio or video element. (Added in Qt 5.6)
#define QWebEnginePage_ToggleMediaMute                                   24 // Mute or unmute the hovered audio or video element. (Added in Qt 5.6)
#define QWebEnginePage_DownloadLinkToDisk                                16 // Download the current link to the disk. Requires a slot for downloadRequested(). (Added in Qt 5.6)
#define QWebEnginePage_DownloadImageToDisk                               19 // Download the highlighted image to the disk. Requires a slot for downloadRequested(). (Added in Qt 5.6)
#define QWebEnginePage_DownloadMediaToDisk                               25 // Download the hovered audio or video to the disk. Requires a slot for downloadRequested(). (Added in Qt 5.6)
#define QWebEnginePage_InspectElement                                    26 // Trigger any attached Web Inspector to inspect the highlighed element. (Added in Qt 5.6)
#define QWebEnginePage_ExitFullScreen                                    27 // Exit the fullscreen mode. (Added in Qt 5.6)
#define QWebEnginePage_RequestClose                                      28 // Request to close the web page. If defined, the window.onbeforeunload handler is run, and the user can confirm or reject to close the page. If the close request is confirmed, windowCloseRequested is emitted. (Added in Qt 5.6)
#define QWebEnginePage_Unselect                                          29 // Clear the current selection. (Added in Qt 5.7)
#define QWebEnginePage_SavePage                                          30 // Save the current page to disk. MHTML is the default format that is used to store the web page on disk. Requires a slot for downloadRequested(). (Added in Qt 5.7)
#define QWebEnginePage_ViewSource                                        32 // Show the source of the current page in a new tab. Requires implementation of createWindow(). (Added in Qt 5.8)
#define QWebEnginePage_ToggleBold                                        33 // Toggles boldness for the selection or at the cursor position. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_ToggleItalic                                      34 // Toggles italics for the selection or at the cursor position. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_ToggleUnderline                                   35 // Toggles underlining of the selection or at the cursor position. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_ToggleStrikethrough                               36 // Toggles striking through the selection or at the cursor position. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_AlignLeft                                         37 // Aligns the lines containing the selection or the cursor to the left. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_AlignCenter                                       38 // Aligns the lines containing the selection or the cursor at the center. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_AlignRight                                        39 // Aligns the lines containing the selection or the cursor to the right. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_AlignJustified                                    40 // Stretches the lines containing the selection or the cursor so that each line has equal width. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_Indent                                            41 // Indents the lines containing the selection or the cursor. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_Outdent                                           42 // Outdents the lines containing the selection or the cursor. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_InsertOrderedList                                 43 // Inserts an ordered list at the current cursor position, deleting the current selection. Requires contenteditable="true". (Added in Qt 5.10)
#define QWebEnginePage_InsertUnorderedList                               44 // Inserts an unordered list at the current cursor position, deleting the current selection. Requires contenteditable="true". (Added in Qt 5.10)

//enum QWebEnginePage_WebWindowType
#define QWebEnginePage_WebBrowserWindow                                  0  // A complete web browser window.
#define QWebEnginePage_WebBrowserTab                                     1  // A web browser tab.
#define QWebEnginePage_WebDialog                                         2  // A window without decoration.
#define QWebEnginePage_WebBrowserBackgroundTab                           3  // A web browser tab without hiding the current visible WebEngineView. (Added in Qt 5.7)

//enum QWebEngineScript_InjectionPoint
#define QWebEngineScript_DocumentCreation                                2  // The script will be executed as soon as the document is created. This is not suitable for any DOM operation.
#define QWebEngineScript_DocumentReady                                   1  // The script will run as soon as the DOM is ready. This is equivalent to the DOMContentLoaded event firing in JavaScript.
#define QWebEngineScript_Deferred                                        0  // The script will run when the page load finishes, or 500ms after the document is ready, whichever comes first.

//enum QWebEngineScript_ScriptWorldId
#define QWebEngineScript_MainWorld                                       0  // The world used by the page's web contents. It can be useful in order to expose custom functionality to web contents in certain scenarios.
#define QWebEngineScript_ApplicationWorld                                1  // The default isolated world used for application level functionality implemented in JavaScript.
#define QWebEngineScript_UserWorld                                       2  // The first isolated world to be used by scripts set by users if the application is not making use of more worlds. As a rule of thumb, if that functionality is exposed to the application users, each individual script should probably get its own isolated world.

//enum QWebEngineSettings_FontFamily
#define QWebEngineSettings_StandardFont                                  0  //
#define QWebEngineSettings_FixedFont                                     1  //
#define QWebEngineSettings_SerifFont                                     2  //
#define QWebEngineSettings_SansSerifFont                                 3  //
#define QWebEngineSettings_CursiveFont                                   4  //
#define QWebEngineSettings_FantasyFont                                   5  //
#define QWebEngineSettings_PictographFont                                6  // (added in Qt 5.7)

//enum QWebEngineSettings_FontSize
#define QWebEngineSettings_MinimumFontSize                               0  // The hard minimum font size.
#define QWebEngineSettings_MinimumLogicalFontSize                        1  // The minimum logical font size that is applied when zooming out.
#define QWebEngineSettings_DefaultFontSize                               2  // The default font size for regular text.
#define QWebEngineSettings_DefaultFixedFontSize                          3  // The default font size for fixed-pitch text.
                                                                            //
//enum QWebEngineSettings_WebAttribute
#define QWebEngineSettings_AutoLoadImages                                0  // Automatically dowloads images for web pages. When this setting is disabled, images are loaded from the cache. Enabled by default.
#define QWebEngineSettings_JavascriptEnabled                             1  // Enables the running of JavaScript programs. Enabled by default.
#define QWebEngineSettings_JavascriptCanOpenWindows                      2  // Allows JavaScript programs to open popup windows without user interaction. Enabled by default.
#define QWebEngineSettings_JavascriptCanAccessClipboard                  3  // Allows JavaScript programs to read from and write to the clipboard. Writing to the clipboard is always allowed if it is specifically requested by the user. Disabled by default.
#define QWebEngineSettings_LinksIncludedInFocusChain                     4  // Includes hyperlinks in the keyboard focus chain. Enabled by default.
#define QWebEngineSettings_LocalStorageEnabled                           5  // Enables support for the HTML 5 local storage feature. Enabled by default.
#define QWebEngineSettings_LocalContentCanAccessRemoteUrls               6  // Allows locally loaded documents to ignore cross-origin rules so that they can access remote resources that would normally be blocked, because all remote resources are considered cross-origin for a local file. Remote access that would not be blocked by cross-origin rules is still possible when this setting is disabled (default). Note that disabling this setting does not stop XMLHttpRequests or media elements in local files from accessing remote content. Basically, it only stops some HTML subresources, such as scripts, and therefore disabling this setting is not a safety mechanism.
#define QWebEngineSettings_XSSAuditingEnabled                            7  // Monitors load requests for cross-site scripting attempts. Suspicious scripts are blocked and reported in the inspector's JavaScript console. Disabled by default, because it might negatively affect performance.
#define QWebEngineSettings_SpatialNavigationEnabled                      8  // Enables the Spatial Navigation feature, which means the ability to navigate between focusable elements, such as hyperlinks and form controls, on a web page by using the Left, Right, Up and Down arrow keys. For example, if a user presses the Right key, heuristics determine whether there is an element they might be trying to reach towards the right and which element they probably want. Disabled by default.
#define QWebEngineSettings_LocalContentCanAccessFileUrls                 9  // Allows locally loaded documents to access other local URLs. Enabled by default.
#define QWebEngineSettings_HyperlinkAuditingEnabled                      10 // Enables support for the ping attribute for hyperlinks. Disabled by default.
#define QWebEngineSettings_ScrollAnimatorEnabled                         11 // Enables animated scrolling. Disabled by default.
#define QWebEngineSettings_ErrorPageEnabled                              12 // Enables displaying the built-in error pages of Chromium. Enabled by default.
#define QWebEngineSettings_PluginsEnabled                                13 // Enables support for Pepper plugins, such as the Flash player. Disabled by default. See also Pepper Plugin API. (Added in Qt 5.6)
#define QWebEngineSettings_FullScreenSupportEnabled                      14 // Enables fullscreen support in an application. Disabled by default. (Added in Qt 5.6)
#define QWebEngineSettings_ScreenCaptureEnabled                          15 // Enables screen capture in an application. Disabled by default. (Added in Qt 5.7)
#define QWebEngineSettings_WebGLEnabled                                  16 // Enables support for HTML 5 WebGL. Enabled by default if available. (Added in Qt 5.7)
#define QWebEngineSettings_Accelerated2dCanvasEnabled                    17 // Specifies whether the HTML5 2D canvas should be a OpenGL framebuffer. This makes many painting operations faster, but slows down pixel access. Enabled by default if available. (Added in Qt 5.7)
#define QWebEngineSettings_AutoLoadIconsForPage                          18 // Automatically downloads icons for web pages. Enabled by default. (Added in Qt 5.7)
#define QWebEngineSettings_TouchIconsEnabled                             19 // Enables support for touch icons and precomposed touch icons Disabled by default. (Added in Qt 5.7)
#define QWebEngineSettings_FocusOnNavigationEnabled                      20 // Gives focus to the view associated with the page, whenever a navigation operation occurs (load, stop, reload, reload and bypass cache, forward, backward, set content, and so on). Enabled by default. (Added in Qt 5.8)
#define QWebEngineSettings_PrintElementBackgrounds                       21 // Turns on printing of CSS backgrounds when printing a web page. Enabled by default. (Added in Qt 5.8)
#define QWebEngineSettings_AllowRunningInsecureContent                   22 // By default, HTTPS pages cannot run JavaScript, CSS, plugins or web-sockets from HTTP URLs. This provides an override to get the old insecure behavior. Disabled by default. (Added in Qt 5.8)
#define QWebEngineSettings_AllowGeolocationOnInsecureOrigins             23 // Since Qt 5.7, only secure origins such as HTTPS have been able to request Geolocation features. This provides an override to allow non secure origins to access Geolocation again. Disabled by default. (Added in Qt 5.9)


#endif
