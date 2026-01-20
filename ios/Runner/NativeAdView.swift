import GoogleMobileAds
import UIKit

class MyNativeAdView: NativeAdView {
    
    private let mediaV: MediaView = {
        let view = MediaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        return imageView
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let adLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 100/255, green: 107/255, blue: 255/255, alpha: 1.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    private let callToActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.clipsToBounds = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
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
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        iconHeadlineStack.axis = .horizontal
        iconHeadlineStack.spacing = 8
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
        
        // ✅ 设置 mediaView 最小高度 120pt，符合 AdMob 规范
        mediaV.heightAnchor.constraint(greaterThanOrEqualToConstant: 120).isActive = true
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
        
        gradientLayer.colors = [
            UIColor(red: 100/255, green: 107/255, blue: 255/255, alpha: 1.0).cgColor,
            UIColor(red: 157/255, green: 100/255, blue: 255/255, alpha: 1.0).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.cornerRadius = 4
        callToActionButton.layer.insertSublayer(gradientLayer, at: 0)
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
