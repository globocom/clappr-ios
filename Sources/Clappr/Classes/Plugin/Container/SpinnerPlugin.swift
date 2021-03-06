open class SpinnerPlugin: OverlayPlugin {

    fileprivate var spinningWheel: UIActivityIndicatorView!
    private let loadingStates: [PlaybackState] = [.none, .stalling]

    @objc var isAnimating: Bool {
        return spinningWheel.isAnimating
    }

    open class override var name: String {
        return "spinner"
    }

    public required init(context: UIObject) {
        super.init(context: context)
        spinningWheel = UIActivityIndicatorView(style: .whiteLarge)
        view.addSubview(spinningWheel)
        view.isUserInteractionEnabled = false
        view.accessibilityIdentifier = "SpinnerPlugin"
    }
    
    open override func bindEvents() {
        guard let core = core else { return }
        
        listenTo(core, event: .willShowModal) { [weak self] _ in self?.stopAnimating() }
        listenTo(core, event: .willHideModal) { [weak self] _ in self?.updateVisibility() }
    }

    open override func render() {
        view.addMatchingConstraints(spinningWheel)
        view.anchorInCenter()
    }

    override open func onDidChangePlayback() {
        updateVisibility()
        
        guard let playback = core?.activePlayback else { return }
        
        listenTo(playback, event: .playing) { [weak self] _ in self?.stopAnimating() }
        listenTo(playback, event: .stalling) { [weak self] _ in self?.startAnimating() }
        listenTo(playback, event: .willPlay) { [weak self] _ in self?.startAnimating() }
        listenTo(playback, event: .error) { [weak self] _ in self?.stopAnimating() }
        listenTo(playback, event: .didComplete) { [weak self] _ in self?.stopAnimating() }
        listenTo(playback, event: .didPause) { [weak self] _ in self?.stopAnimating() }
        listenTo(playback, event: .didStop) { [weak self] _ in self?.stopAnimating() }
    }
    
    private func updateVisibility() {
        let playbackState = core?.activePlayback?.state ?? .error
        
        if loadingStates.contains(playbackState) {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
    
    private func startAnimating() {
        view.isHidden = false
        spinningWheel.startAnimating()
        Logger.logDebug("started animating spinning wheel", scope: pluginName)
    }

    private func stopAnimating() {
        view.isHidden = true
        spinningWheel.stopAnimating()
        Logger.logDebug("stoped animating spinning wheel", scope: pluginName)
    }

    open override func destroy() {
        super.destroy()

        Logger.logDebug("destroying", scope: "SpinnerPlugin")
        Logger.logDebug("destroying ui elements", scope: "SpinnerPlugin")
        view.removeFromSuperview()
        Logger.logDebug("destroyed", scope: "SpinnerPlugin")
    }
}
