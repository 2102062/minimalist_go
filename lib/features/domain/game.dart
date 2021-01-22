import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimialist_go/game_bloc.dart';

enum BoardEdges {
  North, South, East, West
}

class Game {
  bool whiteTurn = true;
  List<List<String>> _gridState = [[]];
  List<List<int>> _checkGrid = [[]];

  get gridState {
    return _gridState;
  }

  set gridState(List<List<String>> gridState) {
    debugPrint(
        "Game.gridState: gridState has just been set from $_gridState to $gridState");
    _gridState = gridState;
  }

  void createGrid(int size) {
    debugPrint("Game.createGrid: Creating new grid... [size $size]");
    _checkGrid =
        List.generate(size, (index) => List.generate(size, (index) => 0));
    _gridState =
        List.generate(size, (index) => List.generate(size, (index) => '-'));
    debugPrint(
        "Game.createGrid: Created a grid of size ${gridState.length} by ${gridState[0].length}");
    debugPrint(
        "Game.createGrid: gridState[${size - 1}][${size - 1}] => '${gridState[size - 1][size - 1]}'");
  }

  void updateTile(int x, int y) {
    debugPrint("Game.updateTile: Move selected at ($x, $y)");
    if (!isSuicidal(x, y, whiteTurn) && !isOccupied(x, y)) {
      debugPrint(
          "Game.updateTile: Board size check: ${gridState.length} x ${gridState[0].length}");
      _gridState[x][y] = whiteTurn ? "W" : "B";
      whiteTurn = !whiteTurn;
      debugPrint("Game.updateTile: whiteTurn => $whiteTurn");
      debugPrint(
          "Game.updateTile: Move successful. ($x, $y) [${_gridState[x][y]}]");
    } else {
      debugPrint("Game.updateTile: Move is suicidal. No move has been made.");
    }
  }

  bool isSuicidal(int x, int y, bool white) {
    String opponent = white ? "B" : "W";
    debugPrint("Game.checkIfSuicidal: Opponent is $opponent");
    if (!isOnEdge(x, y, BoardEdges.North) && gridState[x][y + 1] != opponent) return false;
    if (!isOnEdge(x, y, BoardEdges.South) && gridState[x][y - 1] != opponent) return false;
    if (!isOnEdge(x, y, BoardEdges.East) && gridState[x + 1][y] != opponent) return false;
    if (!isOnEdge(x, y, BoardEdges.West) && gridState[x - 1][y] != opponent) return false;
    return true;
  }

  bool isOccupied(int x, int y) {
    return gridState[x][y] != '-';
  }

  bool isOnEdge(x, y, BoardEdges edge) {
    switch(edge){
      case BoardEdges.North:
        return (y + 1 == gridState.length);
      case BoardEdges.South:
        return (y - 1 < 0);
      case BoardEdges.East:
        return (x + 1 == gridState.length);
      case BoardEdges.West:
        return (x - 1 < 0);
      default:
        return false;
    }

  }

  bool recursiveFilledCheck(int x, int y, bool white) {
    String self = white ? "W" : "B";


  }
}
