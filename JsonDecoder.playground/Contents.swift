import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct SpaceInfo : Decodable {
    
    let number : Int
    let message : String
    let people : [PeopleInfo]
}

struct PeopleInfo : Decodable {
    let name : String
    let craft : String
}

func load() {
    let string = "http://api.open-notify.org/astros.json"
    guard let url = URL(string: string) else { return }
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let data = data else { return }
        guard let result = try? JSONDecoder().decode(SpaceInfo.self, from: data)
        else {
            print("Can't decode data to SpaceInfo structure")
            return
        }
        print("There are \(result.number) people in space")
        for i in 0..<result.number {
            print(i+1, ": ", result.people[i].name, " ", result.people[i].craft)
        }
    }
    task.resume()
}
load()
