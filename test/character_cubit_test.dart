import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task/features/character/domain/entities/character_entity.dart';
import 'package:flutter_task/features/character/domain/repositories/character_repository.dart';
import 'package:flutter_task/features/character/presentation/cubit/character_cubit.dart';
import 'package:flutter_task/features/character/presentation/cubit/character_state.dart';

class MockCharacterRepository implements CharacterRepository {
  int getCharactersCallCount = 0;
  int lastRequestedPage = 1;
  String? lastStatus;
  String? lastGender;
  String? lastSpecies;
  String? lastType;

  @override
  Future<CharacterFetchResult> getCharacters({
    int page = 1,
    String? name,
    String? status,
    String? species,
    String? gender,
    String? type,
  }) async {
    getCharactersCallCount++;
    lastRequestedPage = page;
    lastStatus = status;
    lastGender = gender;
    lastSpecies = species;
    lastType = type;

    final mockCharacters = [
      CharacterEntity(
        id: (page - 1) * 2 + 1,
        name: 'Character Page $page Item 1',
        status: 'Alive',
        species: 'Human',
        type: type ?? '',
        gender: 'Male',
        originName: 'Earth',
        locationName: 'Earth',
        imageUrl: '',
        episodeUrls: const [],
        created: '',
      ),
      CharacterEntity(
        id: (page - 1) * 2 + 2,
        name: 'Character Page $page Item 2',
        status: 'Alive',
        species: 'Human',
        type: type ?? '',
        gender: 'Female',
        originName: 'Earth',
        locationName: 'Earth',
        imageUrl: '',
        episodeUrls: const [],
        created: '',
      ),
    ];

    return CharacterFetchResult(
      characters: mockCharacters,
      totalPages: 3,
      totalCount: 6,
      hasNextPage: page < 3,
    );
  }

  @override
  Future<CharacterEntity> getSingleCharacter(int id) async {
    throw UnimplementedError();
  }

  @override
  Future<List<CharacterEntity>> getMultipleCharacters(List<int> ids) async {
    throw UnimplementedError();
  }
}

void main() {
  group('CharacterCubit Pagination & Filter Tests', () {
    late MockCharacterRepository mockRepository;
    late CharacterCubit cubit;

    setUp(() {
      mockRepository = MockCharacterRepository();
      cubit = CharacterCubit(repository: mockRepository);
    });

    tearDown(() {
      cubit.close();
    });

    test('1. Initial fetch loads page 1', () async {
      await cubit.fetchCharacters();

      expect(cubit.state.status, CharacterStatus.success);
      expect(cubit.state.page, 1);
      expect(cubit.state.characters.length, 2);
      expect(cubit.state.hasNextPage, isTrue);
      expect(mockRepository.lastRequestedPage, 1);
    });

    test('2. loadNextPage fetches page 2 and appends characters', () async {
      await cubit.fetchCharacters();
      expect(cubit.state.characters.length, 2);

      await cubit.loadNextPage();

      expect(cubit.state.status, CharacterStatus.success);
      expect(cubit.state.page, 2);
      expect(cubit.state.characters.length, 4);
      expect(cubit.state.characters[0].name, 'Character Page 1 Item 1');
      expect(cubit.state.characters[2].name, 'Character Page 2 Item 1');
      expect(cubit.state.hasNextPage, isTrue);
      expect(mockRepository.lastRequestedPage, 2);
    });

    test('3. Pagination stops when page reach last page (hasNextPage = false)', () async {
      await cubit.fetchCharacters(); // page 1
      await cubit.loadNextPage();    // page 2
      await cubit.loadNextPage();    // page 3 (hasNextPage becomes false)

      expect(cubit.state.page, 3);
      expect(cubit.state.characters.length, 6);
      expect(cubit.state.hasNextPage, isFalse);

      final callsCountBefore = mockRepository.getCharactersCallCount;

      await cubit.loadNextPage();

      expect(mockRepository.getCharactersCallCount, callsCountBefore);
    });

    test('4. Applying filter resets pagination page to 1 and applies type filter', () async {
      await cubit.fetchCharacters();
      await cubit.loadNextPage();
      expect(cubit.state.page, 2);

      cubit.applyFilters(status: 'Alive', type: 'Genetic experiment');
      await Future.delayed(Duration.zero);

      expect(cubit.state.page, 1);
      expect(cubit.state.characters.length, 2);
      expect(cubit.state.statusFilter, 'Alive');
      expect(cubit.state.typeFilter, 'Genetic experiment');
      expect(mockRepository.lastType, 'Genetic experiment');
    });

    test('5. Tapping X on filter chip explicitly clears that specific filter', () async {
      cubit.applyFilters(status: 'Alive', gender: 'Male', species: 'Human', type: 'Cyborg');
      await Future.delayed(Duration.zero);
      expect(cubit.state.statusFilter, 'Alive');
      expect(cubit.state.genderFilter, 'Male');
      expect(cubit.state.speciesFilter, 'Human');
      expect(cubit.state.typeFilter, 'Cyborg');

      // Tap X on Status chip -> removes status filter
      cubit.applyFilters(status: null, gender: cubit.state.genderFilter, species: cubit.state.speciesFilter, type: cubit.state.typeFilter);
      await Future.delayed(Duration.zero);

      expect(cubit.state.statusFilter, isNull);
      expect(cubit.state.genderFilter, 'Male');
      expect(cubit.state.speciesFilter, 'Human');
      expect(cubit.state.typeFilter, 'Cyborg');
      expect(mockRepository.lastStatus, isNull);
      expect(mockRepository.lastGender, 'Male');
    });

    test('6. clearExportPath clears exportPath in state', () {
      cubit.clearExportPath();
      expect(cubit.state.exportPath, isNull);
    });
  });
}
