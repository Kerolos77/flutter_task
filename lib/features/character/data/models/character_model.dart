import '../../domain/entities/character_entity.dart';

class CharacterModel extends CharacterEntity {
  const CharacterModel({
    required super.id,
    required super.name,
    required super.status,
    required super.species,
    required super.type,
    required super.gender,
    required super.originName,
    required super.locationName,
    required super.imageUrl,
    required super.episodeUrls,
    required super.created,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown Name',
      status: json['status'] as String? ?? 'unknown',
      species: json['species'] as String? ?? 'Unknown Species',
      type: json['type'] as String? ?? '',
      gender: json['gender'] as String? ?? 'unknown',
      originName: (json['origin'] != null && json['origin']['name'] != null)
          ? json['origin']['name'] as String
          : 'Unknown Origin',
      locationName: (json['location'] != null && json['location']['name'] != null)
          ? json['location']['name'] as String
          : 'Unknown Location',
      imageUrl: json['image'] as String? ?? '',
      episodeUrls: json['episode'] != null
          ? List<String>.from(json['episode'] as List)
          : const [],
      created: json['created'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': {'name': originName},
      'location': {'name': locationName},
      'image': imageUrl,
      'episode': episodeUrls,
      'created': created,
    };
  }
}
