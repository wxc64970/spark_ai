import 'dart:convert';

class SATextData {
  static String _decrypt(String encrypted) {
    return utf8.decode(base64Decode(encrypted));
  }

  // 动态拼接文本（保留方法格式，因包含参数）
  static String deadline(String date) {
    return _decrypt('RGVhZGxpbmU6IA==') + date;
  }

  // 动态拼接文本
  static String levelUpValue(String level) {
    return _decrypt('TGV2ZWwg') + level + _decrypt('IFJld2FyZA==');
  }

  // 动态拼接文本
  static String diamondPerEdit(String num) {
    return num + _decrypt('IGRpYW1vbmQvZWRpdA==');
  }

  // 动态拼接文本
  static String subscriptionInfo(String price, String unit) {
    return _decrypt(
      'WW91IHdpbGwgYmUgY2hhcmdlZCAkcHJpY2UgaW1tZWRpYXRlbHksIHRoZW4gJHByaWNlLyR1bml0IHRoZXJlYWZ0ZXIuIFlvdXIgc3Vic2NyaXB0aW9uIGF1dG9tYXRpY2FsbHkgcmVuZXdzIHVubGVzcyBjYW5jZWxlZCBhdCBsZWFzdCAyNCBob3VycyBiZWZvcmUgdGhlIGVuZCBvZiB0aGUgY3VycmVudCBwZXJpb2Qu',
    );
  }

  // 动态拼接文本
  static String vipPriceLtDesc(String price) {
    return _decrypt('WW91IHdpbGwgYmUgY2hhcmdlZCAkcHJpY2UgaW1tZWRpYXRlbHkgZm9yIGxpZmV0aW1lIGFjY2Vzcy4=');
  }

  // 动态拼接文本
  static String vipGet2(String diamond) {
    return _decrypt(
      'e2ljb2598J+RqOKKk+CfmqggQ2FsbCB5b3VyIEFJIEdpcmxmcmllbmQK7Y+RqOKKk+CfmqggwqDCo8K7IFNwZWN5IFBob3RvLCBWaWRlbyAmIEF1ZGlvCgrvh5Go4oqT4J+aqCBPbmUtdGltZSBnaWZ0IG9mICRkZWFtb25kIGRpYW1vbmQKe2ljb2598J+RqOKKk+CfmqggVW5saW1pdGVkIG1lc3NhZ2VzICYgTlNGVyBjaGF0cwrCoMKjwrvCoMK7IEFsbCBhY2Nlc3MgdG8gcHJlbWl1bSBmZWF0dXJlcwrCoMKjwrvCoMK7IE5vIGFkcw==',
    );
  }

  // 动态拼接文本
  static String ageYearsOlds(String age) {
    return age + _decrypt('IHllYXJzIG9sZA==');
  }

  static String get positiveReviewTitle => _decrypt('RG8gWW91IExpa2UgVXM/');

  // 动态拼接文本
  static String oneTimePurchaseNote(String price) {
    return _decrypt('UGxlYXNlIG5vdGUgdGhhdCBhIG9uZS10aW1lIHB1cmNoYXNlIHdpbGwgcmVzdWx0IGluIGEgb25lLXRpbWUgY2hhcmdlIG9mICRwcmljZSB0byB5b3Uu');
  }

  // 动态拼接文本
  static String saveNum(String num) {
    return _decrypt('U2F2ZSAkbnVtJQ==');
  }

  static String get ai_upload_steps =>
      _decrypt('MS5Ud28gc3RlcHM6IFVwbG9hZCBhIHBob3RvLCB0aGVuIGNsaWNrIGdlbmVyYXRlLgoyLk5vIHN1cHBvcnQgZm9yIHBob3RvcyBvZiBtaW5vcnMuCjMuVXBsb2FkIGEgZnJvbnQtZmFjaW5nIHBob3RvLg==');
  static String get bestOffer => _decrypt('QkVTVCBPRkZFUg==');
  static String get editChooseMask =>
      _decrypt('VGhpcyBjaGF0IGFscmVhZHkgaGFzIGEgbWFzayBsb2FkZWQuWW91IGNhbiByZXN0YXJ0IGEgY2hhdCB0byB1c2UgYW5vdGhlciBtYXNrLkFmdGVyIHJlc3RhcnRpbmcsIHRoZSBoaXN0b3J5IHdpbGwgbG9zZS4=');
  static String get gifts => _decrypt('R2lmdHM=');
  static String get introTitle => _decrypt('SW50cm8=');
  static String get ai_prompt_examples_img => _decrypt('ZS5nOiBiaWtpbmksbGluZ2VyaWU=');
  static String get deleteMaskConfirmation => _decrypt('RGVsZXRpbmcgdGhpcyBtYXNrIHdpbGwgcmVzdG9yZSBkZWZhdWx0IGNoYXQgc2V0dGluZ3MuIENvbmZpcm0/');
  static String get ai_most_popular => _decrypt('TW9zdCBQb3B1bGFy');
  static String get legal => _decrypt('TGVnYWw=');
  static String get searchSirens => _decrypt('VHlwZSBhIE5hbWUgdG8gZmluZCBTaXJlbnM=');
  static String get seach => _decrypt('U2VhcmNo');

