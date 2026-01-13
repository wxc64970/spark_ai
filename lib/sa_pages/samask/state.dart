import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SamaskState {
  final RxList<SAMaskModel> maskList = <SAMaskModel>[].obs;
  final Rx<SAMaskModel?> selectedMask = Rx<SAMaskModel?>(null);
  final RxBool hasMore = true.obs;
  final RxInt currentPage = 1.obs;
  final RxBool isLoading = false.obs;
  final Rx<EmptyType?> emptyType = Rx<EmptyType?>(null);
}
