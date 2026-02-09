import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SaaigenerateimageState {
  //age
  final _age = "".obs;
  set age(value) => _age.value = value;
  get age => _age.value;
  final Rx<Gender?> selectedGender = Rx<Gender?>(Gender.female);
  final _imageStyleTabs = "".obs;
  set imageStyleTabs(value) => _imageStyleTabs.value = value;
  get imageStyleTabs => _imageStyleTabs.value;
  //NSFW
  final _nsfw = true.obs;
  set nsfw(value) => _nsfw.value = value;
  get nsfw => _nsfw.value;
  //是否可点击
  final _isClick = false.obs;
  set isClick(value) => _isClick.value = value;
  get isClick => _isClick.value;
}
