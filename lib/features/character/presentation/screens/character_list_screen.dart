import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/character_cubit.dart';
import '../cubit/character_state.dart';
import '../widgets/character_card.dart';
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 30,
                height: 30,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.auto_awesome,
                  color: AppColors.neonCyber,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Rick & Morty',
              style: theme.appBarTheme.titleTextStyle,
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: widget.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: AppColors.portalGreen,
            ),
            onPressed: widget.onToggleTheme,
          ),
          BlocBuilder<CharacterCubit, CharacterState>(
            builder: (context, state) {
              return IconButton(
                tooltip: 'Export to Excel (.xlsx)',
                icon: state.isExporting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.portalGreen,
                        ),
                      )
                    : const Icon(
                        Icons.explicit_outlined,
                        color: AppColors.portalGreen,
                        size: 26,
                      ),
                onPressed: state.isExporting
                    ? null
                    : () {
                        context.read<CharacterCubit>().exportToExcel();
                      },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
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
                content: Text('Excel file created & shared successfully!'),
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
              // Search & Filter Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    // Search Input Field
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (val) {
                          context.read<CharacterCubit>().onSearchChanged(val);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search characters...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 20),
                                  onPressed: () {
                                    _searchController.clear();
                                    context.read<CharacterCubit>().onSearchChanged('');
                                  },
                                )
                              : null,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // Filter Button
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: state.hasActiveFilters
                                ? AppColors.portalGreen
                                : theme.cardTheme.color,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: state.hasActiveFilters
                                  ? AppColors.portalGreen
                                  : (widget.isDarkMode
                                      ? AppColors.borderDark
                                      : AppColors.borderLight),
                            ),
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.filter_list_rounded,
                              color: state.hasActiveFilters
                                  ? Colors.white
                                  : AppColors.portalGreen,
                            ),
                            onPressed: () => _openFilterBottomSheet(state),
                          ),
                        ),
                        if (state.hasActiveFilters)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.neonCyber,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Active Filters Indicators
              if (state.hasActiveFilters)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      if (state.statusFilter != null)
                        _buildFilterChip(
                          label: 'Status: ${state.statusFilter}',
                          onDeleted: () {
                            context.read<CharacterCubit>().applyFilters(
                                  status: null,
                                  gender: state.genderFilter,
                                  species: state.speciesFilter,
                                  type: state.typeFilter,
                                );
                          },
                        ),
                      if (state.genderFilter != null)
                        _buildFilterChip(
                          label: 'Gender: ${state.genderFilter}',
                          onDeleted: () {
                            context.read<CharacterCubit>().applyFilters(
                                  status: state.statusFilter,
                                  gender: null,
                                  species: state.speciesFilter,
                                  type: state.typeFilter,
                                );
                          },
                        ),
                      if (state.speciesFilter != null)
                        _buildFilterChip(
                          label: 'Species: ${state.speciesFilter}',
                          onDeleted: () {
                            context.read<CharacterCubit>().applyFilters(
                                  status: state.statusFilter,
                                  gender: state.genderFilter,
                                  species: null,
                                  type: state.typeFilter,
                                );
                          },
                        ),
                      if (state.typeFilter != null)
                        _buildFilterChip(
                          label: 'Type: ${state.typeFilter}',
                          onDeleted: () {
                            context.read<CharacterCubit>().applyFilters(
                                  status: state.statusFilter,
                                  gender: state.genderFilter,
                                  species: state.speciesFilter,
                                  type: null,
                                );
                          },
                        ),
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                          context.read<CharacterCubit>().clearFilters();
                        },
                        child: const Text('Clear All', style: TextStyle(fontSize: 12)),
                      )
                    ],
                  ),
                ),

              // Character Count Bar
              if (state.status == CharacterStatus.success)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Characters: ${state.totalCount}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Showing ${state.characters.length}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.portalGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              // Main Body Content
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
            label: const Text('Export Excel', style: TextStyle(fontWeight: FontWeight.bold)),
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
        errorMessage: state.errorMessage ?? 'Failed to load characters.',
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

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDeleted,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        deleteIcon: const Icon(Icons.close_rounded, size: 14),
        onDeleted: onDeleted,
        backgroundColor: AppColors.portalGreen.withValues(alpha: 0.15),
        side: const BorderSide(color: AppColors.portalGreen, width: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
