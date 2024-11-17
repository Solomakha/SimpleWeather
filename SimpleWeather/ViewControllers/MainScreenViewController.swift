//
//  MainScreenViewController.swift
//  SimpleWeather
//
//  Created by Дмитрий Соломаха on 28.09.2024.
//

import UIKit
import Charts
import DGCharts

public let apiKey = "c5879221935c6f2584c803c06084ccc1"  // Замените на ваш API-ключ
public let baseURL = "https://api.openweathermap.org/data/2.5/"
public var city = "Kharkiv"

class MainScreenViewController: UIViewController {
    weak var coordinator:AppCoordinator?
    
    var locationLabel = UILabel()
    
    var weatherValue: String = String()
    var weatherImage: UIImage = UIImage()
    
    let weatherService = WeatherService()
    let weatherForecastService = WeatherForecastService()
    
    // LineChartView для отображения графика
    private var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationLabel.text = city
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
        
        fetchWeather(for: city)
        // Добавляем целевое действие для изменения индекса
        segmentedControl.addTarget(self, action: #selector(indexChanged(_:)), for: .valueChanged)
        
        weatherForecastService.fetchFiveDayForecast(for: city, apiKey: apiKey) { [weak self] forecastArray, error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
            } else if let forecastArray = forecastArray {
                DispatchQueue.main.async {
                    self?.updateChartWithData(forecastArray)
                }
            }
        }
        
        // Инициализируем и добавляем LineChartView в weatherGraphView
        setupChartView()
        
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
        addCity.setTitle("Add city", for: .normal)
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
        label.text = "Sunny"
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
        let item = ["Today","Tomorrow","Week"]
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
    
    private func setupChartView() {
        lineChartView = LineChartView()
        lineChartView.translatesAutoresizingMaskIntoConstraints = false
        lineChartView.backgroundColor = .clear
        weatherGraphView.addSubview(lineChartView)
        
        NSLayoutConstraint.activate([
            lineChartView.leadingAnchor.constraint(equalTo: weatherGraphView.leadingAnchor, constant: 10),
            lineChartView.trailingAnchor.constraint(equalTo: weatherGraphView.trailingAnchor, constant: -10),
            lineChartView.topAnchor.constraint(equalTo: weatherGraphView.topAnchor, constant: 10),
            lineChartView.bottomAnchor.constraint(equalTo: weatherGraphView.bottomAnchor, constant: -10)
        ])
    }
    
    // Метод для обновления данных на графике
    private func updateChartWithData(_ forecastArray: [WeatherForecast]) {
        var dataEntries: [ChartDataEntry] = []
        
        // Создание данных для графика
        for (index, forecast) in forecastArray.enumerated() {
            let dataEntry = ChartDataEntry(x: Double(index), y: forecast.avgTemp)
            dataEntries.append(dataEntry)
        }
        
        // Настройка данных для графика
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        
        // Настройка отображения линии и точек
        chartDataSet.colors = [.black]              // Цвет линии
        chartDataSet.circleColors = [.black]         // Цвет границ точек
        chartDataSet.circleHoleColor = .black        // Цвет центра точек (заливка)
        chartDataSet.circleRadius = 6.0              // Размер точек
        chartDataSet.circleHoleRadius = 2.0          // Размер внутреннего круга
        chartDataSet.lineWidth = 3.0                 // Ширина линии
        chartDataSet.drawFilledEnabled = false       // Отключаем заполнение под линией
        
        // Включаем отображение значений
        chartDataSet.drawValuesEnabled = true
        chartDataSet.valueFormatter = BelowPointValueFormatter()
        chartDataSet.valueFont = .systemFont(ofSize: 10)
        chartDataSet.valueTextColor = .black
        
        let chartData = LineChartData(dataSet: chartDataSet)
        lineChartView.data = chartData
        
        // Настройка пользовательского форматтера для оси X
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: forecastArray.map { _ in "" })
        lineChartView.xAxis.granularity = 1
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false // Убираем линии сетки
        lineChartView.xAxis.drawAxisLineEnabled = false // Убираем линию оси X
        lineChartView.xAxis.labelFont = .systemFont(ofSize: 12)
        lineChartView.xAxis.labelTextColor = .black
        
        // Отключение оси Y и других лишних элементов
        lineChartView.leftAxis.enabled = false        // Полностью отключаем левую ось Y
        lineChartView.rightAxis.enabled = false       // Полностью отключаем правую ось Y
        
        // Отключение легенды и описания
        lineChartView.legend.enabled = false
        lineChartView.chartDescription.enabled = false
        
        // Анимация
        lineChartView.animate(xAxisDuration: 1.0) // Плавное появление графика
    }
    
    //Функція для зміни стану weatherGraphView
    @objc func indexChanged(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            weatherGraphView.backgroundColor = .black
        case 1:
            weatherGraphView.backgroundColor = .blue
        case 2:
            weatherGraphView.backgroundColor = .green
        default:
            weatherGraphView.backgroundColor = .clear
        }
    }
    
}
