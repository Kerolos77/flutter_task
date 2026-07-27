import 'package:flutter/material.dart';
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
                          title: 'Species',
                          value: character.species,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CharacterDetailTile(
                          icon: Icons.wc_rounded,
                          title: 'Gender',
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
                          title: 'Episodes',
                          value: '${character.episodeUrls.length} Episodes',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CharacterDetailTile(
                          icon: Icons.tag_rounded,
                          title: 'Character ID',
                          value: '#${character.id}',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  CharacterDetailTile(
                    icon: Icons.category_rounded,
                    title: 'Character Type',
                    value: character.type.trim().isNotEmpty
                        ? character.type.trim()
                        : 'Standard / None',
                  ),

                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Location Details Section
                  Text(
                    'Location Details',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.portalGreen,
                    ),
                  ),

                  const SizedBox(height: 12),

                  CharacterLocationCard(
                    title: 'Origin Planet',
                    locationName: character.originName,
                    icon: Icons.public_rounded,
                  ),

                  const SizedBox(height: 12),

                  CharacterLocationCard(
                    title: 'Last Known Location',
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
