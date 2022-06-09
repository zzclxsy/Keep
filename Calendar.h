#ifndef CALENDAR_H
#define CALENDAR_H

#include <QObject>

class Calendar : public QObject
{
    Q_OBJECT
public:
    explicit Calendar(QObject *parent = nullptr);
    Q_INVOKABLE bool isCurrentMonth();
    Q_INVOKABLE void reset();
    Q_INVOKABLE QString date();
    Q_INVOKABLE QString now();
    Q_INVOKABLE QString nextMonth();
    Q_INVOKABLE QString lastMonth();
    Q_INVOKABLE QString nextYear();
    Q_INVOKABLE QString lastYear();
    Q_INVOKABLE QString gotoDate(QString date);

private:
    QString CalendarView(int year, int month, int day);
    int GetWeekDate(int y, int m, int d);
    int GetDayNumofMonth(int y, int m);

private:
    int m_day;
    int m_month;
    int m_year;
};

#endif // CALENDAR_H
