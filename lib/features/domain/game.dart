import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mimialist_go/game_bloc.dart';

enum BoardEdges { North, South, East, West }

class Game {
  bool whiteTurn = true;
  List<List<String>> _gridState = [[]];
  List<List<bool>> currentGroup;

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
      collectSurroundedPieces(x, y, whiteTurn);
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
        debugPrint(
            "Game.isOnEdge: On North Edge -> ${y + 1 == gridState.length} ${y + 1} [${gridState.length}]");
        return (y + 1 == gridState.length);
      case BoardEdges.South:
        debugPrint(
            "Game.isOnEdge: On South Edge -> ${y - 1 < 0} ${y - 1} [<0]");
        return (y - 1 < 0);
      case BoardEdges.East:
        debugPrint(
            "Game.isOnEdge: On East Edge -> ${x + 1 == gridState.length} ${x + 1}");
        return (x + 1 == gridState.length);
      case BoardEdges.West:
        debugPrint("Game.isOnEdge: On West Edge -> ${x - 1 < 0} ${x - 1} [<0]");
        return (x - 1 < 0);
      default:
        return false;
    }
  }

  List<List<int>> getNeighbors(int x, int y) {
    List<List<int>> neighbors = new List();
    debugPrint("Game.getNeighbors: x=$x, y=$y");
    debugPrint("Game.getNeighbors: x,y-1${{x, (y - 1)}.toString()}");
    if (y > 0) neighbors.add([x, y - 1]);
    if (y < _gridState[0].length - 1) neighbors.add([x, y + 1]);
    if (x > 0) neighbors.add([x - 1, y]);
    if (x < _gridState.length - 1) neighbors.add([x + 1, y]);
    debugPrint(
        "Game.getNeighbors: ${neighbors.length} neighbors, ${neighbors.toString()}");
    return neighbors;
  }

  /// TODO: Figure out the implementation to this method
  void collectSurroundedPieces(int x, int y, bool whiteTurn) {
    String self = whiteTurn ? "W" : "B";
    String opponent = whiteTurn ? "B" : "W";
    List<List<bool>> board = List.generate(
      _gridState.length,
      (i) =>
          List.generate(_gridState[0].length, (j) => _gridState[i][j] == self),
    );
    List<List<bool>> opponentBoard = List.generate(
      _gridState.length,
      (i) => List.generate(
          _gridState[0].length, (j) => _gridState[i][j] == opponent),
    );
    List<List<int>> neighbors = getNeighbors(x, y);
    for (List<int> coords in neighbors) {
      int xn = coords.elementAt(0);
      int yn = coords.elementAt(1);
      debugPrint(
          "Game.collectSurroundedPieces: xn,yn=$xn,$yn; opponentBoard[xn][yn]=${opponentBoard[xn][yn]}");
      if (!opponentBoard[xn][yn]) continue;
      capturePieces(board, opponentBoard, xn, yn);
    }
    capturePieces(opponentBoard, board, x, y);
  }

  void capturePieces(
      List<List<bool>> board, List<List<bool>> opponentBoard, x, y) {
    currentGroup = List.generate(
      _gridState.length,
      (i) => List.generate(_gridState[0].length, (j) => false),
    );
    bool hasLiberties = testGroup(board, opponentBoard, x, y);

    debugPrint("Game.capturePieces: currentGroup = ${currentGroup.toString()}");
    debugPrint("Game.capturePieces: board = ${board.toString()}");
    debugPrint(
        "Game.capturePieces: opponentBoard = ${opponentBoard.toString()}");

    if (!hasLiberties) {
      for (int i = 0; i < _gridState.length; i++) {
        for (int j = 0; j < _gridState[0].length; j++) {
          if (currentGroup[i][j]) {
            _gridState[i][j] = "";
          }
        }
      }
    }
  }

  bool testGroup(
    List<List<bool>> board,
    List<List<bool>> opponentBoard,
    x,
    y,
  ) {
    debugPrint("Game.testGroup: currentGroup.length = ${currentGroup.length}");
    debugPrint(
        "Game.testGroup: currentGroup[0] = ${currentGroup[0].toString()}");
    if (currentGroup[x][y]) return false;
    if (opponentBoard[x][y]) {
      currentGroup[x][y] = true;
      debugPrint("Game.testGroup: currentGroup[$x][$y]=true");
      List<List<int>> neighbors = getNeighbors(x, y);
      for (List<int> coords in neighbors) {
        bool hasLiberties = testGroup(
            board, opponentBoard, coords.elementAt(0), coords.elementAt(1));
        if (hasLiberties) return true;
      }
      return false;
    }
    return !board[x][y];
  }
}
