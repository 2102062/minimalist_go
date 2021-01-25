import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimialist_go/game_bloc.dart';

enum BoardEdges { North, South, East, West }

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
    debugPrint("Game.isSuicidal: Opponent is $opponent");
    /// If it is on the edge, the isOnEdge function returns a true value. So, we
    /// only want to check the gridState if it is not on the edge. By negating
    /// the value and providing it first in the && expression, we short circuit
    /// and prevent an out of range error if it is actually on the edge.
    if (!isOnEdge(x, y, BoardEdges.North) && gridState[x][y + 1] != opponent) {
      debugPrint("Game.isSuicidal: North Space Empty");
      return false;
    }
    if (!isOnEdge(x, y, BoardEdges.South) && gridState[x][y - 1] != opponent) {
      debugPrint("Game.isSuicidal: South Space Empty");
      return false;
    }
    if (!isOnEdge(x, y, BoardEdges.East) && gridState[x + 1][y] != opponent) {
      debugPrint("Game.isSuicidal: East Space Empty");
      return false;
    }
    if (!isOnEdge(x, y, BoardEdges.West) && gridState[x - 1][y] != opponent) {
      debugPrint("Game.isSuicidal: West Space Empty");
      return false;
    }
    return true;
  }

  bool isOccupied(int x, int y) {
    return gridState[x][y] != '-';
  }


  bool isOnEdge(x, y, BoardEdges edge) {
    switch (edge) {
      case BoardEdges.North:
        debugPrint("Game.isOnEdge: On North Edge -> ${y + 1 == gridState.length} ${y + 1} [${gridState.length}]");
        return (y + 1 == gridState.length);
      case BoardEdges.South:
        debugPrint("Game.isOnEdge: On South Edge -> ${y - 1 < 0} ${y - 1} [<0]");
        return (y - 1 < 0);
      case BoardEdges.East:
        debugPrint("Game.isOnEdge: On East Edge -> ${x + 1 == gridState.length} ${x + 1}");
        return (x + 1 == gridState.length);
      case BoardEdges.West:
        debugPrint("Game.isOnEdge: On West Edge -> ${x - 1 < 0} ${x - 1} [<0]");
        return (x - 1 < 0);
      default:
        return false;
    }
  }
  /// This method returns true when placing a piece in a certain space would
  /// cause a closed loop of one color.
  /// TODO: Figure out the implementation to this method
  bool recursiveClosedLoopCheck(int x, int y, bool white) {
    String self = white ? "W" : "B";
    String opponent = white ? "B" : "W";
    if(!isOnEdge(x, y, BoardEdges.North)) {
      if(!isOnEdge(x, y + 1, BoardEdges.North)) {

      } else if (true) {

      }
    };
    if(recursiveClosedLoopCheck(x + 1, y, white)) return true;
  }

  void _clearCheckGrid() {
    _checkGrid = List.generate(_checkGrid.length,
        (index) => List.generate(_checkGrid.length, (index) => 0));
  }
}
