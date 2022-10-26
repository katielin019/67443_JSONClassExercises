import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let url = "https://api.github.com/search/repositories?q=language:swift&sort=stars&order=desc"

struct Result: Decodable {
  let totalCount: Int
  let incompleteResults: Bool
  let repos: [Repository]
  
  enum CodingKeys : String, CodingKey {
    case totalCount = "total_count"
    case incompleteResults = "incomplete_results"
    case repos = "items"
  }
}

struct Repository: Decodable {
  let id: Int
  let name: String
  let description: String?
  let htmlURL: String
  
  enum CodingKeys : String, CodingKey {
    case id
    case name
    case description
    case htmlURL = "html_url"
  }
}

let task = URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
    guard let data = data else {
      print("Error: No data to decode")
      return
    }
  
    guard let result = try? JSONDecoder().decode(Result.self, from: data) else {
      print("Error: Couldn't decode data into a result")
      return
  }
  
  print("Total Count: \(result.totalCount)")
  print("---------------------------")
  
  print("Repositories:")
  for repo in result.repos {
    print("- \(repo.name): \(repo.description ?? "N/A")")
  }
  
}

task.resume()
