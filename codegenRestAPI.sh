# 스크립트 작성 : 박동권(dk@devrock.co.kr)

# 현재 내 파일이 있는 위치로 이동(.sh)
cd $(dirname "$0")
# use swift4 + rxswift

swagger-codegen generate -i http://boostdev.lysn.com/v2/api-docs?group=API -l swift4 -c codegen-config.json -o BoostMINI
