import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task/features/character/data/models/character_model.dart';
import 'package:flutter_task/features/character/data/models/character_response_model.dart';

void main() {
  group('CharacterModel & API Response Tests', () {
    test('1. Get all characters endpoint response parsing', () {
      final json = {
        'info': {
          'count': 826,
          'pages': 42,
          'next': 'https://rickandmortyapi.com/api/character?page=2',
          'prev': null
        },
        'results': [
          {
            'id': 1,
            'name': 'Rick Sanchez',
            'status': 'Alive',
            'species': 'Human',
            'type': '',
            'gender': 'Male',
            'origin': {'name': 'Earth (C-137)', 'url': 'https://rickandmortyapi.com/api/location/1'},
            'location': {'name': 'Citadel of Ricks', 'url': 'https://rickandmortyapi.com/api/location/3'},
            'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
            'episode': ['https://rickandmortyapi.com/api/episode/1'],
            'created': '2017-11-04T18:48:46.250Z'
          }
        ]
      };

      final responseModel = CharacterResponseModel.fromJson(json);

      expect(responseModel.totalCount, 826);
      expect(responseModel.totalPages, 42);
      expect(responseModel.nextPageUrl, 'https://rickandmortyapi.com/api/character?page=2');
      expect(responseModel.results.length, 1);
      
      final first = responseModel.results.first;
      expect(first.id, 1);
      expect(first.name, 'Rick Sanchez');
      expect(first.isAlive, isTrue);
      expect(first.originName, 'Earth (C-137)');
      expect(first.locationName, 'Citadel of Ricks');
    });

    test('2. Filter characters endpoint response parsing', () {
      final json = {
        'info': {
          'count': 29,
          'pages': 2,
          'next': 'https://rickandmortyapi.com/api/character/?page=2&name=rick&status=alive',
          'prev': null
        },
        'results': [
          {
            'id': 1,
            'name': 'Rick Sanchez',
            'status': 'Alive',
            'species': 'Human',
            'type': '',
            'gender': 'Male',
            'origin': {'name': 'Earth (C-137)'},
            'location': {'name': 'Citadel of Ricks'},
            'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
            'episode': ['https://rickandmortyapi.com/api/episode/1']
          }
        ]
      };

      final responseModel = CharacterResponseModel.fromJson(json);

      expect(responseModel.totalCount, 29);
      expect(responseModel.totalPages, 2);
      expect(responseModel.results.length, 1);
      expect(responseModel.results.first.name, 'Rick Sanchez');
      expect(responseModel.results.first.status, 'Alive');
    });

    test('3. Get a single character endpoint response parsing', () {
      final json = {
        'id': 2,
        'name': 'Morty Smith',
        'status': 'Alive',
        'species': 'Human',
        'type': '',
        'gender': 'Male',
        'origin': {'name': 'unknown', 'url': ''},
        'location': {'name': 'Citadel of Ricks', 'url': 'https://rickandmortyapi.com/api/location/3'},
        'image': 'https://rickandmortyapi.com/api/character/avatar/2.jpeg',
        'episode': ['https://rickandmortyapi.com/api/episode/1'],
        'created': '2017-11-04T18:50:21.651Z'
      };

      final model = CharacterModel.fromJson(json);

      expect(model.id, 2);
      expect(model.name, 'Morty Smith');
      expect(model.status, 'Alive');
      expect(model.species, 'Human');
      expect(model.gender, 'Male');
      expect(model.originName, 'unknown');
      expect(model.locationName, 'Citadel of Ricks');
      expect(model.imageUrl, 'https://rickandmortyapi.com/api/character/avatar/2.jpeg');
    });

    test('4. Get multiple characters endpoint response parsing', () {
      final jsonList = [
        {
          'id': 1,
          'name': 'Rick Sanchez',
          'status': 'Alive',
          'species': 'Human',
          'type': '',
          'gender': 'Male',
          'origin': {'name': 'Earth (C-137)'},
          'location': {'name': 'Citadel of Ricks'},
          'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
          'episode': ['https://rickandmortyapi.com/api/episode/1']
        },
        {
          'id': 183,
          'name': 'Johnny Depp',
          'status': 'Alive',
          'species': 'Human',
          'type': '',
          'gender': 'Male',
          'origin': {'name': 'Earth (C-137)'},
          'location': {'name': 'Earth (C-137)'},
          'image': 'https://rickandmortyapi.com/api/character/avatar/183.jpeg',
          'episode': ['https://rickandmortyapi.com/api/episode/8']
        }
      ];

      final characters = jsonList.map((item) => CharacterModel.fromJson(item)).toList();

      expect(characters.length, 2);
      expect(characters[0].id, 1);
      expect(characters[0].name, 'Rick Sanchez');
      expect(characters[1].id, 183);
      expect(characters[1].name, 'Johnny Depp');
    });
  });
}
