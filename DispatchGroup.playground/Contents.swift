import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


class DispatchGroupTest1 {
    private let queueSerial1 = DispatchQueue(label: "HI")
    private let groupRed = DispatchGroup()
    
    func loadInfo() {
        queueSerial1.async(group: groupRed) {
            sleep(2)
            print("1")
        }
        
        queueSerial1.async(group: groupRed) {
            sleep(2)
            print("2")
        }
        
        groupRed.notify(queue: .main) {
            print("groupRed finished all")
        }
    }
}

let dispatchGroupTest1 = DispatchGroupTest1()
//dispatchGroupTest1.loadInfo()


class DispatchGroupTest2 {
    private let queueConcurrent = DispatchQueue(label: "HI concurrent", attributes: .concurrent)
    private let groupBlack = DispatchGroup()
    
    func loadInfo() {
        groupBlack.enter()
        //помещаем этот блок кода в группу
        queueConcurrent.async {
            sleep(2)
            print("1")
            self.groupBlack.leave()
        }
        
        groupBlack.enter()
        queueConcurrent.async {
            sleep(9)
            print("2")
            self.groupBlack.leave()
        }
        
        groupBlack.wait()
        print("Finished")
        
        groupBlack.notify(queue: .main) {
            print("groupBlack finished all")
        }
    }
}

let dispatchGroupTest2 = DispatchGroupTest2()
dispatchGroupTest2.loadInfo()


class EightImage : UIView {
    public var ivs = [UIImageView]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 20, width: 20, height: 20)))
        ivs.append(UIImageView(frame: CGRect(x: 20, y: 0, width: 20, height: 20)))
        ivs.append(UIImageView(frame: CGRect(x: 20, y: 20, width: 20, height: 20)))
        
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 50, width: 20, height: 20)))
        ivs.append(UIImageView(frame: CGRect(x: 0, y: 70, width: 20, height: 20)))
        ivs.append(UIImageView(frame: CGRect(x: 20, y: 50, width: 20, height: 20)))
        ivs.append(UIImageView(frame: CGRect(x: 20, y: 70, width: 20, height: 20)))
        
        for i in 0..<8 {
            ivs[i].contentMode = .scaleAspectFit
            self.addSubview(ivs[i])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

var view = EightImage(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
view.backgroundColor = .red

let imageURLs = ["https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg", "http://bestkora.com/IosDeveloper/wp-content/uploads/2016/12/Screen-Shot-2017-01-17-at-9.33.52-PM.png", "http://adriatic-lines.com/wp-content/uploads/2015/04/canal-of-Venice.jpg", "http://adriatic-lines.com/wp-content/uploads/2015/04/1024px-Venice_Carnival_-_Masked_Lovers_2010.jpg"]
var images = [UIImage]()

PlaygroundPage.current.liveView = view

//этот метод достает только по одной картинке
func asyncLoadImage(imageURL : URL, runQueue : DispatchQueue, completionQueue : DispatchQueue, completion : @escaping(UIImage?, Error?)->()) {
    runQueue.async {
        do {
            let data = try Data(contentsOf: imageURL)
            completionQueue.async {
                completion(UIImage(data: data), nil)
            }
        } catch let error {
            completionQueue.async {
                completion(nil, error)
            }
        }
    }
}


//этот метод создает группу асинхронных операций
func asyncGroup() {
    let aGroup = DispatchGroup()
    
    for i in 0..<4 {
        aGroup.enter()
        asyncLoadImage(imageURL: URL(string: imageURLs[i])!, runQueue: .global(), completionQueue: .main) { resImage, error in
            guard let image = resImage else { return }
            images.append(image)
            aGroup.leave()
        }
    }
    
    aGroup.notify(queue: .main) {
        for i in 0..<4 {
            view.ivs[i].image = images[i]
        }
    }
}
asyncGroup()

// работа асинхронности видна(загружаются как пришел ответ, в хаотичном порядке) Те без группы все получается некрасиво
func asyncUrlSession() {
    for i in 4..<8 {
        let url = URL(string: imageURLs[i-4])
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                view.ivs[i].image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
asyncUrlSession()
