import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:spark_ai/saCommon/index.dart';
import 'package:url_launcher/url_launcher.dart';

enum SAPolicyBottomType { gems, vip1, vip2 }

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({super.key, required this.type});

  final SAPolicyBottomType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SAPolicyBottomType.gems:
        return _buildGemsBottom();
      case SAPolicyBottomType.vip1:
        return _buildVipBottom(true);
      case SAPolicyBottomType.vip2:
        return _buildVipBottom(false);
    }
  }

  // 提取公共逻辑，减少重复
  Widget _buildVipBottom(bool showSubscriptionText) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(SATextData.privacyPolicy, () => launchUrl(Uri.parse(EnvConfig.privacy))),
            _buildSeparator(),
            _buildButton(SATextData.termsOfUse, () => launchUrl(Uri.parse(EnvConfig.terms))),
          ],
        ),
        if (showSubscriptionText) ...[
          SizedBox(height: 24.w),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 48.w),
            child: Text(
              SATextData.subscriptionAutoRenew,
              style: TextStyle(color: Color(0xffFFFFFF).withValues(alpha: 0.5), fontSize: 20.sp, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGemsBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton(SATextData.termsOfUse, () => launchUrl(Uri.parse(EnvConfig.terms))),
        SizedBox(width: 16.w),
        _buildSeparator(),
        SizedBox(width: 16.w),
        _buildButton(SATextData.privacyPolicy, () => launchUrl(Uri.parse(EnvConfig.privacy))),
      ],
    );
  }

  // 提取分隔符部分
  Widget _buildSeparator() {
    return Container(width: 1, height: 12, margin: const EdgeInsets.symmetric(horizontal: 8), color: const Color(0xFFCCCCCC));
  }

  Widget _buildButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24.sp,
          color: Color(0xffFFFFFF).withValues(alpha: 0.7),
          fontWeight: FontWeight.w400,
          decoration: TextDecoration.underline,
          decorationColor: Color(0xFFA5A5B9),
          decorationThickness: 1.0,
        ),
      ),
    );
  }
}
