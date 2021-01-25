
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
      yield GameBoardLoadedState(GameState(game.gridState));
      debugPrint("GameBoardBloc.mapEventToState: Yielded new LoadedState");
    } else if (event is LoadBoardEvent) {
      debugPrint("GameBoardBloc.mapEventToState: LoadBoardEvent received.");
      game.createGrid(16);
      yield GameBoardLoadedState(GameState(game.gridState));
      debugPrint("GameBoardBloc.mapEventToState: Yielded new LoadedState");
    } else {
      debugPrint("GameBoardBloc.mapEventToState: Unhandled event of type ${event.runtimeType} received");
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

  @override
  List<Object> get props => super.props + [x,y];
}

class LoadBoardEvent extends GameBoardEvent {}

class GameBoardState extends Equatable {
  @override
  List<Object> get props => [];
}

class GameBoardLoadedState extends GameBoardState {
  final GameState board;

  GameBoardLoadedState(this.board);

  @override
  List<Object> get props => super.props + [board];
}

class GameBoardIdleState extends GameBoardState {}

