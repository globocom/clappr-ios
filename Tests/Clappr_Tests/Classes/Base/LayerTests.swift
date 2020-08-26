import Quick
import Nimble
@testable import Clappr

class LayerTests: QuickSpec {
    override func spec() {
        describe(".Layer") {
            context("When a Layer is attached to a view") {
                it("resizes to match the view bounds") {
                    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
                    let superview = UIView(frame: frame)
                    let layer = TestLayer(frame: .zero)
                    
                    layer.attach(to: superview)
                    superview.layoutIfNeeded()
                    
                    expect(layer.center).to(equal(superview.center))
                    expect(layer.bounds.size).to(equal(superview.bounds.size))
                }
                context("and the view size changes") {
                    it("resizes to match the view bounds") {
                        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                        let biggerFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
                        let rootView = UIView(frame: frame)
                        let testLayer = TestLayer()
                        
                        testLayer.attach(to: rootView)
                        testLayer.layoutIfNeeded()
                        rootView.bounds = biggerFrame
                        rootView.layoutIfNeeded()
                        
                        expect(testLayer.bounds.size).to(equal(biggerFrame.size))
                    }
                }
            }
        }
    }
    
    class TestLayer: UIView, Layer {}
}
