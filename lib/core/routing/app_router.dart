import 'package:flutter/material.dart';
import '../../features/character/domain/entities/character_entity.dart';
import '../../features/character/presentation/screens/character_detail_screen.dart';
import '../../features/character/presentation/screens/character_list_screen.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings, {
    required VoidCallback onToggleTheme,
    required bool isDarkMode,
  }) {
    switch (settings.name) {
      case Routes.characterList:
        return MaterialPageRoute(
          builder: (_) => CharacterListScreen(
            onToggleTheme: onToggleTheme,
            isDarkMode: isDarkMode,
          ),
          settings: settings,
        );

      case Routes.characterDetail:
        final character = settings.arguments as CharacterEntity?;
        if (character == null) {
          return _errorRoute('Character details missing.');
        }
        return MaterialPageRoute(
          builder: (_) => CharacterDetailScreen(character: character),
          settings: settings,
        );

      default:
        return _errorRoute('No route defined for ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Navigation Error')),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
