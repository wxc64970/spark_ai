import Flutter
import UIKit
import google_mobile_ads
import FBSDKCoreKit
import AppTrackingTransparency
import CoreTelephony

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // 注意：使用 FlutterImplicitEngineDelegate 时，插件注册在 didInitializeImplicitFlutterEngine 中
        // 不要在这里调用 GeneratedPluginRegistrant.register，否则会导致重复注册

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
    
    
    // Flutter UIScene 隐式引擎初始化
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        // Register plugins with `engineBridge.pluginRegistry`
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        
        // Create method channels with `engineBridge.applicationRegistrar.messenger()`
        let channel = FlutterMethodChannel(
            name: "sparkPlugin_face_channel",
            binaryMessenger: engineBridge.applicationRegistrar.messenger()
        )
        
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
            
            switch call.method {
                
            case "initSparkFaceSDK":
                guard
                    let args = call.arguments as? [String: Any],
                    let appId = args["appId"] as? String,
                    let clientToken = args["clientToken"] as? String
                else {
                    result(
                        FlutterError(
                            code: "INVALID_ARGUMENTS",
                            message: "Missing appId or clientToken",
                            details: nil
                        )
                    )
                    return
                }
                
                // Facebook SDK 配置
                Settings.shared.appID = appId
                Settings.shared.clientToken = clientToken
                Settings.shared.loggingBehaviors = [
                    .appEvents, .networkRequests, .developerErrors, .informational
                ]
                
                if #available(iOS 14, *) {
                    switch ATTrackingManager.trackingAuthorizationStatus {
                    case .authorized:
                        Settings.shared.isAdvertiserTrackingEnabled = true
                    case .notDetermined:
                        break
                    default:
                        Settings.shared.isAdvertiserTrackingEnabled = false
                    }
                }
                
                AppEvents.shared.logEvent(.init("spark_ai_ios_log_event"))
                AppEvents.shared.activateApp()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    AppEvents.shared.flush()
                }
                
                result("Facebook SDK initialized successfully")
                
            case "isinitSparkFaceSDK":
                let ok = Settings.shared.appID != nil && !(Settings.shared.appID!.isEmpty)
                result(ok)
                
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        
        // sim check
        let simChannel = FlutterMethodChannel(
            name: "sa_sim_check",
            binaryMessenger: engineBridge.applicationRegistrar.messenger()
        )
        
        simChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }
            if call.method == "saHasSimCard" {
                result(self.hasSim())
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
    }
    
    private func hasSim() -> Bool {
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
}

