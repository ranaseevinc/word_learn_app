import 'package:flutter/material.dart';

class TranslationHelper {
  static final Map<String, String> _turkishTranslations = {
    'apple': 'elma',
    'car': 'araba',
    'house': 'ev',
    'dog': 'köpek',
    'cat': 'kedi',
    'school': 'okul',
    'book': 'kitap',
    'computer': 'bilgisayar',
    'phone': 'telefon',

  };

  static String getTranslatedWord(BuildContext context, String englishWord) {
    final languageCode = Localizations.localeOf(context).languageCode;

    if (languageCode == 'tr') {
      return _turkishTranslations[englishWord.toLowerCase()] ?? englishWord;
    } else {
      return englishWord;
    }
  }
}