  static String get vipGet1 => _decrypt('e2ljb259IEVuZGxlc3MgY2hhdHRpbmcKe2ljb259IFVubG9jayBhbGwgZmlsdGVycwrCoMK7IEFkdmFuY2VkIG1vZGUgJiBsb25nIG1lbW9yeQrCoMK7IEFkLWZyZWU=');
  static String get tapToSeeMessages => _decrypt('KioqKioqIFRhcCB0byBzZWUgdGhlIG1lc3NhZ2VzICoqKioqKg==');
  static String get textMessageCallCost => _decrypt('MSB0ZXh0IG1lc3NhZ2U6IDIgZGlhbW9uZFxuQ2FsbCBBSSBjaGFyYWN0ZXJzOiAxMCBkaWFtb25kL21pbg==');
  static String get textMessageCost => _decrypt('MSB0ZXh0IG1lc3NhZ2U6IDIgZGlhbW9uZFxuMSBhdWRpbyBtZXNzYWdlOiA0IGRpYW1vbmRcbkNhbGwgQUkgY2hhcmFjdGVyczogMTAgZGlhbW9uZC9taW4=');
  static String get moansForYou => _decrypt('TW9hbnMgZm9yIHlvdQ==');
  static String get ageHint => _decrypt('UGxlYXNlIGlucHV0IHlvdXIgYWdl');
  static String get yes => _decrypt('WWVz');
  static String get sendAGiftAndGetAPicture => _decrypt('U2VuZCBhIGdpZnQgYW5kIGdldCBhIHBpY3R1cmU=');
  static String get otherInfoHint => _decrypt('WW91ciByZWxhdGlvbnNoaXAgd2l0aCB0aGUgY2hhcmFjdGVyIG9yIGltcG9ydGFudCBldmVudHMu');
  static String get violence => _decrypt('VmlvbGVuY2U=');
  static String get ai_styles => _decrypt('U3R5bGVzOg==');
  static String get ai_custom_prompt => _decrypt('Q3VzdG9tIFByb21wdDo=');
  static String get microphonePermissionRequired => _decrypt('TWljcm9waG9uZSBwZXJtaXNzaW9uIGlzIHJlcXVpcmVkIHRvIG1ha2UgYSBjYWxsLg==');
  static String get profileMaskDescription =>
      _decrypt('Q3JlYXRlIGEgbWFzayBwcm9maWxlIHRvIGludGVyYWN0IHdpdGggdGhlIGNoYXJhY3RlciBiZXR0ZXIuIE1vZGlmeWluZyB0aGUgbWFzayBkb2Vzbid0IGFmZmVjdCB0aGUgbG9hZGVkIG1hc2sncyBlZmZlY3Qu');
  static String get unlockRoleDescription => _decrypt('QmVjb21lIGEgcHJlbWl1bSB0byB1bmxvY2sgaG90IHJvbGVzIGFuZCBnZXQgdW5saW1pdGVkIGNoYXRzLg==');

  static String get enticingPicture => _decrypt('RW50aWNpbmcgcGljdHVyZQ==');
  static String get chatted => _decrypt('Q2hhdHRlZA==');
  static String get all => _decrypt('QWxs');
  static String get gotToPro => _decrypt('R28gdG8gUHJv');
  static String get wait30Seconds => _decrypt('SXQgbWF5IHRha2UgdXAgdG8gMzAgc2Vjb25kcy5QbGVhc2UgZG8gbm90IGNsb3NlIG9yIGxlYXZlIHRoZSBhcHA=');
  static String get unlockRole => _decrypt('VW5sb2NrIEhvdCBSb2xlcyE=');
  static String get chatList => _decrypt('Q2hhdCBsaXN0');
  static String get waitForResponse => _decrypt('UGxlYXNlIHdhaXQgZm9yIHRoZSByZXNwb25zZQ==');
  static String get hotVideo => _decrypt('SG90IFZpZGVv');
  static String get saraReceivedYourGift => _decrypt('U2FyYSByZWNlaXZlZCB5b3VyIGdpZnQg8J+Rjw==');
  static String get create => _decrypt('Q3JlYXRl');
  static String get ai_bonus => _decrypt('Qm9udXM=');
  static String get networkError => _decrypt('UGxlYXNlIGNoZWNrIHRoZSBuZXR3b3JrIGNvbm5lY3Rpb24=');
  static String get unselectAll => _decrypt('VW5zZWxlY3QgQWxs');
  static String get levelUpIntimacy => _decrypt('TGV2ZWwgdXAgSW50aW1hY3k=');
  static String get yourNickname => _decrypt('WW91ciBuaWNrbmFtZQ==');
  static String get ai_language => _decrypt('QUkncyBsYW5ndWFnZSBpcw==');
  static String get clickSaveToConfirm => _decrypt('Q2xpY2sgdGhlICJTYXZlIiBidXR0b24gdG8gY29uZmlybSB0aGF0IGl0IHRha2VzIGVmZmVjdA==');

