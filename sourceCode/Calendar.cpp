#include "Calendar.h"
#include "QJsonObject"
#include <QJsonDocument>
#include <QDate>
#include <QDebug>
Calendar::Calendar(QObject *parent) : QObject(parent)
{
    reset();
}

bool Calendar::isCurrentMonth()
{
    QDate date = QDate::currentDate();
    if (m_year == date.year() && m_month == date.month())
        return true;

    return false;
}

void Calendar::reset()
{
    QDate date = QDate::currentDate();
    m_day = date.day();
    m_month = date.month();
    m_year = date.year();
}

QString Calendar::date()
{
    QString date = QString("%1年 %2月").arg(m_year).arg(m_month);
    return date;
}

QString Calendar::now()
{
    reset();
    return CalendarView(m_year, m_month, m_day);
}

QString Calendar::nextMonth()
{
    if (m_month == 12)
    {
        m_month = 1;
        m_year++;
    }
    else
        m_month++;

    return CalendarView(m_year, m_month, m_day);
}

QString Calendar::lastMonth()
{
    if (m_month == 1){
        m_month = 12;
        m_year--;
    }
    else
        m_month--;

    return CalendarView(m_year, m_month, m_day);
}

QString Calendar::nextYear()
{
    m_year++;
    return CalendarView(m_year, m_month, m_day);
}

QString Calendar::lastYear()
{
    m_year--;
    return CalendarView(m_year, m_month, m_day);
}

QString Calendar::gotoDate(QString date)
{
    QJsonParseError JsonError;
    QJsonDocument JsonParse = QJsonDocument::fromJson(date.toUtf8(), &JsonError);

    if(JsonError.error != QJsonParseError::NoError)
        return QString();

    do {
        if(!JsonParse.isObject())
            break;

        QJsonObject obj = JsonParse.object();

        if (!obj.contains("year"))
            break;
        int year = obj.value("year").toInt();

        if (!obj.contains("month"))
            break;
        int month = obj.value("month").toInt();

        if (!obj.contains("day"))
            break;
        int day = obj.value("day").toInt();

        return CalendarView(year, month, day);;
    } while (0);
    return QString();
}

int Calendar::currDay() const
{
    return m_day;
}

int Calendar::currMonth() const
{
    return m_month;
}

int Calendar::currYear() const
{
    return m_year;
}

QString Calendar::CalendarView(int year, int month, int day)
{
    QJsonObject root;
    QJsonObject nowDate;
    QJsonObject monthView;

    //当天日期
    nowDate["year"] = year;
    nowDate["month"] = month;
    nowDate["day"] = day;
    nowDate["week"] = GetWeekDate(year, month, day);

    //当月视图
    monthView["month"] = m_month;
    monthView["year"] = m_year;
    monthView["dayNum"] = GetDayNumofMonth(year,month);
    monthView["week"] = GetWeekDate(year, month, 1);
    root["nowDate"] = nowDate;
    root["monthView"] = monthView;

    QJsonDocument document;
    document.setObject(root);
    QByteArray byteArray = document.toJson(QJsonDocument::Indented);
    return QString (byteArray);
}

int Calendar::GetWeekDate(int y, int m, int d)
{
    int week;
    if (m == 1 || m == 2) {
        y = y - 1;
        m = m + 12;
    }
    week = (d + 2 * m + 3 * (m + 1) / 5 + y + y / 4 - y / 100 + y / 400 + 1) % 7;
    if (week == 0)
        week = 7;
    return week;//其中0-6表示周日到周六
}

int Calendar::GetDayNumofMonth(int y, int m)
{
    int monthmax;
    if (m == 1 || m == 3 || m == 5 || m == 7 || m == 8 || m == 10 || m == 12) monthmax = 31;
    if (m == 4 || m == 6 || m == 9 || m == 11) monthmax = 30;
    if (m == 2)
    {
        if ((y % 4 == 0 && y % 100 != 0) || y % 400 == 0)//闰年
            monthmax = 29;
        else//非闰年
            monthmax = 28;
    }
    return monthmax;
}
