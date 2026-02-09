import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../../index.dart';
import 'build_discovery_list.dart';

class ASBodyWidget extends GetView<SadiscoveryController> {
  const ASBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => Get.toNamed(SARouteNames.search),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10.w, // 水平模糊度（对应 blur 10px）
                      sigmaY: 10.w, // 垂直模糊度（对应 blur 10px）
                    ),
                    // 关键2：实现 box-shadow + 背景半透（需嵌套 Container）
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 20.w,
                        horizontal: 27.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(46.r),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(
                              0x61c5e7b3,
                            ), // #c5e7b361 → 0x61(透明度) + c5e7b3(颜色)
                            offset: Offset(0, 8), // 0 8px（x=0，y=8）
                            blurRadius: 8, // 8px 模糊半径
                            spreadRadius: 0, // 0 扩散半径（对应 CSS 的第4个值）
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/sa_05.png",
                            width: 40.w,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(width: 16.w),
                          Text(
                            SATextData.seach,
                            style: TextStyle(
                              fontSize: 28.sp,
                              color: Color(0xffD9D9D9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (SA.storage.isSAB)
                Row(
                  children: [
                    SizedBox(width: 32.w),
                    InkWell(
                      onTap: () => controller.handleFilter(),
                      child: Image.asset(
                        "assets/images/sa_02.png",
                        width: 48.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 24.w),
          Expanded(child: BuildDiscoveryList()),
        ],
      ),
    );
  }
}
