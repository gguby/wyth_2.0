
//mkdir -p ~/Library/Developer/Xcode/Templates/Custom 해당 폴더에 .xctemplate 폴더 복사

import Foundation
import Moya

enum ___FILEBASENAME___ {
    case getPhotos
}

extension ___FILEBASENAME___ : TargetType {
    var baseURL: URL {
        return URL(string: "https://api.flickr.com/")!
    }
    
    var path: String {
        switch self {
        case .getPhotos:
            return "services/feeds/photos_public.gne"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getPhotos:
            return .requestParameters(parameters: ["format" : "json", "nojsoncallback" : 1], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
