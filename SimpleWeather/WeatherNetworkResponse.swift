//
//  WeatherNetworkResponse.swift
//  SimpleWeather
//
//  Created by Дмитрий Соломаха on 10.11.2024.
//

import Foundation

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

// Определим структуру для хранения данных прогноза
struct WeatherForecast {
    let date: String
    let avgTemp: Double
}
