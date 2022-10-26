//
//  443JSONParsingSol.swift
//
//
//  Created by Katie Lin on 9/27/22.
//

import Foundation

let forecastURL: NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=40.443229&lon=-79.944137&APPID=ad83d72d867862de7a87faec3178ffa6")!

let data = NSData(contentsOf: forecastURL as URL)!

var results = [(key: AnyObject, value: AnyObject)]()

do {
  let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
  as! [String:AnyObject]

  if let mainForecast = json["main"] as? NSDictionary {
    for item in mainForecast {
      results.append(item as! (key: AnyObject, value: AnyObject))
    }
  }
  
  let t = results[4].value
  print("Temp is \(t)")
  
} catch {
  print("error serializing JSON: \(error)")
}

print("  ")
print(results)


print("  ")
//============================//
// Now print the temp line the SwiftyJSON way (if SwiftyJSON already added to repo)

let swiftyjson = try JSON(data: data as Data)
print(swiftyjson)

if let temp_data = swiftyjson["main"]["temp"].float {
  print("Temp is: \(temp_data)")
}



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
  
  enum CodingKeys : String, CodingKey {
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

