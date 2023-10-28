import 'package:encontrarCuidado/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';

class HourQueue extends StatelessWidget {
  final Function nextDays, previousDays;
  final ObservableList<DateTime> days;
  const HourQueue({
    Key key,
    this.nextDays,
    this.previousDays,
    this.days,
  }) : super(key: key);

  String getData(DateTime _date, String type) {
    if (type == 'week_day') {
      String weekDay = DateFormat("EEEE", "pt_BR").format(_date);
      String weekDayFormated =
          weekDay.substring(0, 1).toUpperCase() + weekDay.substring(1, 3);
      return weekDayFormated;
    } else if (type == 'day_month') {
      String monthDay = _date.day.toString().padLeft(2, '0');
      String month = DateFormat('MMM', "pt_BR").format(_date);
      String monthFormated =
          month.substring(0, 1).toUpperCase() + month.substring(1, 3);
      return '$monthDay $monthFormated';
    } else {
      return 'Type is wrong';
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<String> weekDays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];
    return Column(
      children: [
        Container(
          width: maxWidth(context),
          padding: EdgeInsets.symmetric(
              horizontal: wXD(17, context), vertical: wXD(15, context)),
          child: Row(
            children: [
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: previousDays,
                child: Container(
                  padding: EdgeInsets.only(right: wXD(2, context)),
                  height: wXD(27, context),
                  width: wXD(27, context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: Color(0xff41C3B3),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Color(0xfffafafa),
                    size: wXD(16, context),
                  ),
                ),
              ),
              Spacer(flex: 3),
              Column(
                children: [
                  Text(getData(days.first, 'week_day')),
                  SizedBox(height: wXD(3, context)),
                  Text(
                    getData(days.first, 'day_month'),
                    style: TextStyle(
                      color: Color(0xff787C81),
                    ),
                  )
                ],
              ),
              Spacer(flex: 5),
              Column(
                children: [
                  Text(getData(days[1], 'week_day')),
                  SizedBox(height: wXD(3, context)),
                  Text(
                    getData(days[1], 'day_month'),
                    style: TextStyle(
                      color: Color(0xff787C81),
                    ),
                  )
                ],
              ),
              Spacer(flex: 5),
              Column(
                children: [
                  Text(getData(days.last, 'week_day')),
                  SizedBox(height: wXD(3, context)),
                  Text(
                    getData(days.last, 'day_month'),
                    style: TextStyle(
                      color: Color(0xff787C81),
                    ),
                  )
                ],
              ),
              Spacer(flex: 3),
              InkWell(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: nextDays,
                child: Container(
                  padding: EdgeInsets.only(left: wXD(1, context)),
                  height: wXD(27, context),
                  width: wXD(27, context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: Color(0xff41C3B3),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xfffafafa),
                    size: wXD(16, context),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: wXD(25, context)),
          height: wXD(1, context),
          color: Color(0xff707070).withOpacity(.4),
        ),
      ],
    );
  }
}
