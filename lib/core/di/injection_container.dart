import 'package:get_it/get_it.dart';
import '../../features/character/data/datasources/character_data_source.dart';
import '../../features/character/data/datasources/character_remote_data_source_impl.dart';
import '../../features/character/data/repositories/character_repository_impl.dart';
import '../../features/character/domain/repositories/character_repository.dart';
import '../../features/character/domain/usecases/get_characters.dart';
import '../../features/character/domain/usecases/get_multiple_characters.dart';
import '../../features/character/domain/usecases/get_single_character.dart';
import '../../features/character/presentation/cubit/character_cubit.dart';
import '../network/api_client.dart';

final GetIt sl = GetIt.instance;

Future<void> initInjection() async {
  // 1. External & Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // 2. Data Sources
  sl.registerLazySingleton<CharacterDataSource>(
    () => CharacterRemoteDataSourceImpl(apiClient: sl()),
  );

  // 3. Repositories
  sl.registerLazySingleton<CharacterRepository>(
    () => CharacterRepositoryImpl(dataSource: sl()),
  );

  // 4. Use Cases
  sl.registerLazySingleton<GetCharactersUseCase>(
    () => GetCharactersUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetSingleCharacterUseCase>(
    () => GetSingleCharacterUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetMultipleCharactersUseCase>(
    () => GetMultipleCharactersUseCase(repository: sl()),
  );

  // 5. Cubit
  sl.registerFactory<CharacterCubit>(
    () => CharacterCubit(getCharactersUseCase: sl()),
  );
}
