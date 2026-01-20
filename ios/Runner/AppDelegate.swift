import Flutter
import UIKit
import google_mobile_ads
import FBSDKCoreKit
import GoogleMobileAds

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
            self, factoryId: "discoverNativeAd", nativeAdFactory: nativeAdFactory)

        // Facebook 基础初始化
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    // 移除 didInitializeImplicitFlutterEngine，因为现在使用 SceneDelegate

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
