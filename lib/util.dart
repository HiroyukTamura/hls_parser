import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';



class Util {

  static final _surroundQuotes = RegExp(r'''^(['"])(.*)\1$''');

  static void assertNonNull(List params) {
    assert(params != null);
    params.forEach((it) {
      assert(it != null);
    });
  }

  static Tuple2<String, String> splitAt({@required String str, @required String delimiterChar, int index = 0}) {
    assert (str != null);
    assert (delimiterChar != null);
    assert (delimiterChar.length == 1);
    int lastDelimiterPos = -1;
    for (int i = 0, j = 0; i < str.length; i++) {
      if (str[i] == delimiterChar) {
        if (j++ == index) {
          return Tuple2<String, String>(str.substring(0, i), str.substring(i + 1));
        }
        lastDelimiterPos = i;
      }
    }

    if (lastDelimiterPos != -1) {
      return Tuple2<String, String>(str.substring(0, lastDelimiterPos), str.substring(lastDelimiterPos + 1));
    }

    return Tuple2<String, String>(str, '');
  }

  static String unquote(String val) =>
      val.replaceFirstMapped(_surroundQuotes, (m) => m[2]).trim();
}
