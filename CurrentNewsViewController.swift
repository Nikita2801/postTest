//
//  CurrentNewsViewController.swift
//  TablePostApp
//
//  Created by 1 on 12.11.2021.


import UIKit

class CurrentNewsViewController: UIViewController {
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var nameOfTextLabel: UILabel!

    @IBOutlet weak var curTableView: UITableView!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    var id = 0
    var photos : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        curTableView.dataSource = self
        
        
 // request
        
        getPost { [weak self] posts in
            switch posts {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let posts):
                DispatchQueue.main.async {
                    self?.text.text = posts.text
                    self?.nameOfTextLabel.text = posts.title
                    let photo = posts.images
                    if photo.isEmpty == false {
                    self?.photos = photo
                        self!.curTableView.reloadData()
                    }
                    print(photo)
                    
                    if let timeResult = (Double(posts.timeshamp) as? Double) {
                        let date = Date(timeIntervalSince1970: timeResult)
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
                        dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
                        dateFormatter.timeZone = .current
                        let localDate = dateFormatter.string(from: date)
                        self!.dateLabel.text = "\(localDate)"
                    }
                    self?.likeButton.titleLabel?.text = "\(posts.likesCount)"
            }
        }
        
            }
        
    }





// Request function
private let session = URLSession.shared
func getPost(completion: @escaping ((Result<PostCurrent, Error>) -> Void)) {
    let baseUrl: URL  = getUrl(id: id)
    let request = getRequest(url: baseUrl, method: "GET", data: nil)
    session.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        guard (response as? HTTPURLResponse) != nil else { return }
        
        if let data = data {
            do {
                let postResponses = try JSONDecoder().decode(PostId.self, from: data)
                completion(.success(postResponses.post))
            } catch {
                completion(.failure(error))
            }
        }
        
    }
    .resume()
}



    private func getRequest(url: URL, method: String, data: Data?) -> URLRequest {
    var request = URLRequest(url: url)
    
    request.httpBody = data
    request.httpMethod = method
    
    return request
}
   private func getUrl (id: Int) -> URL {
       if id == 116 {
           fatalError()
       }
        let url: URL = URL(string: "https://raw.githubusercontent.com/aShaforostov/jsons/master/api/posts/\(id).json")!
       
        return url
    }

}

// Extension TableView
extension CurrentNewsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? CurrentTableViewCell else { fatalError()}
     
        let url = URL(string: photos[indexPath.row])
        if let data = try? Data(contentsOf: url!) {
            cell.photosView.image = UIImage(data: data)
        }
        
        return cell
    }
    
    
}


