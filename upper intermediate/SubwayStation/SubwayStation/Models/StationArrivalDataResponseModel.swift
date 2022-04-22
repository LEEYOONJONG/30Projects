struct StationArrivalDataResponseModel:Decodable{
    var realtimeArrivalList:[RealtimeArrivalList]=[]
    
    struct RealtimeArrivalList:Decodable{
        let line:String
        let remainTime:String
        let currentStation:String
        
        enum CodingKeys:String, CodingKey{
            case line = "trainLineNm"
            case remainTime = "arvlMsg2"
            case currentStation = "arvlMsg3"
        }
    }
}
