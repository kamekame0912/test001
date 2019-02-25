import UIKit

class ViewController: UIViewController {
    
    var line01:CAShapeLayer!
    var selectLayer:CALayer!,touchLastPoint:CGPoint!
    
    var oval11:CAShapeLayer!,oval12:CAShapeLayer!
    var handleMargin:CGFloat! = 5,handleWidth:CGFloat! = 30
    
    var lineHandleState:Int! = 0
    var lineState:Int! = 1
    
    var commitLayer:CAShapeLayer! = CAShapeLayer()
    
    var btnAddLine:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellow
        
        line01 = CAShapeLayer()
        line01.frame = CGRect(x: 50, y: 200, width: 100, height: 100)
        line01.strokeColor = UIColor.blue.cgColor
        let line02 = UIBezierPath()
        line02.move(to: CGPoint(x: 0, y: 0))
        line02.addLine(to: CGPoint(x: line01.frame.width, y: line01.frame.height))
        line01.path = line02.cgPath
        self.view.layer.addSublayer(line01)

        
    }
    func hitLayer(touch:UITouch) -> CALayer{
        var touchPoint = touch.location(in: self.view)
        touchPoint = self.view.layer.convert(touchPoint, to: self.view.layer.superlayer)
        return self.view.layer.hitTest(touchPoint)!
    }
    func selectLayerFunc(layer:CALayer?){
        if(layer == self.view.layer) || (layer == nil){
            selectLayer = nil
        }
        selectLayer = layer
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        selectLayer = nil
        let touch:UITouch = touches.first!
        let layer:CALayer = hitLayer(touch: touch)
        let touchPoint:CGPoint = touch.location(in: self.view)
        touchLastPoint = touchPoint
        self.selectLayerFunc(layer: layer)
        switch lineHandleState {
        case 0:
            switch selectLayer {
            case self.view.layer:
                lineHandleState = 0
            case line01:
                commitLayer = (selectLayer as! CAShapeLayer)
                oval11 = CAShapeLayer()
                
                oval11.strokeColor = UIColor.blue.cgColor
                oval11.fillColor = UIColor.clear.cgColor
                oval11.path = UIBezierPath(ovalIn: CGRect(x: handleMargin, y: handleMargin, width: handleWidth - handleMargin * 2, height: handleWidth - handleMargin * 2)).cgPath
                self.view.layer.addSublayer(oval11)
                
                oval12 = CAShapeLayer()
                
                oval12.strokeColor = UIColor.blue.cgColor
                oval12.fillColor = UIColor.clear.cgColor
                oval12.path = UIBezierPath(ovalIn: CGRect(x: handleMargin, y: handleMargin, width: handleWidth - handleMargin * 2, height: handleWidth - handleMargin * 2)).cgPath
                self.view.layer.addSublayer(oval12)
                switch lineState{
                case 1:
                    oval11.frame = CGRect(x: selectLayer.frame.origin.x - handleWidth / 2, y: selectLayer.frame.origin.y - handleWidth / 2, width: handleWidth, height: handleWidth)
                    oval12.frame = CGRect(x: selectLayer.frame.size.width +  selectLayer.frame.origin.x - handleWidth / 2, y:selectLayer.frame.size.height + selectLayer.frame.origin.y - handleWidth / 2, width: handleWidth, height: handleWidth)
                case 2:
                    oval11.frame = CGRect(x: selectLayer.frame.origin.x - handleWidth / 2 + selectLayer.frame.size.width, y: selectLayer.frame.origin.y - handleWidth / 2, width: handleWidth, height: handleWidth)
                    oval12.frame = CGRect(x:selectLayer.frame.origin.x - handleWidth / 2, y:selectLayer.frame.size.height + selectLayer.frame.origin.y - handleWidth / 2, width: handleWidth, height: handleWidth)
                case 3:
                    oval11.frame = CGRect(x: selectLayer.frame.origin.x - handleWidth / 2 + selectLayer.frame.size.width, y: selectLayer.frame.size.height + selectLayer.frame.origin.y - handleWidth / 2, width: handleWidth, height: handleWidth)
                    oval12.frame = CGRect(x:selectLayer.frame.origin.x - handleWidth / 2, y:selectLayer.frame.origin.y - handleWidth / 2, width: handleWidth, height: handleWidth)
                case 4:
                    oval11.frame = CGRect(x: selectLayer.frame.origin.x - handleWidth / 2, y: selectLayer.frame.size.height + selectLayer.frame.origin.y - handleWidth / 2, width: handleWidth, height: handleWidth)
                    oval12.frame = CGRect(x:selectLayer.frame.origin.x - handleWidth / 2 + selectLayer.frame.size.width, y:selectLayer.frame.origin.y - handleWidth / 2, width: handleWidth, height: handleWidth)
                default:
                    break
                }
                
            default:
                break
            }
            lineHandleState = 1
        case 1:
            switch selectLayer{
            case self.view.layer:
                lineHandleState = 0
            default:
                break
            }
        default:
            break
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch = touches.first!
        let touchPoint:CGPoint = touch.location(in: self.view)
        let touchOffsetPoint:CGPoint = CGPoint(x: touchPoint.x - touchLastPoint.x, y: touchPoint.y - touchLastPoint.y)
        touchLastPoint = touchPoint
        switch selectLayer {
        case self.view.layer:
            break
        case oval11,oval12:
            let px:CGFloat = selectLayer.frame.origin.x
            let py:CGFloat = selectLayer.frame.origin.y
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            selectLayer.frame.origin.x = px + touchOffsetPoint.x
            selectLayer.frame.origin.y = py + touchOffsetPoint.y
            let compX = oval12.frame.origin.x - oval11.frame.origin.x
            let compY = oval12.frame.origin.y - oval11.frame.origin.y
            print(compX)
            print(compY)
            switch (compX,compY){
            case (0...,0...):
                commitLayer.frame.origin.x = oval11.frame.origin.x + handleWidth / 2
                commitLayer.frame.origin.y = oval11.frame.origin.y + handleWidth / 2
                commitLayer.frame.size.width = oval12.frame.origin.x - oval11.frame.origin.x
                commitLayer.frame.size.height = oval12.frame.origin.y - oval11.frame.origin.y
                commitLayer.strokeColor = UIColor.blue.cgColor
                let line02 = UIBezierPath()
                line02.move(to: CGPoint(x: 0, y: 0))
                line02.addLine(to: CGPoint(x: line01.frame.width, y: line01.frame.height))
                commitLayer.path = line02.cgPath
                self.view.layer.addSublayer(commitLayer)
            case (...0,0...):
                commitLayer.frame.origin.x = oval11.frame.origin.x + handleWidth / 2
                commitLayer.frame.origin.y = oval11.frame.origin.y + handleWidth / 2
                commitLayer.frame.size.width = oval12.frame.origin.x - oval11.frame.origin.x
                commitLayer.frame.size.height = oval12.frame.origin.y - oval11.frame.origin.y
                commitLayer.strokeColor = UIColor.blue.cgColor
                let line02 = UIBezierPath()
                line02.move(to: CGPoint(x: line01.frame.width, y: 0))
                line02.addLine(to: CGPoint(x: 0, y: line01.frame.height))
                commitLayer.path = line02.cgPath
                self.view.layer.addSublayer(commitLayer)
            case (0...,...0):
                commitLayer.frame.origin.x = oval11.frame.origin.x + handleWidth / 2
                commitLayer.frame.origin.y = oval11.frame.origin.y + handleWidth / 2
                commitLayer.frame.size.width = oval12.frame.origin.x - oval11.frame.origin.x
                commitLayer.frame.size.height = oval12.frame.origin.y - oval11.frame.origin.y
                commitLayer.strokeColor = UIColor.blue.cgColor
                let line02 = UIBezierPath()
                line02.move(to: CGPoint(x: 0, y: line01.frame.height))
                line02.addLine(to: CGPoint(x: line01.frame.width, y:0 ))
                commitLayer.path = line02.cgPath
                self.view.layer.addSublayer(commitLayer)
            case (...0,...0):
                commitLayer.frame.origin.x = oval11.frame.origin.x + handleWidth / 2
                commitLayer.frame.origin.y = oval11.frame.origin.y + handleWidth / 2
                commitLayer.frame.size.width = oval12.frame.origin.x - oval11.frame.origin.x
                commitLayer.frame.size.height = oval12.frame.origin.y - oval11.frame.origin.y
                commitLayer.strokeColor = UIColor.blue.cgColor
                let line02 = UIBezierPath()
                line02.move(to: CGPoint(x: line01.frame.width, y: line01.frame.height))
                line02.addLine(to: CGPoint(x: 0, y: 0))
                commitLayer.path = line02.cgPath
                self.view.layer.addSublayer(commitLayer)
            default:
                break
            }
            
            CATransaction.commit()
        default:
            break
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch lineHandleState {
        case 0:
            oval11.removeFromSuperlayer()
            oval12.removeFromSuperlayer()
            lineHandleState = 0
        case 1:
            let compX = oval12.frame.origin.x - oval11.frame.origin.x
            let compY = oval12.frame.origin.y - oval11.frame.origin.y
            switch (compX,compY){
            case (0...,0...):
                lineState = 1
            case (...0,0...):
                lineState = 2
            case (...0,...0):
                lineState = 3
            case (0...,...0):
                lineState = 4
            default:
                break
            }
        default:
            break
        }
    }
}
