extension UIView {
    @objc public func addSubviewMatchingConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        constrainSize(toSizeOf: view)
        view.layoutIfNeeded()
    }

    @objc func constrainSize(toSizeOf view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    @objc func center(in view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func bindFrameToSuperviewBounds(marginTop: Double = 0,
                                    marginRight: Double = 0,
                                    marginBottom: Double = 0,
                                    marginLeft: Double = 0,
                                    identifier: String? = nil) {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        let hConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(marginLeft)-[subview]-\(marginRight)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self])
        
        if let identifier = identifier {
            for constraint in hConstraints {
                constraint.identifier = "H:|-\(marginLeft)-\(identifier)-\(marginRight)-|"
            }
        }
        
        superview.addConstraints(hConstraints)
        
        let vConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-\(marginTop)-[subview]-\(marginBottom)-|", options: .directionLeadingToTrailing, metrics: nil, views: ["subview": self])
        
        if let identifier = identifier {
            for constraint in vConstraints {
                constraint.identifier = "V:|-\(marginTop)-\(identifier)-\(marginBottom)-|"
            }
        }
        
        superview.addConstraints(vConstraints)
    }
    
    func bindFrameToSuperviewBounds(with edges: UIEdgeInsets, identifier: String? = nil) {
        bindFrameToSuperviewBounds(
            marginTop: Double(edges.top),
            marginRight: Double(edges.right),
            marginBottom: Double(edges.bottom),
            marginLeft: Double(edges.left),
            identifier: identifier)
    }
    
    func setWidthAndHeight(with size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: size.width).isActive = true
        heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
    
    class func fromNib<T: UIView>() -> T {
        let nib = UINib(nibName: String(describing: T.self), bundle: Bundle(for: T.self))
        return (nib.instantiate(withOwner: nil, options: nil).last as? T)!
    }
    
    func addRoundedBorder(with radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func setVerticalPoint(to point: CGFloat, duration: TimeInterval = 0) {
        UIView.animate(withDuration: duration) {
            self.frame.origin.y = point
        }
    }
}
