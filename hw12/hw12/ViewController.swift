//
//  ViewController.swift
//  hw12
//
//  Created by Panda on 24.05.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var isWorkTime: Bool = true
    private var isStarted: Bool = false
    private var isPause: Bool = false
    
    
    private var timer = Timer()
    private var displayTimer = 10.0
    
    
    private lazy var lblType: UILabel = {
        var lbl = UILabel()
            
        lbl.text = Strings.lblIsWorkTime
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 40, weight: .bold)
        lbl.textColor = Metric.green
        return lbl
    }()
    
    private lazy var lblReset: UIButton = {
        var btn = UIButton(type: .system)
            
        btn.setTitle(Strings.btnReset, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
        btn.setTitleColor(Metric.reset, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        return btn
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
            
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
            
        return stackView
    }()
    
    private lazy var btnTimer: UIButton = {
        let btn = UIButton()
        
        btn.addTarget(self, action: #selector(runNpauseTimer), for: .touchUpInside)
        
        return btn
    }()
        private lazy var imgStartPause: UIImageView = {
            var imgSP = UIImageView()
            
            let img = UIImage(systemName: "play.circle")
            imgSP.image = img
            imgSP.tintColor = Metric.green
            
            return imgSP
        }()
    
    private lazy var lblTimer: UILabel = {
        var lbl = UILabel()
            
        lbl.text = convertToTimer(displayTimer: displayTimer) //"00:00"
        lbl.font = .systemFont(ofSize: 40, weight: .bold)
        lbl.textColor = Metric.green
        return lbl
    }()
    
    private lazy var circle: UIView = {
        let view = UIView()
        
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.layer.cornerRadius = Metric.circleWidth / 2
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    let shapeLayer = CAShapeLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        setupView()
        setupHierarchy()
        setupLayout()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        animationCircle()
    }
    
    private func setupHierarchy() {
        view.addSubview(circle)
        circle.layer.addSublayer(shapeLayer)
        view.addSubview(btnTimer)
        view.addSubview(lblType)
        view.addSubview(lblReset)
        
        //btnTimer.addSubview(circle)
        btnTimer.addSubview(lblTimer)
        btnTimer.addSubview(imgStartPause)
    }
    
    private func setupLayout() {
        
        btnTimer.translatesAutoresizingMaskIntoConstraints = false
        btnTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnTimer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        btnTimer.widthAnchor.constraint(equalToConstant: 200).isActive = true
        btnTimer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        
        lblType.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblType.bottomAnchor.constraint(equalTo: btnTimer.topAnchor, constant: -50).isActive = true
        
        circle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circle.heightAnchor.constraint(equalToConstant: Metric.circleHeight).isActive = true
        circle.widthAnchor.constraint(equalToConstant: Metric.circleWidth).isActive = true
        
        lblTimer.translatesAutoresizingMaskIntoConstraints = false
        lblTimer.centerXAnchor.constraint(equalTo: btnTimer.centerXAnchor).isActive = true
        lblTimer.topAnchor.constraint(equalTo: btnTimer.topAnchor, constant: 50).isActive = true
            
        
        imgStartPause.translatesAutoresizingMaskIntoConstraints = false
        imgStartPause.centerXAnchor.constraint(equalTo: btnTimer.centerXAnchor).isActive = true
        imgStartPause.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imgStartPause.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imgStartPause.topAnchor.constraint(equalTo: lblTimer.bottomAnchor, constant: 30).isActive = true
        
        lblReset.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        lblReset.topAnchor.constraint(equalTo: btnTimer.bottomAnchor, constant: 20).isActive = true
        lblReset.widthAnchor.constraint(equalToConstant: 200).isActive = true
        lblReset.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        
    }
    
    private func setupView() {
        
        //btnTimer.backgroundColor = #colorLiteral(red: 0.07412432879, green: 0.08454861492, blue: 0.2357147634, alpha: 0.3927750126)
        view.backgroundColor = Metric.darkGreen
    }
    
    @objc func runNpauseTimer() {
        
        
        if isStarted {
            timer.invalidate()
            pauseAnimation()
            isPause = true
            isStarted = false
            imgStartPause.image = UIImage(systemName: "play.circle")
        } else {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(action), userInfo: nil, repeats: true)
            imgStartPause.image = UIImage(systemName: "pause.circle.fill")
            isStarted = true
            if isPause {
                resumeAnimation()
                isPause = false
            } else {
                basicAnimation()
            }
            
        }
    }
    
    @objc func action() {
        displayTimer -= 0.01
        
        if isWorkTime && displayTimer < 0 {
            isWorkTime = false
            displayTimer = 5
            view.backgroundColor = Metric.darkBurgundy
            lblTimer.textColor = Metric.burgundy
            imgStartPause.tintColor = Metric.burgundy
            lblType.text = Strings.lblIsNotWorkTime
            lblType.textColor = Metric.burgundy
            shapeLayer.strokeColor = Metric.burgundy.cgColor
            
            basicAnimation()
        }
        if !isWorkTime && displayTimer < 0 {
            isWorkTime = true
            displayTimer = 10
            view.backgroundColor = Metric.darkGreen
            lblTimer.textColor = Metric.green
            imgStartPause.tintColor = Metric.green
            lblType.text = Strings.lblIsWorkTime
            lblType.textColor = Metric.green
            shapeLayer.strokeColor = Metric.green.cgColor
            
            basicAnimation()
        }
        
        lblTimer.text = convertToTimer(displayTimer: displayTimer)
        
    }
    
    func convertToTimer(displayTimer: Double) -> String {
        
        var result = ""
        let min = Int(displayTimer) / 60
        let sec = Int(displayTimer) % 60
        result = "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
        return result
    }
    
    func animationCircle(){
        
        let center = CGPoint(x: circle.frame.width / 2, y: circle.frame.height / 2)
        
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circlePath = UIBezierPath(arcCenter: center, radius: Metric.circleWidth / 2 - 5, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = #colorLiteral(red: 0.2180668712, green: 0.03185554966, blue: 0.1179199442, alpha: 0)
        shapeLayer.strokeEnd = 1
        shapeLayer.lineCap = .round
        if isWorkTime {
            shapeLayer.strokeColor = Metric.green.cgColor
        } else {
            shapeLayer.strokeColor = Metric.burgundy.cgColor
        }
    }
    
    func basicAnimation() {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        
        animation.toValue = 0
        animation.duration = CFTimeInterval(displayTimer)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = true
        shapeLayer.speed = 1
        shapeLayer.add(animation, forKey: "basicAnimation")
    }
    
    func pauseAnimation() {
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation() {
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1
        shapeLayer.timeOffset = 0
        shapeLayer.beginTime = 0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    @objc func resetTimer() {
        
        //shapeLayer.strokeColor = enabled ? Metric.green.cgColor : Metric.burgundy.cgColor
        shapeLayer.strokeColor = Metric.green.cgColor
        
        isWorkTime = true
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = 0
        isStarted = false
        isPause = false
        imgStartPause.image = UIImage(systemName: "play.circle")
        displayTimer = 10
        lblTimer.text = convertToTimer(displayTimer: displayTimer)
        view.backgroundColor = Metric.darkGreen
        lblTimer.textColor = Metric.green
        imgStartPause.tintColor = Metric.green
        lblType.text = "time to work"
        lblType.textColor = Metric.green
        timer.invalidate()
        shapeLayer.speed = 0.1
        shapeLayer.strokeColor = Metric.green.cgColor
        
    }

}


extension ViewController {
    enum Metric {
        static let circleHeight: CGFloat = 200
        static let circleWidth: CGFloat = 200
        
        static let green = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        static let darkGreen = #colorLiteral(red: 0.1676505506, green: 0.2282019258, blue: 0.1698732376, alpha: 1)
        static let burgundy = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        static let darkBurgundy = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
        
        static let reset = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
    }
    
    enum Strings {
        static let lblIsWorkTime: String = "time to work"
        static let lblIsNotWorkTime: String = "time to rest"
        static let btnReset: String = "Reset timer"
    }
}

