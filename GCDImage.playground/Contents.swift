import UIKit
import PlaygroundSupport //чтобы не завершался до завершения потоков

class MyViewController  : UIViewController {
    var button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "vc 1"
        view.backgroundColor = UIColor.white
        
        button.addTarget(self, action: #selector(pressedAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        initButton()
    }
    
    @objc func pressedAction() {
        print("pressed")
        let vc = SecondViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func initButton() {
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        button.setTitle("Press", for: .normal)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        view.addSubview(button)
    }
}



class SecondViewController  : UIViewController {
    
    let image = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "vc 2"
        view.backgroundColor = UIColor.white
        
        loadImage()
        //        let imageURL = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
        //
        //        if let data = try? Data(contentsOf: imageURL) {
        //            self.image.image = UIImage(data: data)
        //        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initImage()
    }
    
    func initImage() {
        image.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        image.center = view.center
        view.addSubview(image)
    }
    
    func loadImage() {
        let imageURL = URL(string: "https://www.planetware.com/photos-large/F/france-paris-eiffel-tower.jpg")!
        let queue = DispatchQueue.global(qos: .utility)
        queue.async { //асинхронно, чтобы не мешать главному потоку
            if let data = try? Data(contentsOf: imageURL) {
                DispatchQueue.main.async { //все uiки должны загружаться в главном потоке
                    self.image.image = UIImage(data: data)
                }
            }
        }
    }
}
let vc = MyViewController()
let navBar = UINavigationController(rootViewController: vc)
navBar.view.frame = CGRect(x: 0, y: 0, width: 300, height: 500)
PlaygroundPage.current.liveView = navBar
