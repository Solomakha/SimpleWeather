//
//  WeatherNetworkService.swift
//  SimpleWeather
//
//  Created by Дмитрий Соломаха on 10.11.2024.
//

import Foundation
import Alamofire

//Мережевий запит
class WeatherService {
    
    func getWeather(for city: String, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let parameters: [String: String] = [
            "q": city,
            "appid": apiKey,
            "units": "metric"
        ]
        
        AF.request("\(baseURL)weather", parameters: parameters).responseDecodable(of: WeatherResponse.self) { response in
            switch response.result {
            case .success(let weatherResponse):
                completion(.success(weatherResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
