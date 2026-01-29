import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import 'index.dart';

class SaaiskuController extends GetxController {
  SaaiskuController();

  final state = SaaiskuState();

  final aiSkuList = <SASkModel>[].obs;

  Rx<SASkModel> selectedModel = SASkModel().obs;
  var isVideo = false;
  late ConsumeFrom from;

  /// 在 widget 内存中分配后立即调用。
  @override
  void onInit() {
    super.onInit();
    var arg = Get.arguments;
    if (arg != null && arg is ConsumeFrom) {
      from = arg;
    }
    isVideo = from == ConsumeFrom.img2v;
    SAlogEvent(isVideo ? 't_buyvideos' : 't_buyphotos');
    _loadData();

    ever(SAPayUtils().iapEvent, (event) async {
      if (event?.$1 == IAPEvent.goldSucc && event?.$2 != null) {
        await SA.login.fetchUserInfo();
        // Get.back(result: true);
      }
    });
  }

  Future<void> _loadData() async {
    SALoading.show();
    await SAPayUtils().query();

    var products = SAPayUtils().consumableList;

    if (!isVideo) {
      aiSkuList.assignAll(
        products.where((e) => e.createImg != null && e.createImg! > 0).toList(),
      );
    } else {
      aiSkuList.assignAll(
        products
            .where((e) => e.createVideo != null && e.createVideo! > 0)
            .toList(),
      );
    }

    selectedModel.value = aiSkuList.firstWhereOrNull(
      (e) => e.id == aiSkuList.last.id,
    )!;
    SALoading.close();
    update();
  }

  String photoText(int count) {
    if (count == 1) {
      return 'photo_one'.tr;
    } else {
      return 'photo_count'.trParams({'count': count.toString()});
    }
  }

  String videoText(int count) {
    if (count == 1) {
      return 'video_one'.tr;
    } else {
      return 'video_count'.trParams({'count': count.toString()});
    }
  }

  void buy() async {
    await SAPayUtils().buy(selectedModel.value, consFrom: from);
  }

  /// 在 onInit() 之后调用 1 帧。这是进入的理想场所
  @override
  void onReady() {
    super.onReady();
  }

  /// 在 [onDelete] 方法之前调用。
  @override
  void onClose() {
    super.onClose();
  }

  /// dispose 释放内存
  @override
  void dispose() {
    super.dispose();
  }
}
