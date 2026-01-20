import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAMakStylesWidget extends StatelessWidget {
  const SAMakStylesWidget({super.key, required this.list, required this.onChooseed, this.selectedStyel});

  final List<SAImgStyle> list;
  final SAImgStyle? selectedStyel;
  final void Function(SAImgStyle data) onChooseed;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SATextData.ai_styles,
            style: TextStyle(color: Color(0xFF222222), fontSize: 28.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.w),
          SizedBox(
            width: 686.w,
            height: 152.w,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: list.length,
              itemBuilder: (_, index) {
                final item = list[index];
                final isSelected = item.style == selectedStyel?.style;
                return _buildItem(item, isSelected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(SAImgStyle item, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onChooseed(item);
      },
      child: SizedBox(
        width: 120.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84.w,
              height: 84.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: Colors.white,
                border: Border.all(width: 2.w, color: isSelected ? SAAppColors.pinkColor : const Color(0xFFFFFFFF)),
              ),
              child: Center(
                child: CachedNetworkImage(imageUrl: item.icon ?? '', width: 48.w, color: const Color(0xFF6D6C6E)),
              ),
            ),
            SizedBox(height: 8.w),
            SizedBox(
              height: 56.w,
              child: Text(
                item.name ?? '',
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: isSelected ? SAAppColors.pinkColor : const Color(0xFF666666), fontSize: 20.sp, fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400, height: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
