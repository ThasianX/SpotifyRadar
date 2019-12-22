// Credits: https://github.com/spotify/SpotifyLogin/blob/master/Sources/SpotifyLoginButton.swift

import UIKit

class SpotifyLoginButton: UIButton {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        applyLayout()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyLayout()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    func applyLayout() {
        backgroundColor = UIColor.spt_green()
        setTitleColor(.white, for: .normal)
        tintColor = .white
        titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 0.0)
        imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 8.0)
        adjustsImageWhenHighlighted = false
        setImage(UIImage(named: "spotifylogo.png")!
            .withRenderingMode(.alwaysTemplate), for: .normal)
        setTitle("SIGN IN WITH SPOTIFY", for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        frame.size = intrinsicContentSize
    }

    override public var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.spt_darkGreen() : UIColor.spt_green()
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 260.0, height: 55.0)
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height/2
    }

}

internal extension UIColor {

    class func spt_green() -> UIColor {
        return UIColor(red: 29.0/255.0, green: 185.0/255.0, blue: 84.0/255.0, alpha: 1.0)
    }

    class func spt_darkGreen() -> UIColor {
        return UIColor(red: 29.0/255.0, green: 167.0/255.0, blue: 77.0/255.0, alpha: 1.0)
    }

}
