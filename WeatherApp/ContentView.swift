//
//  ContentView.swift
//  WeatherApp
//
//  Created by kalyan on 3/27/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = WeatherDataViewModel()
    @State private var cityName = ""
    var body: some View {
        NavigationStack {
            VStack{
                if viewModel.isLoading{
                    ProgressView("Loading weather")
                }else if viewModel.weather == nil{
                    ContentUnavailableView("No Weather",systemImage: "sun.max", description: Text("sorry it seems the weather doesn't like you"))
                }else{
                    VStack(spacing: 24){
                      
                        Text(viewModel.weather?.name ?? "None")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        
                        VStack(spacing: 4) {
                            Text(viewModel.weather?.weather.first?.main ?? "")
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
            Task{await viewModel.fetchData(city: cityName)}
        }
        .padding()
    }
}



#Preview {
    ContentView()
}
