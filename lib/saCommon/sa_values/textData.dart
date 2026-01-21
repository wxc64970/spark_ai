import 'package:encrypt/encrypt.dart';

class SATextData {
  static final _key = Key.fromUtf8('21414212432453255435466576000000');
  static final _iv = IV.fromBase64('gScioPT85qqx5d/ExwMvbw==');

  static String _decrypt(String base64) {
    final encrypter = Encrypter(AES(_key));
    return encrypter.decrypt64(base64, iv: _iv);
  }

  // 动态拼接文本（保留方法格式，因包含参数）
  static String deadline(String date) {
    return 'Deadline: $date';
  }

  // 动态拼接文本
  static String levelUpValue(String level) {
    return 'Level $level Reward';
  }

  // 动态拼接文本
  static String diamondPerEdit(String num) {
    return '$num diamond/edit';
  }

  // 动态拼接文本
  static String subscriptionInfo(String price, String unit) {
    return 'You will be charged $price immediately, then $price/$unit thereafter. Your subscription automatically renews unless canceled at least 24 hours before the end of the current period.';
  }

  // 动态拼接文本
  static String vipPriceLtDesc(String price) {
    return 'You will be charged $price immediately for lifetime access.';
  }

  // 动态拼接文本
  static String vipGet2(String diamond) {
    return '{{icon}}😄 Call your AI Girlfriend\n{{icon}}🥰 Spicy Photo, Video & Audio\n{{icon}}💎 One-time gift of $diamond diamond\n{{icon}}👏🏻 Unlimited messages & NSFW chats\n{{icon}}🔥 All access to premium features\n{{icon}}❤️ No ads';
  }

  // 动态拼接文本
  static String ageYearsOlds(String age) {
    return '$age years old';
  }

  static final String positiveReviewTitle = _decrypt('+TB+cM3bozR66Dk1HieTbg==');

  // 动态拼接文本
  static String oneTimePurchaseNote(String price) {
    return 'Please note that a one-time purchase will result in a one-time charge of $price to you.';
  }

  // 动态拼接文本
  static String saveNum(String num) {
    return 'Save $num%';
  }

  static String get ai_upload_steps =>
      _decrypt('jHEKXs2O8Ax28y8vawHcAy9Q4x25DIpx2F2f0lZ1c2ypuUZ31f21JMRNZpDsjA+ziLumqdUFKA0qeRtoCeHLIysNHO/tVTubWswQp+iM8utVk9nMFtNvtwXHkOzv3V3/xsOyV+HTbtaqDw2RLdQstWmpQ0CVxASpy6QP49G8Wm8=');
  static String get bestOffer => _decrypt('/xoNfYLhxT5W0VoTTVKqaQ==');
  static String get editChooseMask =>
      _decrypt('6Tc3WoLN6xlnoz15OTHNCzkR71yrDJs52kiDlVZtdGij/EE15fGrJMBJZtXsiAiix8Pgp/pKaxY+fUtzFLWeNiFfXfHqTieRW8wSoLuKtcRclc+QPJIkkQHKjfnik1vzgMW1XLWWYcS9CRGPLdMttnHmASLrrCetz6AL59W4Xms=');
  static String get gifts => _decrypt('+jY4XdGliHMYiFceQF+nZA==');
  static String get introTitle => _decrypt('9DEqW82liHMYiFceQF+nZA==');
  static String get ai_prompt_examples_img => _decrypt('2HE5E4LM6hN67TU5Jz3CCCVD7ljUIPYVuyX88noNFwU=');
  static String get deleteMaskConfirmation => _decrypt('+ToyTNbH7R8z9zR8OHTBDjNap0qxQJY5xUyDihlzfimj/EN6yfKqJMBAaYG+nh6i0tj64OhEKD0wZw1uCfjURA==');
  static String get ai_most_popular => _decrypt('8DAtXYL+7Ahm7z1nT1Coaw==');
  static String get legal => _decrypt('8To5SM6liHMYiFceQF+nZA==');
  static String get searchSirens => _decrypt('6SYuTILPozZy7jk1PzuMCSlf4x2LRYh82Vr2+HAHHQ8=');
  static String get seach => _decrypt('7jo/W8HGiXIZiVYfQV6mZQ==');

