//
//  ContentView.swift
//  WeatherApp
//
//  Created by kalyan on 3/27/26.
//

import SwiftUI
import CoreLocation

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

struct ContentView: View {
    @State private var viewModel = WeatherDataViewModel()
    @State private var cityName = ""
    @State private var forecastModel = ForeCastDataViewModel()
    @State private var locationManager = LocationManager()
    
    private var daily: [ForecastWeather.ForecastItem] {
        forecastModel.weather?.list.filter { $0.dt_txt.contains("12:00:00") } ?? []
    }
    var body: some View {
        NavigationStack {
            VStack{
                if viewModel.isLoading{
                    ProgressView("Loading weather")
                }else if viewModel.weather == nil{
                    ContentUnavailableView("No Weather",systemImage: "sun.max", description: Text("sorry it seems the weather doesn't like you"))
                }else{
                    ScrollView{
                        VStack{
                            Text(viewModel.weather?.name ?? "None")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            
                            VStack(spacing: 4) {
                                Image(systemName:(image(weather: viewModel.weather?.weather.first?.main ?? "")))
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                Text(viewModel.weather?.weather.first?.description ?? "No description")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            
                            Text(String(format: "%.1f°", viewModel.weather?.main.temp ?? 0))
                                .font(.system(size: 64, weight: .thin))
                            
                            
                            VStack(spacing: 12) {
                                HStack {
                                    Text("Feels Like:")
                                        .foregroundStyle(.secondary)
                                    Image(systemName: "thermometer.medium")
                                    Spacer()
                                    Text(String(format: "%.1f°", viewModel.weather?.main.feels_like ?? 0))
                                        .fontWeight(.semibold)
                                }
                                
                                HStack {
                                    Text("Humidity:")
                                        .foregroundStyle(.secondary)
                                    Image(systemName: "humidity.fill")
                                    Spacer()
                                    Text(String(format: "%.0f%%", viewModel.weather?.main.humidity ?? 0))
                                        .fontWeight(.semibold)
                                    
                                }
                                
                                HStack{
                                    Text("WindSpeed").foregroundStyle(.secondary)
                                    Image(systemName: "wind")
                                    
                                    Spacer()
                                    Text("\(String(format: "%.1f",viewModel.weather?.wind.speed ?? 0)) mph")
                                        .fontWeight(.semibold)
                                }
                                Spacer()
                                
                                Section("Forecast Weather"){
                                    ForEach(daily, id: \.self) { forecast in
                                        HStack {
                                            Text(forecast.dt_txt.prefix(10))
                                                .foregroundStyle(.secondary)
                                         
                                            Spacer()
                                            Text(String(format: "%.1f°", forecast.main.temp))
                                                .fontWeight(.semibold)
                                            Image(systemName:image(weather: forecast.weather.first?.main ?? ""))
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .padding()
                        
                    }
                }
                
            }
            .searchable(text: $cityName)
            .onSubmit(of:.search){
                Task{
                    await viewModel.fetchData(city: cityName)
                    await forecastModel.fetchForecast(cityName: cityName)
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        locationManager.requestLocation()
                    } label: {
                        Image(systemName: "location.fill")
                    }
                }
            }
            .onChange(of: locationManager.location) { oldValue, newValue in
                guard let location = newValue else { return }
                Task {
                    await viewModel.fetchData(latitude: location.latitude, longitude: location.longitude)
                    await forecastModel.fetchForecast(latitude: location.latitude, longitude: location.longitude)
                }
            }
            .padding()
        }
    }
    
    func image(weather: String) -> String {
        switch weather{
        case "Clear": return "sun.max.fill"
        case "Clouds": return "cloud.fill"
        case "Rain" : return "cloud.rain.fill"
        case "Snow" : return "cloud.snow.fill"
        case "Thunderstorm": return "cloud.bolt.fill"
        default : return "cloud.fill"
        }
    }
}

#Preview {
    ContentView()
}
