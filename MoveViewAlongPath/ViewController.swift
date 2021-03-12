//
//  ViewController.swift
//  MoveViewAlongPath
//
//  Created by UMARFAROOQTV.
//  Copyright © 2020 com. MoveViewAlongPath. All rights reserved.
//


import UIKit
import CoreGraphics
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var bead1: UIImageView!
    @IBOutlet weak var bead2: UIImageView!
    @IBOutlet weak var bead3: UIImageView!
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var allTotal: UILabel!
    
    var moveAlongPath: CAAnimation!
    var moveBackPath: CAAnimation!
    let forwardPath = UIBezierPath()
    let backwardPath = UIBezierPath()
    
    let goView  = CustomView(frame: CGRect(x: 150, y: 10, width: 50, height: 50))
    let backView  = CustomBackView(frame: CGRect(x:365 , y: 200, width: 50, height: 50))
    
    let startPoint = CGPoint(x: 68, y: 166)//Start
    let endPoint = CGPoint(x: 375, y: 200)//End
    let controlPoint = CGPoint(x: 150, y: 100)//Control point
    
    var avPlayer: AVAudioPlayer?
    var counter = 0
    var totalValue = 33
    var AllTotal = 0
    var isRoundCompleted = false
    
   
    @IBAction func restTapped(_ sender: Any) {
        //reset main counter
        counter = 0
        AllTotal = 0
        updateCounter()
        updateTotalCounter()
    }
    @IBAction func changeSetting(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: "", message: "Choose Option", preferredStyle: .actionSheet)
        
        let oneAction = UIAlertAction(title: "33", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.totalValue = 33
            //reset main counter
            self.counter = 0
            self.updateCounter()
          
        })
        
        let twoAction = UIAlertAction(title: "99", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.totalValue = 99
            //reset main counter
            self.counter = 0
            self.updateCounter()
            
        })
        
        let threeAction = UIAlertAction(title: "999", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            self.totalValue = 999
            
            //reset main counter
            self.counter = 0
            self.updateCounter()
            
        })
        
        let customAction = UIAlertAction(title: "Custom", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.presentCustomAlert()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
            //self.alertTypeCustom = false
        })
        
        optionMenu.addAction(oneAction)
        optionMenu.addAction(twoAction)
        optionMenu.addAction(threeAction)
        optionMenu.addAction(customAction)
        optionMenu.addAction(cancelAction)
        
        //self.present(optionMenu, animated: true, completion: nil)
        self.present(optionMenu, animated: true, completion: {
            
        })
        
    }
    
    func presentCustomAlert(){
        
        let alertController = UIAlertController(title: "Custom Option", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Please enter value"
            textField.keyboardType = .numberPad
        }
        
        let saveAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { alert -> Void in
            let customTextField = alertController.textFields![0] as UITextField
            self.totalValue = (customTextField.text! as NSString).integerValue
            
            if self.totalValue == 0 {
                self.totalValue = 33
            }
            
            //reset main counter
            self.counter = 0
            self.updateCounter()
        })
        
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func goForwardTapped(_ sender: Any) {
        startForwardAnimation()
    }
    @IBAction func goBackwardTapped(_ sender: Any) {
        startBackwardAnimation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //this method is for forward path
        addAnimation()
        //this method is for bacward path
        addBackAnimation()
     
        //Swipe Gesture Added
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    func playAudio(audioName: String){
        
        let soundPath = Bundle.main.path(forResource: "\(audioName)", ofType: "mp3")!
        let url = URL(fileURLWithPath: soundPath)
        
        do {
            avPlayer = try AVAudioPlayer(contentsOf: url)
            avPlayer?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case .right:
                print("Swiped right")
                startForwardAnimation()
            case .left:
                print("Swiped left")
                startBackwardAnimation()
            default:
                break
            }
        }
    }
    
    func startForwardAnimation(){
        //playAudio(audioName: "tick")
        
        if counter < totalValue {
            counter = counter + 1
            self.backView.removeFromSuperview()
            initiateAnimation()
            updateCounter()
        }
        
        
        //Reset Counter
        if isRoundCompleted {
            self.counter = 1
            AllTotal = AllTotal + 1
            self.backView.removeFromSuperview()
            initiateAnimation()
            updateCounter()
            updateTotalCounter()
            isRoundCompleted = false
        }
    }
    
    func startBackwardAnimation(){
        //playAudio(audioName: "tock")
        
        if counter >= 0 {
            
            if counter == 0 {
                //no counter increment
                counter = totalValue - 1
            }else{
                counter = counter - 1
            }
            
            self.goView.removeFromSuperview()
            initiateBackAnimation()
            updateCounter()
            
        }
        
    }
    
    func updateCounter() {
        lblCounter.text = "\(counter) / \(totalValue)"
    }
    
    func updateTotalCounter () {
        allTotal.text = "Total = \(AllTotal)"
    }
    func checkForFinalCounter() {
        if counter == totalValue {
            isRoundCompleted = true
        }else{
            isRoundCompleted = false
        }
    }
    
    func addBackAnimation(){
        
        let moveBackPath = CAKeyframeAnimation(keyPath: "position")
        moveBackPath.path = curevedPath(isReversed: true).cgPath
        moveBackPath.duration = 1
        moveBackPath.repeatCount = 0
        moveBackPath.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        moveBackPath.delegate = self
        self.moveBackPath = moveBackPath
        
    }
    
    func addAnimation() {
        
        let moveForwardPath = CAKeyframeAnimation(keyPath: "position")
        moveForwardPath.path = curevedPath(isReversed: false).cgPath
        moveForwardPath.duration = 1
        moveForwardPath.repeatCount = 0
        //moveForwardPath.calculationMode = kCAAnimationPaced
        moveForwardPath.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        moveForwardPath.delegate = self
        self.moveAlongPath = moveForwardPath
    }
    
    func curevedPath(isReversed: Bool) -> UIBezierPath {
        
        var path = UIBezierPath()
        if isReversed {
            path = createReversePath()
        }else{
            path = createCurvePath()
        }
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 1.0
        //self.view.layer.addSublayer(shapeLayer)
        self.view.layer.insertSublayer(shapeLayer, at: 0)
        
        return path
    }
    
    
    //MARK:- Custom Curve Path
    func createCurvePath() -> UIBezierPath {
        
        forwardPath.move(to: startPoint)
        forwardPath.addQuadCurve(to: endPoint, controlPoint: controlPoint)
        return forwardPath
    }
    
    
    func initiateAnimation() {
        let layer = createLayer()
        layer.add(moveAlongPath, forKey: "animate forward path")
        
    }
    
    //MARK:- Custom View Path
    func createLayer() -> CALayer {
        
        self.view.addSubview(goView)
        
        //place out of screen constraints
        goView.translatesAutoresizingMaskIntoConstraints = false
        goView.addConstaintsToSuperview(leftOffset: 10, topOffset: -150)
        goView.addConstaints(height: 50, width: 50)
        
        
        let customlayer = goView.layer
        customlayer.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        customlayer.position = CGPoint(x: 25, y: 25)
        return customlayer
    }
    
    //MARK:- Backward Animation
    
    func initiateBackAnimation() {
        let layer = createBackLayer()
        layer.add(moveBackPath, forKey: "animate forward path")//animate back Path
    }
    
    func createReversePath() -> UIBezierPath {
           backwardPath.move(to: endPoint)
           backwardPath.addQuadCurve(to: startPoint, controlPoint: controlPoint)
           return backwardPath
    }
    
    func createBackLayer() -> CALayer {
        
        self.view.addSubview(backView)
        
        //place out of screen constraints
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.addConstaintsToSuperview(leftOffset: 10, topOffset: -150)
        backView.addConstaints(height: 50, width: 50)
        
        let customlayer = backView.layer
        customlayer.bounds = CGRect(x: 375, y: 200, width: 50, height: 50)
        customlayer.position = CGPoint(x: 25, y: 25)
        return customlayer
    }
    
}

extension ViewController: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.goView.removeFromSuperview()
            self.backView.removeFromSuperview()
            playAudio(audioName: "tock")
            checkForFinalCounter()
        }
    }
}


class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    func setUpView() {
        let image = UIImage(named: "bead.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
    
        addSubview(imageView)
        //backgroundColor = .orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CustomBackView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    func setUpView() {
        let image = UIImage(named: "bead.png")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 375, y: 200, width: self.bounds.width, height: self.bounds.height)
    
        addSubview(imageView)
        //backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




extension UIView {

    public func addConstaintsToSuperview(leftOffset: CGFloat, topOffset: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: self,
                           attribute: .leading,
                           relatedBy: .equal,
                           toItem: self.superview,
                           attribute: .leading,
                           multiplier: 1,
                           constant: leftOffset).isActive = true

        NSLayoutConstraint(item: self,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.superview,
                           attribute: .top,
                           multiplier: 1,
                           constant: topOffset).isActive = true
    }

    public func addConstaints(height: CGFloat, width: CGFloat) {

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint(item: self,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: height).isActive = true


        NSLayoutConstraint(item: self,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1,
                           constant: width).isActive = true
    }
}
