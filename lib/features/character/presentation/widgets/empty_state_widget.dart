import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onResetFilters;

  const EmptyStateWidget({
    super.key,
    this.title = 'No Characters Found',
    this.message = 'No characters matched your active search or filter criteria.',
    this.onResetFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.portalGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                size: 64,
                color: AppColors.portalGreen,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onResetFilters != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onResetFilters,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reset All Filters'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.portalGreen,
                  side: const BorderSide(color: AppColors.portalGreen),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
