import QtQuick 2.12
import QtQuick.Window 2.12
import QtQml 2.12
Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    Calendar{
        anchors.fill: parent
        anchors.bottomMargin: -11
    }
}
