import UIKit
import SnapKit
import Alamofire

final class StationDetailViewController:UIViewController{
    private let station:Station
    private var realtimeArrivalList:[StationArrivalDataResponseModel.RealtimeArrivalList] = []
    
    // 주기
    var realTime = Timer()
    var counter:Int = 10
    
    private lazy var refreshControl:UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchData), for: .valueChanged)
        return refreshControl
    }()
    private lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: view.frame.width - 32, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(StationDetailCollectionViewCell.self, forCellWithReuseIdentifier: "StationDetailCollectionViewCell")
        collectionView.dataSource = self
        return collectionView
    }()
    private lazy var timerButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .black)
        button.layer.cornerRadius = 40
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = station.stationName
        
        view.addSubview(collectionView)
        view.addSubview(timerButton)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        timerButton.snp.makeConstraints{
            $0.bottom.trailing.equalToSuperview().inset(16)
            $0.height.width.equalTo(80)
            
        }
        collectionView.refreshControl = refreshControl
        fetchData()
        checkTimeTrigger()
    }
    override func viewDidDisappear(_ animated: Bool) {
        realTime.invalidate()
        counter = 10
    }
    init(station: Station){
        self.station = station
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func fetchData(){
        counter = 10
        var stationName = station.stationName

        if stationName == "이수" || stationName == "총신대입구" {
            stationName = "총신대입구(이수)"
        }
        let urlString = "http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/\(stationName.replacingOccurrences(of: "역", with: ""))"
        print("urlString : ", urlString)
        AF.request(urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            .responseDecodable(of: StationArrivalDataResponseModel.self) { [weak self] response in
                self?.refreshControl.endRefreshing()
                guard case .success(let data) = response.result else { return }
//                print(data.realtimeArrivalList)
                self?.realtimeArrivalList = data.realtimeArrivalList
                self?.collectionView.reloadData()
            }
            .resume()
    }
}
extension StationDetailViewController{
    private func checkTimeTrigger(){
        realTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    @objc private func updateCounter(){
        self.timerButton.setTitle(String(counter), for: .normal)
        if (counter == 0){
            fetchData()
            print("Refreshing Timer Occured !")
        }
        counter -= 1
    }
}
extension StationDetailViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return realtimeArrivalList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StationDetailCollectionViewCell", for: indexPath) as? StationDetailCollectionViewCell
        let realTimeArrival = realtimeArrivalList[indexPath.item]
        cell?.setup(with: realTimeArrival)
        return cell ?? UICollectionViewCell()
    }
}

