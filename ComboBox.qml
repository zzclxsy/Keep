import QtQuick 2.0
import QtGraphicalEffects 1.12
import QtQml 2.12
import QtQuick.Controls 2.5
Item {
    id: item1
    width: 177

    //外部接口
    property alias dataText: showText.text
    signal dataBeChosen(string data);
    signal hasOpen()
    signal hasClose()
    property var beforeITEM

    //内部model数据
    property var jsonModel
    function openBox()
    {
        mouseArea.isOpen = true
        image.source = "qrc:/image/arrow-up.svg"
        dropShadow.visible = true
        rectangle2.visible = true
        listView.positionViewAtIndex(listView.currentIndex, ListView.Center)
        hasOpen()
    }
    function closeBox()
    {
        mouseArea.isOpen = false
        image.source = "qrc:/image/arrow-down.svg"
        dropShadow.visible = false
        rectangle2.visible = false
        hasClose()
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
        height: 0
        color: "#ffffff"
        radius: 5
        anchors.top: rectangle.bottom
        anchors.topMargin: 16
        anchors.horizontalCenter: parent.horizontalCenter

        ListView {
            id: listView
            orientation: ListView.Vertical//垂直列表
            clip: true
            ScrollBar.vertical: ScrollBar {
                id: scrollBar
            }
            anchors.fill: parent
            anchors.rightMargin: 4
            anchors.leftMargin: 4
            anchors.bottomMargin: 4
            anchors.topMargin: 4
            model : jsonModel
            currentIndex:20
            delegate:
                Rectangle {
                height: 40
                width: listView.width
                property alias textColor: text.color
                Text {
                    id:text
                    text: modelData.name
                    font.pixelSize: 20
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                }
                MouseArea{
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        if (index === listView.currentIndex)
                            return
                        text.color = "#6699FF"
                    }
                    onExited: {
                        if (index === listView.currentIndex)
                            return
                        text.color = "#000000"
                    }
                    onClicked: {
                        showText.text = text.text
                        closeBox()
                        dataBeChosen(text.text)
                        beforeITEM.textColor = "#000000"
                        listView.currentIndex = index
                        listView.currentItem.textColor = "red"
                        beforeITEM = listView.currentItem
                    }
                }
            }
        }
    }

    function setModelData(array)
    {
        var sum =0
        var data = []
        for (var i = 0; i < array.length; i++)
        {
            var tmp={}
            tmp["name"] = array[i]
            data.push(tmp)
            sum++
        }
        jsonModel = data
        if (sum*40 > 300)
            rectangle2.height = 300
        else
            rectangle2.height = sum*40
    }

    function defaultData(str,index)
    {
        showText.text = str
        listView.positionViewAtIndex(index, ListView.Center)
        listView.currentIndex = index
        listView.currentItem.textColor = "red"
        beforeITEM = listView.currentItem
    }
}


