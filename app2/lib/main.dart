import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() {
  runApp(MaterialApp(home: TimerSamplePage())); // ここが Widget ツリーの起点
}

class TimerSamplePage extends StatefulWidget { // 状態を持ちたいので StatefulWidget を継承
  @override
  _TimerSamplePageState createState() => _TimerSamplePageState();
}

class _TimerSamplePageState extends State<TimerSamplePage> {
  late Timer _timer;
  late DateTime _time;
  int started = 0;

  @override
  void initState() { // 初期化処理
    _time = DateTime.utc(0, 0, 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) { // setState() の度に実行される
    final Shader _linearGradient = LinearGradient(
      colors: <Color>[
        Color(0xFF004445),
        Color(0xFFC07754),
      ],
    ).createShader(
      Rect.fromLTWH(
        0.0,
        0.0,
        250.0,
        70.0,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer",style: TextStyle(color: Color(0xFFE2B58A)),),
        backgroundColor: Color(0xFF004445),
      ),
      body: Container(
      color: Color(0xFFE2B58A),
      child:
      Column(mainAxisAlignment: MainAxisAlignment.center, 
      children: [
      Spacer(flex: 5,),
      Text(
        DateFormat.Hms().format(_time),
        style: new TextStyle(
          fontSize: 80,
          fontWeight: FontWeight.bold,
          foreground: Paint()..shader = _linearGradient
        ),
        
      ),//.animate(onPlay: (controller) => controller.repeat()).shake(duration: 1.seconds),
      Spacer(flex: 4,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 3,),
          Container(
          width: 120,
          child:
          FloatingActionButton.extended(
            onPressed: () {
              if(started != 1) {
              _timer = Timer.periodic(
                Duration(seconds: 1), 
                (Timer timer) {
                  setState(() {
                    if (_time != DateTime.utc(0,0,0,0,0)) {
                      _time = _time.subtract(Duration(seconds: 1));
                      started = 1;
                      if (_time == DateTime.utc(0,0,0,0,0,0)){
                        _timer.cancel();
                        started = 0;
                        Alarm().start();
                      }
                    }else {
                      _timer.cancel();
                    }
                  });
                }
              );
              }
            } ,
            shape: const StadiumBorder(
              //side: BorderSide(color: Color(0xFF004445))
            ),
            backgroundColor: Color(0xFFC07754),
            label: Text("Start",style: TextStyle(color: Color(0xFF004445),fontWeight: FontWeight.bold),),
            icon: Icon(Icons.play_arrow,color: Color(0xFF004445),),
          ),
          ),
          Spacer(flex: 1,),
          Container(
          width: 120,
          child:
          FloatingActionButton.extended(
            onPressed: () { // Stopボタンタップ時の処理
              Alarm().stop();
              if (_timer !=  null && _timer.isActive) {
                _timer.cancel();
                started = 0;
              }
            },
            shape: const StadiumBorder(
              //side: BorderSide(color: Color(0xFF004445))
            ),
            backgroundColor: Color(0xFFC07754),
            label: Text("Stop",style: TextStyle(color: Color(0xFF004445),fontWeight: FontWeight.bold),),
            icon: Icon(Icons.pause,color: Color(0xFF004445),),
          ),
          ),
          Spacer(flex: 3,),
        ],
      ),
      Spacer(flex: 1,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(flex: 3,),
          Container(
          width: 120,
          child:
          FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                _time = DateTime.utc(0, 0, 0);
                started = 0;
              });
            },
            shape: const StadiumBorder(
              //side: BorderSide(color: Color(0xFF004445))
            ),
            label: Text("reset",style: TextStyle(color: Color(0xFF004445),fontWeight: FontWeight.bold),),
            backgroundColor: Color(0xFFC07754),
            icon: Icon(Icons.stop,color: Color(0xFF004445),),
          ),
          ),
          Spacer(flex: 1,),
          Container(
          width: 120,
          child : 
          FloatingActionButton.extended(
            shape: const StadiumBorder(
              //side: BorderSide(color: Color(0xFF004445))
            ),
            backgroundColor: Color(0xFFC07754),
            label: Text('Edit',style: TextStyle(color: Color(0xFF004445),fontWeight: FontWeight.bold),),
            icon: Icon(Icons.access_time,color: Color(0xFF004445),),
            onPressed: () async {
              Picker(
                adapter: DateTimePickerAdapter(type: PickerDateTimeType.kHMS, value: _time, customColumnType: [3, 4, 5]),
                title: Text("Select Time",style: TextStyle(color: Color(0xFFE2B58A)),),
                onConfirm: (Picker picker, List value) {
                  setState(() => {_time = DateTime.utc(0, 0, 0, value[0], value[1], value[2])});
                },
                backgroundColor: Color(0xFFE2B58A),
                headerColor: Color(0xFF004445),
                cancelTextStyle: TextStyle(color: Color(0xFFC07754)),
                confirmTextStyle: TextStyle(color: Color(0xFFC07754)),
                textStyle: TextStyle(color: Color(0xFF004445)),
              ).showModal(context);
            },
          ),
          ),
          Spacer(flex: 3,),
        ],
      ),
      Spacer(flex: 2,),



      Container(
      child : Stack(
      children:[
        Container(
          decoration: BoxDecoration(
          color: Color(0xFFC07754),
          borderRadius: BorderRadius.circular(20),
          //border: Border.all(color: Color(0xFF004445))
          
          
      ),
          child : Column(
            children: [
        Container(
          height: 10,
        ),
        Row(
        children: [
          Spacer(),
          ElevatedButton(
            child: const Text(
              '1min',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF004445),
              onPrimary: Color(0xFFE2B58A),
              shape: const CircleBorder(),
              minimumSize: Size(75, 75)
            ),
            onPressed: () {
              setState(() {
                _time = DateTime.utc(0,0,0,0,1);
              });
            },
          ),
          Spacer(),
          ElevatedButton(
            child: const Text(
              '3min',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE2B58A),
              onPrimary: Color(0xFF004445),
              shape: const CircleBorder(),
              minimumSize: Size(75, 75)
            ),
            onPressed: () {
              setState(() {
                _time = DateTime.utc(0,0,0,0,3);
              });
            },
          ),
          Spacer(),
          ElevatedButton(
            child: const Text(
              '5min',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF004445),
              onPrimary: Color(0xFFE2B58A),
              shape: const CircleBorder(),
              minimumSize: Size(75, 75)
            ),
            onPressed: () {
              setState(() {
                _time = DateTime.utc(0,0,0,0,5);
              });
            },
          ),
          Spacer(),
        ],
      ),
      Container(
        height: 10,
      ),
      Row(
        children: [
          Spacer(),
          ElevatedButton(
            child: const Text(
              '10min',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE2B58A),
              onPrimary: Color(0xFF004445),
              shape: const CircleBorder(),
              minimumSize: Size(75, 75)
            ),
            onPressed: () {
              setState(() {
                _time = DateTime.utc(0,0,0,0,10);
              });
            },
          ),
          Spacer(),
          ElevatedButton(
            child: const Text(
              '30min',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF004445),
              onPrimary: Color(0xFFE2B58A),
              shape: const CircleBorder(),
              minimumSize: Size(75, 75)
            ),
            onPressed: () {
              setState(() {
                _time = DateTime.utc(0,0,0,0,30);
              });
            },
          ),
          Spacer(),
          ElevatedButton(
            child: const Text(
              '1h',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFE2B58A),
              onPrimary: Color(0xFF004445),
              shape: const CircleBorder(),
              minimumSize: Size(75, 75)
            ),
            onPressed: () {
              setState(() {
                _time = DateTime.utc(0,0,0,1,0);
              });
            },
          ),
          Spacer(),
        ],
      ),
      Container(
        height: 10,
      ),
      ]
      )
      ),
      ],
      )
      ),
      Spacer(flex: 5,),
    ]),
    ),
    );
  }
}

class Alarm {
  late Timer _timer;

  /// アラームをスタートする
  void start() {
    FlutterRingtonePlayer.playAlarm();
    if (Platform.isIOS) {
      _timer = Timer.periodic(
        Duration(seconds: 4),
        (Timer timer) => {FlutterRingtonePlayer.playAlarm()},
      );
    }
  }

  /// アラームをストップする
  void stop() {
    if (Platform.isAndroid) {
      FlutterRingtonePlayer.stop();
    } else if (Platform.isIOS) {
      if (_timer != null && _timer.isActive) _timer.cancel();
    }
  }
}
