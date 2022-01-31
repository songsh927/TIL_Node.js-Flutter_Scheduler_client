import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'memo.dart';
import 'addschedule.dart';

void main() {
  runApp(MaterialApp(
      home: MyApp()
  )
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];

  @override
  void initState(){
    super.initState();
    getData();
  }

  addData(date, title, text) async{
    DateTime now = DateTime.now();
    var newData = {
      "id": DateFormat('yyyy.MM.dd.HH.mm.ss').format(now),
      "date": date.toString(),
      "title": title.toString(),
      "text": text.toString(),
    };
    http.Response res = await http.post(
        Uri.parse('http://localhost:3000/scheduler'),
        headers: {"Content-Type" : "application/json"},
        body:jsonEncode(newData)
    );
    setState(() {
      getData();
      //data.add(newData);
    });


  }

  getData([date]) async{
    var getServerData;
    if(date != null){
      getServerData = await http.get(
        Uri.parse('http://localhost:3000/scheduler?date=$date'),
        headers: {"Content-Type" : "application/json"},
      );
    }else{
      getServerData = await http.get(
        Uri.parse('http://localhost:3000/scheduler'),
      );
    }
    setState(() {
      data = jsonDecode(getServerData.body);
    });
  }

  delData(id) async{

    http.Response res = await http.delete(
      Uri.parse('http://localhost:3000/scheduler/$id'),
    );
    setState(() {//TODO foreach로 바꾸기
      getData();
      /*for(var a = 0 ; a < data.length ; a++) {
        if (data[a]['id'] == id) {
          data.remove(data[a]);
        }
      }*/
    });
  }

  updateData(id, date, title, text) async{
    var newData = {
      "id": id,
      "date": date.text,
      "title": title.text,
      "text": text.text,
    };
    http.Response res = await http.put(
      Uri.parse('http://localhost:3000/scheduler/$id'),
      headers: {"Content-Type" : "application/json"},
      body: jsonEncode(newData)
    );
    setState(() {
      getData();
      /*for(var a = 0 ; a < data.length ; a++) {
        if (data[a]['id'] == id) {
          if(date.text != ""){
            data[a]['date'] = date.text;
          }
          if(title.text != ""){
            data[a]['title'] = title.text;
          }
          if(text.text != ""){
            data[a]['text'] = text.text;
          }
        }
      }*/
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduler'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return addSchedule(addData : addData);
                });
                //addData();
              },
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: (i){
          setState((){
            tab = i;
          });
        },

        items: [

          BottomNavigationBarItem(
            icon: Icon(Icons.today_outlined),
            label: 'today',
            activeIcon: Icon(Icons.today),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'week',
            activeIcon: Icon(Icons.calendar_today),
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.sticky_note_2_outlined),
            label: 'Memo',
            activeIcon: Icon(Icons.sticky_note_2),
          )
        ],

        selectedItemColor: Colors.teal,
      ),
      body: [
        todaySchedule(data: data , delData : delData , updateData: updateData, getData: getData,),
        weekSchedule(data : data, getData: getData,),
        memoTodo()
      ][tab],
    );
  }
}

class todaySchedule extends StatefulWidget {
  todaySchedule({Key? key, this.data , this.delData, this.updateData, this.getData}) : super(key: key);

  final getData;
  final delData;
  final updateData;
  final data;

  @override
  State<todaySchedule> createState() => _todayScheduleState();
}

class _todayScheduleState extends State<todaySchedule> {
  bool _isChecked = false;
  DateTime now = DateTime.now();

  //var count = 10;
  var scroll = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Row(
            children: [
              Text('오늘일정만 보기'),
              Switch(
                value: _isChecked,
                onChanged: (value){
                  setState(() {
                    _isChecked = value;
                    if(_isChecked){
                      widget.getData(DateFormat('yyyy.MM.dd').format(now));
                    }else{
                      widget.getData();
                    }
                  });
                },
              ),
            ],
          ),
        ),
        Flexible(
          child: ListView.builder(itemCount: widget.data.length ,controller: scroll ,itemBuilder: (c,i){
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.grey, offset: Offset(0.0,1.0),blurRadius: 6.0)
                ]
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(2, 5, 2, 5),
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('시간: ${widget.data[i]['date'].toString()}'),
                      Text('내용: ${widget.data[i]['title']}'),
                      Text('상세내용: ${widget.data[i]['text']}')
                    ],
                  ),
                  Row(
                    children: [
                      IconButton( icon: Icon(Icons.check_box_outlined) ,onPressed:(){
                        widget.delData(widget.data[i]['id']);
                      }),
                      IconButton( icon: Icon(Icons.settings_applications), onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => updatePage(
                              data : widget.data[i],
                              id : widget.data[i]['id'] ,
                              delData: widget.delData,
                              updateData : widget.updateData,))
                        );
                      },)
                    ]
                  )
                ],
              ),
            );
          }),
        )
      ],
    );
  }
}

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

class updatePage extends StatelessWidget {
  updatePage({Key? key , this.data, this.updateData, this.delData , this.id}) : super(key: key);

  final data;
  final updateData;
  final delData;
  final id;
  var inputDate = TextEditingController();
  var inputTitle = TextEditingController();
  var inputText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Schedule Update'),
          backgroundColor: Colors.teal,
        ),
        body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('날짜'),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: inputDate,
                    decoration: InputDecoration(
                      hintText: data['date'].toString(),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Colors.teal),
                      ),
                    ),
                  ),
                ),

                Text('제목'),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: inputTitle,
                    decoration: InputDecoration(
                      hintText: '${data['title']}',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Colors.teal),
                      ),
                    ),
                  ),
                ),

                Text('내용'),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: inputText,
                    decoration: InputDecoration(
                      hintText: data['text'],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Colors.blue),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(width: 1, color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4)
                        )
                      ) ,
                      child: IconButton(
                          onPressed: (){
                            updateData(id,inputDate,inputTitle,inputText);
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.check)
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.all(
                              Radius.circular(4)
                          )
                      ) ,
                      child: IconButton(
                          onPressed: (){
                            delData(data['id']);
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.delete_outline_sharp)
                      ),
                    )
                  ],
                )
              ],
            ),
        ),

    );
  }
}