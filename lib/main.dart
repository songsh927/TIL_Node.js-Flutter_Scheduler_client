import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'memo.dart';
import 'addschedule.dart';
import 'todayschedule.dart';
import 'weekschedule.dart';

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

