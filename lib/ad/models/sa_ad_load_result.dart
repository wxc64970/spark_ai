import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdLoadResult {
  final Ad? ad;
  final LoadAdError? error;

  AdLoadResult({this.ad, this.error});
}
