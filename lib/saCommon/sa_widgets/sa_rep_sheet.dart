import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

/// hello
class SAReportSheet extends StatelessWidget {
  const SAReportSheet({Key? key}) : super(key: key);

  Future<void> request() async {
    SALoading.show();
    await Future.delayed(const Duration(seconds: 1));
    SALoading.close();
    SAToast.show(SATextData.reportSuccessful);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Function> actsion = {
      SATextData.spam.tr: request,
      SATextData.violence.tr: request,
      SATextData.childAbuse.tr: request,
      SATextData.copyright.tr: request,
      SATextData.personalDetails.tr: request,
      SATextData.illegalDrugs.tr: request,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(width: 32.w),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Image.asset("assets/images/close.png", width: 48.w, fit: BoxFit.contain),
            ),
          ],
        ),
        SizedBox(height: 32.w),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/images/sa_10.png"), fit: BoxFit.fitWidth, alignment: AlignmentGeometry.topCenter),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(32.w), topRight: Radius.circular(32.w)),
            color: Colors.white,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 40.w, horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(actsion.keys.length, (index) {
                      final fn = actsion.values.toList()[index];
                      return GestureDetector(
                        onTap: () async {
                          await fn.call();
                          Get.back();
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 20.w),
                          padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 32.w),
                          decoration: BoxDecoration(color: const Color(0xffF4F7F0), borderRadius: BorderRadius.circular(52.r)),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    actsion.keys.toList()[index],
                                    style: TextStyle(color: const Color(0xFF222222), fontSize: 28.sp, fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: Get.mediaQuery.padding.bottom + 20.w),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
