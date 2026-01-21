import GoogleMobileAds
import UIKit

class MyNativeAdView: NativeAdView {
    
    // 广告视图尺寸常数
    private enum AdDimensions {
        static let mediaViewMinHeight: CGFloat = 120  // 媒体视图最小高度
        static let mediaViewMaxHeight: CGFloat = 200 // 媒体视图最大高度
        static let iconSize: CGFloat = 40  // 图标大小
        static let iconRadius: CGFloat = 4  // 图标圆角
        static let mediaRadius: CGFloat = 8  // 媒体视图圆角
        static let buttonHeight: CGFloat = 36  // CTA 按钮高度
        static let buttonMinWidth: CGFloat = 80 // 按钮最小宽度（完整定义，解决编译错误）
        static let spacing: CGFloat = 4  // 间距
        static let padding: CGFloat = 8  // 边距
        static let labelCornerRadius: CGFloat = 4  // 标签圆角
        static let adViewMaxWidth: CGFloat = 355 // 广告视图最大宽度（新增，适配手机屏幕）
    }
    
    private let mediaV: MediaView = {
        let view = MediaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = AdDimensions.mediaRadius
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        // 新增：媒体视图宽度绑定到父视图（mainStack），避免宽度溢出
        view.widthAnchor.constraint(lessThanOrEqualToConstant: AdDimensions.adViewMaxWidth - 2*AdDimensions.padding).isActive = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = AdDimensions.iconRadius
        imageView.clipsToBounds = true
//        imageView.widthAnchor.constraint(equalToConstant: AdDimensions.iconSize).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: AdDimensions.iconSize).isActive = true
        NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalToConstant: AdDimensions.iconSize),
                    imageView.heightAnchor.constraint(equalToConstant: AdDimensions.iconSize)
                ])
        return imageView
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // 新增：禁用自动约束
        label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail // 新增：文本溢出时截断
        return label
    }()
    
    private let adLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // 新增：禁用自动约束
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 100/255, green: 107/255, blue: 255/255, alpha: 1.0)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail // 新增：文本截断
        label.backgroundColor = UIColor(red: 100/255, green: 107/255, blue: 255/255, alpha: 0.1)
        label.paddingLeft = 4
        label.paddingRight = 4
        label.layer.cornerRadius = AdDimensions.labelCornerRadius
        label.clipsToBounds = true
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false // 新增：禁用自动约束
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail // 新增：文本截断
        return label
    }()
    
    private let callToActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false // 新增：禁用自动约束
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: AdDimensions.buttonHeight).isActive = true
        button.backgroundColor = UIColor(red: 66/255, green: 133/255, blue: 244/255, alpha: 1.0)
        button.layer.cornerRadius = AdDimensions.buttonHeight / 2
        // 新增：按钮尺寸约束（最小宽度+固定高度），避免溢出
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: AdDimensions.buttonHeight),
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: AdDimensions.buttonMinWidth),
            button.widthAnchor.constraint(lessThanOrEqualToConstant: AdDimensions.adViewMaxWidth - 2*AdDimensions.padding)
                ])
        return button
    }()
    
    private let gradientLayer = CAGradientLayer()
    
    private let mainStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = AdDimensions.spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .fill // 新增：子视图填充stack宽度
        stack.distribution = .fillProportionally
        return stack
    }()
    private let iconHeadlineStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = AdDimensions.spacing
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill // 新增：填充宽度
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.widthAnchor.constraint(lessThanOrEqualToConstant: AdDimensions.adViewMaxWidth).isActive = true
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
        mediaV.heightAnchor.constraint(greaterThanOrEqualToConstant: AdDimensions.mediaViewMinHeight).isActive = true
        mediaV.heightAnchor.constraint(lessThanOrEqualToConstant: AdDimensions.mediaViewMaxHeight).isActive = true
        
        // 设置宽高比约束
        mediaV.widthAnchor.constraint(equalTo: mediaV.heightAnchor, multiplier: 355/370).isActive = true
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: AdDimensions.padding),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AdDimensions.padding),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AdDimensions.padding),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AdDimensions.padding),
            // 修正：媒体视图高度约束（原范围过大，新增宽高比为16:9，适配广告素材）
            mediaV.heightAnchor.constraint(greaterThanOrEqualToConstant: AdDimensions.mediaViewMinHeight),
            mediaV.heightAnchor.constraint(lessThanOrEqualToConstant: AdDimensions.mediaViewMaxHeight),
            mediaV.widthAnchor.constraint(equalTo: mediaV.heightAnchor, multiplier: 16/9), // 16:9是广告素材标准比例
                        
            // 新增：iconHeadlineStack/bodyLabel宽度绑定到mainStack，避免溢出
            iconHeadlineStack.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
            bodyLabel.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
                        
            // 新增：按钮居中，避免偏左/偏右溢出
            callToActionButton.centerXAnchor.constraint(equalTo: mainStack.centerXAnchor)
            
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
        // 新增：强制刷新布局，避免约束延迟生效
        self.setNeedsUpdateConstraints()
        self.updateConstraintsIfNeeded()
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
//        callToActionButton.isHidden = nativeAd.advertiser == nil
        // 修正：按钮隐藏逻辑（原逻辑反了）
        callToActionButton.isHidden = nativeAd.callToAction == nil
        iconImageView.isHidden = nativeAd.icon == nil
        adLabel.isHidden = nativeAd.advertiser == nil
        
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
        
        // 强制布局更新，确保素材渲染在视图内
        self.setNeedsLayout()
        self.layoutIfNeeded()
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
