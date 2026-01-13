import 'package:get/get.dart';

class SaprofileState {
  final _isLoading = false.obs;
  get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;

  final _collect = false.obs;
  get collect => _collect.value;
  set collect(bool value) => _collect.value = value;
}
