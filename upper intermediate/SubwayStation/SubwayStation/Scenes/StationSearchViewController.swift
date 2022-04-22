import SnapKit
import UIKit
import Alamofire

class StationSearchViewController: UIViewController {
    private var stations:[Station] = []
    private var searchText:String = ""
    private var searchButtonTapped:Bool = false
    private lazy var tableView:UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableViewLayout()
        setNavigationItems()
    }
    
    private func setTableViewLayout(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    private func setNavigationItems(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "지하철 도착 정보"
        
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지하철역을 입력해주세요."
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    private func requestStationName(from stationName:String){
        let urlString = "http://openapi.seoul.go.kr:8088/sample/json/SearchInfoBySubwayNameService/1/5/\(stationName)/"
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationResponseModel.self){ [weak self] response in
                guard
                    let self = self,
                    case .success(let data) = response.result else { return }
                self.stations = data.stations
                self.stations = self.stations.sorted(by: {$0.lineNumber < $1.lineNumber})
                self.tableView.reloadData()
            }
            .resume()
    }
}

extension StationSearchViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = stations[indexPath.row].stationName
        cell.detailTextLabel?.text = stations[indexPath.row].lineNumber
        return cell
    }
}

extension StationSearchViewController:UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
        tableView.reloadData()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchButtonTapped {
            tableView.isHidden = false
            searchButtonTapped = false // initialize
        } else {
            tableView.isHidden = true
        }
        stations = []
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestStationName(from: searchText)
        self.searchText = searchText
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("검색 : ", searchText)
        requestStationName(from: searchText)
        searchButtonTapped = true
    }
}
extension StationSearchViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.row]
        let vc = StationDetailViewController(station: station)
        navigationController?.pushViewController(vc, animated: true)
    }
}
