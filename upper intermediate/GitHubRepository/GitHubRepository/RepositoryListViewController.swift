import UIKit

class RepositoryListViewController:UITableViewController{
    private let organization = "Apple"
    
    override func viewDidLoad(){
        super.viewDidLoad()
        title = organization + "Repositories"
        self.refreshControl = UIRefreshControl() // 당겨서 새로고침
        let refreshControl = self.refreshControl!
        refreshControl.backgroundColor = .white
        refreshControl.tintColor = .darkGray
        refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")// 표현되는 글자. 인디케이터 아래
        //        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged) // refresh 액션 할 수 있는
        tableView.register(RepositoryListCell.self, forCellReuseIdentifier: "RepositoryListCell")
        tableView.rowHeight = 140
    }
    @objc func refresh(){
        
    }
}
extension RepositoryListViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else { return UITableViewCell() }
        return cell
    }
}
