//
//  ForeCastDataViewModel.swift
//  WeatherApp
//
//  Created by kalyan on 3/28/26.
//

import Foundation
import Observation

@Observable
class ForeCastDataViewModel{
    var weather: ForecastWeather? = nil
    var isLoading = false
    var errorMessage: String? = nil
    
    func fetchForecast(cityName: String) async{
        
        isLoading = true
        errorMessage = nil
        
        let query = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? cityName
        
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(query)&appid=8a12c1d5be43fa2c83d9c7ba11b7c2bb&units=imperial"
        
        guard let url = URL(string: urlString) else{
            isLoading = false
            errorMessage = "Invalid api"
            return
        }
        
        do{
            let(data,_) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            let response = try JSONDecoder().decode(ForecastWeather.self, from: data)
            weather.self = response
            isLoading = false
        }catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("Error:\(error)")
            
        }
        isLoading = false
    }
    
    func fetchForecast(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=8a12c1d5be43fa2c83d9c7ba11b7c2bb&units=imperial"
        
        guard let url = URL(string: urlString) else {
            isLoading = false
            errorMessage = "Invalid api"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            let response = try JSONDecoder().decode(ForecastWeather.self, from: data)
            weather = response
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
            print("Error: \(error)")
        }
    }
}
