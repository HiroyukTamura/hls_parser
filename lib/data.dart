import 'package:meta/meta.dart';
import 'util.dart';

class Rendition {
  Rendition({
    @required this.type,
    this.uri,
    @required this.groupId,
    this.language,
    this.assocLanguage,
    @required this.name,
    this.isDefault,
    this.autoselect,
    this.forced,
    this.instreamId,
    this.characteristics,
    this.channels
  }) {
    Util.assertNonNull([type, groupId, name]);
    if (type == 'SUBTITLES') {
      assert (uri != null);
    }
    if (type == 'CLOSED-CAPTIONS') {
      assert (instreamId != null);
      assert (uri == null);
    }
    if (forced) {
      assert(type == 'CLOSED-CAPTIONS');
    }
  }

  final String type;
  final language;
  final uri;
  final groupId;
  final assocLanguage;
  final name;
  final bool isDefault;
  final bool autoselect;
  final bool forced;
  final instreamId;
  final characteristics;
  final channels;
}