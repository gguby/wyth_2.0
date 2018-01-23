# 스크립트 작성 : 박동권(dk@devrock.co.kr)

# 현재 내 파일이 있는 위치로 이동(.sh)
cd $(dirname "$0")
# use swift4 + rxswift



# brew install swagger-codegen

# brew upgrade swagger-codegen
swagger-codegen version
echo " -> 2.3.0 기준의 스크립트"


# _sedReplace 내부에도 동일 스트링이 있음.
_sedReplace(){
#exit 0;
sed -i '' -e $'s|// Generated by swagger-codegen|// Generated by swagger-codegen\\\n// Modified by dk (dk@devrock.co.kr)|g' $1



sed -i '' -E $'s|public var ([a-zA-Z0-9]*): Any\\?|public var \\1: String?|g' $1

# 얘는 나중에 Sort가 실제로 만들어지면 없애야 하는 코드일 수 있다.
#sed -i '' -e $'s|sort: Sort\\?|sort: String\\?|g' $1


sed -i '' -e $'s|public var autowireCapableBeanFactory: AutowireCapableBeanFactory?|// public var autowireCapableBeanFactory: AutowireCapableBeanFactory?|g' $1
sed -i '' -e $'s|public var parentBeanFactory: BeanFactory?|// public var parentBeanFactory: BeanFactory?|g' $1


sed -i '' -e $'s|public var parentBeanFactory: BeanFactory?|// public var parentBeanFactory: BeanFactory?|g' $1


sed -i '' -E $'s|public typealias ([a-zA-Z0-9]*) = Any|// public typealias \\1 = Any|g' $1

#// decoder.dataDecodingStrategy = .base64Decode
#// eecoder.dataEncodingStrategy = .base64Encode
sed -i '' -e $'s|dataDecodingStrategy = .base64Decode|dataDecodingStrategy = .base64|g' $1
sed -i '' -e $'s|dataEncodingStrategy = .base64Encode|dataEncodingStrategy = .base64|g' $1

#// encoder.outputFormatting = (prettyPrint ? .prettyPrinted : .compact)
sed -i '' -e $'s|(prettyPrint ? .prettyPrinted : .compact)|.prettyPrinted|g' $1

sed -i '' -e $'s|if let value: String = nillableValue|if let value: String = nillableValue as? String|g' $1
sed -i '' -e $'s|_value: String?)) -> URLQueryItem in|_value: Any?)) -> URLQueryItem in|g' $1

sed -i '' -e $'s|encodeIfPossible(value)|encodeIfPossible(value) as! String|g' $1
#sed -i '' -e $'s|_value: String?)) -> URLQueryItem in|_value: Any?)) -> URLQueryItem in|g' $1


sed -i '' -e $'s|observer.on(.next())|// observer.on(.next())|g' $1

sed -i '' -e $'s|(xAPPVersion: String, xDevice: String, acceptLanguage: String, |(|g' $1
sed -i '' -e $'s|(xAPPVersion: String, xDevice: String, acceptLanguage: String)|()|g' $1
sed -i '' -e $'s|(xAPPVersion: xAPPVersion, xDevice: xDevice, acceptLanguage: acceptLanguage, |(|g' $1
sed -i '' -e $'s|(xAPPVersion: xAPPVersion, xDevice: xDevice, acceptLanguage: acceptLanguage)|()|g' $1
                 


#sed -i '' -e $'s|required public init(method: String, URLString: String, parameters: [String:Any]?,|required public init(method: String, URLString: String, parameters: [String:String]?,|g' $1


# sed -i '' -e $'s|import Foundation|import Foundation\\\nimport Alamofire|g' $1
#sed -i '' -E $'s|([a-zA-Z0-9]*): Codable {|\\1: BaseModel {\\\n	// autogen apiList protocol\\\n	static var apiList: [String: APIRequest] = \\1.buildApiRequests()\\\n|g' $X

sed -i '' -E $'s|([a-zA-Z0-9]*): Codable {|\\1: EasyCodable {\\\n|g' $X

#echo "check file : $1"
}


rm -rf BoostMINI/BoostMINI/Classes/Swaggers
rm -rf BoostMINI/BoostMINI/Libraries/Swaggers
rm -rf BoostMINI/BoostMINI/Classes/Model/Generated

swagger-codegen generate -i http://boostdev.lysn.com/v2/api-docs?group=API -l swift4 -c codegen-config.json -o BoostMINI

# # // Classes 디렉토리보다는 Libraries 디렉토리가 더 어울린다.
echo "move files from 'BoostMINI/BoostMINI/Classes/Swaggers' to 'BoostMINI/BoostMINI/Libraries/Swaggers'..."


mkdir BoostMINI/BoostMINI/Libraries/Swaggers 2>>/dev/null
mkdir BoostMINI/BoostMINI/Classes/Model/Generated 2>>/dev/null



#cp -R BoostMINI/BoostMINI/Classes/Swaggers BoostMINI/BoostMINI/Classes/Model/SwaggersOriginal