  static String get vipGet1 => _decrypt('xiQ3Ss3A/gUzxjJxJzHfHGBS71ysWJN30COLhR9idGe65AVO0vKxZ8gIaZnyzR2/ysXx9ehgcwU2agRpBujLBCAJXfHmXyvURIMbpOjHu+lVj83CcYUsjQfS9fbwlF+wzsygGdSaJdG7AwbzCKFB3w==');
  static String get tapToSeeMessages => _decrypt('l3V0A4j64ggz9zM1ODHJTzRZ4h21SYlq1k6VjVYrMSPtsysVspDQCq0mBvuQ43XY');
  static String get textMessageCallCost => _decrypt('jH8qTNraoxV28C90LDGWT3IR41S5QZV30yOznxptO0iOuUZz3ey/Z9dNeoakzUrmhtX95vYFZhpwZAJpf5HvQQ==');
  static String get textMessageCost => _decrypt('jH8qTNraoxV28C90LDGWT3IR41S5QZV30yPB3hd0f2CouUh+z+2/Y8YSKMG+iRK3y97645EpaRIzKSpOW/aDJDYeX+vgSDzOCd1P4ayI+uhVj87NcYkv63yi9oSC9DXW');
  static String get moansForYou => _decrypt('8DA/R9GO5RdhoyV6PlevbA==');
  static String get ageHint => _decrypt('7TM7SNHLoxF98ylhay3DGjIR5lq9J/ESvCL79X0KEAI=');
  static String get yes => _decrypt('5DotJK+jjnUejlEYRlmhYg==');
  static String get sendAGiftAndGetAPicture => _decrypt('7jowTYLPox965Sg1KjrITydU8x25DIpw1F2FjBMCGAo=');
  static String get otherInfoHint => _decrypt('5DArW4Lc5hRy9zV6JSfEBjAR8FSsRNpt30zQnR5gaWik7UBpnPGsJMpFeJrsmRq40pHx8f4EfA1xDmwAfJLsQg==');
  static String get violence => _decrypt('6zYxRcfA4B0bi1QdQ1ykZw==');
  static String get ai_styles => _decrypt('7isnRcfduXEailUcQl2lZg==');
  static String get ai_custom_prompt => _decrypt('/iotXc3Doyhh7DFlP26ubQ==');
  static String get microphonePermissionRequired => _decrypt('8DY9W83e6xd95nxlLibBBjNC7lK2DJNql1uVjwNoaWyjuVF0nPO/b8YIadX9jBe6iL6biJRlB3FQBmQIdJrkSg==');
  static String get profileMaskDescription =>
      _decrypt('/i07SNbLoxkz7j1mIHTcHS9X7lG9DI52l0CeihNzemqzuVJyyPb+cMtNKJb2jAm3xcXx9bsIbQorbBkpW9iEIS0ZRfbrXW+AQYlfrKmS8KVejs+Rcsc1whTNmejoiRyryNT9VfqfbNKtRg6Xfs9jqT2jCyv9qn2KzqEK5tS5X2o=');
  static String get unlockRoleDescription => _decrypt('/zo9Rs/Loxkz8y5wJj3ZAmBF6B2tQpZ21ELQlhl1O3uo9UBonP+wYINPbYG+mBW6z9z98/4OKB03aB90VZboRg==');

  static String get enticingPicture => _decrypt('+DEqQMHH7R8z8zV2PyHeClAhly3IPOoJpzng7mYRCxk=');
  static String get chatted => _decrypt('/jc/XdbL53EailUcQl2lZg==');
  static String get all => _decrypt('/DMyJK+jjnUejlEYRlmhYg==');
  static String get gotToPro => _decrypt('+jB+Xc2O0wp8hFsSTFOraA==');
  static String get wait30Seconds => _decrypt('9Ct+RMPXowxy6Dk1PiSMGy8RtA34X5962EeUjVhRd2ym6kA72PH+asxcKJbyggizht7mp/cPaQg6KR9vHrWKNTRwM5CKNUD7JuNwzsfulIo=');
  static String get unlockRole => _decrypt('6DEyRsHFozB893xHJDjJHGE+iDLXI/UWuCb/8XkOFAY=');
  static String get chatList => _decrypt('/jc/XYLC6gtnhFsSTFOraA==');
  static String get waitForResponse => _decrypt('7TM7SNHLow9y6ig1LTveTzRZ4h2qSYlp2EeDm3IFHw0=');
  static String get hotVideo => _decrypt('9TAqCfTH5x18hFsSTFOraA==');
  static String get saraReceivedYourGift => _decrypt('7j4sSILc5ht26ipwL3TVADVDp1qxSo45R7Z+f3IFHw0=');
  static String get create => _decrypt('/i07SNbLiXIZiVYfQV6mZQ==');
  static String get ai_bonus => _decrypt('/zAwXNGliHMYiFceQF+nZA==');
  static String get networkError => _decrypt('7TM7SNHLoxt75j9+ayDECmBf4kmvQ4hyl0qfkBhkeH2u9ksWsZPTCa4lBfiT4Hbb');
  static String get unselectAll => _decrypt('6DEtTM7L4AwzwjB5T1Coaw==');
  static String get levelUpIntimacy => _decrypt('8TooTM6O9ggzyjJhIjnNDDk+iDLXI/UWuCb/8XkOFAY=');
  static String get yourNickname => _decrypt('5DArW4LA6ht47T14LlevbA==');
  static String get ai_language => _decrypt('/Ba8qTrdoxRy7TtgKjPJTylCiTPWIvQXuSf+8HgPFQc=');
  static String get clickSaveToConfirm => _decrypt('/jM3SsmO9xB2o35GKiLJTWBT8kmsQ5Q5w0bQnRlvfWC19AVv1P+qJMpcKIH/hh6lhtTy4f4JfHdWAGIOcpziTA==');

