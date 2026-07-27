class AppStrings {
  // App General
  static const String appTitle = 'Rick & Morty Explorer';
  static const String appBarTitle = 'Rick & Morty';

  // Navigation & Tooltips
  static const String switchToLightMode = 'Switch to Light Mode';
  static const String switchToDarkMode = 'Switch to Dark Mode';
  static const String exportToExcelTooltip = 'Export to Excel (.xlsx)';
  static const String totalCharactersLabel = 'Total Characters';
  static const String showingCountLabel = 'Showing';

  // Search & Filters
  static const String searchHint = 'Search characters...';
  static const String filterCharacters = 'Filter Characters';
  static const String resetAll = 'Reset All';
  static const String clearAll = 'Clear All';
  static const String applyFiltersButton = 'Apply Filters';
  static const String statusHeader = 'Status';
  static const String genderHeader = 'Gender';
  static const String speciesHeader = 'Species';
  static const String typeHeader = 'Character Type';
  static const String enterTypeHint = 'Enter character type (e.g. Genetic experiment)';

  // Filter Values
  static const String statusAlive = 'alive';
  static const String statusDead = 'dead';
  static const String statusUnknown = 'unknown';

  static const String genderFemale = 'female';
  static const String genderMale = 'male';
  static const String genderGenderless = 'genderless';
  static const String genderUnknown = 'unknown';

  // Detail Screen
  static const String speciesLabel = 'Species';
  static const String genderLabel = 'Gender';
  static const String episodesLabel = 'Episodes';
  static const String characterIdLabel = 'Character ID';
  static const String locationDetailsHeader = 'Location Details';
  static const String originPlanetLabel = 'Origin Planet';
  static const String lastKnownLocationLabel = 'Last Known Location';
  static const String standardNoneType = 'Standard / None';

  // Export & Sharing
  static const String exportExcelButton = 'Export Excel';
  static const String excelCreatedSuccess = 'Excel file created & shared successfully!';
  static const String excelSheetTitle = 'Rick & Morty Characters';
  static const String shareSubject = 'Rick & Morty Characters Export';
  static const String openAgain = 'OPEN AGAIN';

  // Headers for Excel
  static const String headerId = 'ID';
  static const String headerName = 'Name';
  static const String headerStatus = 'Status';
  static const String headerSpecies = 'Species';
  static const String headerType = 'Type';
  static const String headerGender = 'Gender';
  static const String headerOrigin = 'Origin';
  static const String headerLastLocation = 'Last Known Location';
  static const String headerEpisodesCount = 'Episodes Count';
  static const String headerImageUrl = 'Image URL';

  // States & Errors
  static const String portalMalfunction = 'Oops! Portal Malfunction';
  static const String tryAgain = 'Try Again';
  static const String noCharactersFoundTitle = 'No Characters Found';
  static const String noCharactersFoundMessage = 'No characters matched your active search or filter criteria.';
  static const String resetAllFiltersButton = 'Reset All Filters';
  static const String failedToLoadCharacters = 'Failed to load characters.';
  static const String exportFailedPrefix = 'Export failed: ';

  // Api Error Messages
  static const String connectionTimeout = 'Connection timeout. Please check your internet connection.';
  static const String noCharactersFoundCriteria = 'No characters found matching your criteria.';
  static const String serverErrorPrefix = 'Server error (';
  static const String serverErrorSuffix = '). Please try again later.';
  static const String requestCancelled = 'Request was cancelled.';
  static const String noInternetConnection = 'No internet connection available.';
  static const String somethingWentWrong = 'Something went wrong. Please try again.';
}
