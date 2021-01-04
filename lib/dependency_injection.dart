import 'package:get_it/get_it.dart';
import 'package:mimialist_go/game_bloc.dart';

import 'game.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(() => GameBoardBloc(IdleState()));
  sl.registerFactory(() => Game(bloc: sl()));
}
