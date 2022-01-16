import 'package:flutter/material.dart';

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

  addData(){

  }

  getData(){

  }

  delData(){

  }

  updateData(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduler'),
        backgroundColor: Colors.teal,
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
        todaySchedule(),
        weekSchedule(),
        memoTodo()
      ][tab],
    );
  }
}

class todaySchedule extends StatelessWidget {
  todaySchedule({Key? key}) : super(key: key);

  var count = 10;
  var scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: count ,controller: scroll ,itemBuilder: (c,i){
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.all(Radius.circular(4.0))
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(2, 5, 2, 5),
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('시간: '),
                Text('내용: '),
                Text('상세내용')
              ],
            ),
            IconButton( icon: Icon(Icons.check_box_outlined) ,onPressed:(){
            })
          ],
        ),
      );
    });
  }
}

class weekSchedule extends StatelessWidget {
  const weekSchedule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('주간 스케쥴'),
    );
  }
}

class memoTodo extends StatelessWidget {
  const memoTodo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('MEMO'),
    );
  }
}

