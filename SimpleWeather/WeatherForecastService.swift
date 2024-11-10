//
//  WeatherForecastService.swift
//  SimpleWeather
//
//  Created by Дмитрий Соломаха on 10.11.2024.
//

import Foundation
import Alamofire

class WeatherForecastService {
        
        func fetchFiveDayForecast(for city: String, apiKey: String, completion: @escaping ([WeatherForecast]?, Error?) -> Void) {
            
            let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=\(apiKey)&units=metric"
            
            // Выполняем запрос
            AF.request(urlString).responseJSON { response in
                switch response.result {
                case .success(let value):
                    // Парсим JSON
                    if let json = value as? [String: Any],
                       let list = json["list"] as? [[String: Any]] {
                        
                        // Группируем данные по дате и собираем температуры
                        var forecast: [String: [Double]] = [:]
                        
                        for item in list {
                            if let main = item["main"] as? [String: Any],
                               let temp = main["temp"] as? Double,
                               let dt = item["dt"] as? TimeInterval {
                                
                                // Форматируем дату
                                let date = Date(timeIntervalSince1970: dt)
                                let formatter = DateFormatter()
                                formatter.dateFormat = "dd-MM-yyyy"
                                let dateString = formatter.string(from: date)
                                
                                // Добавляем температуру в массив для конкретного дня
                                forecast[dateString, default: []].append(temp)
                            }
                        }
                        
                        // Создаем массив с прогнозами
                        var forecastArray: [WeatherForecast] = []
                        for (date, temps) in forecast.sorted(by: { $0.key < $1.key }).prefix(5) {
                            let avgTemp = temps.reduce(0, +) / Double(temps.count)
                            forecastArray.append(WeatherForecast(date: date, avgTemp: avgTemp))
                        }
                        
                        // Передаем результат в completion
                        completion(forecastArray, nil)
                        
                    } else {
                        completion(nil, NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Неверный формат данных"]))
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
