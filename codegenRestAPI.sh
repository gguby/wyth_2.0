# 스크립트 작성 : 박동권(dk@devrock.co.kr)

# 현재 내 파일이 있는 위치로 이동(.sh)
cd $(dirname "$0")
# use swift4 + rxswift






# _sedReplace 내부에도 동일 스트링이 있음.
_sedReplace(){
#exit 0;
sed -i '' -e $'s|// Generated by swagger-codegen|// Generated by swagger-codegen\\\n// Modified by dk (dk@devrock.co.kr)|g' $1



sed -i '' -E $'s|public var ([a-zA-Z0-9]*): Any\\?|public var \\1: String?|g' $1

# 얘는 나중에 Sort가 실제로 만들어지면 없애야 하는 코드일 수 있다.
sed -i '' -e $'s|sort: Sort\\?|sort: String\\?|g' $1


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
sed -i '' -E $'s|([a-zA-Z0-9]*): Codable {|\\1: BaseModel {\\\n	// autogen apiList protocol\\\n	static var apiList: [String: APIRequest] = \\1.buildApiRequests()\\\n|g' $X

#echo "check file : $1"
}





swagger-codegen generate -i http://boostdev.lysn.com/v2/api-docs?group=API -l swift4 -c codegen-config.json -o BoostMINI

# # // Classes 디렉토리보다는 Libraries 디렉토리가 더 어울린다.
echo "move files from 'BoostMINI/BoostMINI/Classes/Swaggers' to 'BoostMINI/BoostMINI/Libraries/Swaggers'..."

mkdir BoostMINI/BoostMINI/Libraries/Swaggers 2>>/dev/null
mkdir BoostMINI/BoostMINI/Classes/Models/Generated 2>>/dev/null

#cp -R BoostMINI/BoostMINI/Classes/Swaggers BoostMINI/BoostMINI/Classes/Model/SwaggersOriginal


# Any 타입은 Codable에 있으면 안된다. 임의로 String으로 바꿔준다.
# BeanFactory애들 제거해준다.
# Sort 등으로 Type변경된 아이들도 제거해준다.
#echo "Part 1"
for X in BoostMINI/BoostMINI/Classes/Swaggers/*.swift; do _sedReplace $X; done;
#echo "Part 2"
for X in BoostMINI/BoostMINI/Classes/Swaggers/APIs/*.swift; do _sedReplace $X;
sed -i '' -E $'s|open class ([a-zA-Z0-9]*API) {|open class \\1 {\\\n  private static var xAPPVersion: String = BSTApplication.shortVersion ?? "unknown"\\\n  private static var xDevice: String     = "ios"\\\n  private static var acceptLanguage: String = "ko-KR"|g' $X;
sed -i '' -e $'s|completion(response?.body, error);|completion(response?.body, BSTErrorBaker.errorFilter(error, response))|g' $X;
sed -i '' -e $'s|observer.on(.error(error as Error))|observer.on(.error(BSTErrorBaker<Any>.errorFilter(error)!))|g' $X;

done;
#echo "Part 3"
for X in BoostMINI/BoostMINI/Classes/Swaggers/Models/*.swift; do _sedReplace $X; done;


mv BoostMINI/BoostMINI/Classes/Swaggers/*.swift BoostMINI/BoostMINI/Libraries/Swaggers
cp -R BoostMINI/BoostMINI/Classes/Swaggers/* BoostMINI/BoostMINI/Classes/Model/Generated/

#rm -rf BoostMINI/BoostMINI/Classes/Swaggers





#2>>/dev/null
echo ""
echo "finished."

