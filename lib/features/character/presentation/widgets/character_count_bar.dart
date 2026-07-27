import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/character_state.dart';

class CharacterCountBar extends StatelessWidget {
  final CharacterState state;

  const CharacterCountBar({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state.status != CharacterStatus.success) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
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
    );
  }
}
