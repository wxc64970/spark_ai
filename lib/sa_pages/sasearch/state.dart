import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SasearchState {
  // 响应式状态
  final list = <ChaterModel>[].obs;
  final type = Rx<EmptyType?>(EmptyType.noSearch);
  final searchQuery = ''.obs;
  final _currentRequestId = 0.obs;
  set currentRequestId(value) => _currentRequestId.value = value;
  get currentRequestId => _currentRequestId.value;
  final _isLoading = false.obs;
  set isLoading(value) => _isLoading.value = value;
  get isLoading => _isLoading.value;
}
