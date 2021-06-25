//
//  ViewController.swift
//  DownloadPhoto
//
//  Created by Аэлита Лукманова on 19.06.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        let string = "https://avatars.mds.yandex.net/get-pdb/231404/f30f2d55-3d0e-4a60-b8e2-7dec8dd98dfb/s1200"
        guard let url = URL(string: string) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            print("Done!")
            guard let data = data else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.imageView.image = image
            }
        }
        task.resume()
        
    }


}

