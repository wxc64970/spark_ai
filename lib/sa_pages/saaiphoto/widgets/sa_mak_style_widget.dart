import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/index.dart';

class SAMakStylesWidget extends StatelessWidget {
  const SAMakStylesWidget({
    super.key,
    required this.list,
    required this.onChooseed,
    this.selectedStyel,
  });

  final List<StyleConfigItem?> list;
  final StyleConfigItem? selectedStyel;
  final void Function(StyleConfigItem data) onChooseed;

  @override
  Widget build(BuildContext context) {
    if (list.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          SATextData.ai_styles,
          style: TextStyle(
            color: Color(0xFF222222),
            fontSize: 28.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8.w),
        SizedBox(
          // width: 686.w,
          height: 160.w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final item = list[index];
              final isSelected = item!.style == selectedStyel?.style;
              return _buildItem(item, isSelected);
            },
            separatorBuilder: (context, index) => SizedBox(width: 16.w),
            itemCount: list.length,
          ),
        ),
      ],
    );
  }

  Widget _buildItem(StyleConfigItem item, bool isSelected) {
    return GestureDetector(
      onTap: () {
        onChooseed(item);
      },
      child: Container(
        width: 120.w,
        height: 160.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(
            image: NetworkImage(item.url ?? ''),
            fit: BoxFit.cover,
          ),
          color: Colors.white,
          border: Border.all(
            width: 2.w,
            color: isSelected
                ? SAAppColors.primaryColor
                : const Color(0xFFFFFFFF),
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            isSelected
                ? Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: SAAppColors.primaryColor.withValues(alpha: 0.13),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            Positioned(
              bottom: 8.w,
              left: 0,
              width: 120.w,
              child: Center(
                child: Text(
                  item.name ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
