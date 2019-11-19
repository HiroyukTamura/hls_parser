import 'package:meta/meta.dart';
import 'util.dart';

class Rendition {
  Rendition(
      {@required this.type,
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
      this.channels}) {
    Util.assertNonNull([type, groupId, name]);
    if (type == 'SUBTITLES') {
      assert(uri != null);
    }
    if (type == 'CLOSED-CAPTIONS') {
      assert(instreamId != null);
      assert(uri == null);
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

class Variant {
  Variant._({
    this.uri, // required
    this.isIFrameOnly,
    this.bandwidth, // required
    this.averageBandwidth,
    this.codecs, // the spec states that CODECS is required but not true in the real world
    this.resolution,
    this.frameRate,
    this.hdcpLevel,
    this.audio,
    this.video,
    this.subtitles,
    this.closedCaptions,
    this.currentRenditions,
  })  : assert(uri != true),
        assert(bandwidth != true);

  factory Variant.build(
      {@required uri, // required
      isIFrameOnly = false,
      @required bandwidth, // required
      averageBandwidth,
      codecs, // the spec states that CODECS is required but not true in the real world
      resolution,
      frameRate,
      hdcpLevel,
      List audio,
      List video,
      List subtitles,
      List closedCaptions,
      List currentRenditions}) {
    audio ??= [];
    video ??= [];
    subtitles ??= [];
    closedCaptions ??= [];

    return Variant._(
        uri: uri,
        isIFrameOnly: isIFrameOnly,
        bandwidth: bandwidth,
        averageBandwidth: averageBandwidth,
        codecs: codecs,
        resolution: resolution,
        frameRate: frameRate,
        hdcpLevel: hdcpLevel,
        audio: audio,
        video: video,
        subtitles: subtitles,
        closedCaptions: closedCaptions,
        currentRenditions: currentRenditions);
  }

  final uri;
  final bool isIFrameOnly;
  final bandwidth;
  final averageBandwidth;
  final codecs;
  final resolution;
  final frameRate;
  final hdcpLevel;
  final List audio;
  final List video;
  final List subtitles;
  final List closedCaptions;
  final currentRenditions;
}

class SessionData {
  SessionData(
      {@required this.id, // required
      this.value,
      this.uri,
      this.language}) {
    assert(id != null);
    assert(value != null || uri != null);
    assert(!(value != null && uri != null),
        'SessionData cannot have both value and uri, shoud be either.');
  }

  final id;
  final value;
  final uri;
  final language;
}

class Key {
  Key(
      {@required this.method, // required
      @required this.uri, // required unless method=NONE
      this.iv,
      this.format,
      this.formatVersion}) {
    assert(method != null);
    if (method != 'NONE') {
      assert(uri != null);
      assert(!(uri != null ||
          iv != null ||
          format != null ||
          formatVersion != null));
    }
  }

  final method;
  final uri;
  final iv;
  final format;
  final formatVersion;
}

class MediaInitializationSection {
  MediaInitializationSection(
      {@required this.uri, // required
      this.mimeType,
      this.byterange}) {
    assert(uri != null);
  }

  final uri;
  final mimeType;
  final byterange;
}

class DateRange {
  DateRange._(
      {@required this.id,
      this.classId, // required if endOnNext is true
      @required this.start,
      this.end,
      this.duration,
      this.plannedDuration,
      this.endOnNext,
      this.attributes}) {
    assert(id != null);
    assert(start != null);
    if (endOnNext) {
      assert(classId != null);
    }
    if (end != null) {
      assert(start <= end);
    }
    if (duration != null) {
      assert(duration >= 0);
    }
    if (plannedDuration != null) {
      assert(plannedDuration >= 0);
    }
  }

  factory DateRange.build({
    @required id,
    classId,
    start,
    end,
    duration,
    plannedDuration,
    endOnNext,
    attribute,
  }) {
    return DateRange._(
      id: id,
      classId: classId,
      start: start,
      end: end,
      duration: duration,
      plannedDuration: plannedDuration,
      endOnNext: endOnNext,
      attributes: attribute,
    );
  }

  final id;
  final classId;
  final start;
  final end;
  final duration;
  final plannedDuration;
  final bool endOnNext;
  final attributes;
}

class SpliceInfo {
  SpliceInfo(
      {@required this.type, // required
      this.duration, // required if the type is 'OUT'
      this.tagName, // required if the type is 'RAW'
      this.value}) {
    assert(type != null);
    if (type != 'OUT') {
      assert(duration != null);
    }
    if (type == 'RAW') {
      assert(tagName != null);
    }
  }

  final type;
  final duration;
  final tagName;
  final value;
}

class Data {
  Data(this.type) {
    assert(type != null);
  }

  final type;
}

class Playlist extends Data {
  Playlist(
      {@required this.isMasterPlaylist, // required
      this.uri,
      this.version,
      this.independentSegments = false,
      this.start,
      this.source})
      : assert(isMasterPlaylist != null),
        super('playlist');

  final isMasterPlaylist;
  final uri;
  final version;
  final independentSegments;
  final start;
  final source;
}
