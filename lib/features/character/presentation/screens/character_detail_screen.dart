import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/character_entity.dart';
import '../widgets/character_detail_header.dart';
import '../widgets/character_detail_tile.dart';
import '../widgets/character_location_card.dart';

class CharacterDetailScreen extends StatelessWidget {
  final CharacterEntity character;

  const CharacterDetailScreen({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Image Header
          CharacterDetailHeader(character: character),

          // Details List Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: CharacterDetailTile(
                          icon: Icons.fingerprint_rounded,
                          title: AppStrings.speciesLabel,
                          value: character.species,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CharacterDetailTile(
                          icon: Icons.wc_rounded,
                          title: AppStrings.genderLabel,
                          value: character.gender,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: CharacterDetailTile(
                          icon: Icons.movie_outlined,
                          title: AppStrings.episodesLabel,
                          value: '${character.episodeUrls.length} ${AppStrings.episodesLabel}',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CharacterDetailTile(
                          icon: Icons.tag_rounded,
                          title: AppStrings.characterIdLabel,
                          value: '#${character.id}',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  CharacterDetailTile(
                    icon: Icons.category_rounded,
                    title: AppStrings.typeHeader,
                    value: character.type.trim().isNotEmpty
                        ? character.type.trim()
                        : AppStrings.standardNoneType,
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Location Details Section
                  Text(
                    AppStrings.locationDetailsHeader,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.portalGreen,
                    ),
                  ),

                  const SizedBox(height: 12),

                  CharacterLocationCard(
                    title: AppStrings.originPlanetLabel,
                    locationName: character.originName,
                    icon: Icons.public_rounded,
                  ),

                  const SizedBox(height: 12),

                  CharacterLocationCard(
                    title: AppStrings.lastKnownLocationLabel,
                    locationName: character.locationName,
                    icon: Icons.location_on_rounded,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
