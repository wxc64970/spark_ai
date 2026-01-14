import 'dart:io';
import 'package:encrypt/encrypt.dart';

void main() {
  // Original key from user (invalid length 26)
  final rawKey = '21414212432453255435466576';
  // Pad to 32 bytes
  final validKeyStr = rawKey.padRight(32, '0');

  final key = Key.fromUtf8(validKeyStr);
  final iv = IV.fromBase64('gScioPT85qqx5d/ExwMvbw==');
  final encrypter = Encrypter(AES(key));

  String encrypt(String input) {
    return encrypter.encrypt(input, iv: iv).base64;
  }

  final file = File('/Users/wangchao/Documents/work/spark_ai/lib/saCommon/sa_values/textData.dart');
  final lines = file.readAsLinesSync();
  final newLines = <String>[];

  // Regexes
  final regexSingle = RegExp(r"'([^'\\]*(?:\\.[^'\\]*)*)'");
  final regexDouble = RegExp(r'"([^"\\]*(?:\\.[^"\\]*)*)"');

  for (var line in lines) {
    // Update the key definition
    if (line.contains('static final _key = Key.fromUtf8')) {
      newLines.add("  static final _key = Key.fromUtf8('$validKeyStr');");
      continue;
    }

    // Skip IV line and others, keep them as is
    if (line.contains('Key.fromUtf8') || line.contains('IV.fromBase64') || line.contains('package:encrypt')) {
      newLines.add(line);
      continue;
    }

    // Skip the _decrypt method definition itself
    if (line.contains('_decrypt(')) {
      newLines.add(line);
      continue;
    }

    String newLine = line;

    // Helper to process regex
    newLine = processRegex(regexSingle, newLine, encrypt);
    newLine = processRegex(regexDouble, newLine, encrypt);

    newLines.add(newLine);
  }

  // Write back
  final outputFile = File('/Users/wangchao/Documents/work/spark_ai/lib/saCommon/sa_values/textData_encrypted.dart');
  outputFile.writeAsStringSync(newLines.join('\n'));
  print('Done. Check ${outputFile.path}');
}

String processRegex(RegExp regex, String line, String Function(String) encryptFunc) {
  String newLine = line;
  final matches = regex.allMatches(line);
  final matchesList = matches.toList();

  for (var i = matchesList.length - 1; i >= 0; i--) {
    final match = matchesList[i];
    final content = match.group(1);

    if (content == null) continue;

    if (content.contains(r'$')) {
      continue;
    }

    // We only encrypt non-empty strings usually, but empty strings are fine to encrypt too.
    // If quote is double, unescape \"
    // If quote is single, unescape \'
    String valueToEncrypt = content;

    // Check which quote type by checking the full match text
    final fullMatch = line.substring(match.start, match.end);
    final isDouble = fullMatch.startsWith('"');

    if (isDouble) {
      if (valueToEncrypt.contains(r'\"')) {
        valueToEncrypt = valueToEncrypt.replaceAll(r'\"', '"');
      }
    } else {
      if (valueToEncrypt.contains(r"\'")) {
        valueToEncrypt = valueToEncrypt.replaceAll(r"\'", "'");
      }
    }

    if (valueToEncrypt.contains(r"\\")) {
      valueToEncrypt = valueToEncrypt.replaceAll(r"\\", r"\");
    }
    valueToEncrypt = valueToEncrypt.replaceAll(r'\n', '\n');

    try {
      final encrypted = encryptFunc(valueToEncrypt);

      final replacement = "_decrypt('$encrypted')";
      newLine = newLine.replaceRange(match.start, match.end, replacement);

      if (newLine.contains('static const')) {
        newLine = newLine.replaceFirst('static const', 'static final');
      }
    } catch (e) {
      print('Error encrypting match: $fullMatch. Error: $e');
    }
  }
  return newLine;
}
