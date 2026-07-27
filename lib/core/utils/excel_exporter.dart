import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../constants/app_strings.dart';
import '../../features/character/domain/entities/character_entity.dart';

class ExcelExporter {
  static Future<String> exportCharactersToExcel(List<CharacterEntity> characters) async {
    try {
      final excel = Excel.createExcel();
      
      // Rename default sheet
      final String defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
      excel.rename(defaultSheet, AppStrings.excelSheetTitle);
      final Sheet sheetObject = excel[AppStrings.excelSheetTitle];

      // Headers
      final List<CellValue> headers = [
        TextCellValue(AppStrings.headerId),
        TextCellValue(AppStrings.headerName),
        TextCellValue(AppStrings.headerStatus),
        TextCellValue(AppStrings.headerSpecies),
        TextCellValue(AppStrings.headerType),
        TextCellValue(AppStrings.headerGender),
        TextCellValue(AppStrings.headerOrigin),
        TextCellValue(AppStrings.headerLastLocation),
        TextCellValue(AppStrings.headerEpisodesCount),
        TextCellValue(AppStrings.headerImageUrl),
      ];

      sheetObject.appendRow(headers);

      // Data Rows
      for (final char in characters) {
        sheetObject.appendRow([
          IntCellValue(char.id),
          TextCellValue(char.name),
          TextCellValue(char.status),
          TextCellValue(char.species),
          TextCellValue(char.type),
          TextCellValue(char.gender),
          TextCellValue(char.originName),
          TextCellValue(char.locationName),
          IntCellValue(char.episodeUrls.length),
          TextCellValue(char.imageUrl),
        ]);
      }

      final fileBytes = excel.save();
      if (fileBytes == null || fileBytes.isEmpty) {
        throw Exception('Failed to generate Excel file bytes.');
      }

      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/rick_and_morty_characters_$timestamp.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);
      openExportedFile(filePath, characters.length);

      return filePath;
    } catch (e) {
      throw Exception('Excel Export Error: $e');
    }
  }

  static Future<void> openExportedFile(String filePath, int characterCount) async {
    try {
      // Directly trigger native share dialog
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: AppStrings.shareSubject,
        text: 'Exported $characterCount characters from Rick & Morty App.',
      );
    } catch (_) {}
  }
}