  static String get noSubscriptionAvailable => _decrypt('8zB+WtfM8Bth6ixhIjvCTyFH5lS0TZh10i73+XEGHA4=');
  static String get save => _decrypt('7j4oTK6ij3Qfj1AZR1igYw==');
  static String get maxInputLength => _decrypt('8D4mQM/b7lh67SxgP3TACi5W81XiDM8phwmTlhdzemqz/FdosJLSCK8kBPmS4Xfa');
  static String get feedback => _decrypt('+zo7TcDP4BMbi1QdQ1ykZw==');
  static String get unlockTextReply => _decrypt('6DEyRsHFoyx2+yg1GTHcAzk+iDLXI/UWuCb/8XkOFAY=');
  static String get clearHistoryFailed => _decrypt('/jM7SNCO6xFg9zNnMnTBCjNC5lq9X9p/1kCcmxIgGQs=');
  static String get reportSuccessful => _decrypt('7zouRtDaowtm4D9wOCfKGiw+iDLXI/UWuCb/8XkOFAY=');
  static String get unlock => _decrypt('6DEyRsHFiXIZiVYfQV6mZQ==');
  static String get listening => _decrypt('8TYtXcfA6hZ0rXI7T1Coaw==');
  static String get home => _decrypt('9TAzTK6ij3Qfj1AZR1igYw==');
  static String get hotPhoto => _decrypt('9TAqCdLG7Ax8hFsSTFOraA==');
  static String get createOrderError => _decrypt('/i07SNbLoxdh5zlnazHeHS9DiTPWIvQXuSf+8HgPFQc=');
  static String get easterEggUnlock =>
      _decrypt('/jAwTtDP9wsz7DI1PjrAACNa7lO/DI5x0gm1nwV1fnvn/EJ8nPi7ZdddepC/zSK505H35vVKZhEoKR53F/qKIWQWUf7iXzzUXYNfpLCR9+pIhIqWdIVhlxvPjej4jhy51d++TfyRZpnpIQqAaIQtrj2nTT7wpn2FzqEK5tS5X2o=');
  static String get vipMember => _decrypt('6xYOCe/L7hp28VoTTVKqaQ==');
  static String get clothing => _decrypt('/jMxXcrH7R8bi1QdQ1ykZw==');
  static String get msgTips => _decrypt('7zouRcvL8Fhy8Tk1LDHCCjJQ81i8DJhgl2ic3hdvfymh/FFy0/C/aKsgAP2W5XPe');
  static String get realistic => _decrypt('7zo/Rcvd9xFwhFsSTFOraA==');
  static String get dislike => _decrypt('8zAqCdHP9xFg5TVwL3iMASVU4074RZdpxUaGmxtkdX3plioUs5HRC6wnB/qR4nTZ');
  static String get ai_most_popular_new => _decrypt('8DAtXYL+7Ahm7z1nT1Coaw==');
  static String get anime => _decrypt('/DE3RMeliHMYiFceQF+nZA==');
  static String get toCreate => _decrypt('6TB+StDL4gx2hFsSTFOraA==');
  static String get yourAge => _decrypt('5DArW4Lv5B0bi1QdQ1ykZw==');
  static String get notEnough => _decrypt('9DEtXMTI6ht65jJhazbNAyFf5Fj0DIp10kiDm1Zzfmqv+Fd82ZXVD6gjA/6V5nDd');
  static String get personalDetails => _decrypt('7TosWs3A4hQz5zlhKj3AHFAhly3IPOoJpzng7mYRCxk=');
  static String get message => _decrypt('0DotWsPJ5nEailUcQl2lZg==');
  static String get ai_photo_label => _decrypt('7TcxXc2liHMYiFceQF+nZA==');
  static String get subFeedback => _decrypt('7io8RMvaoxkz5TlwLzbNDCs+iDLXI/UWuCb/8XkOFAY=');
  static String get dailyReward => _decrypt('+T43RduO8R1k4i5xT1Coaw==');
  static String get weekly => _decrypt('6jo7Qs7XiXIZiVYfQV6mZQ==');
  static String get ai_art_consumes_power =>
      _decrypt('+i07SNaO4gpnoz96JSfZAiVCp163QYpsw0iElxlvemXn6Ups2ez+Zc1MKIH3gB74hvTi4ukTKA06agRpH7WSKjFfS/7sTm+dWswLs6mP6ONVk8eLcodhixvfkK37lES6zML9VvPef9inAgaEI6dH2Q==');
  static String get upgradeTochat => _decrypt('6C85W8PK5lhn7Hx2IzXYbg==');
  static String get ai_purchase_balance => _decrypt('7SosSsrP8B0zwT15KjrPClAhly3IPOoJpzng7mYRCxk=');
  static String get unlockNow => _decrypt('6DEyRsHFozZ89FoTTVKqaQ==');
  static String get otherInfo => _decrypt('8is2TNCO6hZ17FoTTVKqaQ==');
  static String get lifetime => _decrypt('8TY4TNbH7h0bi1QdQ1ykZw==');
  static String get clearHistoryConfirmation => _decrypt('/C07CdvB9lhg9i5wayDDTyNd4lyqDJt12wmYlwV1dHu+uUh+z+2/Y8ZbN/Cb6H7T');
  static String get longReply => _decrypt('8TAwToL85gh/+mY1Jz3HCmBC81KqVfATvSP69HwLEQM=');
  static String get vipUpgrade => _decrypt('6C85W8PK5lhn7HxDAgSubQ==');

