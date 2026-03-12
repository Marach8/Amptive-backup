class Constants {
  Constants._();

  static const int kTimerLimit = 10;
  static const int kMaxNumberCommunities = 5;
  static const List<String> kCountryList = <String>[
    'AR',
    'DE',
    'GB',
    'NG',
    'CN'
  ];
  static final String kDefaultCountrySelected = kCountryList[3];

  // create show
  static const int kMaxTitleCharacters = 140;
  static const int kMaxDescriptionCharacters = 4000;
}
