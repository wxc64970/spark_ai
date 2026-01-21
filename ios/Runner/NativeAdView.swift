import GoogleMobileAds
import UIKit

class MyNativeAdView: NativeAdView {
    
    // 广告视图尺寸常数
    private enum AdDimensions {
        static let mediaViewHeight: CGFloat = 120  // 媒体视图最小高度
        static let mediaViewMaxHeight: CGFloat = 500 // 媒体视图最大高度
        static let iconSize: CGFloat = 40  // 图标大小
        static let iconRadius: CGFloat = 4  // 图标圆角
        static let mediaRadius: CGFloat = 8  // 媒体视图圆角
        static let buttonHeight: CGFloat = 36  // CTA 按钮高度
        static let spacing: CGFloat = 8  // 间距
        static let padding: CGFloat = 12  // 边距
        static let labelCornerRadius: CGFloat = 4  // 标签圆角
    }
    
    private let mediaV: MediaView = {
        let view = MediaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = AdDimensions.mediaRadius
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = AdDimensions.iconRadius
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: AdDimensions.iconSize).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: AdDimensions.iconSize).isActive = true
        return imageView
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let adLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 100/255, green: 107/255, blue: 255/255, alpha: 1.0)
        label.numberOfLines = 1
        label.backgroundColor = UIColor(red: 100/255, green: 107/255, blue: 255/255, alpha: 0.1)
        label.paddingLeft = 4
        label.paddingRight = 4
        label.layer.cornerRadius = AdDimensions.labelCornerRadius
        label.clipsToBounds = true
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .darkGray
        label.numberOfLines = 2
        return label
    }()
    
    private let callToActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: AdDimensions.buttonHeight).isActive = true
        button.backgroundColor = UIColor(red: 66/255, green: 133/255, blue: 244/255, alpha: 1.0)
        button.layer.cornerRadius = AdDimensions.buttonHeight / 2
        return button
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    private let mainStack = UIStackView()
    private let iconHeadlineStack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        mainStack.axis = .vertical
        mainStack.spacing = AdDimensions.spacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        iconHeadlineStack.axis = .horizontal
        iconHeadlineStack.spacing = AdDimensions.spacing
        iconHeadlineStack.alignment = .center
        
        iconHeadlineStack.addArrangedSubview(iconImageView)
        
        let headlineStack = UIStackView(arrangedSubviews: [headlineLabel, adLabel])
        headlineStack.axis = .vertical
        headlineStack.spacing = 2
        iconHeadlineStack.addArrangedSubview(headlineStack)
        
        addSubview(mainStack)
        mainStack.addArrangedSubview(mediaV)
        mainStack.addArrangedSubview(iconHeadlineStack)
        mainStack.addArrangedSubview(bodyLabel)
        mainStack.addArrangedSubview(callToActionButton)
        
        // 设置媒体视图高度约束
        mediaV.heightAnchor.constraint(greaterThanOrEqualToConstant: AdDimensions.mediaViewHeight).isActive = true
        mediaV.heightAnchor.constraint(lessThanOrEqualToConstant: AdDimensions.mediaViewMaxHeight).isActive = true
        
        // 设置宽高比约束（16:9）
        mediaV.widthAnchor.constraint(equalTo: mediaV.heightAnchor, multiplier: 355/370).isActive = true
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: AdDimensions.padding),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AdDimensions.padding),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AdDimensions.padding),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AdDimensions.padding),
        ])
        
//        gradientLayer.colors = [
//            UIColor(red: 100/255, green: 107/255, blue: 255/255, alpha: 1.0).cgColor,
//            UIColor(red: 157/255, green: 100/255, blue: 255/255, alpha: 1.0).cgColor
//        ]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
//        gradientLayer.cornerRadius = 4
//        callToActionButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = callToActionButton.bounds
    }
    
    private func setupBindings() {
        // ✅ 绑定 GADNativeAdView 所需字段
        self.mediaView = mediaV
        self.iconView = iconImageView
        self.headlineView = headlineLabel
        self.bodyView = bodyLabel
        self.callToActionView = callToActionButton
        self.advertiserView = adLabel
    }
    
    func configure(with nativeAd: NativeAd) {
        self.nativeAd = nativeAd
        
        headlineLabel.text = nativeAd.headline
        bodyLabel.text = nativeAd.body
        callToActionButton.setTitle(nativeAd.callToAction, for: .normal)
        callToActionButton.isHidden = nativeAd.advertiser == nil
        
        // In order for the SDK to process touch events properly, user interaction should be disabled.
        callToActionButton.isUserInteractionEnabled = false

        if let icon = nativeAd.icon {
            iconImageView.image = icon.image
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
        
        if let advertiser = nativeAd.advertiser {
            adLabel.text = advertiser
            adLabel.isHidden = false
        } else {
            adLabel.isHidden = true
        }
        
        if nativeAd.mediaContent.hasVideoContent || nativeAd.mediaContent.mainImage != nil {
            mediaV.mediaContent = nativeAd.mediaContent
            mediaV.isHidden = false
        } else {
            mediaV.isHidden = true
        }
        
        setNeedsLayout()
        layoutIfNeeded()
    }
}

// MARK: - UILabel 扩展，支持 padding
extension UILabel {
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return objc_getAssociatedObject(self, "paddingLeftKey") as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, "paddingLeftKey", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBInspectable var paddingRight: CGFloat {
        get {
            return objc_getAssociatedObject(self, "paddingRightKey") as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, "paddingRightKey", newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func drawPaddedText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: paddingLeft, bottom: 0, right: paddingRight)
        self.drawText(in: rect.inset(by: insets))
    }
}
