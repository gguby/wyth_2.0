## 개발환경세팅
### 소스 설치 후 최초 수행해야 하는 작업들에 대한 가이드
- cocoaPod
	- `pod install` 이 필요합니다.
- templates
	- 고유 스타일가이드의 팔레트 및 기타 개발을 줄 수 있는 파일템플릿을 사용합니다.
	- BoostMINI/BoostMINI/Resources 디렉토리의 `installEnv.sh` 을 실행해주시면 자동으로 설정됩니다.
- restAPI의 Model은 swagger-codegen을 사용합니다.
    - `codegenRestAPI.sh` 를 실행하시면 최신의 API를 기반으로 모델이 다시 생성됩니다.
     이는 Classes/Model/Generated에 자동으로 복사되며,
     관련 처리 파일들은 Libraries/Swaggers 로 복사됩니다.
     