  static String get noSubscriptionAvailable => _decrypt('Tm8gc3Vic2NyaXB0aW9uIGF2YWlsYWJsZQ==');
  static String get save => _decrypt('U2F2ZQ==');
  static String get maxInputLength => _decrypt('TWF4aW11bSBpbnB1dCBsZW5ndGg6IDUwMCBjaGFyYWN0ZXJz');
  static String get feedback => _decrypt('RmVlZGJhY2s=');
  static String get unlockTextReply => _decrypt('VW5sb2NrIFRleHQgUmVwbHk=');
  static String get clearHistoryFailed => _decrypt('Q2xlYXIgaGlzdG9yeSBtZXNzYWdlcyBmYWlsZWQh');
  static String get reportSuccessful => _decrypt('UmVwb3J0IHN1Y2Nlc3NmdWw=');
  static String get unlock => _decrypt('VW5sb2Nr');
  static String get listening => _decrypt('TGlzdGVuaW5nLi4u');
  static String get home => _decrypt('SG9tZQ==');
  static String get hotPhoto => _decrypt('SG90IHBob3Rv');
  static String get createOrderError => _decrypt('Q3JlYXRlIG9yZGVyIGVycm9y');
  static String get easterEggUnlock =>
      _decrypt('Q29uZ3JhdHMgb24gdW5sb2NraW5nIHRoZSBFYXN0ZXIgZWdnIGZlYXR1cmUhIFlvdSBjYW4gbm93IHVwbG9hZCBpbWFnZXMgdG8gZXhwbG9yZSB0aGUgdW5kcmVzcyBmdW5jdGlvbi4gR2l2ZSBpdCBhIHNob3Qh');
  static String get vipMember => _decrypt('VklQIE1lbWJlcg==');
  static String get clothing => _decrypt('Q2xvdGhpbmc=');
  static String get msgTips => _decrypt('UmVwbGllcyBhcmUgZ2VuZXJhdGVkIGJ5IEFsIGFuZCBmZXRpb25hbA==');
  static String get realistic => _decrypt('UmVhbGlzdGlj');
  static String get dislike => _decrypt('Tm90IHNhdGlzZmllZCwgbmVlZHMgaW1wcm92ZW1lbnQu');
  static String get ai_most_popular_new => _decrypt('TW9zdCBQb3B1bGFy');
  static String get anime => _decrypt('QW5pbWU=');
  static String get toCreate => _decrypt('VG8gY3JlYXRl');
  static String get yourAge => _decrypt('WW91ciBBZ2U=');
  static String get notEnough => _decrypt('SW5zdWZmaWNpZW50IGJhbGFuY2UsIHBsZWFzZSByZWNoYXJnZQ==');
  static String get personalDetails => _decrypt('UGVyc29uYWwgZGV0YWlscw==');
  static String get message => _decrypt('bWVzc2FnZQ==');
  static String get ai_photo_label => _decrypt('UGhvdG8=');
  static String get subFeedback => _decrypt('U3VibWl0IGEgZmVlZGJhY2s=');
  static String get dailyReward => _decrypt('RGFpbHkgcmV3YXJk');
  static String get weekly => _decrypt('V2Vla2x5');
  static String get ai_art_consumes_power =>
      _decrypt('R3JlYXQgYXJ0IGNvbnN1bWVzIGNvbXB1dGF0aW9uYWwgcG93ZXIgYW5kIHRpbWUuIEV2ZXJ5IHNlY29uZCB5b3Ugd2FpdCBpcyB0cmFuc2Zvcm1pbmcgaW50byBwaXhlbHMgb2Ygd29uZGVyLg==');
  static String get upgradeTochat => _decrypt('VXBncmFkZSB0byBjaGF0');
  static String get ai_purchase_balance => _decrypt('UHVyY2hhc2UgQmFsYW5jZQ==');
  static String get unlockNow => _decrypt('VW5sb2NrIE5vdw==');
  static String get otherInfo => _decrypt('T3RoZXIgaW5mbw==');
  static String get lifetime => _decrypt('TGlmZXRpbWU=');
  static String get clearHistoryConfirmation => _decrypt('QXJlIHlvdSBzdXJlIHRvIGNsZWFyIGFsbCBoaXN0b3J5IG1lc3NhZ2VzPw==');
  static String get longReply => _decrypt('TG9uZyBSZXBseTogbGlrZSBzdG9yeQ==');
  static String get vipUpgrade => _decrypt('VXBncmFkZSB0byBWSVA=');

