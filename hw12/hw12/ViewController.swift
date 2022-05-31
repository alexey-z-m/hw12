import UIKit
class ViewController: UIViewController {
    private var isWorkTime: Bool = true
    private var isStarted: Bool = false
    private var isPause: Bool = false
    private var timer = Timer()
    private let timeToWork = 10.0
    private let timeToRest = 5.0
    private var displayTimer = 10.0
    
    private lazy var labelType: UILabel = {
        var label = UILabel()
        label.text = Strings.labelIsWorkTime
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = Metric.green
        return label
    }()
    
    private lazy var labelReset: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(Strings.buttonReset, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
        button.setTitleColor(Metric.reset, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private lazy var buttonTimer: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(runNpauseTimer), for: .touchUpInside)
        return button
    }()
    
    private lazy var imageStartPause: UIImageView = {
        var imageSP = UIImageView()
        let image = UIImage(systemName: "play.circle")
        imageSP.image = image
        imageSP.tintColor = Metric.green
        return imageSP
    }()
    
    private lazy var labelTimer: UILabel = {
        var label = UILabel()
        label.text = convertToTimer(displayTimer: displayTimer) //"00:00"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = Metric.green
        return label
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
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        startCircleAnimation()
    }
    
    private func setupHierarchy() {
        view.addSubview(circle)
        circle.layer.addSublayer(shapeLayer)
        view.addSubview(buttonTimer)
        view.addSubview(labelType)
        view.addSubview(labelReset)
        buttonTimer.addSubview(labelTimer)
        buttonTimer.addSubview(imageStartPause)
    }
    
    private func setupLayout() {
        buttonTimer.translatesAutoresizingMaskIntoConstraints = false
        buttonTimer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonTimer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        buttonTimer.widthAnchor.constraint(equalToConstant: Metric.buttonTimerWidth).isActive = true
        buttonTimer.heightAnchor.constraint(equalToConstant: Metric.buttonTimerHeight).isActive = true
        labelType.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelType.bottomAnchor.constraint(equalTo: buttonTimer.topAnchor, constant: -50).isActive = true
        circle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circle.heightAnchor.constraint(equalToConstant: Metric.circleHeight).isActive = true
        circle.widthAnchor.constraint(equalToConstant: Metric.circleWidth).isActive = true
        labelTimer.translatesAutoresizingMaskIntoConstraints = false
        labelTimer.centerXAnchor.constraint(equalTo: buttonTimer.centerXAnchor).isActive = true
        labelTimer.topAnchor.constraint(equalTo: buttonTimer.topAnchor, constant: 50).isActive = true
        imageStartPause.translatesAutoresizingMaskIntoConstraints = false
        imageStartPause.centerXAnchor.constraint(equalTo: buttonTimer.centerXAnchor).isActive = true
        imageStartPause.widthAnchor.constraint(equalToConstant: Metric.imageStartPauseWidth).isActive = true
        imageStartPause.heightAnchor.constraint(equalToConstant: Metric.imageStartPauseHeight).isActive = true
        imageStartPause.topAnchor.constraint(equalTo: labelTimer.bottomAnchor, constant: 30).isActive = true
        labelReset.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelReset.topAnchor.constraint(equalTo: buttonTimer.bottomAnchor, constant: 20).isActive = true
        labelReset.widthAnchor.constraint(equalToConstant: Metric.labelResetWidth).isActive = true
        labelReset.heightAnchor.constraint(equalToConstant: Metric.labelResetHeight).isActive = true
    }
    
    private func setupView() {
        view.backgroundColor = Metric.darkGreen
    }
    
    func pauseTimer() {
        timer.invalidate()
        pauseAnimation()
        isPause = true
        isStarted = false
        imageStartPause.image = UIImage(systemName: "play.circle")
    }
    
    @objc func runNpauseTimer() {
        if isStarted {
            pauseTimer()
        } else {
            timer = Timer.scheduledTimer(
                timeInterval: 0.01,
                target: self,
                selector: #selector(startTimer),
                userInfo: nil,
                repeats: true
            )
            imageStartPause.image = UIImage(systemName: "pause.circle.fill")
            isStarted = true
            if isPause {
                resumeAnimation()
                isPause = false
            } else {
                basicAnimation()
            }
        }
    }
    
