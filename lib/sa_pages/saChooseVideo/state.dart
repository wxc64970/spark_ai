import 'package:get/get.dart';

class SachoosevideoState {
  // title
  final _isShowHelp = false.obs;
  set isShowHelp(value) => _isShowHelp.value = value;
  get isShowHelp => _isShowHelp.value;
}