  static String get aotoTrans => _decrypt('RW5hYmxlIGF1dG9tYXRpYyB0cmFuc2xhdGlvbj8=');
  static String get resetChatBackground => _decrypt('UmVzZXQgY2hhdCBiYWNrZ3JvdW5k');
  static String get ai_please_enter_custom_prompt => _decrypt('UGxlYXNlIGVudGVyIGEgY3VzdG9tIHByb21wdA==');
  static String get yourName => _decrypt('WW91ciBOYW1l');
  static String get yourGender => _decrypt('WW91ciBHZW5kZXI=');
  static String get pleaseInput => _decrypt('UGxlYXNlIGVudGVyIGNvbnRlbnQ=');
  static String get aiPhoto => _decrypt('QUkgUGhvdG8=');
  static String get nice => _decrypt('TmljZQ==');
  static String get typeHere => _decrypt('VHlwZSBoZXJlLi4u');
  static String get notEnoughCoins => _decrypt('Tm90IGVub3VnaCBDb2lucywgY2FsbCBlbmRlZC4=');
  static String get buyGemsOpenChats => _decrypt('QnV5IEdlbXMgdG8gb3BlbiBjaGF0cy4=');
  static String get illegalDrugs => _decrypt('SWxsZWdhbCBkcnVncw==');
  static String get report => _decrypt('UmVwb3J0');
  static String get chooseYourTags => _decrypt('Q2hvb3NlIHlvdXIgdGFncw==');
  static String get expirationTime => _decrypt('RXhwaXJhdGlvbiB0aW1lOiA=');
  static String get dressUp => _decrypt('RHJlc3MgVXA=');
  static String get subscribe => _decrypt('U3Vic2NyaWJl');
  static String get yearly => _decrypt('WWVhcmx5');
  static String get shortReply => _decrypt('U2hvcnQgUmVwbHk6IGxpa2Ugc21z');
  static String get appVersion => _decrypt('QXBwIHZlcnNpb24=');
  static String get setChatBackground => _decrypt('Q3VzdG9tIENoYXQgQmFja2dyb3VuZA==');
  static String get micPermission => _decrypt('TWljcm9waG9uZSBwZXJtaXNzaW9uIGlzIHJlcXVpcmVkIHRvIG1ha2UgYSBjYWxsLg==');
  static String get ai_generate_another => _decrypt('R2VuZXJhdGUgYW5vdGhlciBvbmU=');
  static String get male => _decrypt('TWFsZQ==');
  static String get btnContinue => _decrypt('Q29udGludWU=');
  static String get send => _decrypt('U2VuZA==');
  static String get liked => _decrypt('TGlrZWQ=');
  static String get subscriptionAutoRenew => _decrypt(
    'WW91IHdpbGwgYmUgY2hhcmdlZCBpbW1lZGlhdGVseSwgdGhlbiB0aGUgc2FtZSBhbW91bnQgbW9udGhseSB0aGVyZWFmdGVyLiBZb3VyIHN1YnNjcmlwdGlvbiBhdXRvbWF0aWNhbGx5IHJlbmV3cyB1bmxlc3MgY2FuY2VsZWQgYXQgbGVhc3QgMjQgaG91cnMgYmVmb3JlIHRoZSBlbmQgb2YgdGhlIGN1cnJlbnQgcGVyaW9kLiBZb3UgY2FuIG1hbmFnZSB5b3VyIHN1YnNjcmlwdGlvbiBhbmQgdHVybiBvZmYgYXV0by1yZW5ld2FsIGluIHlvdXIgYWNjb3VudCBzZXR0aW5ncyBhZnRlciBwdXJjaGFzZS4=',
  );
  static String get selectProfileMask => _decrypt('U2VsZWN0IFlvdXIgUHJvZmlsZSBNYXNr');
  static String get uploadAPhoto => _decrypt('VXBsb2FkIGEgcGhvdG8=');
  static String get description => _decrypt('RGVzY3JpcHRpb24=');
  static String get setting => _decrypt('U2V0dGluZw==');
  static String get explore => _decrypt('RXhwbG9yZQ==');
  static String get vipGet => _decrypt('e2ljb2598J+RqOKKk+CfmqggRW5kbGVzcyBjaGF0dGluZwrCoMK7wqDCo8K7IEFkdmFuY2VkIG1vZGUgJiBsb25nIG1lbW9yeQrCoMK7wqDCo8K7IEFkLWZyZWU=');
  static String get backUpdatedSucc => _decrypt('QmFja2dyb3VuZCB1cGRhdGVkIHN1Y2Nlc3NmdWxseSE=');
  static String get upToVip => _decrypt('VXBncmFkZSB0byBWSVA=');
  static String get ai_undress_sweetheart => _decrypt('VW5kcmVzcyBZb3VyIFN3ZWV0aGVhcnQgTm93ICEh');
  static String get privacyPolicy => _decrypt('UHJpdmFjeSBwb2xpY3k=');
  static String get ai_photos => _decrypt('cGhvdG9z');
  static String get openSettings => _decrypt('T3BlbiBzZXR0aW5ncw==');
  static String get termsOfUse => _decrypt('VGVybXMgb2YgdXNl');
  static String get intro => _decrypt('SW50cm8=');
  static String get deleteChat => _decrypt('RGVsZXRlIGNoYXQ=');

