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
    this.channels,
  }) {
    Util.assertNonNull(<dynamic>[type, groupId, name]);
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
    @required this.uri, // required
    @required this.isIFrameOnly,
    @required this.bandwidth, // required
    @required this.averageBandwidth,
    @required this.codecs, // the spec states that CODECS is required but not true in the real world
    @required this.resolution,
    @required this.frameRate,
    @required this.hdcpLevel,
    @required this.audio,
    @required this.video,
    @required this.subtitles,
    @required this.closedCaptions,
    @required this.currentRenditions,
  })
      : assert(uri != true),
        assert(bandwidth != true);

  factory Variant.build({
    @required uri, // required
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
    List currentRenditions,
  }) {
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
  bool isIFrameOnly;
  final bandwidth;
  final averageBandwidth;
  final codecs;
  final resolution;
  final frameRate;
  final hdcpLevel;
  final List audio;
  final List video;
  final List<String> subtitles;
  final List<String> closedCaptions;
  final Map<String, Rendition> currentRenditions;
}

class SessionData {
  SessionData({
    @required this.id, // required
    this.value,
    this.uri,
    this.language,
  })

  assert

  (

  id

  !=

  null

  )

  ,

  assert

  (

  value

  !=

  null

  ||

  uri

  !=

  null

  )

  ,

  assert

  (

  !

  (

  value

  !=

  null

  &&

  uri

  !=

  null

  )

  ,

  '

  SessionData cannot

  have both

  value and

  uri

  ,

  shoud be

  either

      .

  '

  );

  final id;
  final value;
  final uri;
  final language;
}

class Key {
  Key({
    @required this.method, // required
    @required this.uri, // required unless method=NONE
    this.iv,
    this.format,
    this.formatVersion,
  }) : assert(method != null) {
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
  MediaInitializationSection({@required this.uri, // required
    this.mimeType,
    this.byterange,}) :
        assert(uri != null);

  final uri;
  final mimeType;
  final byterange;
}

class DateRange {
  DateRange._({
    @required this.id,
    @required this.classId, // required if endOnNext is true
    @required this.start,
    @required this.end,
    @required this.duration,
    @required this.plannedDuration,
    @required this.endOnNext,
    @required this.attributes,
  })
      : assert(id != null),
        assert(start != null) {
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
  final double start;
  final double end;
  final double duration;
  final double plannedDuration;
  final bool endOnNext;
  final attributes;
}

class SpliceInfo {
  SpliceInfo({
    @required this.type, // required
    this.duration, // required if the type is 'OUT'
    this.tagName, // required if the type is 'RAW'
    this.value,
  }): assert(type != null) {
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
  Data(this.type) :
    assert(type != null);

  final String type;
}

class Playlist extends Data {
  Playlist({
    @required this.isMasterPlaylist,
    this.uri,
    this.version,
    this.independentSegments = false,
    this.start,
    this.source,
  })
      : assert(isMasterPlaylist != null),
        super('playlist');

  final bool isMasterPlaylist;
  final uri;
  final version;
  final bool independentSegments;
  final start;
  final source;
}

class MasterPlaylist extends Playlist {
  MasterPlaylist._({
    @required isMasterPlaylist,
    @required this.variants,
    @required this.currentVariant,
    @required this.sessionDataList,
    @required this.sessionKeyList,
  })
      : assert(variants != null),
        assert(sessionDataList != null),
        assert(sessionKeyList != null),
        super(isMasterPlaylist: isMasterPlaylist); //todo fix

  factory MasterPlaylist.build({
    bool isMasterPlaylist = true,
    variants,
    currentVariant,
    sessionDataList,
    sessionKeyList,
  }) {
    variants ??= [];
    sessionDataList ??= [];
    sessionKeyList ??= [];
    return MasterPlaylist._(
        isMasterPlaylist: isMasterPlaylist,
        variants: variants,
        currentVariant: currentVariant,
        sessionDataList: sessionDataList,
        sessionKeyList: sessionKeyList);
  }

  final variants;
  final currentVariant;
  final sessionDataList;
  final sessionKeyList;
}

class MediaPlaylist extends Playlist {
  MediaPlaylist._({
    @required this.targetDuration,
    @required this.mediaSequenceBase,
    @required this.discontinuitySequenceBase,
    @required this.endlist,
    @required this.playlistType,
    @required this.isIFrameOnly,
    @required this.segments,
    @required this.hash,
    @required bool isMasterPlaylist,
  }) : super(isMasterPlaylist: isMasterPlaylist); //todo fix

  factory MediaPlaylist.build({bool isMasterPlaylist = false,
    targetDuration,
    double mediaSequenceBase = 0,
    double discontinuitySequenceBase = 0,
    endList,
    playlistType,
    isIFramel,
    List<Segment> segments,
    hash}) {
    segments ??= <Segment>[];

    return MediaPlaylist._(
      targetDuration: targetDuration,
      mediaSequenceBase: mediaSequenceBase,
      discontinuitySequenceBase: discontinuitySequenceBase,
      endlist: endList,
      playlistType: playlistType,
      isIFrameOnly: isIFrameOnly,
      segments: segments,
      hash: hash,
      isMasterPlaylist: isMasterPlaylist,
    );
  }

  final int targetDuration;
  final int mediaSequenceBase;
  final int discontinuitySequenceBase;
  final bool endlist;
  final String playlistType;
  final bool isIFrameOnly;
  final List<Segment> segments;
  final hash;
}

class Segment extends Data {
  Segment._({
    @required this.uri,
    @required this.mimeType,
    @required this.data,
    @required this.duration,
    @required this.title,
    @required this.byterange,
    @required this.discontinuity,
    @required this.mediaSequenceNumber,
    @required this.discontinuitySequence,
    @required this.key,
    @required this.map,
    @required this.programDateTime,
    @required this.dateRange,
    @required this.markers,
  }) : super('segment') {
    Util.assertNonNull(<dynamic>[uri, mediaSequenceNumber, discontinuitySequence]);
  }

  factory Segment.build({
    @required String uri,
    String mimeType,
    data,
    double duration,
    String title,
    ByteRange byterange,
    bool discontinuity,
    @required int mediaSequenceNumber,
    @required int discontinuitySequence,
    key,
    map,
    DateTime programDateTime,
    DateRange dateRange,
    List<Marker> markers,
  }) {
    // ignore: always_specify_types
    markers ??= [];
    return Segment._(
      uri: uri,
      mediaSequenceNumber: mediaSequenceNumber,
      discontinuitySequence: discontinuitySequence,
      byterange: byterange,
      mimeType: mimeType,
      duration: duration,
      data: data,
      title: title,
      dateRange: dateRange,
      discontinuity: discontinuity,
      key: key,
      map: map,
      markers: markers,
      programDateTime: programDateTime,
    );
  }

  final String uri;
  final String mimeType;
  final data;
  final double duration;
  final String title;
  final ByteRange byterange;
  final bool discontinuity;
  final int mediaSequenceNumber;
  final int discontinuitySequence;
  final key;
  final map;
  final DateTime programDateTime;
  final DateRange dateRange;
  final List<Marker> markers;
}

class Marker {
  String type;
  String tagName;
  String value;
}

{offset: 256, length: 128},
class ByteRange {
  int offset;
  int length;
}