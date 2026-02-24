import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spark_ai/main.dart';
import 'package:spark_ai/saCommon/index.dart';

class SaaigenerateloadingPage extends StatefulWidget {
  const SaaigenerateloadingPage({Key? key}) : super(key: key);

  @override
  State<SaaigenerateloadingPage> createState() =>
      _SaaigenerateloadingPageState();
}

class _SaaigenerateloadingPageState extends State<SaaigenerateloadingPage>
    with RouteAware {
  static const int _maxRetries = 40;
  static const Duration _retryInterval = Duration(seconds: 3);
  static const Duration _timeoutDuration = Duration(minutes: 2);

  double _progress = 0.0;
  Timer? _timeoutTimer;
  Timer? _progressTimer;
  GenAvatarResulut? _cachedResult;
  bool _hasResult = false;
  bool _isDisposed = false; // 页面是否已销毁的标志
  bool _isTimeoutHandled = false;
  int _currentStep = 0;
  int? genImgId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    RoutePages.observer.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _handleReturnFromVip();
  }

  @override
  void initState() {
    super.initState();

    _startGeneration();
  }

  @override
  void dispose() {
    // 设置页面已销毁标志，停止后台请求
    _isDisposed = true;

    _timeoutTimer?.cancel();
    _progressTimer?.cancel();
    RoutePages.observer.unsubscribe(this);
    super.dispose();
  }

  Future<void> _startGeneration() async {
    final id = Get.arguments;
    if (id == null) {
      log.d(SATextData.loadingIdNull);
      SAToast.show(SATextData.loadingIdNull);
      Get.back();
      return;
    }

    try {
      genImgId = id;
      _updateProgress(0.1);
      await _startRecursiveGeneration(id);
    } catch (e) {
      log.d('Generation start error: $e');
      _updateProgress(0.0);
    }
  }

  Future<void> _startRecursiveGeneration(dynamic id) async {
    try {
      _startProgressAnimation();
      _timeoutTimer = Timer(_timeoutDuration, () {
        log.d('Generation timeout');
        _handleGenerationTimeout();
      });

      await _checkGenerationResult(id);
    } catch (e) {
      log.d('Recursive generation error: $e');
      _updateProgress(0.0);
    }
  }

  Future<void> _checkGenerationResult(
    int generateId, {
    int retryCount = 0,
  }) async {
    // 检查页面是否已销毁
    if (_isDisposed) {
      log.d('Page disposed, stopping generation result check');
      return;
    }

    if (retryCount >= _maxRetries) {
      _timeoutTimer?.cancel();
      log.d('Generation timeout after $_maxRetries attempts');
      _handleGenerationTimeout();
      return;
    }

    try {
      log.d('Checking generation result, attempt: ${retryCount + 1}');

      final result = await ImageAPI.avatarAiGenerateResult(generateId);
      final imageList = result?.imageList;

      if (imageList != null && imageList.isNotEmpty) {
        // 再次检查页面是否已销毁，避免在已销毁的页面上更新状态
        if (_isDisposed) {
          log.d('Page disposed, skipping result handling');
          return;
        }

        _hasResult = true;
        _cachedResult = result;
        await _handleResultReceived();
      } else {
        log.d('Generation not ready, waiting for next check...');

        // 使用可中断的延时，每100ms检查一次页面状态
        final checkInterval = Duration(milliseconds: 100);
        final totalChecks =
            _retryInterval.inMilliseconds ~/ checkInterval.inMilliseconds;

        for (int i = 0; i < totalChecks && !_isDisposed; i++) {
          await Future.delayed(checkInterval);
        }

        // 检查页面是否已销毁
        if (_isDisposed) {
          log.d('Page disposed during delay, stopping generation result check');
          return;
        }

        await _checkGenerationResult(generateId, retryCount: retryCount + 1);
      }
    } catch (e) {
      log.d('Check generation result error (attempt ${retryCount + 1}): $e');

      // 即使出错也要检查页面状态
      if (!_isDisposed && retryCount < _maxRetries - 1) {
        // 使用可中断的延时
        final checkInterval = Duration(milliseconds: 100);
        final totalChecks =
            _retryInterval.inMilliseconds ~/ checkInterval.inMilliseconds;

        for (int i = 0; i < totalChecks && !_isDisposed; i++) {
          await Future.delayed(checkInterval);
        }

        if (!_isDisposed) {
          await _checkGenerationResult(generateId, retryCount: retryCount + 1);
        }
      }
    }
  }

  void _startProgressAnimation() {
    _updateProgress(0.1);
    _currentStep = 1;

    _progressTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      _currentStep++;

      // 前50步必须至少10秒 (50步 * 200ms = 10秒)
      // 后续步骤根据是否有结果调整速度
      double newProgress;
      if (_currentStep <= 50) {
        // 前50步：10秒内从10%增长到50% (每步增长0.8%)
        newProgress = 0.1 + (_currentStep * 0.008);
      } else {
        // 50步之后的处理
        if (_hasResult) {
          // 有结果时快速增长到70%
          newProgress = 0.5 + ((_currentStep - 50) * 0.004);
        } else {
          // 没有结果时缓慢增长，避免停滞
          // 从50%开始，每步增长0.1%，最多到65%
          double slowIncrement = (_currentStep - 50) * 0.001;
          newProgress = 0.5 + slowIncrement;
          newProgress = newProgress.clamp(0.5, 0.65); // 限制在50%-65%之间
        }
      }

      _updateProgress(newProgress.clamp(0.1, 0.7));

      // 到达70%时停止，等待结果处理
      if (_progress >= 0.7) {
        timer.cancel();
      }
    });
  }

  Future<void> _handleResultReceived() async {
    // 如果当前进度小于50%，等待到50%
    while (_progress < 0.5 && mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    // 等待进度到达70%
    while (_progress < 0.7 && mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    // 进度到达70%后，处理VIP逻辑
    final isVip = SA.login.vipStatus.value;

    if (isVip) {
      // VIP用户直接完成
      _updateProgress(0.95);
      await Future.delayed(const Duration(milliseconds: 500));
      await _handleGenerationComplete(_cachedResult!);
    } else {
      // 非VIP用户10秒延迟
      for (int i = 0; i < 100; i++) {
        if (!mounted) break;
        final progress = 0.7 + (0.25 * i / 100);
        _updateProgress(progress);
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (mounted) {
        await _handleGenerationComplete(_cachedResult!);
      }
    }
  }

  Future<void> _handleGenerationComplete(GenAvatarResulut result) async {
    _timeoutTimer?.cancel();
    _updateProgress(1.0);

    await Future.delayed(const Duration(milliseconds: 1000));

    log.d('Generation complete with result: $result progress: 1.0');

    if (Get.currentRoute == SARouteNames.aiGenerateLoading) {
      Get.offNamed(SARouteNames.aiGenerateResult, arguments: result);
    } else {
      _cachedResult = result;
    }
  }

  void _handleCachedResult() {
    if (_cachedResult != null &&
        Get.currentRoute == SARouteNames.aiGenerateLoading) {
      final result = _cachedResult!;
      _cachedResult = null;

      Get.offNamed(SARouteNames.aiGenerateResult, arguments: result);
    }
  }

  void _handleCachedResultSafely() {
    // 确保当前路由正确且没有其他路由操作在进行
    if (_cachedResult != null &&
        Get.currentRoute == SARouteNames.aiGenerateLoading &&
        !Get.isDialogOpen! &&
        !Get.isBottomSheetOpen!) {
      final result = _cachedResult!;
      _cachedResult = null;

      // 使用 WidgetsBinding.instance.addPostFrameCallback 确保在下一帧执行
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && Get.currentRoute == SARouteNames.aiGenerateLoading) {
          Get.offNamed(SARouteNames.aiGenerateResult, arguments: result);
        }
      });
    }
  }

  void _handleReturnFromVip() {
    // 延迟执行，确保页面返回动画完成
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      // 检查是否有缓存结果且当前进度状态
      if (_cachedResult != null) {
        if (_progress >= 0.7) {
          // 如果进度已经到70%以上，安全地处理结果
          _handleCachedResultSafely();
        } else {
          // 如果进度还没到70%，继续等待进度到达70%后再处理
          // 进度动画会自动处理，不需要额外操作
          log.d('Returned from VIP, waiting for progress to reach 70%');
        }
      } else {
        // 没有缓存结果，确保进度动画继续运行
        if (_progressTimer == null || !_progressTimer!.isActive) {
          log.d('Returned from VIP, restarting progress animation');
          _startProgressAnimation();
        }
      }
    });
  }

  void _updateProgress(double progress) {
    if (mounted) {
      setState(() {
        _progress = progress;
      });
    }
  }

  void _handleGenerationTimeout() {
    if (_isDisposed || _isTimeoutHandled) {
      return;
    }
    _isTimeoutHandled = true;
    _timeoutTimer?.cancel();
    _progressTimer?.cancel();
    SAToast.show(SATextData.loadingTimeoutWithCreditRefund);
    if (Get.currentRoute == SARouteNames.aiGenerateLoading) {
      Get.back();
    }
  }

  Future<void> _onGoPressed() async {
    SAlogEvent('imageloading_go_click');
    Get.toNamed(SARouteNames.vip, arguments: VipFrom.aiImagespeed);
    if (_cachedResult != null) {
      _handleCachedResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff262626),
      body: SafeArea(
        child: Stack(
          children: [
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: EdgeInsets.only(left: 32.w),
                child: Image.asset(
                  "assets/images/sa_21.png",
                  width: 48.w,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 32.w,
                  children: [
                    loadingIndicatorWidget(),
                    progressText(),
                    promotionCard(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingIndicatorWidget() {
    return SizedBox(
      width: 88.w,
      height: 88.w,
      child: LoadingAnimationWidget.hexagonDots(
        color: Colors.white,
        size: 88.w,
      ),
    );
  }

  Widget progressText() {
    return Text(
      '${(_progress * 100).toInt()}% Generating...',
      style: TextStyle(
        color: Colors.white,
        fontSize: 28.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget promotionCard() {
    return Obx(() {
      if (SA.login.vipStatus.value) {
        return SizedBox.shrink();
      }
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: SAAppColors.primaryColor.withValues(alpha: 0.1),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Pro uers will be prioritized~',
                style: TextStyle(
                  color: SAAppColors.primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ButtonGradientWidget(
              onTap: _onGoPressed,
              height: 64,
              width: 144.w,
              borderRadius: BorderRadius.circular(104.r),
              child: Center(
                child: Text(
                  'GO!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