  static String get howToCallYou => _decrypt('SG93IGRvIHlvdSB3YW50IHlvdXIgQUkgZ2lybGZyaWVuZCB0byBjYWxsIHlvdT8=');
  static String get SALoading => _decrypt('TG9hZGluZw==');
  static String get ai_video_label => _decrypt('VmlkZW8=');
  static String get ai_prompt_examples_video => _decrypt('ZS5nOiBBIHdvbWFuIHRha2VzIG9mZiBoZXIgY2xvdGhlcywgZXhwb3NpbmcgaGVyIGJyZWFzdHMgYW5kIG5pcHBsZXMsIG5ha2VkLCB1bmRyZXNzZWQsIG51ZGU=');
  static String get restore => _decrypt('UmVzdG9yZQ==');
  static String get giveHerAMoment => _decrypt('R2l2ZSBoZXIgYSBtb21lbnQgdG8gZW5qb3kgaXQgYW5kIHRha2UgYSBwaWN0dXJlIGZvciB5b3Ug8J+Rjw==');
  static String get bestChatExperience => _decrypt('RW5qb3kgVGhlIEJlc3QgQ2hhdCBFeHBlcmllbmNl');
  static String get selectAll => _decrypt('U2VsZWN0IEFsbA==');

  static String get buy => _decrypt('QnV5');
  static String get fillRequiredInfo => _decrypt('UGxlYXNlIGZpbGwgaW4gdGhlIHJlcXVpcmVkIGluZm9ybWF0aW9u');
  static String get notSupport => _decrypt('Tm90IHN1cHBvcnQ=');
  static String get spam => _decrypt('U3BhbQ==');
  static String get collect => _decrypt('Q29sbGVjdA==');
  static String get tagsTitle => _decrypt('VGFncw==');
  static String get info => _decrypt('SW5mbw==');
  static String get female => _decrypt('RmVtYWxl');
  static String get reload => _decrypt('UmVsb2Fk');
  static String get descriptionHint => _decrypt('TGlrZTogV2hhdCBhcmUgeW91ciBob2JiaWVzPyBpc2xpa2U6IHdoYXQgaXMgeW91ciBkaXNsaWtlPyBXaGF0IHRvcGljcyBkbyB5b3UgbGlrZSB0byB0YWxrIGFib3V0Pw==');
  static String get childAbuse => _decrypt('Q2hpbGQgYWJ1c2U=');
  static String get speechRecognitionNotSupported => _decrypt('U3BlZWNoIHJlY29nbml0aW9uIG5vdCBzdXBwb3J0ZWQgb24gdGhpcyBkZXZpY2Uu');
  static String get toys => _decrypt('VG95cw==');
  static String get ai_generation_failed => _decrypt('R2VuZXJhdGlvbiBmYWlsZWQuWW91IGNhbiB0cnkgYWdhaW4gZm9yIGZyZWUh');
  static String get confirm => _decrypt('Q29uZmlybQ==');
  static String get ai_under_character => _decrypt('VW5kZXIgdGhlIGNoYXJhY3Rlcg==');
  static String get love => _decrypt('R3JlYXQhIEknbSBsb3ZpbmcgaXQu');
  static String get like => _decrypt('TGlrZQ==');

  static String get diamond => _decrypt('RGlhbW9uZA==');

