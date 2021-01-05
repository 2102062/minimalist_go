import 'package:get_it/get_it.dart';
import 'package:mimialist_go/game_bloc.dart';

import 'features/domain/game.dart';
import 'features/domain/game_state.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory(() => GameBoardBloc(IdleState(), sl()));
  sl.registerFactory(() => Game());
}
