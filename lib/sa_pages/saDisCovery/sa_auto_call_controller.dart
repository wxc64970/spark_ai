import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/saApplication/index.dart';

import '../../../main.dart';

class SAAutoCallController extends GetxController {
  // 主动来电
  final List<ChaterModel> _callList = [];
  ChaterModel? _callRole;
  int _callCount = 0;
  int _lastCallTime = 0;
  bool _calling = false;

  void onCall(List<ChaterModel>? list) async {
    try {
      if (list == null || list.isEmpty) return;
      _callList.assignAll(list);
      final role = list.where((element) => element.gender == 1 && element.renderStyle == 'REALISTIC').toList().randomOrNull;
      if (role == null) {
        return;
      }
      _callRole = role;
      callOut();
    } catch (e) {
      log.e(e.toString());
    }
  }

  Future callOut() async {
    try {
      if (_callRole == null) {
        return;
      }
      final roleId = _callRole?.id;
      if (roleId == null || roleId.isEmpty) {
        return;
      }

      String? url;
      if (_callRole!.videoChat == true) {
        SAlogEvent('t_ai_videocall');
        final guide = _callRole?.characterVideoChat?.firstWhereOrNull((e) => e.tag == 'guide');
        url = guide?.gifUrl;
      } else {
        SAlogEvent('t_ai_audiocall');
        url = _callRole?.avatar;
      }

      if (url == null || url.isEmpty) {
        return;
      }
      await Future.delayed(const Duration(seconds: 4));

      if (!canCall() || _calling) {
        return;
      }

      _calling = true;

      _lastCallTime = DateTime.now().millisecondsSinceEpoch;
      _callCount++;

      const sessionId = 0;

      RoutePages.pushPhone(sessionId: sessionId, role: _callRole!, showVideo: true, callState: CallState.incoming);

      final role = _callList.where((element) => element.gender == 1 && element.renderStyle == 'REALISTIC' && element.id != _callRole?.id).toList().randomOrNull;
      if (role == null) {
        return;
      }
      _callRole = role;
    } catch (e) {
      log.e(e.toString());
    } finally {
      _calling = false;
    }
  }

  bool canCall() {
    if (!SA.storage.isSAB) {
      log.d('-------->canCall: false isA');
      return false;
    }

    if (Get.find<SaapplicationController>().state.page != 0) {
      return false;
    }

    if (RoutePages.observer.curRoute?.settings.name != SARouteNames.application) {
      log.d('-------->canCall: false curRoute is not root');
      return false;
    }

    if (SA.login.vipStatus.value) {
      log.d('-------->canCall: false isVip');
      return false;
    }
    if (_callCount > 2) {
      log.d('-------->canCall:false  _callCount > 2');
      return false;
    }
    if (DialogWidget.checkExist(loginRewardTag)) {
      log.d('-------->canCall: false  loginRewardTag');
      return false;
    }
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch;
    if (_lastCallTime > 0 && currentTimestamp - _lastCallTime < 2 * 60 * 1000) {
      log.d('-------->canCall: 180s false');
      return false;
    }
    return true;
  }
}
