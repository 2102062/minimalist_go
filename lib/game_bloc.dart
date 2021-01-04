import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'game.dart';

class GameBoardBloc extends Bloc {
  GameBoardBloc(initialState) : super(initialState);

  @override
  Stream<GameBoardState> mapEventToState(event) async* {
    if(event is TileTappedEvent) {

      yield IdleState();
    }
  }
}

class GameBoardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GameBoardState extends Equatable {
  @override
  List<Object> get props => [];
}

class IdleState extends GameBoardState {

}

class TileTappedEvent extends GameBoardEvent {
  final int x, y;

  TileTappedEvent(this.x, this.y);
}