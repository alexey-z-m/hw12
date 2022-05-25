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
    
    private var timer = Timer()
    private var displayTimer = 0
    
    
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
            imgSP.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            
            return imgSP
        }()
    
    private lazy var lblTimer: UILabel = {
        var lbl = UILabel()
            
        lbl.text = "00:00"
        lbl.font = .systemFont(ofSize: 40, weight: .bold)
        lbl.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        view.addSubview(btnTimer)
        
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
        
        lblTimer.translatesAutoresizingMaskIntoConstraints = false
        lblTimer.centerXAnchor.constraint(equalTo: btnTimer.centerXAnchor).isActive = true
        lblTimer.topAnchor.constraint(equalTo: btnTimer.topAnchor, constant: 50).isActive = true
            
        
        imgStartPause.translatesAutoresizingMaskIntoConstraints = false
        imgStartPause.centerXAnchor.constraint(equalTo: btnTimer.centerXAnchor).isActive = true
        imgStartPause.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imgStartPause.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imgStartPause.topAnchor.constraint(equalTo: lblTimer.bottomAnchor, constant: 30).isActive = true
        
        
    }
    
    private func setupView() {
        
        //btnTimer.backgroundColor = #colorLiteral(red: 0.07412432879, green: 0.08454861492, blue: 0.2357147634, alpha: 0.3927750126)
        view.backgroundColor = #colorLiteral(red: 0.1676505506, green: 0.2282019258, blue: 0.1698732376, alpha: 1)
    }
    
    @objc func runNpauseTimer() {
        if isStarted {
            timer.invalidate()
            isStarted = false
            imgStartPause.image = UIImage(systemName: "play.circle")
        } else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(action), userInfo: nil, repeats: true)
            imgStartPause.image = UIImage(systemName: "pause.circle.fill")
            isStarted = true
        }
    }
    
    @objc func action() {
        displayTimer += 1
        
        if isWorkTime && displayTimer > 10 {
            isWorkTime = false
            displayTimer = 0
            view.backgroundColor = #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1)
            lblTimer.textColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            imgStartPause.tintColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
        }
        if !isWorkTime && displayTimer > 5 {
            isWorkTime = true
            displayTimer = 0
            view.backgroundColor = #colorLiteral(red: 0.1676505506, green: 0.2282019258, blue: 0.1698732376, alpha: 1)
            lblTimer.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            imgStartPause.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        }
        
        
        let min = displayTimer / 60
        let sec = displayTimer % 60
        lblTimer.text = "\(String(format: "%02d", min)):\(String(format: "%02d", sec))"
        
    }
    
    

}

