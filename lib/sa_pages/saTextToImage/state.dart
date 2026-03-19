import 'package:get/get.dart';

class SatexttoimageState {
  final _styleName = "".obs;
  set styleName(value) => _styleName.value = value;
  get styleName => _styleName.value;

  final _styleImage = "".obs;
  set styleImage(value) => _styleImage.value = value;
  get styleImage => _styleImage.value;
  final _coins = "10".obs;
  set coins(value) => _coins.value = value;
  get coins => _coins.value;

  final imageRatioList = [
    {"value": "1:1", "name": "Square"},
    {"value": "9:16", "name": "IG store"},
    {"value": "9:19", "name": "Fullscreen"},
    {"value": "4:3", "name": "Social media"},
  ];
  final _selectImageRatio = "1:1".obs;
  set selectImageRatio(value) => _selectImageRatio.value = value;
  get selectImageRatio => _selectImageRatio.value;

  final _defaultDescription = ''.obs;
  set defaultDescription(value) => _defaultDescription.value = value;
  get defaultDescription => _defaultDescription.value;
  final _numberOfImages = 1.obs;
  set numberOfImages(value) => _numberOfImages.value = value;
  get numberOfImages => _numberOfImages.value;
}
