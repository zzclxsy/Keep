import QtQuick 2.0
import QtQml 2.12
import CalendarAPI 1.0
Item {
    id: item1
    CalendarAPI{
        id:calendarApi
    }

    function currMonthLight(week, day)
    {
        obj[week + day - 1].color = "#50ff0000"
    }

    function now()
    {
        var ret = calendarApi.now()
        var date = JSON.parse(ret)
        if (date == null)
            return
        var week = date["monthView"]["week"]
        var dayNum = date["monthView"]["dayNum"]
        var day = date["nowDate"]["day"]
        setCalendarView(week, dayNum)
        currMonthLight(week, day)
        title.text = calendarApi.date()
    }

    function lastMonth()
    {
        var ret = calendarApi.lastMonth()
        var date = JSON.parse(ret)
        if (date == null)
            return
        var week = date["monthView"]["week"]
        var dayNum = date["monthView"]["dayNum"]
        var day = date["nowDate"]["day"]

        setCalendarView(week, dayNum)
        if (calendarApi.isCurrentMonth())
        {
            currMonthLight(week, day)
        }
        title.text = calendarApi.date()
    }

    function nextMonth()
    {
        var ret = calendarApi.nextMonth()
        var date = JSON.parse(ret)
        if (date == null)
            return
        var week = date["monthView"]["week"]
        var dayNum = date["monthView"]["dayNum"]
        var day = date["nowDate"]["day"]

        setCalendarView(week, dayNum)
        if (calendarApi.isCurrentMonth())
        {
            currMonthLight(week, day)
        }
        title.text = calendarApi.date()
    }

    function setCalendarView(week, dayNum)
    {
        if ((week + dayNum -1) <= 35)
        {
            for(var m = 1; m <= 7; m++)
            {
                obj[35 + m].visible = false
            }
        }
        else
        {
            for(m = 1; m <= 7; m++)
            {
                obj[35 + m].visible = true
            }
        }

        //本月
        for(var j =0; j < dayNum; j++)
        {
            obj[week + j].rectText = j + 1
            obj[week + j].color = "#ffffff"
        }

        //取部分上月天数
        var ret = calendarApi.lastMonth()
        var date = JSON.parse(ret)
        if (date == null)
            return

        var lastDayNum = date["monthView"]["dayNum"]
        for(j = 1; j < week; j++)
        {
            obj[j].rectText = (lastDayNum - week +j +1)
            obj[j].color = "#50888888"
        }

        //下一个月从1号开始
        var index = 1
        for(j = week +dayNum; j <= 42 ;j++)
        {
            obj[j].rectText = index
            obj[j].color = "#50888888"
            index++
        }

        calendarApi.nextMonth()
    }

    property var obj: []
    Grid{
        id:grid
        anchors.fill: parent
        anchors.rightMargin: 134
        anchors.topMargin: 79
        rows: 7
        columns: 7
        spacing:10
    }

    Component{
        id:rectComp
        Rectangle{
            width: 50
            height: 50
            property alias rectText: textComp.text
            border.width: 1
            Text {
                id:textComp
                anchors.fill: parent
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onFocusChanged: {
                if (focus === true)
                    border.color="red"
                else
                    border.color="#000000"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    parent.focus = true
                }
            }
        }
    }

    Rectangle {
        id: titleRect
        height: 79
        color: "#ffffff"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0

        Text {
            id: title
            anchors.fill: parent
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Rectangle {
        id: rectangle
        x: 532
        y: 94
        width: 108
        height: 48
        color: "#ffffff"

        Text {
            id: text1
            text: qsTr("last")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                lastMonth()
            }
        }
    }

    Rectangle {
        id: rectangle1
        x: 532
        y: 166
        width: 108
        height: 48
        color: "#ffffff"

        Text {
            id: text2
            text: qsTr("now")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                console.log("34")
                now()
            }
        }
    }

    Rectangle {
        id: rectangle2
        x: 532
        y: 245
        width: 108
        height: 48
        color: "#ffffff"

        Text {
            id: text3
            text: qsTr("next")
            anchors.fill: parent
            font.pixelSize: 12
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                nextMonth()
            }
        }
    }

    Component.onCompleted: {
        rectComp.createObject(grid,{"rectText":"一"})
        rectComp.createObject(grid,{"rectText":"二"})
        rectComp.createObject(grid,{"rectText":"三"})
        rectComp.createObject(grid,{"rectText":"四"})
        rectComp.createObject(grid,{"rectText":"五"})
        rectComp.createObject(grid,{"rectText":"六"})
        rectComp.createObject(grid,{"rectText":"日"})

        for(var i=1;i <= 42;i++)
        {
            obj[i]=(rectComp.createObject(grid))
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
