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
                    Section("Search Details"){
                        TextField("Please Enter Your city name??", text: $cityName)
                    }
                    
                    
                    
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