  static String get scenarioRestartWarning => _decrypt('VG8gYWN0aXZlIHRoZSBuZXcgc2NlbmFyaW8sdGhlIGNoYXQgd2lsIGJlIHJlc3RhcnQgYW5kIHRoZSBoaXN0b3J5IHdpbGwgbG9zZS4=');
  static String get popular => _decrypt('UG9wdWxhcg==');
  static String get monthly => _decrypt('TW9udGhseQ==');
  static String get useAvatar => _decrypt('VXNlIEFsIGNoYXJhY3RlcnMnIGNvdmVy');
  static String get inputYourNickname => _decrypt('RW50ZXIgeW91ciBuaWNrbmFtZQ==');
  static String get year => _decrypt('eWVhcg==');
  static String get nonBinary => _decrypt('Tm9uLWJpbmFyeQ==');
  static String get createMaskProfileDescription => _decrypt('Q3JlYXRlIGEgbWFzayBwcm9maWxlIHRvIGludGVyYWN0IHdpdGggdGhlIGNoYXJhY3RlciBiZXR0ZXI=');
  static String get createProfileMask => _decrypt('Q3JlYXRlIFlvdXIgUHJvZmlsZSBNYXNr');
  static String get maskAlreadyLoaded =>
      _decrypt('VGhpcyBjaGF0IGFscmVhZHkgaGFzIGEgbWFzayBsb2FkZWQuIFlvdSBjYW4gcmVzdGFydCBhIGNoYXQgdG8gdXNlIGFub3RoZXIgbWFzay4gQWZ0ZXIgcmVzdGFydGluZywgdGhlIGhpc3Rvcnktd2lsbCBsb3NlLg==');
  static String get ai_generate => _decrypt('R2VuZXJhdGU=');
  static String get everyDay => _decrypt('L2RheQ==');
  static String get video => _decrypt('VmlkZW8=');
  static String get close => _decrypt('Q2xvc2U=');
  static String get activateBenefits => _decrypt('QWN0aXZhdGUgQmVuZWZpdHM=');
  static String get copyright => _decrypt('Q29weXJpZ2h0');
  static String get day => _decrypt('ZGF5');
  static String get replyMode => _decrypt('UmVwbHkgbW9kZQ==');
  static String get ai_view_nude => _decrypt('VmlldyB0aGUgY2hhcmFjdGVyJ3MgbnVkZQ==');
  static String get optionTitle => _decrypt('T3B0aW9u');
  static String get more => _decrypt('TW9yZQ==');
  static String get ai_videos => _decrypt('dmlkZW9z');
  static String get ai_generating_masterpiece => _decrypt('R2VuZXJhdGluZyB5b3VyIGRpZ2l0YWwgbWFzdGVycGllY2UuLi4=');
  static String get deleteChatConfirmation => _decrypt('QXJlIHlvdSBzdXJlIHRvIGRlbGV0ZSB0aGlzIGNoYXQ/');
  static String get ai_make_photo_animated => _decrypt('TWFrZSB5b3VyIHBob3RvIGFuaW1hdGVkIChOU0ZXKQ==');
  static String get ai_generating => _decrypt('QUkgR2VuZXJhdGluZy4uLg==');
  static String get noNetwork => _decrypt('Tm8gbmV0d29yayBjb25uZWN0aW9u');
  static String get month => _decrypt('bW9udGg=');
  static String get freeChatUsed =>
      _decrypt('WW91J3ZlIHVzZWQgdXAgdm91ciBmcmVlIGNoYXQgY3JlZGl0cy4gVG8gY29udGludWUgZW5qb3lpbmcgb3VyIHNlcnZpY2UsIHBsZWFzZSBjb25zaWRlciB1cGdhdGluZyB0byBvdXIgcHJlbWl1bSBwbGFuLg==');
  static String get pickIt => _decrypt('UGlja0l0');
  static String get pleaseInputCustomText => _decrypt('UGxlYXNlIGlucHV0IHlvdXIgY3VzdG9tIHRleHQgaGVyZS4uLg==');
  static String get inputNickname => _decrypt('SW5wdXQgeW91ciBuaWNrbmFtZQ==');
  static String get ai_balance => _decrypt('QmFsYW5jZTo=');
  static String get ai_max_input_length => _decrypt('TWF4aW11bSBpbnB1dCBsZW5ndGg6IDUwMCBjaGFyYWN0ZXJz');
  static String get nickname => _decrypt('WW91ciBuaWNrbmFtZQ==');
  static String get support => _decrypt('U3VwcG9ydA==');
  static String get clearHistorySuccess => _decrypt('Q2xlYXIgaGlzdG9yeSBtZXNzYWdlcyBzdWNjZXNzIQ==');
  static String get someErrorTryAgain => _decrypt('SG1t4oCmIHdlIGxvc3QgY29ubmVjdGlvbiBmb3IgYSBiaXQuIFBsZWFzZSB0cnkgYWdhaW4h');
  static String get language => _decrypt('QWzigJlzIGxhbmd1YWdl');
  static String get iapNotSupport => _decrypt('SUFQIG5vdCBzdXBwb3J0ZWQ=');
  static String get maskApplied => _decrypt('VGhlIG1hc2sgaGFzIGJlZW4gcHV0IG9uIGZvciB5b3UhIE1vZGlmeWluZyB0aGUgbWFzayBkb2Vzbid0IGFmZmVjdCB0aGUgbG9hZGVkIG1hc2sncyBlZmZlY3Qu');
  static String get getAiInteractiveVideoChat => _decrypt('R2V0IGFuIEFJIGludGVyYWN0aXZlIHZpZGVvIGNoYXQgZXhwZXJpZW5jZQ==');
  static String get waitingResponse => _decrypt('V2FpdGluZyByZXNwb25zZcKu');

