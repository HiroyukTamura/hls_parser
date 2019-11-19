import 'package:convert/convert.dart';
import 'package:hls_parser/data.dart';
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

  void setCompatibleVersionOfKey(params, attributes) {
    if (attributes['IV'] != null, && params.compatibleVersion < 2) {
      params.compatibleVersion = 2;
    }
    if ((attributes['KEYFORMAT'] != null ||
        attributes['KEYFORMATVERSIONS'] != null) &&
        params.compatibleVersion < 5) {
      params.compatibleVersion = 5;
    }
  }


  parseAttributeList(param) {
    List<String> list = Util.splitByCommaWithPreservingQuotes(param);
    const attributes = {}; //todo fix
    list.forEach((item) {
      Tuple2<String, String> tuple2 = Util.splitAt(
          str: item, delimiterChar: '=');
      String key = tuple2.item1;
      String value = tuple2.item2;
      String val = Util.unquote(value);
      switch (key) {
        case 'URI':
          attributes[key] = val;
          break;
        case 'START-DATE':
        case 'END-DATE':
          attributes[key] = DateTime.parse(val);
          break;
        case 'IV':
          attributes[key] = parseIV(val);
          break;
        case 'BYTERANGE':
          attributes[key] = parseBYTERANGE(val);
          break;
        case 'RESOLUTION':
          attributes[key] = parseResolution(val);
          break;
        case 'END-ON-NEXT':
        case 'DEFAULT':
        case 'AUTOSELECT':
        case 'FORCED':
        case 'PRECISE':
          attributes[key] = val == 'YES';
          break;
        case 'DURATION':
        case 'PLANNED-DURATION':
        case 'BANDWIDTH':
        case 'AVERAGE-BANDWIDTH':
        case 'FRAME-RATE':
        case 'TIME-OFFSET':
          attributes[key] = double.parse(val);
          break;
        default:
          if (key.startsWith('SCTE35-')) {
            attributes[key] = hex.decode(val);
          } else if (key.startsWith('X-')) {
            attributes[key] = parseUserAttribute(value);
          } else {
            attributes[key] = val;
          }
      }
    });
    return attributes;
  }

  String parseTagParam(name, param) {
    switch (name) {
      case 'EXTM3U':
      case 'EXT-X-DISCONTINUITY':
      case 'EXT-X-ENDLIST':
      case 'EXT-X-I-FRAMES-ONLY':
      case 'EXT-X-INDEPENDENT-SEGMENTS':
      case 'EXT-X-CUE-IN':
        return [null, null];
      case 'EXT-X-VERSION':
      case 'EXT-X-TARGETDURATION':
      case 'EXT-X-MEDIA-SEQUENCE':
      case 'EXT-X-DISCONTINUITY-SEQUENCE':
      case 'EXT-X-CUE-OUT':
        return [double.parse(param), null];
      case 'EXT-X-KEY':
      case 'EXT-X-MAP':
      case 'EXT-X-DATERANGE':
      case 'EXT-X-MEDIA':
      case 'EXT-X-STREAM-INF':
      case 'EXT-X-I-FRAME-STREAM-INF':
      case 'EXT-X-SESSION-DATA':
      case 'EXT-X-SESSION-KEY':
      case 'EXT-X-START':
        return [null, parseAttributeList(param)];
      case 'EXTINF':
        return [parseEXTINF(param), null];
      case 'EXT-X-BYTERANGE':
        return [parseBYTERANGE(param), null];
      case 'EXT-X-PROGRAM-DATE-TIME':
        return [DateTime.parse(param), null];
      case 'EXT-X-PLAYLIST-TYPE':
        return [param, null]; // <EVENT|VOD>
      default:
        return [param, null]; // Unknown tag
    }
  }

  Tuple2<String, String> splitTag(String line) {
    int index = line.indexOf(':');
    return index == -1
        ? Tuple2<String, String>(line.substring(1).trim(), null)
        : Tuple2<String, String>(
        line.substring(1, index).trim(), line.substring(index + 1).trim());
  }

