import 'package:equatable/equatable.dart';
import '../../domain/entities/character_entity.dart';

enum CharacterStatus { initial, loading, success, failure }

class CharacterState extends Equatable {
  final CharacterStatus status;
  final List<CharacterEntity> characters;
  final int page;
  final int totalCount;
  final bool hasNextPage;
  final bool isLoadingMore;
  final String? nameQuery;
  final String? statusFilter; // 'alive', 'dead', 'unknown'
  final String? genderFilter; // 'female', 'male', 'genderless', 'unknown'
  final String? speciesFilter;
  final String? typeFilter;
  final String? errorMessage;
  final bool isExporting;
  final String? exportPath;

  const CharacterState({
    this.status = CharacterStatus.initial,
    this.characters = const [],
    this.page = 1,
    this.totalCount = 0,
    this.hasNextPage = false,
    this.isLoadingMore = false,
    this.nameQuery,
    this.statusFilter,
    this.genderFilter,
    this.speciesFilter,
    this.typeFilter,
    this.errorMessage,
    this.isExporting = false,
    this.exportPath,
  });

  bool get hasActiveFilters =>
      (nameQuery != null && nameQuery!.isNotEmpty) ||
      statusFilter != null ||
      genderFilter != null ||
      speciesFilter != null ||
      typeFilter != null;

  CharacterState copyWith({
    CharacterStatus? status,
    List<CharacterEntity>? characters,
    int? page,
    int? totalCount,
    bool? hasNextPage,
    bool? isLoadingMore,
    String? nameQuery,
    String? statusFilter,
    String? genderFilter,
    String? speciesFilter,
    String? typeFilter,
    String? errorMessage,
    bool? isExporting,
    String? exportPath,
    bool clearNameQuery = false,
    bool clearStatusFilter = false,
    bool clearGenderFilter = false,
    bool clearSpeciesFilter = false,
    bool clearTypeFilter = false,
    bool clearExportPath = false,
  }) {
    return CharacterState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      page: page ?? this.page,
      totalCount: totalCount ?? this.totalCount,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      nameQuery: clearNameQuery ? null : (nameQuery ?? this.nameQuery),
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      genderFilter: clearGenderFilter ? null : (genderFilter ?? this.genderFilter),
      speciesFilter: clearSpeciesFilter ? null : (speciesFilter ?? this.speciesFilter),
      typeFilter: clearTypeFilter ? null : (typeFilter ?? this.typeFilter),
      errorMessage: errorMessage ?? this.errorMessage,
      isExporting: isExporting ?? this.isExporting,
      exportPath: clearExportPath ? null : (exportPath ?? this.exportPath),
    );
  }

  @override
  List<Object?> get props => [
        status,
        characters,
        page,
        totalCount,
        hasNextPage,
        isLoadingMore,
        nameQuery,
        statusFilter,
        genderFilter,
        speciesFilter,
        typeFilter,
        errorMessage,
        isExporting,
        exportPath,
      ];
}
