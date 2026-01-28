import Flutter
import UIKit
import FBSDKCoreKit
import AppTrackingTransparency
import CoreTelephony

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if let windowScene = scene as? UIWindowScene {
            self.window = UIWindow(windowScene: windowScene)
        }
        
        // Facebook 基础初始化已在AppDelegate中处理
        // ApplicationDelegate.shared.application(
        //     UIApplication.shared,
        //     didFinishLaunchingWithOptions: nil
        // )
        
        // Flutter 初始化
        let flutterViewController = FlutterViewController()
        self.window?.rootViewController = flutterViewController
        self.window?.makeKeyAndVisible()
        
        // Register plugins
        GeneratedPluginRegistrant.register(with: flutterViewController)
        
        // sim check channel
        let simChannel = FlutterMethodChannel(
            name: "sa_sim_check",
            binaryMessenger: flutterViewController.binaryMessenger
        )
        
        simChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "saHasSimCard" {
                result(self?.cjHasSim() ?? false)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        // Facebook channel
        let channel = FlutterMethodChannel(
            name: "sparkPlugin_face_channel",
            binaryMessenger: flutterViewController.binaryMessenger
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
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func cjHasSim() -> Bool {
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

