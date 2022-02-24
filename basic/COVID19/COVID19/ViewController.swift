import UIKit
import Charts
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var totalCaseLabel: UILabel!
    @IBOutlet weak var newCaseLabel: UILabel!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var labelStackView: UIStackView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicatorView.startAnimating()
        
        self.fetchCovidOverview(completionHandler: {[weak self] result in
            guard let self = self else { return }
            self.indicatorView.stopAnimating()
            self.indicatorView.isHidden = true
            self.labelStackView.isHidden = false
            self.pieChartView.isHidden = false
            switch result{
            case let .success(result):
                debugPrint("success \(result)")
                self.configureStackView(koreaCovidOverview: result.korea)
                let covidOverviewList = self.makeCovidOverviewList(cityCovidOverview: result)
                self.configureChartView(covidOverviewList: covidOverviewList)
            case let .failure(error):
                debugPrint("failure \(error)")
            }
        })
    }
    
    
    func fetchCovidOverview(
        completionHandler: @escaping (Result<CityCovidOverview, Error>) -> Void // Result<..,..>를 받아 아무것도 리턴하지 않는다는 클로져 변수를 파라미터로 받는다는 말인듯.
    ){
        let url = "https://api.corona-19.kr/korea/country/new/"
        let param = [
            "serviceKey":"bpGJ5NAWecQFBwoDyTL3kgHzVal4Ihrxs"
        ]
        
        AF.request(url, method: .get, parameters: param)
            .responseData(completionHandler: {response in // fetchCovidOverview를 실행하면 completionHandler가 실행되게
                switch response.result{
                case let .success(data):
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(CityCovidOverview.self, from: data)
                        completionHandler(.success(result))
                    } catch {
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }
    func configureStackView(koreaCovidOverview:CovidOverview){
        self.totalCaseLabel.text = "\(koreaCovidOverview.totalCase)명"
        self.newCaseLabel.text = "\(koreaCovidOverview.newCase)명"
    }
    
    func makeCovidOverviewList(cityCovidOverview: CityCovidOverview) //를 전달받을 수 있게
        -> [CovidOverview] { // 반환값이 CovidOverView 배열타입이 되게 만들어주겠습니다.
            
        return [
        //json 응답이 배열이 아닌 한 객체로 오기에 cityCOvidOverview 객체안에 있는 시도별 객체를 배열에 추가시켜주겠다.
            cityCovidOverview.seoul,
            cityCovidOverview.busan,
            cityCovidOverview.daegu,
            cityCovidOverview.incheon,
            cityCovidOverview.gwangju,
            cityCovidOverview.daejeon,
            cityCovidOverview.ulsan,
            cityCovidOverview.sejong,
            cityCovidOverview.gyeonggi,
            cityCovidOverview.chungbuk,
            cityCovidOverview.chungnam,
            cityCovidOverview.gyeongbuk,
            cityCovidOverview.gyeongnam,
            cityCovidOverview.jeju,
        ]
    }
    
    // pie chart
    func configureChartView(covidOverviewList:[CovidOverview]){
        self.pieChartView.delegate = self
        let entries = covidOverviewList.compactMap { [weak self] overview -> PieChartDataEntry? in
            
            guard let self = self else { return  nil}
            return PieChartDataEntry(
                value: self.removeFormatString(string:overview.newCase),
                label: overview.countryName,
                data: overview
            )
        }
        let dataSet = PieChartDataSet(entries: entries, label: "코로나 발생 현황")
        designChartView(dataSet:dataSet)
        self.pieChartView.data = PieChartData(dataSet: dataSet)
    }
    func designChartView(dataSet:PieChartDataSet){
        dataSet.sliceSpace = 1
        dataSet.entryLabelColor = .black // 항목이름이 검정색
        dataSet.valueTextColor = .black // 파이차트 안의 항목도 검정색으로
        dataSet.xValuePosition = .outsideSlice // 항목이름이 파이차트에 표시되게 하지 않고 바깥쪽 선으로 표시되게
        dataSet.valueLinePart1OffsetPercentage = 0.8
        dataSet.valueLinePart1Length = 0.2
        dataSet.valueLinePart1OffsetPercentage = 0.3 // 가독성 좋게끔

        dataSet.colors = ChartColorTemplates.vordiplom() + ChartColorTemplates.joyful()
        + ChartColorTemplates.liberty() + ChartColorTemplates.pastel()
        + ChartColorTemplates.material()//색상 추가하면 파이차트 항목이 다양한 색상으로 표시되게 됨.

        // 현재 앵글에서 80도정도 회전된 상태로 파이차트 표시되게
        self.pieChartView.spin(
            duration: 0.3,
            fromAngle: self.pieChartView.rotationAngle,
            toAngle: self.pieChartView.rotationAngle + 80
        )// 파이차트를 80도정도 회전시켜보겠다.

    }
    func removeFormatString(string:String)->Double{
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: string)?.doubleValue ?? 0
    }
}

extension ViewController:ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let covidDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "CovidDetailViewController") as? CovidDetailViewController else { return }
        guard let covidOverview = entry.data as? CovidOverview else { return }
        covidDetailViewController.covidOverview = covidOverview
        self.navigationController?.pushViewController(covidDetailViewController, animated: true)
    }
}
