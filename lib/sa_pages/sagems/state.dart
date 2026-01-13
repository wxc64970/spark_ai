import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SagemsState {
  final Rx<SASkModel> chooseProduct = SASkModel().obs;
  late ConsumeFrom from;
  RxList<SASkModel> list = <SASkModel>[].obs;
}
