import 'package:get_it/get_it.dart';
import '../../features/character/data/datasources/character_data_source.dart';
import '../../features/character/data/datasources/character_remote_data_source_impl.dart';
import '../../features/character/data/repositories/character_repository_impl.dart';
import '../../features/character/domain/repositories/character_repository.dart';
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

  // 4. Cubits (Factory to create new instances per lifecycle when needed)
  sl.registerFactory<CharacterCubit>(
    () => CharacterCubit(repository: sl()),
  );
}
