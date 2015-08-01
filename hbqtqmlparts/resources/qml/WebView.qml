
import QtQuick 2.2
import QtWebView 1.0
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2


Rectangle {
    visible: true

    function setUrl( cUrl ) {
       webView.url = cUrl;
    }
    function stop() {
       webView.stop();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 2

        ToolBar {
            id: navigationBar
            visible: true
            Layout.fillWidth: true

            RowLayout {
                spacing: 0

                ToolButton {
                    id: backButton
                    tooltip: qsTr("Back")
                    iconSource: "qrc:/hbqtqml/resources/png/left-32.png"
                    onClicked: webView.goBack()
                    enabled: webView.canGoBack
                    Layout.preferredWidth: navigationBar.height
                    style: ButtonStyle {
                        background: Rectangle { color: "transparent" }
                    }
                }

                ToolButton {
                    id: forwardButton
                    tooltip: qsTr("Forward")
                    iconSource: "qrc:/hbqtqml/resources/png/right-32.png"
                    onClicked: webView.goForward()
                    enabled: webView.canGoForward
                    Layout.preferredWidth: navigationBar.height
                    style: ButtonStyle {
                        background: Rectangle { color: "transparent" }
                    }
                }

                ToolButton {
                    id: reloadButton
                    tooltip: webView.loading ? qsTr("Stop"): qsTr("Refresh")
                    //iconSource: webView.loading ? "qrc:/hbqtqml/resources/png/stop-32.png" : "qrc:/hbqtqml/resources/png/refresh-32.png"
                    iconSource: "qrc:/hbqtqml/resources/png/stop-32.png"
                    onClicked: webView.loading ? webView.stop() : webView.reload()
                    Layout.preferredWidth: navigationBar.height
                    style: ButtonStyle {
                        background: Rectangle { color: "transparent" }
                    }
                }

                Item { Layout.preferredWidth: 5 }

                TextField {
                    Layout.fillWidth: true
                    id: urlField
                    inputMethodHints: Qt.ImhUrlCharactersOnly | Qt.ImhPreferLowercase
                    text: webView.url

                    onAccepted: webView.url = utils.fromUserInput(text)
                }

                Item { Layout.preferredWidth: 5 }

                ToolButton {
                    id: goButton
                    text: qsTr("Go")
                    Layout.preferredWidth: navigationBar.height
                    onClicked: {
                        Qt.inputMethod.commit()
                        Qt.inputMethod.hide()
                        webView.url = utils.fromUserInput(urlField.text)
                    }
                    style: ButtonStyle {
                        background: Rectangle { color: "transparent" }
                    }
                }

                Item { Layout.preferredWidth: 10 }
            }
        }

        WebView {
            id                    : webView
            objectName            : "webView"
            url                   : "about:blank"
            visible               : true
            Layout.fillHeight     : true
            Layout.fillWidth      : true
        }

        StatusBar {
            id     : statusBar
            Layout.fillWidth: true
            visible: webView.loading && Qt.platform.os !== "ios"
            RowLayout {
                Label { text: webView.loadProgress == 100 ? qsTr("Done") : qsTr("Loading: ") + webView.loadProgress + "%" }
            }
        }
    }
}

