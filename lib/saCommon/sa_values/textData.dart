class SATextData {
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
  static String skuGetImage(String diamond) {
    return '{{icon}} High priority generation\n{{icon}} One-time gift of $diamond gems\n{{icon}} 4 Images per job\n{{icon}} Can generate N#FW image\n{{icon}}Text/Image-to-Image';
  }

  // 动态拼接文本
  static String skuGetVideo(String diamond) {
    return '{{icon}} High priority generation\n{{icon}} One-time gift of $diamond gems\n{{icon}} Can generate N#FW image';
  }

  // 动态拼接文本
  static String ageYearsOlds(String age) {
    return '$age years old';
  }

  static const String positiveReviewTitle = 'Do You Like Us?';

  // 动态拼接文本
  static String oneTimePurchaseNote(String price) {
    return 'Please note that a one-time purchase will result in a one-time charge of $price to you.';
  }

  // 动态拼接文本
  static String saveNum(String num) {
    return 'Save $num%';
  }

  static String get ai_upload_steps =>
      '1.Two steps: Upload a photo, then click generate.\n2.No support for photos of minors.\n3.Upload a front-facing photo.';
  static String get bestOffer => 'BEST OFFER';
  static String get editChooseMask =>
      'This chat already has a mask loaded.You can restart a chat to use another mask.After restarting, the history will lose.';
  static String get gifts => 'Gifts';
  static String get introTitle => 'Intro';
  static String get ai_prompt_examples_img => 'e.g: bikini,lingerie';
  static String get deleteMaskConfirmation =>
      'Deleting this mask will restore default chat settings. Confirm?';
  static String get ai_most_popular => 'Most Popular';
  static String get legal => 'Legal';
  static String get searchSirens => 'Type a Name to find Sirens';
  static String get seach => 'Search';

  static String get vipGet1 =>
      '{{icon}} Endless chatting\n{{icon}} Unlock all filters\n{{icon}} Advanced mode & long memory\n{{icon}} Ad-free';
  static String get tapToSeeMessages => '*****Tap to see the messages *****';
  static String get textMessageCallCost =>
      '1 text message: 2 diamond\\nCall AI characters: 10 diamond/min';
  static String get textMessageCost =>
      '1 text message: 2 diamond\\n1 audio message: 4 diamond\\nCall AI characters: 10 diamond/min';
  static String get moansForYou => 'Moans for you';
  static String get ageHint => 'Please input your age';
  static String get yes => 'Yes';
  static String get sendAGiftAndGetAPicture => 'Send a gift and get a picture';
  static String get otherInfoHint =>
      'Your relationship with the character or important events.';
  static String get violence => 'Violence';
  static String get ai_styles => 'Styles:';
  static String get ai_custom_prompt => 'Custom Prompt:';
  static String get microphonePermissionRequired =>
      'Microphone permission is required to make a call.';
  static String get profileMaskDescription =>
      'Create a mask profile to interact with the character better. Modifying the mask doesn\'t affect the loaded mask\'s effect.';
  static String get unlockRoleDescription =>
      'Become a premium to unlock hot roles and get unlimited chats.';

  static String get enticingPicture => 'Enticing picture';
  static String get chatted => 'Chatted';
  static String get all => 'All';
  static String get gotToPro => 'Go to Pro';
  static String get wait30Seconds =>
      'It may take up to 30 seconds.Please do not close or leave the app';
  static String get unlockRole => 'Unlock Hot Roles!';
  static String get chatList => 'Chat list';
  static String get waitForResponse => 'Please wait for the response';
  static String get hotVideo => 'Hot Video';
  static String get saraReceivedYourGift => 'Sara received your gift 🎁';
  static String get create => 'Create';
  static String get ai_bonus => 'Bonus';
  static String get networkError => 'Please check the network connection';
  static String get unselectAll => 'Unselect All';
  static String get levelUpIntimacy => 'Level up Intimacy';
  static String get yourNickname => 'Your nickname';
  static String get ai_language => 'AI‘s language is';
  static String get clickSaveToConfirm =>
      'Click the "Save" button to confirm that it takes effect';

  static String get noSubscriptionAvailable => 'No subscription available';
  static String get save => 'Save';
  static String get maxInputLength => 'Maximum input length: 500 characters';
  static String get feedback => 'Feedback';
  static String get unlockTextReply => 'Unlock Text Reply';
  static String get clearHistoryFailed => 'Clear history messages failed!';
  static String get reportSuccessful => 'Report successful';
  static String get unlock => 'Unlock';
  static String get listening => 'Listening...';
  static String get home => 'Home';
  static String get hotPhoto => 'Hot photo';
  static String get createOrderError => 'Create order error';
  static String get easterEggUnlock =>
      'Congrats on unlocking the Easter egg feature! You can now upload images to explore the undress function. Give it a shot!';
  static String get vipMember => 'VIP Member';
  static String get clothing => 'Clothing';
  static String get msgTips => 'Replies are generated by Al and fetional';
  static String get realistic => 'Realistic';
  static String get dislike => 'Not satisfied, needs improvement.';
  static String get ai_most_popular_new => 'Most Popular';
  static String get anime => 'Anime';
  static String get toCreate => 'To create';
  static String get yourAge => 'Your Age';
  static String get notEnough => 'Insufficient balance, please recharge';
  static String get personalDetails => 'Personal details';
  static String get message => 'message';
  static String get ai_photo_label => 'Photo';
  static String get subFeedback => 'Submit a feedback';
  static String get dailyReward => 'Daily reward';
  static String get weekly => 'Weekly';
  static String get ai_art_consumes_power =>
      'Great art consumes computational power and time. Every second you wait is transforming into pixels of wonder.';
  static String get upgradeTochat => 'Upgrade to chat';
  static String get ai_purchase_balance => 'Purchase Balance';
  static String get unlockNow => 'Unlock Now';
  static String get otherInfo => 'Other info';
  static String get lifetime => 'Lifetime';
  static String get clearHistoryConfirmation =>
      'Are you sure to clear all history messages?';
  static String get longReply => 'Long Reply: like story';
  static String get vipUpgrade => 'Upgrade to VIP';

  static String get aotoTrans => 'Enable automatic translation?';
  static String get resetChatBackground => 'Rest chat background';
  static String get ai_please_enter_custom_prompt =>
      'Please enter a custom prompt';
  static String get yourName => 'Your Name';
  static String get yourGender => 'Your Gender';
  static String get pleaseInput => 'Please enter content';
  static String get aiPhoto => 'AI Photo';
  static String get nice => 'Nice';
  static String get typeHere => 'Type here...';
  static String get notEnoughCoins => 'Not enough Coins, call ended.';
  static String get buyGemsOpenChats => 'Buy Gems to open chats.';
  static String get illegalDrugs => 'Illegal drugs';
  static String get report => 'Report';
  static String get chooseYourTags => 'Choose your tags';
  static String get expirationTime => 'Expiration time: ';
  static String get dressUp => 'Dress Up';
  static String get subscribe => 'Subscribe';
  static String get yearly => 'Yearly';
  static String get shortReply => 'Short Reply: like sms';
  static String get appVersion => 'App version';
  static String get setChatBackground => 'Custom Chat Background';
  static String get micPermission =>
      'Microphone permission is required to make a call.';
  static String get ai_generate_another => 'Generate another one';
  static String get male => 'Male';
  static String get btnContinue => 'Continue';
  static String get send => 'Send';
  static String get liked => 'Liked';
  static String get subscriptionAutoRenew =>
      'You will be charged immediately, then the same amount every month thereafter. Your subscription automatically renews unless canceled at least 24 hours before the end of the current period. You can manage your subscription and turn off auto-renewal in your account settings after purchase.';
  static String get selectProfileMask => 'Select Your Profile Mask';
  static String get uploadAPhoto => 'Upload a photo';
  static String get description => 'Description';
  static String get setting => 'Setting';
  static String get explore => 'Explore';
  static String get vipGet =>
      '{{icon}}😃 Endless chatting\n{{icon}}🥳 Unlock all filters\n{{icon}}💎 Advanced mode & long memory\n{{icon}}👏Ad-free';
  static String get backUpdatedSucc => 'Background updated successfully!';
  static String get upToVip => 'Upgrade to VIP';
  static String get ai_undress_sweetheart => 'Undress Your Sweetheart Now !!';
  static String get privacyPolicy => 'Privacy policy';
  static String get ai_photos => 'photos';
  static String get openSettings => 'Open settings';
  static String get termsOfUse => 'Terms of use';
  static String get intro => 'Intro';
  static String get deleteChat => 'Delete chat';

  static String get howToCallYou =>
      'How do you want your AI girlfriend to call you?';
  static String get SALoading => 'Loading';
  static String get ai_video_label => 'Video';
  static String get ai_prompt_examples_video =>
      'e.g: A woman takes off her clothes, exposing her breasts and nipples, naked, undressed, nude';
  static String get restore => 'Restore';
  static String get giveHerAMoment =>
      'Give her a moment to enjoy it and take a picture for you 📷';
  static String get bestChatExperience => 'Enjoy The Best Chat Experience';
  static String get selectAll => 'Select All';

  static String get buy => 'Buy';
  static String get fillRequiredInfo =>
      'Please fill in the required information';
  static String get notSupport => 'Not support';
  static String get spam => 'Spam';
  static String get collect => 'Collect';
  static String get tagsTitle => 'Tags';
  static String get info => 'Info';
  static String get female => 'Female';
  static String get reload => 'Reload';
  static String get descriptionHint =>
      'Like: What are your hobbies? islike: what is your dislike? What topics do you like to talk about?';
  static String get childAbuse => 'Child abuse';
  static String get speechRecognitionNotSupported =>
      'Speech recognition not supported on this device.';
  static String get toys => 'Toys';
  static String get ai_generation_failed =>
      'Generation failed.You can try again for free!';
  static String get confirm => 'Confirm';
  static String get ai_under_character => 'Under the character';
  static String get love => 'Great! I\'m loving it.';
  static String get like => 'Like';

  static String get diamond => 'Diamond';

  static String get scenarioRestartWarning =>
      'To active the new scenario,the chat wil be restart and the history will lose.';
  static String get popular => 'Popular';
  static String get monthly => 'Monthly';
  static String get useAvatar => 'Use Al characters\' cover';
  static String get inputYourNickname => 'Enter your nickname';
  static String get year => 'year';
  static String get nonBinary => 'Non-binary';
  static String get createMaskProfileDescription =>
      'Create a mask profile to interact with the character better';
  static String get createProfileMask => 'Create Your Profile Mask';
  static String get maskAlreadyLoaded =>
      'This chat already has a mask loaded. You can restart a chat to use another mask. After restarting, the history will lose.';
  static String get ai_generate => 'Generate';
  static String get everyDay => '/day';
  static String get video => 'Video';
  static String get close => 'Close';
  static String get activateBenefits => 'Activate Benefits';
  static String get copyright => 'Copyright';
  static String get day => 'day';
  static String get replyMode => 'Reply mode';
  static String get ai_view_nude => 'View the character\'s nude';
  static String get optionTitle => 'Option';
  static String get more => 'More';
  static String get ai_videos => 'videos';
  static String get ai_generating_masterpiece =>
      'Generating your digital masterpiece...';
  static String get deleteChatConfirmation =>
      'Are you sure to delete this chat?';
  static String get ai_make_photo_animated => 'Make your photo animated (NSFW)';
  static String get ai_generating => 'AI Generating...';
  static String get noNetwork => 'No network connection';
  static String get month => 'month';
  static String get freeChatUsed =>
      'You\'ve used up your free chat credits. To continue enjoying our service, please consider upgrading to our premium plan.';
  static String get pickIt => 'Pick it';
  static String get pleaseInputCustomText =>
      'Please input your custom text here...';
  static String get inputNickname => 'Input your nickname';
  static String get ai_balance => 'Balance:';
  static String get ai_max_input_length =>
      'Maximum input length: 500 characters';
  static String get nickname => 'Your nickname';
  static String get support => 'Support';
  static String get clearHistorySuccess => 'Clear history messages success!';
  static String get someErrorTryAgain =>
      'Hmm… we lost connection for a bit. Please try again!';
  static String get language => 'Al’s language';
  static String get iapNotSupport => 'IAP not supported';
  static String get maskApplied =>
      'The mask has been put on for you! Modifying the mask doesn\'t affect the loaded mask\'s effect.';
  static String get getAiInteractiveVideoChat =>
      'Get an AI interactive video chat experience';
  static String get waitingResponse => 'Waiting response…';

  static String get bestChoice => 'Best choice';
  static String get invitesYouToVideoCall => 'Invites you to video call…';
  static String get submit => 'Submit';
  static String get ai_generate_nude => 'Generate a nude';
  static String get ai_best_value => 'Best Value';
  static String get week => 'week';
  static String get scenario => 'Scenario';
  static String get ai_upload_steps_extra =>
      '1.Two steps: Upload a photo, then click generate.\n2.No support for photos of minors.\n3.Upload a front-facing photo.\n4.Does not support multiple people photos.';
  static String get edit => 'Edit';
  static String get ai_image_to_video => 'Image to Video';
  static String get nameHint => 'The name that you want bots to call you';
  static String get clearHistory => 'Clear history';
  static String get editScenario => 'Edit scenario';
  static String get tips => 'Tips';
  static String get accept => 'It\'s okay, could be better.';
  static String get restart => 'Restart';
  static String get chat => 'Chat';
  static String get autoTrans => 'Automatic Translation';
  static String get cancel => 'Cancel';
  static String get noData => 'No data';
  static String get openChatsUnlock =>
      'Open chats and Unlock Hot photo, Porn Video, Moans, Generate Images & Videos, Call Girls!';
  static String get ai_ai_photo => 'AI Photo';
  static String get undrMessage =>
      'Undress anyone anytime! Look what\'s under her clothes!';
  static String get tryNow => 'Try Now!';
  static String get Moments => 'Moments';
  static String get undress => 'Undress';
  static String get tease => 'Tease';
  static String get mask => 'Mask';
  static String get tryIt => 'Try It';
  static String get aiGenerateImage => 'AI generate image';
  static String get keyGeneration => 'Keyword Generation';
  static String get textToPicture => 'Text to Picture';
  static String get basics => 'Basics';
  static String get height => 'Height';
  static String get gender => 'Gender';
  static String get imageStyle => 'Image style';
  static String get nsfw => 'NSFW';
  static String get moreDetails => 'More details';
  static String get years => 'Years';
  static String get cm => 'Cm';
  static String get real => 'Real';
  static String get fantasy => 'Fantasy';
  static String get ns => 'Is it NSFW(Not safe for work)?';
  static String get ageMust => 'age must be between 18 and 999';
  static String get heightMust => 'height must be between 10 and 999';
  static String get age => 'Age';
  static String get createImage => 'Create Image';
  static String get describeImage => 'Describe your image';
  static String get creations => 'Creations';
  static String get including =>
      'Suggest including detailed visuals like facial features, age, posture, attire, and background.';
  static String get aiWrite => 'AI write';
  static String get failedGenerate =>
      'Failed to generate image. Please try again.';
  static String get errorGenerate => 'An error occurred. Please try again.';
  static String get loadingIdNull => 'id is null, please try again';
  static String get createMore => 'Create More';
  static String get imagePermission =>
      'Storage permission is required to save images';
  static String get imageSaved => 'Image saved';
  static String get downloadFailed => 'Failed to download image';
  static String get noImages => 'No Images';
  static String get noImagesText =>
      "Let's start creating~\nYour creations will be stored here.";
  static String get delete => "Delete";
  static String get selectItem => "Please select an item first.";
  static List<String> get inputTagsTest => [
    "What’s the most cherished intimate memory you’ve ever made with another person?",
    "How much hands-on experience do you have with romantic and physical relationships?",
    "Have you ever been in a relationship with someone who once dated your friend?",
    "Where did your first romantic and intimate encounter take place?",
    "If you could pick any location for an intensely romantic moment, where would you select?",
    "Is there a particular style or way of approaching physical intimacy that you favor?",
    "Would you be willing to explore new things when it comes to intimate experiences?",
    "Do you find a curvy physique or a sculpted, toned body more appealing?",
    "Can you create a romantic moment that someone will hold in their memory forever?",
    "What time of day or situation makes you long for a romantic connection the most?",
    "Would you be comfortable sharing something personal or private about yourself with me?",
    "Would you be interested in sending and receiving romantic or intimate photos?",
    "Could you share a picture of yourself with me?",
    "What’s the most profound romantic bond you’ve ever shared with someone?",
    "Have you ever had a romantic experience that felt completely enchanting or magical?",
    "Would you be open to exchanging personal photos from your romantic moments?",
    "Would you mind if I asked to see a picture of you?",
    "Have you ever had an intimate moment that altered your perspective on romance?",
    "What’s your typical way of showing intimacy in a romantic relationship?",
  ];
  static String get answer =>
      'Tips: You can use the "Undress" button to show your undressing style to your partner.';
}
