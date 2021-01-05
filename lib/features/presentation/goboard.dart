import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mimialist_go/features/domain/game_state.dart';

import '../domain/game.dart';
import '../../game_bloc.dart';

class GoBoard extends StatelessWidget {
  final GameBoardBloc bloc;

  const GoBoard({Key key, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameBoardBloc>(
      create: (_) => bloc,
      child: BlocBuilder<GameBoardBloc, GameBoardState>(
        builder: (context, state) {
          debugPrint("GoBoard.build: New state received of type <${state.runtimeType}>");
          if (state is LoadedState) {
            int count = state.board.grid.length;
            debugPrint(
                "GoBoard.build: New grid received. (size $count x ${state.board.grid[0]?.length})");
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
                  itemBuilder: (context, index) {
                    int gridStateLength = state.board.grid.length;
                    int x, y = 0;
                    x = (index / gridStateLength).floor();
                    y = (index % gridStateLength);
                    return GestureDetector(
                      onTap: () => _gridItemTapped(x, y),
                      child: GridTile(
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 0.5)),
                          child: Center(
                            child: _buildGridItem(x, y, state.board),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: count * count,
                  shrinkWrap: true,
                ),
              ),
            );
          } else {
            debugPrint("GoBoard.build: Dispatching initial LoadBoardEvent");
            bloc.add(LoadBoardEvent());
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildGridItem(int x, int y, GameState board) {
    if (board.grid.length == 0 || board.grid[0].length == 0) {
      debugPrint("GoBoard._buildGridItem: The board has not been loaded in the grid!");
      return Text('');
    }
    switch (board.grid[x][y]) {
      case '-':
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
        return Text(board.grid[x][y].toString());
    }
  }

  void _gridItemTapped(int x, int y) {
    debugPrint("GoBoard._gridItemTapped: Tile ($x, $y) has been tapped");
    bloc.add(TileTappedEvent(x, y));
  }
}
