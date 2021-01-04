import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimialist_go/game_bloc.dart';


class Game {
  final GameBoardBloc bloc;
  bool whiteTurn = true;
  List<List<String>> gridState = [[]];

  Game({@required this.bloc});

  void createGrid(int size) {
    List<List<String>> list = [];
    List<String> innerList;
    for (int i = 0; i < size; i++) {
      innerList = [];
      for (int j = 0; j < size; j++) {
        innerList.add("");
      }
      list.add(innerList);
    }
    gridState = list;
  }

  void updateTile(int x, int y) {
    if(!checkIfSuicidal(x, y, whiteTurn)) {
      gridState[x][y] = whiteTurn ? "W" : "B";
      whiteTurn = !whiteTurn;
      bloc.add(TileTappedEvent(x, y));
    }
  }

  bool checkIfSuicidal(int x, int y, bool white) {
    String opponent = white ? "B" : "W";
    if(gridState[x + 1][y + 1] != opponent) return false;
    if(gridState[x - 1][y + 1] != opponent) return false;
    if(gridState[x + 1][y - 1] != opponent) return false;
    if(gridState[x - 1][y - 1] != opponent) return false;
    return true;
  }
}
