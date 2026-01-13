import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:spark_ai/saCommon/index.dart';

class EmptyWidget extends StatelessWidget {
  // Constants
  static const double defaultPaddingTop = 100.0;
  static double defaultImageSize = 300.w;

  const EmptyWidget({super.key, required this.type, this.hintText, this.image, this.physics, this.size, this.loadingIconColor, this.onReload, this.paddingTop});

  final EmptyType type;

  /// Optional custom hint text to override the default text for the type
  final String? hintText;

  /// Optional custom image to override the default image for the type
  final Widget? image;

  /// Optional custom size for the container
  final Size? size;

  /// Optional scroll physics for the SingleChildScrollView
  final ScrollPhysics? physics;

  /// Optional color for the SALoading indicator
  final Color? loadingIconColor;

  /// Optional callback when the reload button is pressed
  final VoidCallback? onReload;

  /// Optional padding from the top of the container
  final double? paddingTop;

  /// Builds a reload button with consistent styling
  Widget _buildReloadButton() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onReload,
      child: Container(
        width: 81,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: SAAppColors.primaryColor),
        child: Text(
          SATextData.reload,
          style: TextStyle(fontSize: 28.sp, color: Color(0xffA5A5B9), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  /// Creates the content with appropriate dimensions
  Widget _createContent(double width, double height, List<Widget> widgets) {
    // Add extra space for tall screens
    if (type != EmptyType.SALoading && height / width > 1.3) {
      widgets.add(SizedBox(height: defaultImageSize));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      child: Container(
        width: width,
        height: height - kToolbarHeight,
        padding: EdgeInsets.only(top: paddingTop ?? defaultPaddingTop),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: widgets),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = [];

    if (type == EmptyType.SALoading) {
      // SALoading state - show activity indicator
      widgets.add(SALoading.activityIndicator());
    } else {
      // Empty or No Network state
      // Use custom image if provided, otherwise use default for the type
      widgets.add(image ?? type.image());
      widgets.add(SizedBox(height: 16.w));
      // Add hint text
      final String hint = type.text();
      widgets.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            hintText ?? hint,
            style: TextStyle(fontSize: 28.sp, color: Color(0xFFA5A5B9), fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      );

      // Add reload button for network error if callback is provided
      if (type == EmptyType.noNetwork && onReload != null) {
        widgets.add(SizedBox(height: 32.w));
        widgets.add(_buildReloadButton());
      }
    }

    // Use provided size or get screen dimensions
    final Size screenSize = size ?? Size(Get.width, Get.height);
    return _createContent(screenSize.width, screenSize.height, widgets);
  }
}

/// Represents different types of empty states that can be displayed
enum EmptyType { SALoading, noData, noNetwork, noSearch }

/// Extension methods for EmptyType to provide associated assets and text
extension EmptyTypeExt on EmptyType {
  /// Returns the appropriate image widget for this empty state type
  ///
  /// [width] and [height] can be customized (defaults to the default image size)
  Widget image({double? width, double? height}) {
    final double w = width ?? EmptyWidget.defaultImageSize;

    var name = 'assets/images/sa_no_data.png';
    switch (this) {
      case EmptyType.noData:
        name = 'assets/images/sa_no_data.png';
        break;
      case EmptyType.noNetwork:
        name = 'assets/images/sa_no_network.png';
        break;
      case EmptyType.noSearch:
        name = 'assets/images/sa_no_search.png';
        break;
      case EmptyType.SALoading:
        name = 'assets/images/sa_no_data.png';
        break;
    }
    return Image.asset(name, width: w, fit: BoxFit.contain);
  }

  /// Returns the localized text message for this empty state type
  String text() {
    switch (this) {
      case EmptyType.SALoading:
        return SATextData.SALoading;
      case EmptyType.noData:
        return SATextData.noData;
      case EmptyType.noNetwork:
        return SATextData.noNetwork;
      case EmptyType.noSearch:
        return SATextData.noData;
    }
  }
}