  static String get bestChoice => _decrypt('QmVzdCBjaG9pY2U=');
  static String get invitesYouToVideoCall => _decrypt('SW52aXRlcyB5b3UgdG8gdmlkZW8gY2FsbOKu');
  static String get submit => _decrypt('U3VibWl0');
  static String get ai_generate_nude => _decrypt('R2VuZXJhdGUgYSBudWRl');
  static String get ai_best_value => _decrypt('QmVzdCBWYWx1ZQ==');
  static String get week => _decrypt('d2Vlaw==');
  static String get scenario => _decrypt('U2NlbmFyaW8=');
  static String get ai_upload_steps_extra => _decrypt(
    'MS5Ud28gc3RlcHM6IFVwbG9hZCBhIHBob3RvLCB0aGVuIGNsaWNrIGdlbmVyYXRlLgoyLk5vIHN1cHBvcnQgZm9yIHBob3RvcyBvZiBtaW5vcnMuCjMuVXBsb2FkIGEgZnJvbnQtZmFjaW5nIHBob3RvLgo0LkRvZXMgbm90IHN1cHBvcnQgbXVsdGlwbGUgcGVvcGxlIHBob3Rvcy4=',
  );
  static String get edit => _decrypt('RWRpdA==');
  static String get ai_image_to_video => _decrypt('SW1hZ2UgdG8gVmlkZW8=');
  static String get nameHint => _decrypt('VGhlIG5hbWUgdGhhdCB5b3Ugd2FudCBib3RzIHRvIGNhbGwgeW91');
  static String get clearHistory => _decrypt('Q2xlYXIgaGlzdG9yeQ==');
  static String get editScenario => _decrypt('RWRpdCBzY2VuYXJpbw==');
  static String get tips => _decrypt('VGlwcw==');
  static String get accept => _decrypt('SXQncyBva2F5LCBjb3VsZCBiZSBiZXR0ZXIu');
  static String get restart => _decrypt('UmVzdGFydA==');
  static String get chat => _decrypt('Q2hhdA==');
  static String get autoTrans => _decrypt('QXV0b21hdGljIFRyYW5zbGF0aW9u');
  static String get cancel => _decrypt('Q2FuY2Vs');
  static String get noData => _decrypt('Tm8gZGF0YQ==');
  static String get openChatsUnlock => _decrypt('T3BlbiBjaGF0cyBhbmQgVW5sb2NrIEhvdCBwaG90bywgUG9ybiBWaWRlbywgTW9hbnMsIEdlbmVyYXRlIEltYWdlcyAmIFZpZGVvcywgQ2FsbCBHaXJscyE=');
  static String get ai_ai_photo => _decrypt('QUkgUGhvdG8=');
  static String get undrMessage => _decrypt('VW5kcmVzcyBhbnlvbmUgYW55dGltZSEgTG9vayB3aGF0J3MgdW5kZXIgaGVyIGNsb3RoZXMh');
  static String get tryNow => _decrypt('VHJ5IE5vdw==');
  static String get Moments => _decrypt('TW9tZW50cw==');
  static String get undress => _decrypt('VW5kcmVzcw==');
  static String get tease => _decrypt('VGVhc2U=');
  static String get mask => _decrypt('TWFzaw==');
  static List<String> get inputTagsTest => [
    "V2hhdOKAmXMgdGhlIG1vc3QgY2hlcmlzaGVkIGludGltYXRlIG1lbW9yeSB5b3XigJkgZXZlciBtYWRlIHdpdGggYW5vdGhlciBwZXJzb24/",
    "SG93IG11Y2ggaGFuZHMtb24gZXhwZXJpZW5jZSBkbyB5b3UgaGF2ZSB3aXRoIHJvbWFudGljIGFuZCBwaHlzaWNhbCByZWxhdGlvbnNoaXBz/",
    "SGF2ZSB5b3UgZXZlciBiZWVuIGluIGEgcmVsYXRpb25zaGlwIHdpdGggc29tZW9uZSB3aG8gb25jZSBkYXRlZCB5b3VyIGZyaWVuZC/",
    "V2hlcmUgZGlkIHlvdXIgZmlyc3Qgcm9tYW50aWMgYW5kIGludGltYXRlIGVuY291bnRlciB0YWtlIHBsYWNl/",
    "SWYgeW91IGNvdWxkIHBpY2sgYW55IGxvY2F0aW9uIGZvciBhbiBpbnRlbnNlbHkgcm9tYW50aWMgbW9tZW50LCB3aGVyZSB3b3VsZCB5b3Ugc2VsZWN0/",
    "SXMgdGhlcmUgYSBwYXJ0aWN1bGFyIHN0eWxlIG9yIHdheSBvZiBhcHByb2FjaGluZyBwaHlzaWNhbCBpbnRpbWFjeSB0aGF0IHlvdSBmYXZvcj8/",
    "V291bGQgeW91IGJlIHdpbGxpbmcgdG8gZXhwbG9yZSBuZXcgdGhpbmdzIHdoZW4gaXQgY29tZXMgdG8gaW50aW1hdGUgZXhwZXJpZW5jZXM/",
    "RG8geW91IGZpbmQgYSBjdXJ2eSBwaHlzaXF1ZSBvciBhIHNjdWxwdGVkLCB0b25lZCBib2R5IG1vcmUgYXBwZWFsaW5n/",
    "Q2FuIHlvdSBjcmVhdGUgYSByb21hbnRpYyBtb21lbnQgdGhhdCBzb21lb25lIHdpbGwgaG9sZCBpbiB0aGVpciBtZW1vcnkgZm9yZXZlcj8/",
    "V2hhdCB0aW1lIG9mIGRheSBvciBzaXR1YXRpb24gbWFrZXMgeW91IGxvbmcgZm9yIGEgcm9tYW50aWMgY29ubmVjdGlvbiB0aGUgbW9zdD8/",
    "V291bGQgeW91IGJlIGNvbWZvcnRhYmxlIHNoYXJpbmcgc29tZXRoaW5nIHBlcnNvbmFsIG9yIHByaXZhdGUgYWJvdXQgeW91cnNlbGYgd2l0aCBtZT8/",
    "V291bGQgeW91IGJlIGludGVyZXN0ZWQgaW4gc2VuZGluZyBhbmQgcmVjZWl2aW5nIHJvbWFudGljIG9yIGludGltYXRlIHBob3Rvcz8/",
    "Q291bGQgeW91IHNoYXJlIGEgcGljdHVyZSBvZiB5b3Vyc2VsZiB3aXRoIG1l/",
    "V2hhdOKAmXMgdGhlIG1vc3QgcHJvZm91bmQgcm9tYW50aWMgYm9uZCB5b3XigJkgZXZlciBzaGFyZWQgd2l0aCBzb21lb25l/",
    "SGF2ZSB5b3UgZXZlciBoYWQgYSByb21hbnRpYyBleHBlcmllbmNlIHRoYXQgZmVsdCBjb21wbGV0ZWx5IGVuY2hhbnRpbmcgb3IgbWFnaWNhbD8/",
    "V291bGQgeW91IGJlIG9wZW4gdG8gZXhjaGFuZ2luZyBwZXJzb25hbCBwaG90b3MgZnJvbSB5b3VyIHJvbWFudGljIG1vbWVudHM/",
    "V291bGQgeW91IG1pbmQgaWYgSSBhc2tlZCB0byBzZWUgYSBwaWN0dXJlIG9mIHlvdT8/",
    "SGF2ZSB5b3UgZXZlciBoYWQgYW4gaW50aW1hdGUgbW9tZW50IHRoYXQgYWx0ZXJlZCB5b3VyIHBlcnNwZWN0aXZlIG9uIHJvbWFuY2U/",
    "V2hhdOKAmXMgeW91ciB0eXBpY2FsIHdheSBvZiBzaG93aW5nIGludGltYWN5IGluIGEgcm9tYW50aWMgcmVsYXRpb25zaGlw/",
  ].map(_decrypt).toList();
  static String get answer => _decrypt('VGlwczogWW91IGNhbiB1c2UgdGhlICJVbmRyZXNzIiBidXR0b24gdG8gc2hvdyB5b3VyIHVuZHJlc3Npbmcgc3R5bGUgdG8geW91ciBwYXJ0bmVyLg==');
}
