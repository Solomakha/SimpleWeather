//
//  MainScreenViewController.swift
//  SimpleWeather
//
//  Created by Дмитрий Соломаха on 28.09.2024.
//

import UIKit
import Alamofire

class MainScreenViewController: UIViewController {
    weak var coordinator:AppCoordinator?
    
    var locationLabel = UILabel()
    
    var weatherValue: String = String()
    var weatherImage: UIImage = UIImage()
    
    let weatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = "м.Харків"
        locationLabel.textAlignment = .center
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = UIFont.systemFont(ofSize: 20)
        
        view.addSubview(locationView)
        view.addSubview(temperatureLabel)
        view.addSubview(weatherImgView)
        view.addSubview(weatherMeaningLabel)
        
        view.addSubview(weatherGraphView)
        view.addSubview(segmentedControl)
        
        setupView()
        addConstraints()
        setCustomLabelText()
        
        fetchWeather(for: "Kharkiv")
    }
    
    func setupView(){
        self.view.backgroundColor = .white
        
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
            
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: weatherImgView.bottomAnchor, constant: 20),
            
            weatherMeaningLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weatherMeaningLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10),
            
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
    
    private lazy var temperatureLabel: UILabel = {
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
        
        var weatherString: String = String()
        weatherValue = "25"
        weatherString = String("\(weatherValue) °C")
        
        let attributedString = NSAttributedString(string: weatherString, attributes: textAttributes)
        temperatureLabel.attributedText = attributedString
    }
    
    @objc func addTapped() {
        print("add tapped")
    }
    
    //Структура для запиту на сервер
    struct WeatherResponse: Decodable {
        let main: Main
        let weather: [Weather]
        
        struct Main: Decodable {
            let temp: Double
            let humidity: Int
        }
        
        struct Weather: Decodable {
            let description: String
            let icon: String
        }
    }
    
    //Мережевий запит
    class WeatherService {
        let apiKey = "c5879221935c6f2584c803c06084ccc1"  // Замените на ваш API-ключ
        let baseURL = "https://api.openweathermap.org/data/2.5/weather"
        
        func getWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
            let parameters: [String: String] = [
                "q": city,
                "appid": apiKey,
                "units": "metric"
            ]
            
            AF.request(baseURL, parameters: parameters).responseDecodable(of: WeatherResponse.self) { response in
                switch response.result {
                case .success(let weatherResponse):
                    completion(.success(weatherResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    //Обробка отриманої відповіді
    func fetchWeather(for city: String) {
        weatherService.getWeather(for: city) { [weak self] result in
            switch result {
            case .success(let weatherResponse):
                DispatchQueue.main.async {
                    self?.updateUI(with: weatherResponse)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    //Оновлення елементів інтерфейсу користувача
    func updateUI(with weather: WeatherResponse){
        temperatureLabel.text = "\(weather.main.temp) °C"
        weatherMeaningLabel.text = weather.weather.first?.description.capitalized
        
        if let icon = weather.weather.first?.icon {
            let iconURL = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            loadImage(from: iconURL)
        }
    }
    
    //Функція завантаження зображення
    func loadImage(from urlString: String){
        guard let url = URL(string: urlString) else {return}
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data){
                DispatchQueue.main.async {
                    self.weatherImgView.image = image
                }
            }
        }
    }
}
