import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class SaaigenerateresultState {
  // title
  final _selectedIndex = 0.obs;
  set selectedIndex(value) => _selectedIndex.value = value;
  get selectedIndex => _selectedIndex.value;

  late GenAvatarResulut? reslut;

  List<String> imageUrls = [];
}
