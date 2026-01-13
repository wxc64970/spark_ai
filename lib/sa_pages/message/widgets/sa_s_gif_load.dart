import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spark_ai/saCommon/index.dart';

class SASGifLoad extends StatelessWidget {
  const SASGifLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: const Color(0xFF00120A)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LoadingAnimationWidget.hexagonDots(color: Colors.white, size: 50),
            const SizedBox(height: 16),
            Text(
              SATextData.saraReceivedYourGift,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            Text(
              SATextData.giveHerAMoment,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: const Color(0x1AFFFFFF)),
            const SizedBox(height: 16),
            Text(
              SATextData.wait30Seconds,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
