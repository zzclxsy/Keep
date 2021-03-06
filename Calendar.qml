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
        if (currObj !==null)
        {
            var currDay = currObj.rectText
            currObj.focus = false
        }

        var ret = calendarApi.now()
        var date = JSON.parse(ret)
        if (date === null)
            return
        var week = date["monthView"]["week"]
        var dayNum = date["monthView"]["dayNum"]
        var day = date["nowDate"]["day"]
        var month = date["monthView"]["month"]
        var year = date["monthView"]["year"]

        setCalendarView(week, dayNum, month, year)
        currMonthLight(week, day)
        title.text = calendarApi.date()

        if (currObj !==null)
        {
            obj[parseInt(week) + parseInt(currDay) - 1].focus = true
            currObj = obj[parseInt(week) + parseInt(currDay) - 1]
        }
    }

    function lastMonth()
    {
        if (currObj !==null)
        {
            var currDay = currObj.rectText
            currObj.focus = false
        }
        var ret = calendarApi.lastMonth()
        var date = JSON.parse(ret)
        if (date === null)
            return
        var week = date["monthView"]["week"]
        var dayNum = date["monthView"]["dayNum"]
        var month = date["monthView"]["month"]
        var year = date["monthView"]["year"]

        setCalendarView(week, dayNum, month, year)
        if (calendarApi.isCurrentMonth())
        {
            var day = date["nowDate"]["day"]
            currMonthLight(week, day)
        }
        title.text = calendarApi.date()

        if (currObj !==null)
        {
            obj[parseInt(week) + parseInt(currDay) - 1].focus = true
            currObj = obj[parseInt(week) + parseInt(currDay) - 1]
        }

    }

    function nextMonth()
    {
        if (currObj !==null)
        {
            var currDay = currObj.rectText
            currObj.focus = false
        }

        var ret = calendarApi.nextMonth()
        var date = JSON.parse(ret)
        if (date === null)
            return
        var week = date["monthView"]["week"]
        var dayNum = date["monthView"]["dayNum"]
        var month = date["monthView"]["month"]
        var year = date["monthView"]["year"]

        setCalendarView(week, dayNum, month, year)
        if (calendarApi.isCurrentMonth())
        {
            var day = date["nowDate"]["day"]
            currMonthLight(week, day)
        }
        title.text = calendarApi.date()

        if (currObj !==null)
        {
            obj[parseInt(week) + parseInt(currDay) - 1].focus = true
            currObj = obj[parseInt(week) + parseInt(currDay) - 1]
        }
    }

    function  gotoDate(gotoYear,gotoMonth)
    {
        if (currObj !==null)
        {
            var currDay = currObj.rectText
            currObj.focus = false
        }

        var arr = {}
        arr["year"] = gotoYear
        arr["month"] = gotoMonth
        arr["day"] = 1
        var ret = calendarApi.gotoDate(JSON.stringify(arr))
        var date = JSON.parse(ret)
        if (date === null)
            return
        var week = date["monthView"]["week"]
        var dayNum = date["monthView"]["dayNum"]
        var month = date["monthView"]["month"]
        var year = date["monthView"]["year"]

        setCalendarView(week, dayNum, month, year)
        if (calendarApi.isCurrentMonth())
        {
            var day = date["nowDate"]["day"]
            currMonthLight(week, day)
        }
        title.text = calendarApi.date()

        if (currObj !==null)
        {
            obj[parseInt(week) + parseInt(currDay) - 1].focus = true
            currObj = obj[parseInt(week) + parseInt(currDay) - 1]
        }
    }

    function setCalendarView(week, dayNum,month,year)
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

        //??????
        for(var j =0; j < dayNum; j++)
        {
            obj[week + j].rectText = j + 1
            obj[week + j].opacity = 1
            obj[week + j].color = "#ffffff"
            obj[week + j].month = month
            obj[week + j].year = year
        }

        //?????????????????????
        var ret = calendarApi.lastMonth()
        var date = JSON.parse(ret)
        if (date === null)
            return

        var lastDayNum = date["monthView"]["dayNum"]
        var lastmonth = date["monthView"]["month"]
        var lastyear = date["monthView"]["year"]
        for(j = 1; j < week; j++)
        {
            obj[j].rectText = (lastDayNum - week +j +1)
            obj[j].month = lastmonth
            obj[j].year = lastyear
            obj[j].opacity = 0.5
        }

        //???????????????1?????????
        var index = 1
        if (month === 12){
            month = 1
            year++;
        }
        else
            month++
        for(j = week +dayNum; j <= 42 ;j++)
        {
            obj[j].rectText = index
            obj[j].month = month
            obj[j].year = year
            obj[j].opacity = 0.5
            index++
        }

        calendarApi.nextMonth()
    }

    property var obj: []
    property var currObj:null
    Grid{
        id:grid
        x: 224
        y: 79
        width: 365
        height: 365
        anchors.horizontalCenter: parent.horizontalCenter
        rows: 7
        columns: 7
        spacing:3
    }

    Component{
        id:rectComp
        Rectangle{
            width: 50
            height: 50
            border.width: 2
            border.color:"#00000000"
            radius: 6
            property var month
            property var year
            property alias rectText: textComp.text
            property bool isCanChoice: true
            Text {
                id:textComp
                anchors.fill: parent
                font.pixelSize: 20
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            onFocusChanged: {
                if (focus === false){
                    border.color="#00000000"
                }else {
                    if(!isCanChoice)
                        return
                    border.color="#FF6666"
                }

            }


            MouseArea{
                anchors.fill: parent
                hoverEnabled: true

                onEntered: {
                    if(!isCanChoice)
                        return

                    if (parent.focus ===false)
                        border.color="#9999FF"

                }
                onExited: {
                    if (!parent.focus)
                        border.color="#00000000"
                }
                onClicked: {
                    yearcomboBox.closeBox()
                    monthcomboBox.closeBox()
                    parent.focus = true
                    currObj = parent
                    console.log(parent.year+"???" +parent.month +"???"+ parent.rectText + "???")
                    if (calendarApi.currMonth === 1){
                        if (parent.month === 12){
                            lastMonth()
                            return
                        }
                    }else if (calendarApi.currMonth === 12)
                    {
                        if (parent.month === 1){
                            nextMonth()
                            return
                        }
                    }

                    if (parent.month < calendarApi.currMonth)
                        lastMonth()
                    else if (parent.month > calendarApi.currMonth)
                        nextMonth()

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

        ComboBox {
            id: monthcomboBox
            x: 232
            y: 0
            width: 123
            height: 44
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 147
            anchors.verticalCenterOffset: 0
            onDataBeChosen: {
                 gotoDate(parseInt(yearcomboBox.dataText), parseInt(data))
            }
            Connections{
                target: yearcomboBox
                onHasOpen:{
                    monthcomboBox.closeBox()
                }
            }
        }

        ComboBox {
            id: yearcomboBox
            y: 31
            width: 123
            height: 44
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 147
            anchors.verticalCenterOffset: 0
            onDataBeChosen: {
                 gotoDate(parseInt(data), parseInt(monthcomboBox.dataText))
            }

            Connections{
                target: monthcomboBox
                onHasOpen:{
                    yearcomboBox.closeBox()
                }
            }
        }
    }

    Component.onCompleted: {
        rectComp.createObject(grid,{"rectText":"???","isCanChoice":false})
        rectComp.createObject(grid,{"rectText":"???","isCanChoice":false})
        rectComp.createObject(grid,{"rectText":"???","isCanChoice":false})
        rectComp.createObject(grid,{"rectText":"???","isCanChoice":false})
        rectComp.createObject(grid,{"rectText":"???","isCanChoice":false})
        rectComp.createObject(grid,{"rectText":"???","isCanChoice":false})
        rectComp.createObject(grid,{"rectText":"???","isCanChoice":false})

        for(var i=1;i <= 42;i++)
        {
            obj[i]=(rectComp.createObject(grid))
        }
        now()
        var arr=[]
        for (i = 1; i <= 12 ; i++)
        {
            arr.push(i+"???")
        }

        monthcomboBox.setModelData(arr)
        monthcomboBox.defaultData(calendarApi.currMonth + "???",calendarApi.currMonth - 1)
        arr=[]
        for (i = 1900; i <= 2090 ; i++)
        {
            arr.push(i+"???")
        }
        yearcomboBox.setModelData(arr)
        yearcomboBox.defaultData(calendarApi.currYear + "???",calendarApi.currYear - 1900)
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
