import 'package:equatable/equatable.dart';

class CharacterEntity extends Equatable {
  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final String originName;
  final String locationName;
  final String imageUrl;
  final List<String> episodeUrls;
  final String created;

  const CharacterEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.imageUrl,
    required this.episodeUrls,
    required this.created,
  });

  bool get isAlive => status.toLowerCase() == 'alive';
  bool get isDead => status.toLowerCase() == 'dead';
  bool get isUnknown => !isAlive && !isDead;

  @override
  List<Object?> get props => [
        id,
        name,
        status,
        species,
        type,
        gender,
        originName,
        locationName,
        imageUrl,
        episodeUrls,
        created,
      ];
}
