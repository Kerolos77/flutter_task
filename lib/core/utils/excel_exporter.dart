import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/character/domain/entities/character_entity.dart';

class ExcelExporter {
  static Future<String> exportCharactersToExcel(List<CharacterEntity> characters) async {
    try {
      final excel = Excel.createExcel();
      
      // Rename default sheet
      final String defaultSheet = excel.getDefaultSheet() ?? 'Sheet1';
      excel.rename(defaultSheet, 'Rick & Morty Characters');
      final Sheet sheetObject = excel['Rick & Morty Characters'];

      // Headers
      final List<CellValue> headers = [
        TextCellValue('ID'),
        TextCellValue('Name'),
        TextCellValue('Status'),
        TextCellValue('Species'),
        TextCellValue('Type'),
        TextCellValue('Gender'),
        TextCellValue('Origin'),
        TextCellValue('Last Known Location'),
        TextCellValue('Episodes Count'),
        TextCellValue('Image URL'),
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

  static Future<void> openExportedFile(String filePath,int characterCount ) async {
    try {
      // Directly trigger native share dialog
      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Rick & Morty Characters Export',
            text: 'Exported $characterCount characters from Rick & Morty App.',
          );
    } catch (_) {}
  }
}
