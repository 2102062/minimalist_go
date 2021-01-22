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
          debugPrint(
              "GoBoard.build: New state received of type <${state.runtimeType}> [Address ${state.hashCode}]");
          if (state is LoadedState) {
            int count = state.board.grid.length;
            debugPrint(
                "GoBoard.build: New grid received. (size $count x ${state.board.grid[0]?.length})");
            return AspectRatio(
              aspectRatio: 1.0,
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return Stack(
                    children: <Widget>[
                      Padding(
                        padding:
                            EdgeInsets.all(constraints.biggest.height / 32),
                        child: Container(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                top: BorderSide(
                                  width: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Table(
                                children: List.generate(
                                  state.board.grid.length - 1,
                                  (index) => TableRow(
                                    children: List.generate(
                                      state.board.grid.length - 1,
                                      (index) => AspectRatio(
                                        aspectRatio: 1,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                              left: BorderSide(
                                                width: 1,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Table(
                        children: _buildChildren(count, state, context),
                      ),
                    ],
                  );
                },
              ),
            );
          } else {
            debugPrint(
                "GoBoard.build: Bloc IdleState. Dispatching initial LoadBoardEvent");
            bloc.add(LoadBoardEvent());
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  List<TableRow> _buildChildren(
      int count, LoadedState state, BuildContext context) {
    List<TableRow> list = [];
    for (int i = 0; i < count; i++) {
      int gridStateLength = state.board.grid.length;
      int x, y = 0;
      x = (i / gridStateLength).floor();
      y = (i % gridStateLength);
      List<Widget> rowWidgets = [];
      for (int j = 0; j < count; j++) {
        rowWidgets.add(GestureDetector(
          onTap: () => _gridItemTapped(i, j, context),
          child: GridTile(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                child: _buildGridItem(i, j, state.board),
              ),
            ),
          ),
        ));
      }
      list.add(TableRow(children: rowWidgets));
    }
    return list;
  }

  Widget _buildGridItem(int x, int y, GameState board) {
    if (board.grid.length == 0 || board.grid[0].length == 0) {
      debugPrint(
          "GoBoard._buildGridItem: The board has not been loaded in the grid!");
      return Text('');
    }
    switch (board.grid[x][y]) {
      case '-':
        return Text('');
        break;
      case 'W':
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    spreadRadius: 0,
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  )
                ]),
          ),
        );
        break;
      case 'B':
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    spreadRadius: -1,
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  )
                ]),
          ),
        );
        break;
      default:
        return Text(board.grid[x][y].toString());
    }
  }

  void _gridItemTapped(int x, int y, BuildContext context) {
    debugPrint("GoBoard._gridItemTapped: Tile ($x, $y) has been tapped");
    BlocProvider.of<GameBoardBloc>(context).add(TileTappedEvent(x, y));
  }
}
