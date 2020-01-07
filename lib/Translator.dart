import 'package:personal_site_app/constants.dart';
import 'package:translate/translate.dart';
import 'package:translator/translator.dart';

enum TranslateProvider { GOOGLE, YANDEX }

class Translator {
  final translateGoogle = GoogleTranslator();
  final translateYandex = TranslateIt(YANDEX_API_KEY);

  TranslateProvider provider = DEFAULT_PROVIDER;

  static Translator _instance;

  static instance() {
    if (_instance == null) _instance = Translator();

    return _instance;
  }

  translate(
    String text, {
    String from = FROM_LANG,
    String to = TO_LANG,
    bool html = true,
  }) async {
    switch (provider) {
      case TranslateProvider.GOOGLE:
        final result = await translateGoogle.translate(
          text,
          from: from,
          to: to,
        );
        return html
            ? result
                .replaceAll('] (', '](')
                .replaceAll(': //', '://')
                .replaceAll(' - ', ' – ')
                .replaceAll('[ ', '[')
                .replaceAll(' ]', ']')
            : result;
        break;
      case TranslateProvider.YANDEX:
        final result = await translateYandex.translate(
          text,
          '$from-$to',
          type: html ? 'html' : 'plain',
        );
        if (result.containsKey('text'))
          return result['text'];
        else
          return null;
        break;
      default:
        throw Exception('Incorrect translate provider');
    }
  }
}

class LocalizedString {
  final String original, translated;

  const LocalizedString([this.original = '', this.translated = '']);

  static fromMap(Map map) => LocalizedString(map[FROM_LANG], map[TO_LANG]);

  Map<String, dynamic> toMap() => {FROM_LANG: original, TO_LANG: translated};
}
