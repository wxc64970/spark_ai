import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:spark_ai/sa_pages/index.dart';

class SALevelDialog extends StatefulWidget {
  const SALevelDialog({super.key});

  @override
  State<SALevelDialog> createState() => _SALevelDialogState();
}

class _SALevelDialogState extends State<SALevelDialog> {
  List<Map<String, dynamic>> datas = [];

  final ctr = Get.find<MessageController>();

  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {
    await ctr.loadChatLevel();
    setState(() {
      datas = ctr.state.chatLevelConfigs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            SizedBox(width: 55.w),
            InkWell(
              onTap: () {
                SmartDialog.dismiss();
              },
              child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
            ),
          ],
        ),
        SizedBox(height: 32.w),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 55.w),
          padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 40.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xffEBFFCC), Colors.white], stops: const [0.1, 0.3]),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                SATextData.levelUpIntimacy,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 40.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 32.w),
              ...[
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: datas.length,
                  itemBuilder: (context, index) {
                    return _buildItem(datas[index], index);
                  },
                  separatorBuilder: (context, index) => SizedBox(),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(Map<String, dynamic> data, int index) {
    return Container(
      margin: datas.length == index + 1 ? null : EdgeInsets.only(bottom: 16.w),
      padding: EdgeInsets.symmetric(vertical: 24.w, horizontal: 40.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24.r), color: Color(0xffF4F7F0)),
      child: Row(
        children: [
          Text(
            data['icon'],
            style: TextStyle(color: Colors.white, fontSize: 56.sp, fontWeight: FontWeight.w400),
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['text'],
                  style: TextStyle(color: Color(0xff000000), fontSize: 28.sp, fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 16.w),
                Row(
                  children: [
                    Image.asset('assets/images/sa_20.png', width: 40.w, fit: BoxFit.contain),
                    SizedBox(width: 8.w),
                    Text(
                      "+ ${data['gems']}",
                      style: TextStyle(fontFamily: "Montserrat", color: SAAppColors.pinkColor, fontSize: 32.sp, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
