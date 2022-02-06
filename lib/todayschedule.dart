import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'updatepage.dart';

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