# Any 타입은 Codable에 있으면 안된다. 임의로 String으로 바꿔준다.
# BeanFactory애들 제거해준다.
# Sort 등으로 Type변경된 아이들도 제거해준다.
#echo "Part 1"
for X in BoostMINI/BoostMINI/Classes/Swaggers/*.swift; do _sedReplace $X; done;


for X in BoostMINI/BoostMINI/Classes/Swaggers/CodableHelper.swift; do
# 파일 1개다. 이미 위에서 _sedReplace 는 된 녀석이다.
#head -n 20 $X

# data, date ...
# Decoding, Encoding ...

# 2.3.0 removed
#sed -i '' -E $'s|\.(date[De|En]*codingStrategy) =|.\\1 = .formatted(DateFormatter.jsonDate)	//|g' $X;



# data 는 그냥 주석처리만
sed -i '' -e $'s|decoder.dataDecodingStrategy|//decoder.dataDecodingStrategy|g' $X;
sed -i '' -e $'s|encoder.dataEncodingStrategy|//encoder.dataEncodingStrategy|g' $X;


# sed로 엄두도 안나고 해서 얘는 perl로 변환.
REPLACE_CODABLE_HELPER='returnedDecodable = try decoder.decode(type, from: data) \
        } catch { \
			let json = String.init(data: data, encoding: .utf8) ?? "" \
 \
 \
			if let decodingError = error as? DecodingError {  \
				switch(decodingError) {  \
				case .dataCorrupted: // (let err) \
					for format in [DateFormatter.jsonDate2, DateFormatter.jsonDate3, DateFormatter.jsonDate4] { \
						let decoder = JSONDecoder() \
						decoder.dateDecodingStrategy = .formatted(format) \
						if let obj = try? decoder.decode(type, from: data) { \
							returnedDecodable = obj \
							returnedError = nil \
							break \
						} \
					} \
					// TODO: 에러는 나지 않으나 변환이 제대로 안된다..... \ 
					return (returnedDecodable, returnedError) \
				default:  \
					break  \
				}  \
			} \
			logVerbose("ERROR : data = \\(json)") \
			logVerbose("ERROR : \\(error)") \
			'

perl -i -p0e "s|returnedDecodable = try decoder\.decode\(type, from: data\)[^\}]*\} catch \{|$REPLACE_CODABLE_HELPER|s" "$X";

done;


for X in BoostMINI/BoostMINI/Classes/Swaggers/AlamofireImp*.swift; do
# AlamofireImplementations.swift 하나
sed -i '' -E $'s|let validatedRequest = request\\.validate\\(\\)|logRequest(request)	// logging curl prompt\\\n        let validatedRequest = request.validate()|g' $X;
done;


for X in BoostMINI/BoostMINI/Classes/Swaggers/JSONEncodable*.swift; do
# JSONEncodableEncoding.swift 하나
# 코드내에 2줄이 있기때문에 2개가 다 바뀐다.사실 guard let else { ... } 내부의 것만 치환하면 된다.
sed -i '' -e 's|return urlRequest|return urlRequest.asURLRequestWithParams(parameters)|g' $X;
sed -i '' -e 's|private static let jsonDataKey = "jsonData"|static let jsonDataKey = "jsonData"|g' $X;

done;




#echo "Part 2"
for X in BoostMINI/BoostMINI/Classes/Swaggers/APIs/*.swift; do _sedReplace $X;
#echo "[$X] GO"
#head -n 20 $X

#2.3.0 added
sed -i '' -e $'s|open class _API {|extension DefaultAPI {|g' $X;

sed -i '' -E $'s|open class ([a-zA-Z0-9]*API) {|open class \\1 {\\\n	internal static var xAPPVersion: String = BSTApplication.shortVersion ?? "unknown"\\\n	internal static var xDevice: String        = "ios"\\\n	internal static var acceptLanguage: String = "ko-KR"\\\n	internal static let uniqueIndicatorKey    = "codegenDK-\\1"\\\n|g' $X;

sed -i '' -e $'s|completion(response?.body, error);|completion(response?.body, BSTErrorBaker.errorFilter(error, response))|g' $X;
sed -i '' -e $'s|observer.on(.error(error as Error))|observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))|g' $X;

	
sed -i '' -E $'s|_ error: Error\\?) -> Void)) \\{|_ error: Error?) -> Void)) {\\\n		BSTFacade.ux.showIndicator(uniqueIndicatorKey)|g' $X;
sed -i '' -E $'s|execute \\{ \\(response, error\\) -> Void in|execute { (response, error) -> Void in\\\n		BSTFacade.ux.hideIndicator(uniqueIndicatorKey)|g' $X;

sed -i '' -E $'s|let parameters = JSONEncodingHelper\\.encodingParameters\\(forEncodableObject: (.*)\\)|let parameters: Parameters? = ["\\1": \\1]|g' $X;


done;

#2.3.0 added
mv BoostMINI/BoostMINI/Classes/Swaggers/APIs/_API.swift BoostMINI/BoostMINI/Classes/Swaggers/APIs/DefaultAPI2.swift

#echo "Part 3"
for X in BoostMINI/BoostMINI/Classes/Swaggers/Models/*.swift; do _sedReplace $X; done;


mv BoostMINI/BoostMINI/Classes/Swaggers/*.swift BoostMINI/BoostMINI/Libraries/Swaggers
cp -R BoostMINI/BoostMINI/Classes/Swaggers/* BoostMINI/BoostMINI/Classes/Model/Generated/

rm -rf BoostMINI/BoostMINI/Classes/Swaggers





#2>>/dev/null
echo ""
echo "finished."