//  function parseRendition({attributes}) {
//    const rendition = new Rendition({
//      type: attributes['TYPE'],
//      uri: attributes['URI'],
//      groupId: attributes['GROUP-ID'],
//      language: attributes['LANGUAGE'],
//      assocLanguage: attributes['ASSOC-LANGUAGE'],
//      name: attributes['NAME'],
//      isDefault: attributes['DEFAULT'],
//      autoselect: attributes['AUTOSELECT'],
//      forced: attributes['FORCED'],
//      instreamId: attributes['INSTREAM-ID'],
//      characteristics: attributes['CHARACTERISTICS'],
//      channels: attributes['CHANNELS']
//    });
//    return rendition;
//  }

  String checkRedundantRendition(List<Rendition> renditions,
      Rendition rendition) {
    bool defaultFound = false;
    for (Rendition item in renditions) {
      if (item.name == rendition.name) {
        return 'All EXT-X-MEDIA tags in the same Group MUST have different NAME attributes.';
      }
      if (item.isDefault) {
        defaultFound = true;
      }
    }
    if (defaultFound && rendition.isDefault) {
      return 'EXT-X-MEDIA A Group MUST NOT have more than one member with a DEFAULT attribute of YES.';
    }
    return null;
  }

  addRendition(variant, line, type) {
    Rendition rendition = parseRendition(line);
    List<Rendition> renditions = variant[Util.camelify(type)];
    String errorMessage = checkRedundantRendition(renditions, rendition);
    if (errorMessage != null) {
      throw InvalidPlaylistException(errorMessage);
    }
    renditions.add(rendition);
    if (rendition.isDefault) {
      variant.currentRenditions[Util.camelify(type)] = renditions.length - 1;
    }
  }

  void matchTypes(attrs, variant, params) {
    List<String> typeList = ['AUDIO', 'VIDEO', 'SUBTITLES', 'CLOSED-CAPTIONS'];
    typeList.forEach((String type) {
      if (type == 'CLOSED-CAPTIONS' && attrs[type] == 'NONE') {
        params.isClosedCaptionsNone = true;
        variant.closedCaptions = [];
      } else if (attrs[type] &&
          !variant[Util.camelify(type)].find((item) => item.groupId ==
              attrs[type])) {
        InvalidPlaylistException(
            '$type attribute MUST match the value of the GROUP-ID attribute of an EXT-X-MEDIA tag whose TYPE attribute is $type.');
      }
    });
  }

  parseVariant(List lines, variantAttrs, uri, iFrameOnly, params) {
    Variant variant = Variant.build(
      uri: uri,
      bandwidth: variantAttrs['BANDWIDTH'],
      averageBandwidth: variantAttrs['AVERAGE-BANDWIDTH'],
      codecs: variantAttrs['CODECS'],
      resolution: variantAttrs['RESOLUTION'],
      frameRate: variantAttrs['FRAME-RATE'],
      hdcpLevel: variantAttrs['HDCP-LEVEL']
    );
    for (var line in lines) {
      if (line.name == 'EXT-X-MEDIA') {
        const renditionAttrs = line.attributes;
        const renditionType = renditionAttrs['TYPE'];
        if (!renditionType || !renditionAttrs['GROUP-ID']) {
          throw InvalidPlaylistException('EXT-X-MEDIA TYPE attribute is REQUIRED.');
        }
        if (variantAttrs[renditionType] == renditionAttrs['GROUP-ID']) {
          addRendition(variant, line, renditionType);
          if (renditionType == 'CLOSED-CAPTIONS') {
            for (String instreamId in variant.closedCaptions) {
              if (instreamId?.startsWith('SERVICE') == true && params.compatibleVersion < 7) {
                params.compatibleVersion = 7;
                break;
              }
            }
          }
        }
      }
    }
    matchTypes(variantAttrs, variant, params);
    variant.isIFrameOnly = iFrameOnly;
    return variant;
  }
}