  static String get aotoTrans => _decrypt('+DE/S87Loxlm9zN4KiDFDGBF9Vy2X5Z4w0CfkEkCGAo=');
  static String get resetChatBackground => _decrypt('7zotXYLN6xlnoz50KD/LHS9E6VnUIPYVuyX88noNFwU=');
  static String get ai_please_enter_custom_prompt => _decrypt('7TM7SNHLox199zlnazWMDDVC81K1DIpr2ESAinIFHw0=');
  static String get yourName => _decrypt('5DArW4Lg4hV2hFsSTFOraA==');
  static String get yourGender => _decrypt('5DArW4Lp5hZ35i4QTlGpag==');
  static String get pleaseInput => _decrypt('7TM7SNHLox199zlnazfDATRU6UnUIPYVuyX88noNFwU=');
  static String get aiPhoto => _decrypt('/BZ+ecrB9xcbi1QdQ1ykZw==');
  static String get nice => _decrypt('8zY9TK6ij3Qfj1AZR1igYw==');
  static String get typeHere => _decrypt('6SYuTILG5gp2rXI7T1Coaw==');
  static String get notEnoughCoins => _decrypt('8zAqCcfA7A1063xWJD3CHGwR5Fy0QNp82U2VmlgCGAo=');
  static String get buyGemsOpenChats => _decrypt('/yonCeXL7gsz9zM1JCTJAWBS71ysX9QQviD5938IEgA=');
  static String get illegalDrugs => _decrypt('9DMyTMXP71h38SlyOFevbA==');
  static String get report => _decrypt('7zouRtDaiXIZiVYfQV6mZQ==');
  static String get chooseYourTags => _decrypt('/jcxRtHLowF89i41PzXLHFAhly3IPOoJpzng7mYRCxk=');
  static String get expirationTime => _decrypt('+CcuQNDP9xF87XxhIjnJVWA+iDLXI/UWuCb/8XkOFAY=');
  static String get dressUp => _decrypt('+S07WtGO1ggbi1QdQ1ykZw==');
  static String get subscribe => _decrypt('7io8WsHc6hp2hFsSTFOraA==');
  static String get yearly => _decrypt('5Do/W87XiXIZiVYfQV6mZQ==');
  static String get shortReply => _decrypt('7jcxW9aO0R1j7yUvazjFBCUR9FCrJ/ESvCL79X0KEAI=');
  static String get appVersion => _decrypt('/C8uCdTL8Qt67DIQTlGpag==');
  static String get setChatBackground => _decrypt('/iotXc3Dozt74ig1CTXPBCdD6Ei2SPATvSP69HwLEQM=');
  static String get micPermission => _decrypt('8DY9W83e6xd95nxlLibBBjNC7lK2DJNql1uVjwNoaWyjuVF0nPO/b8YIadX9jBe6iL6biJRlB3FQBmQIdJrkSg==');
  static String get ai_generate_another => _decrypt('+jowTNDP9x0z4jJ6PzzJHWBe6VjUIPYVuyX88noNFwU=');
  static String get male => _decrypt('8D4yTK6ij3Qfj1AZR1igYw==');
  static String get btnContinue => _decrypt('/jAwXcvA9h0bi1QdQ1ykZw==');
  static String get send => _decrypt('7jowTa6ij3Qfj1AZR1igYw==');
  static String get liked => _decrypt('8TY1TMaliHMYiFceQF+nZA==');
  static String get subscriptionAutoRenew => _decrypt(
    '5DArCdXH7xQz4Tk1KDzNHSdU4x2xQZd800CRihNtYiXn7U1+0r6qbMYIe5TziFu3y97h6e9KbQg6exInFvqFMSxfSPfgSCqVT5gas+bBwupPk4qRaYIygQfCj/niklL/wcSpVviffN6qBw+adIQ2v3OjGj64vGfIo9pxzr/QOQFs2+xhZOVlCDT1nZ7gW6JjHIk3KsZvSBz3eZXx4sxffVaUtXsYI70XJkFL5br8NptvHQ5n6INZ01zHs7gn4CaDV9cb6IAsMgIZkxOz909EZ+X+ltl/eWE8bpidr3VSNtOmjPd2JVICHEVL9rzyYpvD6knyRXCK7Ho7hrEGBmGpqnc7OuGYYor9kPk+Pg2SOUQGmfIZqiji84neH+ezf0cWdtpn7wPoIz66SaDNAwz8zQ==',
  );
  static String get selectProfileMask => _decrypt('7joyTMHaoyF89i41GybDCSld4h2VTYlyvyH49n4JEwE=');
  static String get uploadAPhoto => _decrypt('6C8yRsPKoxkz8zR6PzuubQ==');
  static String get description => _decrypt('+TotStDH8wx67DIQTlGpag==');
  static String get setting => _decrypt('7joqXcvA5HEailUcQl2lZg==');
  static String get explore => _decrypt('+CcuRc3c5nEailUcQl2lZg==');
  static String get vipGet =>
      _decrypt('xiQ3Ss3A/gXjHMSWaxHCCyxU9E74T5J4w12ZkBELYHKu+kp1weMumwabKKDwgRS1zZH16/dKbhczfQ51CJ+QPi0cU/H4R79ru2JfgKyX+utZhM7CcY8lh1WN3+Hkk1v/zdSwVueHAsyyDwCZY9k5KoJX4gz85G/Wo8wE6Nq3UWQ=');
  static String get backUpdatedSucc => _decrypt('/z49QsXc7A1953xgOzDNGyVVp06tT5l8xFqWixptYijXiTULrI7OFLM4GOWO/WvG');
  static String get upToVip => _decrypt('6C85W8PK5lhn7HxDAgSubQ==');
  static String get ai_undress_sweetheart => _decrypt('6DE6W8fd8FhK7ClnawfbCiVF71i5Xo45+UaH3lcgGQs=');
  static String get privacyPolicy => _decrypt('7S03X8PN+lhj7DB8KC2ubQ==');
  static String get ai_photos => _decrypt('zTcxXc3diXIZiVYfQV6mZQ==');
  static String get openSettings => _decrypt('8i87R4Ld5gxn6jJyOFevbA==');
  static String get termsOfUse => _decrypt('6TosRNGO7B4z9i9wT1Coaw==');
  static String get intro => _decrypt('9DEqW82liHMYiFceQF+nZA==');
  static String get deleteChat => _decrypt('+ToyTNbLoxt74igQTlGpag==');

