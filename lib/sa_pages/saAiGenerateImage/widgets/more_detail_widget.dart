import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

import '../index.dart';
import 'base_container_widget.dart';
import 'sa_field_title.dart';

class MoreDetailWidget extends GetView<SaaigenerateimageController> {
  const MoreDetailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SaaigenerateimageController>(
      builder: (controller) {
        return BaseContainerWidget(
          child: [
            Text(
              SATextData.moreDetails,
              style: TextStyle(
                fontSize: 28.sp,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            // SizedBox(height: 24.w),
            ...controller.detailOptions.map((option) {
              final category = option.name ?? '';
              final tags = option.tags ?? [];
              final isRequired = option.required ?? false;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SaFieldTitle(
                    title: category,
                    isRequired: isRequired,
                    fontWeight: FontWeight.w500,
                  ),
                  SizedBox(height: 16.w),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // 计算每个选项的宽度：总宽度减去间距，除以3
                      final itemWidth =
                          (constraints.maxWidth - 14.w) / 3; // 16 = 2个间距 * 8

                      return Wrap(
                        spacing: 7.w,
                        runSpacing: 14.w,
                        children: tags.map((tag) {
                          final isSelected = tag.isSelected;
                          return GestureDetector(
                            onTap: () => controller.toggleDetailSelection(
                              category,
                              tag.id ?? '',
                            ),
                            child: Container(
                              width: itemWidth,
                              height: 88.w,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? SAAppColors.primaryColor.withValues(
                                        alpha: 0.3,
                                      )
                                    : const Color(0xFFF4F7F0),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  width: 2.w,
                                  color: isSelected
                                      ? SAAppColors.primaryColor
                                      : Color(0xFFF4F7F0),
                                ),
                              ),
                              child: Text(
                                tag.label ?? 'Unknown',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF000000)
                                      : const Color(0xFF4D4D4D),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }),
          ],
        );
      },
    );
  }
}
