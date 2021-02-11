import 'package:flutter/material.dart';
import 'package:mimialist_go/features/presentation/d-pad.dart';
import 'package:mimialist_go/features/presentation/timer.dart';
import 'package:zoom_widget/zoom_widget.dart';
import 'file:///C:/Users/sccha/AndroidStudioProjects/mimialist_go/lib/features/domain/game.dart';

import 'dependency_injection.dart';
import 'features/presentation/goboard.dart';
import 'game_bloc.dart';

void main() {
  init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final GoBoard board = GoBoard(
    bloc: sl(),
  );
  @override
  State<StatefulWidget> createState() => _MyHomePageState(board);
}

class _MyHomePageState extends State {
  final GoBoard board;
  StopwatchWidget rightStopwatch = StopwatchWidget(timerBloc: sl());
  StopwatchWidget leftStopwatch = StopwatchWidget(timerBloc: sl())..startTimer();
  bool zoom = false;

  _MyHomePageState(this.board);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            height: MediaQuery.of(context).size.height / 2,
          ),
          Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: zoom
                      ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        child: Zoom(
                            width: MediaQuery.of(context).size.width * 2,
                            height: MediaQuery.of(context).size.width * 2,
                            initZoom: 1,
                            child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: board),
                          ),
                      )
                      : Padding(
                          padding: const EdgeInsets.all(16.0), child: board),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 100.0, left: 16.0),
                    child: Center(child: leftStopwatch),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 100.0, right: 16.0),
                    child: Center(child: rightStopwatch),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DPadButton(),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FloatingActionButton(
                        child: Icon(zoom ? Icons.zoom_out : Icons.zoom_in),
                        onPressed: () {
                          setState(() {
                            zoom = !zoom;
                          });
                        }),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
