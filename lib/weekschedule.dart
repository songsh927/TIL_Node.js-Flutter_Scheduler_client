import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class weekSchedule extends StatefulWidget { //TODO 랜더링 크기 flexible로 변경하기
  weekSchedule({Key? key, this.data, this.getData}) : super(key: key);

  final getData;
  final data;
  @override
  State<weekSchedule> createState() => _weekScheduleState();
}

class _weekScheduleState extends State<weekSchedule> {

  final Map<DateTime, List> _events = {};
  var _todayEvents = [];

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {//TODO 데이터 날짜 입력 및 파싱 효율적으로 바꾸기

    widget.getData();

    for(var i = 0 ; i < widget.data.length ; i++){
      int y = int.parse(widget.data[i]['date'].split(".")[0]);
      int m = int.parse(widget.data[i]['date'].split(".")[1]);
      int d = int.parse(widget.data[i]['date'].split(".")[2]);

      if(_events.containsKey(DateTime.utc(y, m, d))){
        _events.update(DateTime.utc(y, m, d), (value) => value + [widget.data[i]['title']]);
      }else{
        _events[DateTime.utc(y, m, d)] = [widget.data[i]['title']];
      }
    }
    super.initState();
  }

  _countSelectedDaySchedule () {
    setState(() {
      _todayEvents = [];
      _events[_selectedDay]?.forEach((e) => _todayEvents.add(e));
    });
    return _todayEvents.length;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(
          height: 400,
          child: TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.utc(2010,1,1),
            lastDay: DateTime.utc(2040,12,31),

            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day){
              return _events[day] ?? [];
            },
          ),
        ),
        Container(
          height: 260,
          child: ListView.builder(
            itemCount: _countSelectedDaySchedule(),
            itemBuilder: (c , i){
              return ListTile(
                title: Text(_todayEvents[i]),
              );
            },
          ),
        ),
      ],
    );
  }
}

