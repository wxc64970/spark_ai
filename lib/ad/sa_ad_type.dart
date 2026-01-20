enum PlacementType {
  open,
  chatback,
  album,
  gems,
  homelist,
  chat;

  String get name {
    switch (this) {
      case PlacementType.open:
        return 'open';
      case PlacementType.chatback:
        return 'chatback';
      case PlacementType.album:
        return 'album';
      case PlacementType.gems:
        return 'gems';
      case PlacementType.homelist:
        return 'homelist';
      case PlacementType.chat:
        return 'chat';
    }
  }

  String get timeKey {
    switch (this) {
      case PlacementType.open:
      case PlacementType.chatback:
      case PlacementType.album:
      case PlacementType.chat:
        return 'common_ad_time';
      case PlacementType.gems:
        return 'rewarded_ad_time';
      case PlacementType.homelist:
        return 'native_ad_time';
    }
  }
}

enum AdType {
  open,
  interstitial,
  rewarded,
  native;

  String get name {
    switch (this) {
      case AdType.open:
        return 'open';
      case AdType.interstitial:
        return 'interstitial';
      case AdType.rewarded:
        return 'rewarded';
      case AdType.native:
        return 'native';
    }
  }
}
