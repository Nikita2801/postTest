//
//  ViewController.swift
//  TablePostApp
//
//  Created by 1 on 11.11.2021.
//
//



// parse new apirequrst and send information to newVc
// how to get picture from url
// how to put all in scroll view , dependency between photos count and size of scrool view
// resize cell by labelHeight
// scrool view tutorial


import UIKit



class ViewController: UIViewController {
    
    
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNav: UIView!
   
    @IBOutlet weak var imageCompany: UIImageView!
    @IBOutlet weak var customNavLAbel: UILabel!
    
    private let service = RawNetworkManager()
    
    
  
    var post : [Post] = []
    var newPost : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        service.getPost { [weak self] posts in
            switch posts {
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                }
            case .success(let posts):
                self?.post = posts
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
        
        
        
    }
    
    
    @IBAction func sort(_ sender: UIButton) {
        if sortButton.titleLabel?.text == "sort by date" {
            newPost = post.sorted( by: { $0.timeshamp > $1.timeshamp } )
            sender.setTitle("sort by like", for: .normal)
            post = newPost
            tableView.reloadData()
        } else {
            newPost = post.sorted( by: { $0.likesCount > $1.likesCount } )
            sender.setTitle("sort by date", for: .normal)
            post = newPost
            tableView.reloadData()
        }
       
    }

    
    
    


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "go", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "go" {
            let indexPath = self.tableView.indexPathForSelectedRow
            guard let vc = segue.destination as? CurrentNewsViewController else {return}
            vc.id = post[indexPath!.row].postID
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        post.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else { fatalError()}

        cell.likeCountLabel.text = "\(post[indexPath.row].likesCount)"
        cell.titleLabel.text = post[indexPath.row].title
        cell.id = post[indexPath.row].postID
        cell.newsTextLabel.text = " " + post[indexPath.row].previewText
      
        tableView.reloadRows(at: [indexPath], with: .fade)
      
        
  //      cell.newsTextLabel.sizeToFit()
        cell.newsTextLabel.numberOfLines = 2
        
        
        if let timeResult = (Double(post[indexPath.row].timeshamp) as? Double) {
            let date = Date(timeIntervalSince1970: timeResult)
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.short //Set date style
            dateFormatter.timeZone = .current
            let localDate = dateFormatter.string(from: date)
            cell.timeLabel.text = "\(localDate)"
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension

    }
}


