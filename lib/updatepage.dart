import 'package:flutter/material.dart';

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