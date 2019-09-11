class BottomDrawerPlugin: DrawerPlugin {

    open class override var name: String {
        return "BottomDrawerPlugin"
    }

    override var position: DrawerPlugin.Position {
        return .bottom
    }

    override var size: CGSize {
        return CGSize(width: coreViewBounds.width, height: coreViewBounds.height/2)
    }

    private var coreViewBounds: CGRect {
        guard let core = core else { return .zero }
        return core.view.bounds
    }

    override func render() {
        moveDown()
    }

    override func bindEvents() {
        guard let core = core else { return }
        
        listenTo(core, event: .showDrawerPlugin) { [weak self] _ in
            self?.moveUp()
        }
    }

    private func moveUp() {
        setVerticalPoint(to: size.height)
    }

    private func moveDown() {
        setVerticalPoint(to: coreViewBounds.height)
    }

    private func setVerticalPoint(to point: CGFloat) {
        view.bounds.origin.y = point
    }
}
