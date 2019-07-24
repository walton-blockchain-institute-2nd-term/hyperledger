#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error
# shell script가 실행될 때 모든 라인의 실행 결과를 검사해서 에러가 발생한 경우 바로 스크립트 실행을 종료
set -e

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

starttime=$(date +%s)
# chaincode language를 go로 설정
CC_SRC_LANGUAGE=${1:-"go"}
# CC_SRC_LANGUAGE 변수의 값을 소문자로 모두 변경
CC_SRC_LANGUAGE=`echo "$CC_SRC_LANGUAGE" | tr [:upper:] [:lower:]`
# CC_SRC_LANGUAGE 변수의 값이 "go" 이거나, "golang"인 경우
if [ "$CC_SRC_LANGUAGE" = "go" -o "$CC_SRC_LANGUAGE" = "golang"  ]; then
	# golang을 사용해서 경로상에 존재하는 chaincode를 설치, 배포, 실행하기 위해 미리 변수에 할당
  CC_RUNTIME_LANGUAGE=golang
	CC_SRC_PATH=github.com/fabcar/go
# CC_SRC_LANGUAGE 변수의 값이 "javascript"인 경우
elif [ "$CC_SRC_LANGUAGE" = "javascript" ]; then
  # node.js를 사용해서 경로상에 존재하는 chaincode를 설치, 배포, 실행하기 위해 미리 변수에 할당
	CC_RUNTIME_LANGUAGE=node
	CC_SRC_PATH=/opt/gopath/src/github.com/fabcar/javascript
elif [ "$CC_SRC_LANGUAGE" = "typescript" ]; then
  # typescript는 node.js의 typescript 관련 모듈을 이용해서 실행하기 때문에 미리 일련의 과정을 수행
	CC_RUNTIME_LANGUAGE=node
	CC_SRC_PATH=/opt/gopath/src/github.com/fabcar/typescript
	echo Compiling TypeScript code into JavaScript ...
  pushd ../chaincode/fabcar/typescript
  # 경로상의 package.json에 지정된 모듈을 모두 설치
	npm install
  # package.json의 build script를 수행
	npm run build
  popd
	echo Finished compiling TypeScript code into JavaScript
else
	echo The chaincode language ${CC_SRC_LANGUAGE} is not supported by this script
	echo Supported chaincode languages are: go, javascript, and typescript
	exit 1
fi


# key store file을 삭제
rm -rf ./hfc-key-store

# 네트워크를 생성하는 shell script를 실행. channel을 만들고 peer를 join.
cd ../network
./start.sh

# chaincode를 설치하고 배포하기 위해서 CLI container를 실행
docker-compose -f ./docker-compose.yml up -d cli
docker ps -a

# chaincode 설치
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode install -n fabcar -v 1.0 -p "$CC_SRC_PATH" -l "$CC_RUNTIME_LANGUAGE"
# chaincode 배포
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode instantiate -o orderer.example.com:7050 -C mychannel -n fabcar -l "$CC_RUNTIME_LANGUAGE" -v 1.0 -c '{"Args":[]}' -P "OR ('Org1MSP.member','Org2MSP.member')"
sleep 10
# chaincode 실행(chaincode의 initLedger함수 호출)
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"initLedger","Args":[]}'

cat <<EOF

Total setup execution time : $(($(date +%s) - starttime)) secs ...

Next, use the FabCar applications to interact with the deployed FabCar contract.
The FabCar applications are available in multiple programming languages.
Follow the instructions for the programming language of your choice:

JavaScript:

  Start by changing into the "javascript" directory:
    cd javascript

  Next, install all required packages:
    npm install

  Then run the following applications to enroll the admin user, and register a new user
  called user1 which will be used by the other applications to interact with the deployed
  FabCar contract:
    node enrollAdmin
    node registerUser

  You can run the invoke application as follows. By default, the invoke application will
  create a new car, but you can update the application to submit other transactions:
    node invoke

  You can run the query application as follows. By default, the query application will
  return all cars, but you can update the application to evaluate other transactions:
    node query

TypeScript:

  Start by changing into the "typescript" directory:
    cd typescript

  Next, install all required packages:
    npm install

  Next, compile the TypeScript code into JavaScript:
    npm run build

  Then run the following applications to enroll the admin user, and register a new user
  called user1 which will be used by the other applications to interact with the deployed
  FabCar contract:
    node dist/enrollAdmin
    node dist/registerUser

  You can run the invoke application as follows. By default, the invoke application will
  create a new car, but you can update the application to submit other transactions:
    node dist/invoke

  You can run the query application as follows. By default, the query application will
  return all cars, but you can update the application to evaluate other transactions:
    node dist/query

EOF