  static String get howToCallYou => _decrypt('9TApCcbBowF89nxiKjrYTzle8k/4bbM50ECCkhBzcmyp/QVv0769Zc9EKIzxmETX');
  static String get SALoading => _decrypt('8TA/TcvA5HEailUcQl2lZg==');
  static String get ai_video_label => _decrypt('6zY6TM2liHMYiFceQF+nZA==');
  static String get ai_prompt_examples_video => _decrypt('2HE5E4Lvow987j17ayDNBCVCp1K+Stpx0lvQnRpub2Gi6gk72eaua9BBZpK+hR6khtPm4voZfA1/aAVjW/uCNTQTWeypGiGVQokb7eiU9eFIhNmReYRtwhvem+iP+Tjb');
  static String get restore => _decrypt('7zotXc3c5nEailUcQl2lZg==');
  static String get giveHerAMoment => _decrypt('+jYoTILG5goz4nx4JDnJATQR81L4SZRz2FDQlwIhemejuVF61/v+ZYNYYZbqmAmzhtf79bsTZwt/+fSUzJboRg==');
  static String get bestChatExperience => _decrypt('+DE0RtuO1xB2ox5wOCCMLChQ8x2dVIp8xUCVkBVkGQs=');
  static String get selectAll => _decrypt('7joyTMHaozl/71oTTVKqaQ==');

  static String get buy => _decrypt('/yonJK+jjnUejlEYRlmhYg==');
  static String get fillRequiredInfo => _decrypt('7TM7SNHLox567zA1IjqMGyhUp0+9XY9wxUyU3h9vfWa19ERv1fGwDaohAfyX5HLf');
  static String get notSupport => _decrypt('8zAqCdHb8wh88SgQTlGpag==');
  static String get spam => _decrypt('7i8/RK6ij3Qfj1AZR1igYw==');
  static String get collect => _decrypt('/jAyRcfN93EailUcQl2lZg==');
  static String get tagsTitle => _decrypt('6T45Wq6ij3Qfj1AZR1igYw==');
  static String get info => _decrypt('9DE4Rq6ij3Qfj1AZR1igYw==');
  static String get female => _decrypt('+zozSM7LiXIZiVYfQV6mZQ==');
  static String get reload => _decrypt('7zoyRsPKiXIZiVYfQV6mZQ==');
  static String get descriptionHint =>
      _decrypt('8TY1TJiO1BBy93x0OTGMFi9E9R2wQ5h73kyDwVZoaGWu8kAhnOm2ZdcIYYa+lBSj1JHw7ugGYRU6NktQE/SfZTAQTPbmSW+QRswGrr3B9+xRhIqWc8A1gxnA3+zpkkmrn77SNprxB7jGaWz5AqtL1Q==');
  static String get childAbuse => _decrypt('/jc3RcaO4hpm8DkQTlGpag==');
  static String get speechRecognitionNotSupported => _decrypt('7i87TMHGowp24DNyJT3YBi9fp1O3WNpqwlmAkQR1fm3n9ks7yPa3d4NMbYP3jh74tqGEl4t6GG5PGXsXa4X7VQ==');
  static String get toys => _decrypt('6TAnWq6ij3Qfj1AZR1igYw==');
  static String get ai_generation_failed => _decrypt('+jowTNDP9xF87XxzKj3ACiQf3lKtDJl42QmEjA8hem6m8Es72vGsJMVabZC/7njV');
  static String get confirm => _decrypt('/jAwT8vc7nEailUcQl2lZg==');
  static String get ai_under_character => _decrypt('6DE6TNCO9xB2oz99KibNDDRU9TDVIfcUuiT983sMFgQ=');
  static String get love => _decrypt('+i07SNaPozE07nx5JCLFAScR7kn2J/ESvCL79X0KEAI=');
  static String get like => _decrypt('8TY1TK6ij3Qfj1AZR1igYw==');

  static String get diamond => _decrypt('+TY/RM3A53EailUcQl2lZg==');

