import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class FilterBottomSheet extends StatefulWidget {
  final String? initialStatus;
  final String? initialGender;
  final String? initialSpecies;
  final String? initialType;
  final Function(String? status, String? gender, String? species, String? type) onApply;
  final VoidCallback onClear;

  const FilterBottomSheet({
    super.key,
    this.initialStatus,
    this.initialGender,
    this.initialSpecies,
    this.initialType,
    required this.onApply,
    required this.onClear,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _selectedStatus;
  String? _selectedGender;
  String? _selectedSpecies;
  String? _selectedType;
  final TextEditingController _typeController = TextEditingController();

  final List<String> _statusOptions = ['alive', 'dead', 'unknown'];
  final List<String> _genderOptions = ['female', 'male', 'genderless', 'unknown'];
  final List<String> _speciesOptions = [
    'human',
    'alien',
    'humanoid',
    'poopybutthole',
    'mythological creature',
    'animal',
    'robot',
    'cronenberg'
  ];

  final List<String> _commonTypeOptions = [
    'Genetic experiment',
    'Superhuman',
    'Parasite',
    'Gromflomite',
    'Cyborg',
    'Clone',
    'Robot',
    'Cronenberg',
    'Microverse inhabitant',
    'Mytholog',
    'Gazorpian',
    'Cat-Person',
    'Zigerion',
    'Meeseeks',
    'Plutonian',
    'Alphabetrian',
    'Pickle',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
    _selectedGender = widget.initialGender;
    _selectedSpecies = widget.initialSpecies;
    _selectedType = widget.initialType;
    if (_selectedType != null) {
      _typeController.text = _selectedType!;
    }
  }

  @override
  void dispose() {
    _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle & Title
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Characters',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedStatus = null;
                      _selectedGender = null;
                      _selectedSpecies = null;
                      _selectedType = null;
                      _typeController.clear();
                    });
                    widget.onClear();
                    Navigator.pop(context);
                  },
                  child: const Text('Reset All'),
                ),
              ],
            ),

            const Divider(height: 24),

            // Status Filter
            _buildSectionTitle('Status'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _statusOptions.map((status) {
                final isSelected = _selectedStatus == status;
                return ChoiceChip(
                  label: Text(status.toUpperCase()),
                  selected: isSelected,
                  selectedColor: AppColors.portalGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedStatus = selected ? status : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Gender Filter
            _buildSectionTitle('Gender'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _genderOptions.map((gender) {
                final isSelected = _selectedGender == gender;
                return ChoiceChip(
                  label: Text(gender.toUpperCase()),
                  selected: isSelected,
                  selectedColor: AppColors.portalGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedGender = selected ? gender : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Species Filter
            _buildSectionTitle('Species'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _speciesOptions.map((species) {
                final isSelected = _selectedSpecies == species;
                return ChoiceChip(
                  label: Text(species.toUpperCase()),
                  selected: isSelected,
                  selectedColor: AppColors.portalGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedSpecies = selected ? species : null;
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Type Filter
            _buildSectionTitle('Character Type'),
            const SizedBox(height: 8),
            TextField(
              controller: _typeController,
              onChanged: (val) {
                setState(() {
                  _selectedType = val.trim().isNotEmpty ? val.trim() : null;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter character type (e.g. Genetic experiment)',
                prefixIcon: const Icon(Icons.category_outlined),
                suffixIcon: _typeController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _typeController.clear();
                          setState(() {
                            _selectedType = null;
                          });
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _commonTypeOptions.map((typeOption) {
                final isSelected = _selectedType?.toLowerCase() == typeOption.toLowerCase();
                return ChoiceChip(
                  label: Text(typeOption),
                  selected: isSelected,
                  selectedColor: AppColors.portalGreen,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                    fontSize: 11,
                  ),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedType = typeOption;
                        _typeController.text = typeOption;
                      } else {
                        _selectedType = null;
                        _typeController.clear();
                      }
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final finalType = _typeController.text.trim().isNotEmpty
                      ? _typeController.text.trim()
                      : _selectedType;
                  widget.onApply(_selectedStatus, _selectedGender, _selectedSpecies, finalType);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.portalGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.portalGreen,
      ),
    );
  }
}
