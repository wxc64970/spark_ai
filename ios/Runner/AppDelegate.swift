import Flutter
import UIKit
import google_mobile_ads
import FBSDKCoreKit
import GoogleMobileAds
import CoreTelephony

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        // Register the native ad factory
        let nativeAdFactory = NativeAdFactory()
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "SAdiscoverNativeAd", nativeAdFactory: nativeAdFactory)

        // Facebook 基础初始化
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func applicationDidBecomeActive(_ application: UIApplication) {
        super.applicationDidBecomeActive(application)

        // 在应用激活时注册 channel，此时 window 已经初始化
        if let controller = window?.rootViewController as? FlutterViewController {
            setupSimCheckChannel(controller: controller)
        }
    }

    override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        return ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    private var simChannelSetup = false

    private func setupSimCheckChannel(controller: FlutterViewController) {
        // 确保只设置一次
        guard !simChannelSetup else { return }
        simChannelSetup = true

        let simChannel = FlutterMethodChannel(
            name: "sa_sim_check",
            binaryMessenger: controller.binaryMessenger
        )

        simChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "saHasSimCard" {
                result(self?.checkHasSimCard() ?? false)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func checkHasSimCard() -> Bool {
        let networkInfo = CTTelephonyNetworkInfo()

        // iOS 12+ 使用 serviceSubscriberCellularProviders
        if #available(iOS 12.0, *) {
            if let carriers = networkInfo.serviceSubscriberCellularProviders {
                // 检查是否有任何有效的运营商信息
                for (_, carrier) in carriers {
                    // 如果有运营商名称或 MCC/MNC，说明有 SIM 卡
                    if let carrierName = carrier.carrierName, !carrierName.isEmpty {
                        return true
                    }
                    if let mcc = carrier.mobileCountryCode, !mcc.isEmpty {
                        return true
                    }
                }
            }
        } else {
            // iOS 12 以下使用旧 API
            if let carrier = networkInfo.subscriberCellularProvider {
                if let carrierName = carrier.carrierName, !carrierName.isEmpty {
                    return true
                }
                if let mcc = carrier.mobileCountryCode, !mcc.isEmpty {
                    return true
                }
            }
        }

        return false
    }
}
