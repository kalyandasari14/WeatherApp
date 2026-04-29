//
//  WeatherDataViewModel.swift
//  WeatherApp
//
//  Created by kalyan on 3/27/26.
//

import Foundation
import Observation


@Observable
class WeatherDataViewModel{
    var weather: WeatherData? =  nil
    var isLoading = false
    var errorMessage: String? = nil
    
    
    func fetchData(city: String) async{
         isLoading = true
         errorMessage = nil
        
        let urlString  = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=8a12c1d5be43fa2c83d9c7ba11b7c2bb&units=imperial"
        
        guard let url = URL(string:urlString)else{
            isLoading = false
            errorMessage = "Invalid Api"
            return
        }
        
        do{
            let(data, _ ) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            let response = try JSONDecoder().decode(WeatherData.self, from: data)
            weather = response
            isLoading = false
        }catch{
            isLoading = false
            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
            print("Error:\(error)")
        }
        
    }
    
    func fetchData(latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=8a12c1d5be43fa2c83d9c7ba11b7c2bb&units=imperial"
        
        guard let url = URL(string: urlString) else {
            isLoading = false
            errorMessage = "Invalid API"
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            
            let response = try JSONDecoder().decode(WeatherData.self, from: data)
            weather = response
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
            print("Error: \(error)")
        }
    }
}
