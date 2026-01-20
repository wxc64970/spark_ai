import Foundation
import google_mobile_ads

class NativeAdFactory: NSObject, FLTNativeAdFactory {
    func createNativeAd(_ nativeAd: NativeAd, customOptions: [AnyHashable : Any]? = nil) -> NativeAdView? {
        let nativeAdView = MyNativeAdView()
        nativeAdView.configure(with: nativeAd)
        return nativeAdView
    }
    
}