    @objc func startTimer() {
        displayTimer -= 0.01
        if isWorkTime && displayTimer < 1.2 {
            shapeLayer.strokeColor = Metric.burgundy.cgColor
        }
        if !isWorkTime && displayTimer < 1.2 {
            shapeLayer.strokeColor = Metric.green.cgColor
        }
        if isWorkTime && displayTimer < 1 {
            isWorkTime = false
            displayTimer = timeToRest
            changeColor(isWorkTime)
            labelType.text = Strings.labelIsNotWorkTime
            basicAnimation()
            pauseTimer()
        }
        if !isWorkTime && displayTimer < 1 {
            isWorkTime = true
            displayTimer = timeToWork
            changeColor(isWorkTime)
            labelType.text = Strings.labelIsWorkTime
            basicAnimation()
            pauseTimer()
        }
        labelTimer.text = convertToTimer(displayTimer: displayTimer)
    }
    
    func changeColor(_ isWorkTime: Bool) {
        var mainColor: UIColor
        var otherColor: UIColor
        if isWorkTime {
            mainColor = Metric.darkGreen
            otherColor = Metric.green
        } else {
            mainColor = Metric.darkBurgundy
            otherColor = Metric.burgundy
        }
        view.backgroundColor = mainColor
        labelTimer.textColor = otherColor
        imageStartPause.tintColor = otherColor
        labelType.textColor = otherColor
    }
    
    func convertToTimer(displayTimer: Double) -> String {
        var result = ""
        let min = Int(displayTimer) / 60
        let sec = Int(displayTimer) % 60
        result = "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
        return result
    }
    
    func startCircleAnimation(){
        let center = CGPoint(x: circle.frame.width / 2, y: circle.frame.height / 2)
        let endAngle = (-CGFloat.pi / 2)
        let startAngle = 2 * CGFloat.pi + endAngle
        let circlePath = UIBezierPath(
            arcCenter: center,
            radius: Metric.circleWidth / 2 - 5,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        shapeLayer.path = circlePath.cgPath
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
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
        animation.duration = CFTimeInterval(displayTimer-1)
        animation.fillMode = .forwards
        shapeLayer.speed = 1
        shapeLayer.add(animation, forKey: "basicAnimation")
    }
    
    func pauseAnimation() {
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0
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
        shapeLayer.strokeColor = Metric.green.cgColor
        isWorkTime = true
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = 0
        isStarted = false
        isPause = false
        imageStartPause.image = UIImage(systemName: "play.circle")
        displayTimer = 10
        labelTimer.text = convertToTimer(displayTimer: displayTimer)
        view.backgroundColor = Metric.darkGreen
        labelTimer.textColor = Metric.green
        imageStartPause.tintColor = Metric.green
        labelType.text = "time to work"
        labelType.textColor = Metric.green
        timer.invalidate()
        shapeLayer.speed = 0.1
        shapeLayer.strokeColor = Metric.green.cgColor
    }
}

extension ViewController {
    enum Metric {
        static let buttonTimerHeight: CGFloat = 200
        static let buttonTimerWidth: CGFloat = 200
        static let imageStartPauseHeight: CGFloat = 40
        static let imageStartPauseWidth: CGFloat = 40
        static let circleHeight: CGFloat = 200
        static let circleWidth: CGFloat = 200
        static let labelResetHeight: CGFloat = 100
        static let labelResetWidth: CGFloat = 200
        static let green = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        static let darkGreen = #colorLiteral(red: 0.1676505506, green: 0.2282019258, blue: 0.1698732376, alpha: 1)
        static let burgundy = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        static let darkBurgundy = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
        static let reset = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
    }
    
    enum Strings {
        static let labelIsWorkTime: String = "time to work"
        static let labelIsNotWorkTime: String = "time to rest"
        static let buttonReset: String = "Reset timer"
    }
}

