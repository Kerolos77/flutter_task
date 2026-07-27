import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/character_state.dart';

class ActiveFilterChipsBar extends StatelessWidget {
  final CharacterState state;
  final VoidCallback onClearAll;
  final Function({String? status, String? gender, String? species, String? type}) onApplyFilters;

  const ActiveFilterChipsBar({
    super.key,
    required this.state,
    required this.onClearAll,
    required this.onApplyFilters,
  });

  @override
  Widget build(BuildContext context) {
    if (!state.hasActiveFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (state.statusFilter != null)
            _buildFilterChip(
              label: 'Status: ${state.statusFilter}',
              onDeleted: () {
                onApplyFilters(
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
                onApplyFilters(
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
                onApplyFilters(
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
                onApplyFilters(
                  status: state.statusFilter,
                  gender: state.genderFilter,
                  species: state.speciesFilter,
                  type: null,
                );
              },
            ),
          TextButton(
            onPressed: onClearAll,
            child: const Text('Clear All', style: TextStyle(fontSize: 12)),
          )
        ],
      ),
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
