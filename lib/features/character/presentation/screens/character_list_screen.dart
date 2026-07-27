import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/character_cubit.dart';
import '../cubit/character_state.dart';
import '../widgets/active_filter_chips_bar.dart';
import '../widgets/character_card.dart';
import '../widgets/character_count_bar.dart';
import '../widgets/character_list_app_bar.dart';
import '../widgets/character_search_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/shimmer_loading.dart';

class CharacterListScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDarkMode;

  const CharacterListScreen({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<CharacterCubit>().fetchCharacters();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      context.read<CharacterCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterBottomSheet(CharacterState state) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterBottomSheet(
          initialStatus: state.statusFilter,
          initialGender: state.genderFilter,
          initialSpecies: state.speciesFilter,
          initialType: state.typeFilter,
          onApply: (status, gender, species, type) {
            context.read<CharacterCubit>().applyFilters(
                  status: status,
                  gender: gender,
                  species: species,
                  type: type,
                );
          },
          onClear: () {
            context.read<CharacterCubit>().clearFilters();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CharacterListAppBar(
        isDarkMode: widget.isDarkMode,
        onToggleTheme: widget.onToggleTheme,
      ),
      body: BlocConsumer<CharacterCubit, CharacterState>(
        listener: (context, state) {
          if (state.errorMessage != null && state.status == CharacterStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.dead,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          if (state.exportPath != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.excelCreatedSuccess),
                backgroundColor: AppColors.alive,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<CharacterCubit>().clearExportPath();
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              // Search Bar & Filter Action Button
              CharacterSearchBar(
                searchController: _searchController,
                onSearchChanged: (val) {
                  context.read<CharacterCubit>().onSearchChanged(val);
                },
                onOpenFilter: () => _openFilterBottomSheet(state),
                hasActiveFilters: state.hasActiveFilters,
                isDarkMode: widget.isDarkMode,
              ),

              // Active Filters Chips Bar
              ActiveFilterChipsBar(
                state: state,
                onClearAll: () {
                  _searchController.clear();
                  context.read<CharacterCubit>().clearFilters();
                },
                onApplyFilters: ({status, gender, species, type}) {
                  context.read<CharacterCubit>().applyFilters(
                        status: status,
                        gender: gender,
                        species: species,
                        type: type,
                      );
                },
              ),

              // Character Count Indicator Bar
              CharacterCountBar(state: state),

              // Main Characters List Body
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.portalGreen,
                  onRefresh: () async {
                    await context.read<CharacterCubit>().fetchCharacters(isRefresh: true);
                  },
                  child: _buildMainBody(context, state),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          return FloatingActionButton.extended(
            onPressed: state.isExporting
                ? null
                : () {
                    context.read<CharacterCubit>().exportToExcel();
                  },
            backgroundColor: AppColors.portalGreen,
            foregroundColor: Colors.white,
            icon: state.isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.file_download_rounded),
            label: const Text(AppStrings.exportExcelButton, style: TextStyle(fontWeight: FontWeight.bold)),
          );
        },
      ),
    );
  }

  Widget _buildMainBody(BuildContext context, CharacterState state) {
    if (state.status == CharacterStatus.loading && state.characters.isEmpty) {
      return const ShimmerLoadingList();
    }

    if (state.status == CharacterStatus.failure && state.characters.isEmpty) {
      return ErrorStateWidget(
        errorMessage: state.errorMessage ?? AppStrings.failedToLoadCharacters,
        onRetry: () {
          context.read<CharacterCubit>().fetchCharacters();
        },
      );
    }

    if (state.characters.isEmpty && state.status == CharacterStatus.success) {
      return EmptyStateWidget(
        onResetFilters: () {
          _searchController.clear();
          context.read<CharacterCubit>().clearFilters();
        },
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: state.characters.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= state.characters.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.portalGreen,
                ),
              ),
            ),
          );
        }

        final character = state.characters[index];
        return CharacterCard(character: character);
      },
    );
  }
}
