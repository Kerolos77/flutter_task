import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/character_cubit.dart';
import '../cubit/character_state.dart';

class CharacterListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const CharacterListAppBar({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
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
            AppStrings.appBarTitle,
            style: theme.appBarTheme.titleTextStyle,
          ),
        ],
      ),
      actions: [
        IconButton(
          tooltip: isDarkMode ? AppStrings.switchToLightMode : AppStrings.switchToDarkMode,
          icon: Icon(
            isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            color: AppColors.portalGreen,
          ),
          onPressed: onToggleTheme,
        ),
        BlocBuilder<CharacterCubit, CharacterState>(
          builder: (context, state) {
            return IconButton(
              tooltip: AppStrings.exportToExcelTooltip,
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
    );
  }
}
