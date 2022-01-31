import 'package:flutter/material.dart';

class addSchedule extends StatefulWidget{
  const addSchedule({Key? key, this.addData}) : super(key: key);

  final addData;
  @override
  _addScheduleState createState() => _addScheduleState();
}

class _addScheduleState extends State<addSchedule> {

  var inputDate = TextEditingController();
  var inputTitle = TextEditingController();
  var inputText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 330,
        child: Column(
          children: [
            Text('일정 추가', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: inputDate,
                decoration: InputDecoration(
                  hintText: 'Date',
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: inputTitle,
                decoration: InputDecoration(
                  hintText: 'Title',
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
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: inputText,
                decoration: InputDecoration(
                  hintText: 'Text',
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
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: (){
                    widget.addData(inputDate.text, inputTitle.text, inputText.text);
                    Navigator.pop(context);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.cancel_outlined),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
