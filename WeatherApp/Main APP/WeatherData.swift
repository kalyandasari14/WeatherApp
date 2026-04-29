//
//  WeatherData.swift
//  WeatherApp
//
//  Created by kalyan on 3/27/26.
//

import Foundation


struct WeatherData: Codable, Hashable{
    var id: Int
    var name: String
    var main: Main
    var wind: Wind
    var weather: [Weather]
    
    
    struct Weather:Codable,Hashable{
        var main: String
        var description: String
      
    }
    
    struct Main : Codable, Hashable{
        var temp: Double
        var feels_like: Double
        var humidity: Int
    }

    struct Wind: Codable,Hashable{
        var speed: Double
        var deg: Int
    }
    
}

struct ForecastWeather:Decodable,Hashable{
    var list: [ForecastItem]
    
    
    struct ForecastItem: Decodable, Hashable{
        var main: Main
        var weather: [Weather]
        var wind: Wind
        var dt_txt: String
        
        
        struct Weather: Decodable, Hashable{
            var main: String
            var description: String
          
        }
        
        struct Main:Decodable,Hashable{
            var temp: Double
            var feels_like: Double
            var humidity: Int
            
        }
        
        struct Wind: Decodable, Hashable{
            var speed: Double
            var deg: Int
        }
    }
    
    
}


