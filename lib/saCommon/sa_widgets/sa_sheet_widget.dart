import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';

class SASheetBottom {
  static void show(ConsumeFrom from) {
    SAlogEvent('buycoin_show');
    Get.bottomSheet(SAStarSkuWidget(from: from), isScrollControlled: true);
  }
}

class SAStarSkuWidget extends StatefulWidget {
  const SAStarSkuWidget({super.key, required this.from});
  final ConsumeFrom from;

  @override
  State<SAStarSkuWidget> createState() => _SAStarSkuWidgetState();
}

class _SAStarSkuWidgetState extends State<SAStarSkuWidget> {
  List<SASkModel> list = [];
  // SASkModel? _chooseProduct;

  @override
  void initState() {
    super.initState();
    _loadData();
    ever(SAPayUtils().iapEvent, (event) async {
      log.d('[udr] iap event: $event,');
      if (!mounted) return;

      if (event?.$1 == IAPEvent.goldSucc && event?.$2 != null) {
        // switch (from) {
        //   case ConsumeFrom.undr:
        //     logEvent('suc_payundr');
        //     logEvent('suc_payundr_${event?.$2}');
        //     break;
        //   case ConsumeFrom.aiphoto:
        //     logEvent('suc_aiphoto');
        //     logEvent('suc_aiphoto_${event?.$2}');
        //     break;
        //   case ConsumeFrom.img2v:
        //     logEvent('suc_img2v');
        //     logEvent('suc_img2v_${event?.$2}');
        //     break;
        //   default:
        // }
        Get.back(result: true);
      }
    });
  }

  void buy(SASkModel selectedModel) async {
    SAlogEvent(
      'buycoin_sku_click',
      parameters: {'sku': selectedModel.productDetails?.price ?? '--'},
    );
    await SAPayUtils().buy(selectedModel, consFrom: widget.from);
  }

  Future<void> _loadData() async {
    SALoading.show();
    await SAPayUtils().query();
    setState(() {});
    var products = SAPayUtils().consumableList;

    list.assignAll(
      products.where((e) => e.star != null && e.star! > 0).toList(),
    );
    list.sort((a, b) => (a.star ?? 0).compareTo(b.star ?? 0));
    SALoading.close();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Image.asset(
                "assets/images/close.png",
                width: 48.w,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        SizedBox(height: 32.w),
        Container(
          width: Get.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/sa_10.png"),
              fit: BoxFit.fitWidth,
              alignment: AlignmentGeometry.topCenter,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.w),
              topRight: Radius.circular(32.w),
            ),
            color: Colors.white,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 48.w, horizontal: 32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  SATextData.included,
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16.w),
                SARichTextPlaceholder(
                  textKey: SATextData.skuStar,
                  placeholders: {
                    'icon': WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Image.asset(
                        'assets/images/sa_47.png',
                        width: 32.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  },
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Color(0xff808080),
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 32.w),
                SizedBox(height: 540.w, child: _buildSkus()),
                Text(
                  SATextData.buyingCoins,
                  style: TextStyle(fontSize: 20.sp, color: Color(0xff808080)),
                ),
                SizedBox(height: Get.mediaQuery.padding.bottom),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkus() {
    if (list.isEmpty) {
      return Center(
        child: SizedBox(
          height: 100,
          child: Text(
            SATextData.noProductsAvailable,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF808080)),
          ),
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (_, index) {
        final item = list[index];
        String price = item.productDetails?.price ?? '--';

        // var rawPrice = item.productDetails?.rawPrice ?? 0;
        double truncated1 =
            ((list[1].star! - ((list[0].star ?? 0) * 3)) /
                ((list[0].star ?? 0) * 3)) *
            100;
        double truncated2 =
            ((list[2].star! - ((list[0].star ?? 0) * 7)) /
                ((list[0].star ?? 0) * 7)) *
            100;
        String twoTagPrice = '${truncated1.toStringAsFixed(0)}%';
        String threeTagPrice = '${(truncated2.toStringAsFixed(0))}%';
        var star = item.star ?? 0;

        return Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 43.w, vertical: 32.w),
              decoration: BoxDecoration(
                color: Color(0xffF7F7F7),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: InkWell(
                splashColor: Colors.white.withAlpha(30),
                borderRadius: BorderRadius.circular(24.r),
                onTap: () {
                  // _chooseProduct = item;
                  buy(item);
                  setState(() {});
                },
                child: Stack(
                  children: [
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                price,
                                style: TextStyle(
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 6.w,
                            children: [
                              Row(
                                spacing: 10.w,
                                children: [
                                  Text(
                                    star.toString(),
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 40.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  Image.asset(
                                    "assets/images/sa_89.png",
                                    width: 32.w,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                              index != 0
                                  ? Row(
                                      spacing: 10.w,
                                      children: [
                                        Text(
                                          ((list[0].star ?? 0) *
                                                  (index == 1 ? 3 : 7))
                                              .toString(),
                                          style: TextStyle(
                                            fontFamily: "Montserrat",
                                            fontSize: 28.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xff666666),
                                            fontStyle: FontStyle.italic,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                        Image.asset(
                                          "assets/images/sa_89.png",
                                          width: 32.w,
                                          fit: BoxFit.contain,
                                        ),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // if (tags != null) ...tags,
                  ],
                ),
              ),
            ),
            if (index != 0) _buildTag(index == 1 ? twoTagPrice : threeTagPrice),
            // if (most) _buildTag(LocaleKeys.most_popular.tr),
          ],
        );
      },
      separatorBuilder: (_, idx) => const SizedBox(height: 16),
      itemCount: list.length,
    );
  }

  Widget _buildTag(String tag) {
    return Positioned(
      left: 0,
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(24.w),
              bottomEnd: Radius.circular(24.w),
            ),
            // gradient: const LinearGradient(
            //   colors: [Color(0xFFD764FF), Color(0xFF9264FF)],
            // ),
            color: Colors.black,
          ),
          child: Row(
            spacing: 8.w,
            children: [
              Text(
                tag,
                style: TextStyle(
                  color: SAAppColors.yellowColor,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Image.asset(
                "assets/images/sa_89.png",
                width: 32.w,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
