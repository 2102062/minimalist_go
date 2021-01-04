import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../game.dart';
import '../../game_bloc.dart';

class GoBoard extends StatelessWidget {
  final Game game;
  final GameBoardBloc bloc;

  const GoBoard({Key key, @required this.game, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildGameBody();
  }

  Widget _buildGameBody() {
    int count = game.gridState.length;
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1),
            top: BorderSide(width: 1),
          ),
        ),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
          ),
          itemBuilder: _buildGridItems,
          itemCount: count * count,
          shrinkWrap: true,
        ),
      ),
    );
  }

  Widget _buildGridItems(BuildContext context, int index) {
    int gridStateLength = game.gridState.length;
    int x, y = 0;
    x = (index / gridStateLength).floor();
    y = (index % gridStateLength);
    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5)),
          child: Center(
            child: _buildGridItem(x, y),
          ),
        ),
      ),
    );
  }

  Widget _buildGridItem(int x, int y) {
    switch (game.gridState[x][y]) {
      case '':
        return Text('');
        break;
      case 'W':
        return Container(
          color: Colors.blue,
        );
        break;
      case 'B':
        return Container(
          color: Colors.yellow,
        );
        break;
      default:
        return Text(game.gridState[x][y].toString());
    }
  }

  void _gridItemTapped(int x, int y) {
    game.updateTile(x, y);
  }
}