  static String get scenarioRestartWarning => _decrypt('6TB+SMHa6g52oyh9LnTCCjcR9F69Qptr3kbcih5kO2qv+FE7y/eyJMFNKIf7ng+31MW05vUOKAo3bEtvEuafKjYGHOjsViPURYMMpObimIY=');
  static String get popular => _decrypt('7TAuXM7P8XEailUcQl2lZg==');
  static String get monthly => _decrypt('8DAwXcrC+nEailUcQl2lZg==');
  static String get useAvatar => _decrypt('6Cw7CePCoxt74i50KCDJHTMWp163Wp9rvyH49n4JEwE=');
  static String get inputYourNickname => _decrypt('+DEqTNCO+hdm8Xx7IjfHASFc4jDVIfcUuiT983sMFgQ=');
  static String get year => _decrypt('xDo/W66ij3Qfj1AZR1igYw==');
  static String get nonBinary => _decrypt('8zAwBMDH7Rlh+loTTVKqaQ==');
  static String get createMaskProfileDescription => _decrypt('/i07SNbLoxkz7j1mIHTcHS9X7lG9DI52l0CeihNzemqzuVJyyPb+cMtNKJb2jAm3xcXx9bsIbQorbBkCfpDuQA==');
  static String get createProfileMask => _decrypt('/i07SNbLoyF89i41GybDCSld4h2VTYlyvyH49n4JEwE=');
  static String get maskAlreadyLoaded =>
      _decrypt('6Tc3WoLN6xlnoz15OTHNCzkR71yrDJs52kiDlVZtdGij/EE1nMexcYNLaZu+nx6l0tDm87sLKB03aB8nD/rLMDcaHP7rVTucTJ5frKmS8KsaoMyWeZJhkBDYi+z5iVWxx539Tf2bKN+gFReZf91krXSqAW30pnrB6K4F6du2UGU=');
  static String get ai_generate => _decrypt('+jowTNDP9x0bi1QdQ1ykZw==');
  static String get everyDay => _decrypt('kjs/UK6ij3Qfj1AZR1igYw==');
  static String get video => _decrypt('6zY6TM2liHMYiFceQF+nZA==');
  static String get close => _decrypt('/jMxWseliHMYiFceQF+nZA==');
  static String get activateBenefits => _decrypt('/DwqQNTP9x0zwTl7LjLFGzM+iDLXI/UWuCb/8XkOFAY=');
  static String get copyright => _decrypt('/jAuUNDH5BBnhFsSTFOraA==');
  static String get day => _decrypt('2T4nJK+jjnUejlEYRlmhYg==');
  static String get replyMode => _decrypt('7zouRduO7hd35loTTVKqaQ==');
  static String get ai_view_nude => _decrypt('6zY7XoLa6x0z4DR0OTXPGyVDoE74Qo990i73+XEGHA4=');
  static String get optionTitle => _decrypt('8i8qQM3AiXIZiVYfQV6mZQ==');
  static String get more => _decrypt('8DAsTK6ij3Qfj1AZR1igYw==');
  static String get ai_videos => _decrypt('yzY6TM3diXIZiVYfQV6mZQ==');
  static String get ai_generating_masterpiece => _decrypt('+jowTNDP9xF95HxsJCHeTyRY4FSsTZY52kiDihNza2Ci+kA1krDUDqkiAv+U53Hc');
  static String get deleteChatConfirmation => _decrypt('/C07CdvB9lhg9i5wayDDTyRU61isSdpt30CD3hVpen34lioUs5HRC6wnB/qR4nTZ');
  static String get ai_make_photo_animated => _decrypt('8D41TILX7A1hoyx9JCDDTyFf7lC5WJ99lwG+rTBWMgg=');
  static String get ai_generating => _decrypt('/BZ+bsfA5gpy9zV7LHqCQVAhly3IPOoJpzng7mYRCxk=');
  static String get noNetwork => _decrypt('8zB+R8fa9Bdh6Hx2JDrCCiNF7lK2J/ESvCL79X0KEAI=');
  static String get month => _decrypt('0DAwXcqliHMYiFceQF+nZA==');
  static String get freeChatUsed =>
      _decrypt('5DArDtTLow1g5jg1PiSMFi9E9R2+Xp98l0qYnwIheHui/Uxvz7D+UMwIa5rwmRK409S04vUAZwc2ZwwnFOCZZTcaTunsWSrYCZwTpKmS/qVZjsSRdYQkkFXej+r5nFi2ztb9TfreZ8K7RhOEaMktr3DmHSH5pyetz6AL59W4Xms=');
  static String get pickIt => _decrypt('7TY9QoLH93EailUcQl2lZg==');
  static String get pleaseInputCustomText => _decrypt('7TM7SNHLoxF98ylhay3DGjIR5EirWJV0l12VhgIhc2y1/As1kpXVD6gjA/6V5nDd');
  static String get inputNickname => _decrypt('9DEuXNaO+hdm8Xx7IjfHASFc4jDVIfcUuiT983sMFgQ=');
  static String get ai_balance => _decrypt('/z4ySMzN5kIbi1QdQ1ykZw==');
  static String get ai_max_input_length => _decrypt('8D4mQM/b7lh67SxgP3TACi5W81XiDM8phwmTlhdzemqz/FdosJLSCK8kBPmS4Xfa');
  static String get nickname => _decrypt('5DArW4LA6ht47T14LlevbA==');
  static String get support => _decrypt('7iouWc3c93EailUcQl2lZg==');
  static String get clearHistorySuccess => _decrypt('/jM7SNCO6xFg9zNnMnTBCjNC5lq9X9pqwkqTmwVyOgg=');
  static String get someErrorTryAgain => _decrypt('9TIzyyIIow92ozB6OCCMDC9f6Vi7WJN22QmWkQQheiml8FE1nM6yYcJbbdXqnwL2x9b17vVLAnRVA2ENcZ/hTw==');
  static String get language => _decrypt('/DO8qTvdoxRy7TtgKjPJbg==');
  static String get iapNotSupport => _decrypt('9B4OCczB91hg9ixlJCbYCiQ+iDLXI/UWuCb/8XkOFAY=');
  static String get maskApplied => _decrypt('6Tc7Cc/P8BMz6z1mazbJCi4R90isDJV3l0+fjFZ4dHzmuWh02Pe4fcpGb9XqhR72y9Dn7LsOZxssZ0xzW/SNIyEcSL/xUirURYMepa2Fu+hbksHFb8AkhBPOnPml/j/c');
  static String get getAiInteractiveVideoChat => _decrypt('+joqCcPAozlaozV7PzHeDiNF7ku9DIxw00yf3hVpen3n/F1r2ey3Yc1LbfCb6H7T');
  static String get waitingResponse => _decrypt('6j43XcvA5Fhh5i9lJDrfCqKxITDVIfcUuiT983sMFgQ=');

