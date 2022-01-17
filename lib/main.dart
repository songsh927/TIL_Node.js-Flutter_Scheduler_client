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
  var data = [
    {
      "id": 1,
      "date": 20220117,
      "title": "운동",
      "text": "6시 재성이랑 운동",
    },
    {
      "id": 2,
      "date": 20220117,
      "title": "술약속",
      "text": "8시 당산 술약속",
    },
  ];
  addData(){

  }

  getData(){

  }

  delData(i){
    setState(() {
      data.remove(data[i]);
    });
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
        todaySchedule(data: data , delData : delData),
        weekSchedule(),
        memoTodo()
      ][tab],
    );
  }
}

class todaySchedule extends StatelessWidget {
  todaySchedule({Key? key, this.data , this.delData}) : super(key: key);
  final delData;
  final data;
  //var count = 10;
  var scroll = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemCount: data.length ,controller: scroll ,itemBuilder: (c,i){
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('시간: ${data[i]['date'].toString()}'),
                Text('내용: ${data[i]['title']}'),
                Text('상세내용: ${data[i]['text']}')
              ],
            ),
            Row(
              children: [
                IconButton( icon: Icon(Icons.check_box_outlined) ,onPressed:(){
                  delData(i);
                }),
                IconButton( icon: Icon(Icons.settings_applications), onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => updatePage(data : data[i]))
                  );
                },)
              ]
            )
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

class updatePage extends StatelessWidget {
  const updatePage({Key? key , this.data}) : super(key: key);

  final data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Schedule Update'),
          backgroundColor: Colors.teal,
        ),
        body: Container(
            child: Text('Update Page')
        ),
        bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,

          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.check),
              label: 'save',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.delete_outline_sharp),
              label: 'delete',
            )
          ],
        )
    );
  }
}

