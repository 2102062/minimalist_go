
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/domain/game.dart';
import 'features/domain/game_state.dart';

class GameBoardBloc extends Bloc<GameBoardEvent, GameBoardState> {
  final Game game;
  GameBoardBloc(initialState, this.game) : super(initialState);

  @override
  Stream<GameBoardState> mapEventToState(event) async* {
    if(event is TileTappedEvent) {
      debugPrint("GameBoardBloc.mapEventToState: TileTappedEvent received.");
      game.updateTile(event.x, event.y);
      yield LoadedState(GameState(game.gridState));
      debugPrint("GameBoardBloc.mapEventToState: Yielded new LoadedState");
    } else if (event is LoadBoardEvent) {
      debugPrint("GameBoardBloc.mapEventToState: LoadBoardEvent received.");
      game.createGrid(16);
      yield LoadedState(GameState(game.gridState));
      debugPrint("GameBoardBloc.mapEventToState: Yielded new LoadedState");
    }
  }
}

class GameBoardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TileTappedEvent extends GameBoardEvent {
  final int x, y;

  TileTappedEvent(this.x, this.y);
}

class LoadBoardEvent extends GameBoardEvent {}

class GameBoardState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadedState extends GameBoardState {
  final GameState board;

  LoadedState(this.board);
}

class IdleState extends GameBoardState {}

