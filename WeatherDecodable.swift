//
//  WeatherDecodable.swift
//  
//
//  Created by Katie Lin on 9/27/22.
//

import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let url = "http://api.openweathermap.org/data/2.5/weather?lat=40.443229&lon=-79.944137&APPID=ad83d72d867862de7a87faec3178ffa6"

// Your structs go here
struct Station: Decodable {
  let id: Int
  let name: String
  let forecast: Forecast
  
  enum CodingKeys : String, CodingKey {
    case id
    case name
    case forecast = "main"
  }
}

struct Forecast: Decodable {
  let tempMax: Float
  let tempMin: Float
  let humidity: Int
  let temp: Float
  
  enum codingKeys : String, CodingKey {
    case tempMax = "temp_max"
    case humidity
    case tempMin = "temp_min"
    case temp
  }
}






let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
  guard let data = data else {
    print("Error: No data to decode")
    return
  }
  
  // Decode the JSON here
  guard let station = try? JSONDecoder().decode(Station.self, from: data) else {
    print("Error: Couldn't decode station data")
    return
  }
    
  
  // Output if everything is working right
  print("Station ID: \(station.id)")
  print("Name:       \(station.name)")
  print("---------------------------")
  print("Forecast:")
  print("  Cur Temp: \(station.forecast.temp) K")
  print("  Humidity: \(station.forecast.humidity)%")
  print("  Max Temp: \(station.forecast.tempMax) K")
  print("  Min Temp: \(station.forecast.tempMin) K")

}

task.resume()

