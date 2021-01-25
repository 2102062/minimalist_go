import 'package:get_it/get_it.dart';
import 'package:mimialist_go/game_bloc.dart';

import 'features/domain/game.dart';
import 'features/domain/game_state.dart';
import 'features/presentation/timer.dart';

final sl = GetIt.instance;

void init() {
  sl.registerFactory<GameBoardBloc>(() => GameBoardBloc(GameBoardIdleState(), sl<Game>()));
  sl.registerFactory<TimerBloc>(() => TimerBloc(TimerDefaultState()));
  sl.registerLazySingleton<Game>(() => Game());
}
