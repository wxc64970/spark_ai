import 'package:get/get.dart';

class SaapplicationState {
  final _page = 1.obs;
  set page(value) => _page.value = value;
  get page => _page.value;
}
