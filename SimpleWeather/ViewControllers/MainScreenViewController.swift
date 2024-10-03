//
//  MainScreenViewController.swift
//  SimpleWeather
//
//  Created by Дмитрий Соломаха on 28.09.2024.
//

import UIKit

class MainScreenViewController: UIViewController {
    weak var coordinator:AppCoordinator?
    
    var locationLabel = UILabel()
    
    var weatherString: String = String()
    var weatherValue: String = String()
    
    var weatherImage: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = "м.Харків"
        locationLabel.textAlignment = .center
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont.systemFont(ofSize: 20)
        
        view.addSubview(locationView)
        view.addSubview(weatherValueLabel)
        view.addSubview(weatherImgView)
        view.addSubview(weatherMeaningLabel)
        
        view.addSubview(weatherGraphView)
        view.addSubview(segmentedControl)
        
        setupView()
        addConstraints()
        setCustomLabelText()
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
        let stByUkr = UILabel()
        stByUkr.text = "Зроблено в 🇺🇦"
        stByUkr.textAlignment = .center
        stByUkr.textColor = .gray
        stByUkr.translatesAutoresizingMaskIntoConstraints = false
        
        let leftLabelItem = UIBarButtonItem(customView: stByUkr)
        self.navigationItem.leftBarButtonItem = leftLabelItem
        let rightButtonItem = UIBarButtonItem(customView: addCityButton)
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            addCityButton.widthAnchor.constraint(equalToConstant: 130),
            
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            locationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationView.widthAnchor.constraint(equalToConstant: 150),
            locationView.heightAnchor.constraint(equalToConstant: 40),
            
            locationLabel.centerXAnchor.constraint(equalTo: locationView.centerXAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: locationView.centerYAnchor),
            
            weatherImgView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 50),
            weatherImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherImgView.widthAnchor.constraint(equalToConstant: 150),
            weatherImgView.heightAnchor.constraint(equalToConstant: 150),
            
            weatherValueLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherValueLabel.topAnchor.constraint(equalTo: weatherImgView.bottomAnchor, constant: 20),
            
            weatherMeaningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherMeaningLabel.topAnchor.constraint(equalTo: weatherValueLabel.bottomAnchor, constant: 10),
            
            weatherGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherGraphView.topAnchor.constraint(equalTo: weatherMeaningLabel.bottomAnchor, constant: 10),
            weatherGraphView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            weatherGraphView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            weatherGraphView.heightAnchor.constraint(equalToConstant: 200),
            
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            segmentedControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            segmentedControl.widthAnchor.constraint(equalToConstant: 350)
        
        ])
    }
    
    private lazy var addCityButton: UIButton = {
        let addCity = UIButton()
        addCity.setTitle("Додати місто", for: .normal)
        addCity.setTitleColor(.gray, for: .normal)
        addCity.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addCity.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addCity.backgroundColor = .lightGray.withAlphaComponent(0.1)
        addCity.layer.cornerRadius = 15
        addCity.translatesAutoresizingMaskIntoConstraints = false
        return addCity
    }()
    
    var weatherImgView: UIImageView = {
        var weatherImg = UIImageView()
        weatherImg.contentMode = UIView.ContentMode.scaleAspectFill
        weatherImg.backgroundColor = .clear
        weatherImg.translatesAutoresizingMaskIntoConstraints = false
        weatherImg.image = UIImage(named: "sunny-day")
        return weatherImg
    }()
    
    private lazy var weatherValueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var weatherMeaningLabel = {
        let label = UILabel()
        label.text = "Ясно"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var locationView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 20
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationLabel)
        return view
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let item = ["Сьогодні","Завтра","Тиждень"]
        let control = UISegmentedControl(items: item)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .lightGray.withAlphaComponent(0.1)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private lazy var weatherGraphView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.2)
        view.layer.cornerRadius = 20
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func setCustomLabelText() {
        let customFont = UIFont(name: "Helvetica", size: 50) ?? UIFont.boldSystemFont(ofSize: 70)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: customFont,
            .foregroundColor: UIColor.black
        ]
        
        weatherValue = "25"
        weatherString = String("\(weatherValue) °C")
        
        let attributedString = NSAttributedString(string: weatherString, attributes: textAttributes)
        weatherValueLabel.attributedText = attributedString
    }
    
    @objc func addTapped() {
        print("add tapped")
    }
}

