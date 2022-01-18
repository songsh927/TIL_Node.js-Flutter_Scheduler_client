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
      "text": "6시 운동",
    },
    {
      "id": 2,
      "date": 20220117,
      "title": "술약속",
      "text": "8시 약속",
    },
  ];
  addData(){

  }

  getData(){

  }

  delData(i){

    setState(() {
      for(var a = 0 ; a < data.length ; a++) {
        if (data[a]['id'] == i) {
          data.remove(data[a]);
        }
      };
    });
  }

  updateData(id, date, title, text){
    setState(() {
      for(var a = 0 ; a < data.length ; a++) {
        if (data[a]['id'] == id) {
          if(date.text != ""){
            data[a]['date'] = date.text;
            print(data);
          }
          if(title.text != ""){
            data[a]['title'] = title.text;
          }
          if(text.text != ""){
            data[a]['text'] = text.text;
          }
        }
      }
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
        todaySchedule(data: data , delData : delData , updateData: updateData,),
        weekSchedule(),
        memoTodo()
      ][tab],
    );
  }
}

class todaySchedule extends StatelessWidget {
  todaySchedule({Key? key, this.data , this.delData, this.updateData}) : super(key: key);

  final delData;
  final updateData;
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
                  delData(data[i]['id']);
                }),
                IconButton( icon: Icon(Icons.settings_applications), onPressed: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => updatePage(data : data[i], id : data[i]['id'] , delData: delData, updateData : updateData,))
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
                            print(inputDate);
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

