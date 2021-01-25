import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class StopwatchWidget extends StatelessWidget {
  final TimerBloc timerBloc;

  const StopwatchWidget({Key key, @required this.timerBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TimerBloc>(
      create: (_) => timerBloc,
      child: BlocBuilder<TimerBloc, TimerBlocState>(
        builder: (BuildContext context, TimerBlocState state) {
          //debugPrint("StopwatchWidget.build: state is ${state.runtimeType.toString()}");
          String text;
          if(state is TimerDefaultState) {
            text = "00:00:00";
          } else if (state is UpdatedTimeState) {
            int tick = state.newTick;
            String hourStr = (tick / 3600).floor().toString().padLeft(2,'0');
            String minuteStr = ((tick / 60) % 60).floor().toString().padLeft(2,'0');
            String secondStr = (tick % 60).toString().padLeft(2,'0');
            text = "$hourStr:$minuteStr:$secondStr";
          } else {
            text = "00:00:00";
          }
          return Text(text, style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontFamily: GoogleFonts.oswald().fontFamily
          ),);
        },
      ),
    );
  }

  void startTimer() {
    timerBloc.startTimer();
  }

  void pauseTimer() {
    timerBloc.pauseTimer();
  }
}

class TimerBloc extends Bloc<TimerBlocEvent, TimerBlocState> {
  Stream<int> timerStream;
  StreamSubscription<int> timerSubscription;
  bool running = false;

  TimerBloc(TimerBlocState initialState) : super(initialState);

  Stream<int> stopwatchStream() {
    debugPrint("TimerBloc.stopwatchStream: starting method");
    StreamController<int> streamController;
    Timer timer;
    Duration timerInterval = Duration(seconds: 1);
    int counter = 0;

    void tick(_) {
      counter++;
      streamController.add(counter);
    }

    void stopTimer() {
      debugPrint("TimerBloc.stopwatchStream.stopTimer: starting method");
      if (timer != null) {
        timer.cancel();
        timer = null;
        counter = 0;
        streamController.close();
      }
    }

    void pauseTimer() {
      debugPrint("TimerBloc.stopwatchStream.pauseTimer: starting method");
      if (timer != null) {
        timer.cancel();
        timer = null;
        streamController.close();
      }
    }

    void startTimer() {
      debugPrint("TimerBloc.stopwatchStream.startTimer: starting method");
      timer = Timer.periodic(timerInterval, tick);
    }

    streamController = StreamController<int>(
      onListen: startTimer,
      onCancel: stopTimer,
      onResume: startTimer,
      onPause: pauseTimer,
    );

    return streamController.stream;
  }

  void startTimer() {
    debugPrint("TimerBloc.startTimer: starting method");
    timerStream = stopwatchStream();
    timerSubscription = timerStream.listen((int newTick) {
      //debugPrint("TimerBloc.startTimer: newTick $newTick");
      this.add(UpdateTimeEvent(newTick));
    });
    running = true;
  }

  void pauseTimer() {
    debugPrint("TimerBloc.pauseTimer: starting method");
    timerSubscription.pause();
    running = false;
  }

  @override
  Stream<TimerBlocState> mapEventToState(TimerBlocEvent event) async* {
    //debugPrint("TimerBloc.mapEventToState: Event of type ${event.runtimeType}");
    if (event is UpdateTimeEvent) {
      yield UpdatedTimeState(event.newTick);
    } else if (event is StartTimerEvent) {
      startTimer();
    }
  }
}

class TimerBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class TimerDefaultState extends TimerBlocState {}

class UpdatedTimeState extends TimerBlocState {
  final int newTick;

  UpdatedTimeState(this.newTick);

  @override
  List<Object> get props => super.props + [newTick];
}

class TimerBlocEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateTimeEvent extends TimerBlocEvent {
  final int newTick;

  UpdateTimeEvent(this.newTick);
}

class PauseTimerEvent extends TimerBlocEvent {}

class StartTimerEvent extends TimerBlocEvent {}
