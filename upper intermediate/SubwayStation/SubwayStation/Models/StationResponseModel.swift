
struct StationResponseModel:Decodable{
    var stations:[Station] { searchInfo.row } // 바로 사용할 수 있는 변수
    
    
    private let searchInfo:SearchInfoBySubwayNameServiceModel
    enum CodingKeys:String, CodingKey{
        case searchInfo = "SearchInfoBySubwayNameService"
    }
    struct SearchInfoBySubwayNameServiceModel:Decodable{
        var row:[Station] = []
    }
}
struct Station:Decodable{
    let stationName:String
    let lineNumber:String
    
    enum CodingKeys:String, CodingKey{
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
    }
}
