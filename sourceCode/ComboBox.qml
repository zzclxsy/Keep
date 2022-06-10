import QtQuick 2.0
import QtGraphicalEffects 1.12
import QtQml 2.12
Item {
    id: item1
    width: 177
    property var jsonModel
    function openBox()
    {
        mouseArea.isOpen = true
        image.source = "qrc:/image/arrow-up.svg"
        dropShadow.visible = true
        rectangle2.visible = true
    }
    function closeBox()
    {
        mouseArea.isOpen = false
        image.source = "qrc:/image/arrow-down.svg"
        dropShadow.visible = false
        rectangle2.visible = false
    }

    Rectangle {
        id: rectangle
        x: 43
        y: 0
        width: item1.width
        height: 39
        color: "#ffffff"
        radius: 8
        border.color: "#c8bfbf"
        border.width: 1
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            id: showText
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            font.pixelSize: 19
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            anchors.rightMargin: 35
            anchors.leftMargin: 0
            anchors.bottomMargin: 1
            anchors.topMargin: 0
        }

        Rectangle {
            id: rectangle1
            x: 131
            y: 4
            width: 27
            height: 37
            color: "#00f19696"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 8

            Image {
                id: image
                y: -4
                height: 100
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                source: "qrc:/image/arrow-down.svg"
                fillMode: Image.PreserveAspectFit
            }
            MouseArea{
                id:mouseArea
                anchors.fill: parent
                property bool isOpen: false
                onClicked: {
                    if (isOpen === false){
                        openBox()
                    }else if (isOpen){

                        closeBox()
                    }
                }
            }
        }

    }

    DropShadow {
        id:dropShadow
        visible: false
        anchors.fill: rectangle2
        horizontalOffset: 0
        verticalOffset: 0
        radius: 5
        samples: 11
        source: rectangle2
        color: "black"
    }

    Rectangle {
        id: rectangle2
        visible: false
        x: 0
        width: item1.width -5
        height: 365
        color: "#ffffff"
        radius: 5
        anchors.top: rectangle.bottom
        anchors.topMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter

        ListView {
            id: listView
            clip: true
            anchors.fill: parent
            anchors.rightMargin: 4
            anchors.leftMargin: 4
            anchors.bottomMargin: 4
            anchors.topMargin: 4
            model:jsonModel
            delegate:
                Rectangle {
                height: 40
                width: listView.width
                Text {
                    id:text
                    text: name
                    font.pixelSize: 20
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        text.color = "#6699FF"
                    }
                    onExited: {
                        text.color = "#000000"
                    }
                    onClicked: {
                        showText.text = text.text
                        closeBox()
                    }
                }
            }
        }
    }
    Component.onCompleted: {
       jsonModel = []
        jsonModel["name"] = "zz"
        jsonModel["age"] = "11"
    }

}


