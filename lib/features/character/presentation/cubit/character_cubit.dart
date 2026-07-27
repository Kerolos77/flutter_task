import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/excel_exporter.dart';
import '../../domain/repositories/character_repository.dart';
import 'character_state.dart';

class CharacterCubit extends Cubit<CharacterState> {
  final CharacterRepository repository;
  Timer? _debounceTimer;

  CharacterCubit({required this.repository}) : super(const CharacterState());

  Future<void> fetchCharacters({
    String? nameQuery,
    String? statusFilter,
    String? genderFilter,
    String? speciesFilter,
    String? typeFilter,
    bool isRefresh = false,
    bool isExplicitFilterChange = false,
  }) async {
    final queryName = nameQuery ?? state.nameQuery;
    final queryStatus = isExplicitFilterChange
        ? statusFilter
        : (statusFilter ?? state.statusFilter);
    final queryGender = isExplicitFilterChange
        ? genderFilter
        : (genderFilter ?? state.genderFilter);
    final querySpecies = isExplicitFilterChange
        ? speciesFilter
        : (speciesFilter ?? state.speciesFilter);
    final queryType = isExplicitFilterChange
        ? typeFilter
        : (typeFilter ?? state.typeFilter);

    emit(
      state.copyWith(
        status: CharacterStatus.loading,
        page: 1,
        nameQuery: queryName,
        statusFilter: queryStatus,
        genderFilter: queryGender,
        speciesFilter: querySpecies,
        typeFilter: queryType,
        clearStatusFilter: isExplicitFilterChange && statusFilter == null,
        clearGenderFilter: isExplicitFilterChange && genderFilter == null,
        clearSpeciesFilter: isExplicitFilterChange && speciesFilter == null,
        clearTypeFilter: isExplicitFilterChange && typeFilter == null,
        clearExportPath: true,
        errorMessage: null,
      ),
    );

    try {
      final result = await repository.getCharacters(
        page: 1,
        name: queryName,
        status: queryStatus,
        species: querySpecies,
        gender: queryGender,
        type: queryType,
      );

      emit(
        state.copyWith(
          status: CharacterStatus.success,
          characters: result.characters,
          page: 1,
          totalCount: result.totalCount,
          hasNextPage: result.hasNextPage,
          isLoadingMore: false,
          clearExportPath: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CharacterStatus.failure,
          errorMessage: e.toString().replaceAll('Exception: ', ''),
          clearExportPath: true,
        ),
      );
    }
  }

  Future<void> loadNextPage() async {
    if (state.isLoadingMore ||
        !state.hasNextPage ||
        state.status == CharacterStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, clearExportPath: true));

    final nextPage = state.page + 1;

    try {
      final result = await repository.getCharacters(
        page: nextPage,
        name: state.nameQuery,
        status: state.statusFilter,
        species: state.speciesFilter,
        gender: state.genderFilter,
        type: state.typeFilter,
      );

      final updatedList = List.of(state.characters)..addAll(result.characters);

      emit(
        state.copyWith(
          status: CharacterStatus.success,
          characters: updatedList,
          page: nextPage,
          totalCount: result.totalCount,
          hasNextPage: result.hasNextPage,
          isLoadingMore: false,
          clearExportPath: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoadingMore: false, clearExportPath: true));
    }
  }

  void onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      fetchCharacters(nameQuery: query.trim());
    });
  }

  void applyFilters({
    String? status,
    String? gender,
    String? species,
    String? type,
  }) {
    fetchCharacters(
      statusFilter: status,
      genderFilter: gender,
      speciesFilter: species,
      typeFilter: type,
      isExplicitFilterChange: true,
    );
  }

  void clearFilters() {
    emit(
      state.copyWith(
        clearNameQuery: true,
        clearStatusFilter: true,
        clearGenderFilter: true,
        clearSpeciesFilter: true,
        clearTypeFilter: true,
        clearExportPath: true,
      ),
    );
    fetchCharacters(
      nameQuery: '',
      statusFilter: null,
      genderFilter: null,

      speciesFilter: null,
      typeFilter: null,
      isExplicitFilterChange: true,
    );
  }

  Future<void> exportToExcel() async {
    if (state.characters.isEmpty) return;

    emit(state.copyWith(isExporting: true, clearExportPath: true));

    try {
      final path = await ExcelExporter.exportCharactersToExcel(
        state.characters,
      );
      emit(state.copyWith(isExporting: false, exportPath: path));
    } catch (e) {
      emit(
        state.copyWith(
          isExporting: false,
          errorMessage:
              'Export failed: ${e.toString().replaceAll("Exception: ", "")}',
          clearExportPath: true,
        ),
      );
    }
  }

  void clearExportPath() {
    emit(state.copyWith(clearExportPath: true));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