  static String get bestChoice => _decrypt('/zotXYLN6xd64DkQTlGpag==');
  static String get invitesYouToVideoCall => _decrypt('9DEoQNbL8Fhq7Ck1PzuMGSlV4lL4T5t128twWHIFHw0=');
  static String get submit => _decrypt('7io8RMvaiXIZiVYfQV6mZQ==');
  static String get ai_generate_nude => _decrypt('+jowTNDP9x0z4nx7PjDJbg==');
  static String get ai_best_value => _decrypt('/zotXYL44hRm5loTTVKqaQ==');
  static String get week => _decrypt('yjo7Qq6ij3Qfj1AZR1igYw==');
  static String get scenario => _decrypt('7jw7R8Pc6hcbi1QdQ1ykZw==');
  static String get ai_upload_steps_extra => _decrypt(
    'jHEKXs2O8Ax28y8vawHcAy9Q4x25DIpx2F2f0lZ1c2ypuUZ31f21JMRNZpDsjA+ziLumqdUFKA0qeRtoCeHLIysNHO/tVTubWswQp+iM8utVk9nMFtNvtwXHkOzv3V3/xsOyV+HTbtaqDw2RLdQstWmpQ0es503Lo9oigLPFdxF8x/lqNvAxRS38iITkF/V3TIQ3L9h5SA76cI7s9MIpFw==',
  );
  static String get edit => _decrypt('+Ds3Xa6ij3Qfj1AZR1igYw==');
  static String get ai_image_to_video => _decrypt('9DI/TseO9xcz1TVxLjuubQ==');
  static String get nameHint => _decrypt('6Tc7CczP7h0z9zR0P3TVADUR8Fy2WNp72F2D3gJuO2qm9Uk7xfGrDaohAfyX5HLf');
  static String get clearHistory => _decrypt('/jM7SNCO6xFg9zNnMlevbA==');
  static String get editScenario => _decrypt('+Ds3XYLd4B194i58JFevbA==');
  static String get tips => _decrypt('6TYuWq6ij3Qfj1AZR1igYw==');
  static String get accept => _decrypt('9Ct5WoLB6Blqr3x2JCHAC2BT4h26SY5t0lve+3MEHgw=');
  static String get restart => _decrypt('7zotXcPc93EailUcQl2lZg==');
  static String get chat => _decrypt('/jc/Xa6ij3Qfj1AZR1igYw==');
  static String get autoTrans => _decrypt('/CoqRs/P9xFwowhnKjrfAyFF7lK2J/ESvCL79X0KEAI=');
  static String get cancel => _decrypt('/j4wSsfCiXIZiVYfQV6mZQ==');
  static String get noData => _decrypt('8zB+TcPa4nEailUcQl2lZg==');
  static String get openChatsUnlock => _decrypt('8i87R4LN6xln8Hx0JTCMOi5d6F6zDLJ2wwmAlhl1dCXnyUpp0r6IbcdNZ9m+oBS3yMK4p9wPZhstaB9iW9yGJCMaT7+jGhmdTYkQsuTB2ORWjYqldZItkVSs+IqM+jvY');
  static String get ai_ai_photo => _decrypt('/BZ+ecrB9xcbi1QdQ1ykZw==');
  static String get undrMessage => _decrypt('6DE6W8fd8Fhy7SV6JTGMDi5I81S1Sds5+0aflVZ2c2izvlY7yfC6YdEIYJDszRi6ycX84uhLAnRVA2ENcZ/hTw==');
  static String get tryNow => _decrypt('6S0nCezB9Fkbi1QdQ1ykZw==');
  static String get Moments => _decrypt('8DAzTMza8HEailUcQl2lZg==');
  static String get undress => _decrypt('6DE6W8fd8HEailUcQl2lZg==');
  static String get tease => _decrypt('6To/WseliHMYiFceQF+nZA==');
  static String get mask => _decrypt('8D4tQq6ij3Qfj1AZR1igYw==');
  static List<String> get inputTagsTest => [
    _decrypt('6jc/XUAuGgsz9zRwaznDHDQR5FW9XpNq30yU3h9vb2Cq+FF+nPO7acxacdXngg40Jiji4rsPfhstKQZmH/DLMi0LVL/kVCCAQYkN4biE6fZVj5XvEe1M73im8oCG8DHS'),
    _decrypt('9TApCc/b4BAz6z17LyeBAC4R4kWoSYhw0keTm1ZldCm+9lA71P+oYYNfYYH2zQm5y9D68/IJKB8xbUt3E+yYLCceUL/3XyOVXYUQr7uJ8vVJ3qTsEu5P7Hul8YOF8zLR'),
    _decrypt('9T4oTILX7A0z5ipwOXTOCiVfp1S2DJs5xUycnwJodGe08UxrnOm3cMsIe5rziBS4w5Hj7/RKZxA8bEtjGuGOIWQGU+r3GimGQIkRpffimIY='),
    _decrypt('6jc7W8eO5xF3oyV6PiaMCSlD9En4XpV01keElxUhemejuUx1yPezZddNKJDwjhSjyMXx9bseaRU6KRtrGvaOelRvLI+VKl/kOfxv0djxi5U='),
    _decrypt('9Dl+UM3boxt89jBxayTFDCsR5lOhDJZ21EiElxlvO2+o6wV60r63atdNZob7gQL21N755vUeYR1/ZARqHvufaWQIVPr3X2+DRpkTpeiY9PAaks+OeYM13X2j94WD9TTX'),
    _decrypt('9Cx+XcrL8R0z4nxlKibYBiNE61yqDIltzkWV3hlzO36m4AV02r6/dNNaZ5T9hRK4wZHk7+IZYR0+ZUtuFeGCKCUcRb/xUi6ACZUQtOiH+vNVk5XvEe1M73im8oCG8DHS'),
    _decrypt('6jArRcaO+hdmoz5wayPFAyxY6Vr4WJU50lGAkhlzfimp/FI7yPa3asRbKIL2iBX2z8W05PQHbQ1/fQQnEvufLCkeSPqlXzeETJ4WpKaC/vYF7qXtE+9O7Xqk8IKE8jPQ'),
    _decrypt('+TB+UM3box567Tg1KnTPGjJH/h2oRINq3liFm1ZuaSmmuVZ4yfKucMZMJNXqghWzwpH26P8TKBMwew4nGuWbICUTVfHiBUX+I+Z1y8LrkY8='),
    _decrypt('/j4wCdvB9lhw8Tl0PzGMDmBD6FC5Qo5w1AmdkRtkdX3n7U16yL6ta85NZ5v7zQy/yt207/QGbF42Z0tzE/CCN2QSWfLqSDbUT4MNpL6E6boq8bryDPBR8mW7752b7SzP'),
    _decrypt('6jc/XYLa6hV2ozNzazDNFmBe9R2rRY5s1l2ZkRghdmis/FY7xfGrJM9HZpK+ixSkhtC09fQHaRArYAgnGPqFKyEcSPbqVG+AQYlfrKeS77oq8bryDPBR8mW7752b7SzP'),
    _decrypt('6jArRcaO+hdmoz5wazfDAiZe9Um5TpZ8l1qYnwRodW7n6kp22eq2bc1PKIX7nwi5yND4p/QYKA4tYB1mD/DLJCYQSeulQyCBW58ara7B7OxOiYqPed9L6H+h9YeB9zbV'),
    _decrypt('6jArRcaO+hdmoz5waz3CGyVD4k6sSZ453kfQjRNvf2Cp/gV60vr+dsZLbZzohBWxhsP76voEfBc8KQR1W/yFMS0SXevgGj+cRpgQsvfimIY='),
    _decrypt('/jArRcaO+hdmoy99KibJTyER91S7WI9r0gmfmFZ4dHy16kB32r6pbddAKJj70nnU'),
    _decrypt('6jc/XUAuGgsz9zRwaznDHDQR90+3SpVs2U3QjBlsemez8EY73vGwYINRZ4B8beKgw5Hx8f4YKA03aBliH7WcLDAXHOzqVyqbR4lAxM3knoA='),
    _decrypt('9T4oTILX7A0z5ipwOXTEDiQR5h2qQ5d42V2ZnVZkY3mi60x+0v27JNdAaYG+ix660pH36PYaZBsrbAd+W/CFJiweUuvsVCjURp5frKmG8uZbjZXvEe1M73im8oCG8DHS'),
    _decrypt('6jArRcaO+hdmoz5wazvcCi4R81L4SYJ630iemR9vfCm3/Fdo0/C/aINYYJrqggj2wMP76rsTZwstKRloFvSFMS0cHPLqVyqaXZ9AxM3knoA='),
    _decrypt('6jArRcaO+hdmozF8JTCMBiYRzh25X5F80wmEkVZyfmzn+AVr1f2qcdFNKJr4zQK5046aiZVkBnBRB2UJdZvlSw=='),
    _decrypt('9T4oTILX7A0z5ipwOXTEDiQR5lP4RZRt3kSRihMhdmaq/EtvnOq2ZdcIaZnqiAmzwpHt6O4YKA46exh3HvafLDIaHPDrGj2bRI0Roq3emYc='),
    _decrypt('6jc/XUAuGgsz+jNgOXTYFjBY5Fy0DI14zgmfmFZyc2aw8Et8nPewcMpFaZbnzRK4htC09fQHaRArYAgnCfCHJDAWU/H2UiaEFut4xs/mnII='),
  ];
  static String get answer => _decrypt('6TYuWpiO2hdmoz90JXTZHCUR81W9DNhM2U2CmwVyOSml7FFv0/D+cMwIe53xmluvycTmp+4EbAw6ehhuFfLLNjAGUPqlTiDUUIMKs+iR+vdOj8+QMutK6X6g9IaA9jfU');
}
