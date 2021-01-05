import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimialist_go/game_bloc.dart';


class Game {
  bool whiteTurn = true;
  List<List<String>> _gridState = [[]];

  get gridState {
    return _gridState;
  }
  set gridState(List<List<String>> gridState) {
    debugPrint("Game.gridState: gridState has just been set from $_gridState to $gridState");
    _gridState = gridState;
  }

  void createGrid(int size) {
    List<List<String>> list = [];
    List<String> innerList;
    for (int i = 0; i < size; i++) {
      innerList = [];
      for (int j = 0; j < size; j++) {
        innerList.add("-");
      }
      list.add(innerList);
    }
    _gridState = list;
    debugPrint("Game.createGrid: Created a grid of size ${gridState.length} by ${gridState[0].length}");
    debugPrint("Game.createGrid: gridState[${size-1}][${size-1}] => '${gridState[size-1][size-1]}'");
  }

  void updateTile(int x, int y) {
    debugPrint("Game.updateTile: Move selected at ($x, $y)");
    if(true || !checkIfSuicidal(x, y, whiteTurn)) {
      debugPrint("Game.updateTile: Board size check: ${gridState.length} x ${gridState[0].length}");
      _gridState[x][y] = whiteTurn ? "W" : "B";
      whiteTurn = !whiteTurn;
      debugPrint("Game.updateTile: whiteTurn => $whiteTurn");
      debugPrint("Game.updateTile: Move successful. ($x, $y)");
    }
  }

  bool checkIfSuicidal(int x, int y, bool white) {
    String opponent = white ? "B" : "W";
    if(!(x + 1 <= gridState.length) && !(y + 1 <= gridState.length) && gridState[x + 1][y + 1] != opponent) return false;
    if(!(x - 1 <= gridState.length) && !(y + 1 <= gridState.length) && gridState[x - 1][y + 1] != opponent) return false;
    if(!(x + 1 <= gridState.length) && !(y - 1 <= gridState.length) && gridState[x + 1][y - 1] != opponent) return false;
    if(!(x - 1 <= gridState.length) && !(y - 1 <= gridState.length) && gridState[x - 1][y - 1] != opponent) return false;
    return true;
  }
}
