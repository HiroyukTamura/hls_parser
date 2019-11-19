import 'package:convert/convert.dart';
import 'package:tuple/tuple.dart';
import 'util.dart';
import 'exception.dart';

class Parser {

  String getTagCategory(String tagName) {
    switch (tagName) {
      case 'EXTM3U':
      case 'EXT-X-VERSION':
        return 'Basic';
      case 'EXTINF':
      case 'EXT-X-BYTERANGE':
      case 'EXT-X-DISCONTINUITY':
      case 'EXT-X-KEY':
      case 'EXT-X-MAP':
      case 'EXT-X-PROGRAM-DATE-TIME':
      case 'EXT-X-DATERANGE':
      case 'EXT-X-CUE-OUT':
      case 'EXT-X-CUE-IN':
      case 'EXT-X-CUE-OUT-CONT':
      case 'EXT-X-CUE':
      case 'EXT-OATCLS-SCTE35':
      case 'EXT-X-ASSET':
      case 'EXT-X-SCTE35':
        return 'Segment';
      case 'EXT-X-TARGETDURATION':
      case 'EXT-X-MEDIA-SEQUENCE':
      case 'EXT-X-DISCONTINUITY-SEQUENCE':
      case 'EXT-X-ENDLIST':
      case 'EXT-X-PLAYLIST-TYPE':
      case 'EXT-X-I-FRAMES-ONLY':
        return 'MediaPlaylist';
      case 'EXT-X-MEDIA':
      case 'EXT-X-STREAM-INF':
      case 'EXT-X-I-FRAME-STREAM-INF':
      case 'EXT-X-SESSION-DATA':
      case 'EXT-X-SESSION-KEY':
        return 'MasterPlaylist';
      case 'EXT-X-INDEPENDENT-SEGMENTS':
      case 'EXT-X-START':
        return 'MediaorMasterPlaylist';
      default:
        return 'Unknown';
    }
  }

  parseEXTINF(String str) {
    Tuple2<String, String> pair = Util.splitAt(str: str, delimiterChar: ',');
    return {duration: double.parse(pair.item1), title: pair.item2};
  }

  parseBYTERANGE(String str) {
    Tuple2<String, String> pair = Util.splitAt(str: str, delimiterChar: '@');
    double offset = pair.item2 == null ? -1 : double.parse(pair.item2);
    return {length: double.parse(pair.item1), offset: offset};
  }

  parseResolution(String str) {
    Tuple2<String, String> pair = Util.splitAt(str: str, delimiterChar: 'x');
    return {width: double.parse(pair.item1), height: double.parse(pair.item2)};
  }

  parseIV(String str) {
    List<int> iv = hex.decode(str);
    if (iv.length != 16) {
      throw InvalidPlaylistException('IV must be a 128-bit unsigned integer');
    }
    return iv;
  }

  parseUserAttribute(str) {
    if (str.startsWith('"')) {
      return Util.unquote(str);
    }
    if (str.startsWith('0x') || str.startsWith('0X')) {
      return hex.decode(str);
    }
    return double.parse(str);
  }
}