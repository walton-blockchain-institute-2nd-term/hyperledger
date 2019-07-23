# MyNetwork 구성
## fabric-samples 폴더 안에 폴더 생성 후 이동
```cmd
mkdir my-network && cd my-network
```
## 폴더 3개 생성 (network,chaincode,application)
```cmd
mkdir network
mkdir chaincode
mkdir application
```
## basic-network의 내용 복사
- config 폴더
- crypto-config 폴더
- configtx.yaml
- connection.yaml
- crypto-config.yaml
- docker-compose.yml
- generate.sh
- start.sh
- teardown.sh

## application 디렉토리 안에는 fabcar/javascript 디렉토리 안에 있는 모든걸 복사
fabric-samples/fabcar
## chaincode 디렉토리 안에 MyChainCode.go 생성
### MyChainCode.go 생성
```cmd
touch MyChainCode.go
code .
작성
```
``` mychaincode.go
package main

//외부 모듈 추가
import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/protos/peer"
)

// 체인코드 구조체 주가
type SimpleAsset struct {
}

// 1. Init 함수 구현
func (t *SimpleAsset) Init(stub shim.ChaincodeStubInterface) peer.Response {
	args := stub.GetStringArgs()
	if len(args) != 2 {
		return shim.Error("Incorrect arguments. Expecting a key and a value")
	}
	err := stub.PutState(args[0], []byte(args[1]))
	if err != nil {
		return shim.Error(fmt.Sprintf("Falied to create asset: %s", args[0]))
	}
	return shim.Success(nil)
}

// 2. Invoke함수 구현
func (t *SimpleAsset) Invoke(stub shim.ChaincodeStubInterface) peer.Response {
	// 함수와 파라미터 값을 저장
	fn, args := stub.GetFunctionAndParameters()
	// result는 문자열 타입, err는 에러 타입
	var result string
	var err error
	// 함수의 형태가 set이거나 get의 값을 불러오는 함수
	if fn == "set" {
		result, err = set(stub, args)
	} else {
		result, err = get(stub, args)
	}
	// 에러가 존재하면, 에러 전송
	// nil 은 null 을 의미함 , C에서는 null은 0을 의미하지만, go에서는 0이 아님 비어있지 않다로 해석해야할듯
	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success([]byte(result))
}

// set 함수는 체인코드 인터페이스와, 매개변수를 문자열로 받아오고 리턴값으로는 스트링과 에러를 반환한다.
func set(stub shim.ChaincodeStubInterface, args []string) (string, error) {
	// 들어온 매개변수가 2개가 아니면 종료한다.
	if len(args) != 2 {
		return "", fmt.Errorf("Incorrect arguments. Expecting a key and a value")
	}
	// putstate 를 진행하고 에러 발생시 에러에 저장한다.
	err := stub.PutState(args[0], []byte(args[1]))
	// 에러 출력한다.
	if err != nil {
		return "", fmt.Errorf("Failed to set asset : %s", args[0])
	}
	// 1번째 방에있는 매개변수와 에러가 발생하지 않았다는 nil을 리턴한다.
	return args[1], nil
}

// get 함수, 매개변수는 하나여야하고 리턴값으로 스트링 에러 발생한다
func get(stub shim.ChaincodeStubInterface, args []string) (string, error) {
	if len(args) != 1 {
		return "", fmt.Errorf("Incorrect arguments. Expecting a key and a value")
	}
	value, err := stub.GetState(args[0])
	// 에러 출력한다.
	if err != nil {
		return "", fmt.Errorf("Failed to set asset : %s", args[0])
	}
	if value == nil {
		return "", fmt.Errorf("Asset not found : %s", args[0])
	}
	return string(value), nil
}

func main() {
	if err := shim.Start(new(SimpleAsset)); err != nil {
		fmt.Printf("Error starting SimpleAsset chaincode : %s", err)
	}
}
```
# 소스코드 작성 이후 go 외부 라이버러리 임포트 
# ( chaincode 폴더 내부에서 진행되어야 합니다. )
```cmd
go get -u "github.com/hyperledger/faabric/core/chaincode/shim"
go build
```

# network 내용 변경
docker-compose.yml 파일에서 cli 부분에 volume 쪽으로 가면 chaincode 의 위치가 나와있다.
이 위치가 달라질 경우 해당 경로를 변경해주어야한다. 

```shell
# chaincode install
docker exec cli peer chaincode install -n mychaincode -v 1.0 -p github.com/

# chaincode instantiate
docker exec cli peer chaincode instantiate -n mychaincode -v 1.0 -C mychannel -c '{"Args":["name","hansol"]}' -P 'OR ("Org1MSP.member")'
sleep 5

# chaincode query name
docker exec cli peer chaincode query -n mychaincode -C mychannel -c '{"Args":["get","name"]}'

# chaincode invoke FS
docker exec cli peer chaincode invoke -n mychaincode -C mychannel -c '{"Args":["set","FS","260"]}'
sleep 5

# chaincode query FS
docker exec cli peer chaincode query -n mychaincode -C mychannel -c '{"Args":["get","FS"]}'
```

# docker 실행
docker exec cli bash
```docker
# upgrade 부분
peer chaincode list --installed
peer chaincode install -n mychaincode -v 1.1 -p github.com
peer chaincode list -- installed
peer chaincode upgrade -n mychaincode -v 1.1 -C mychannel -c '{"Args":["a","100"]}' -P 'OR ("Org1MSP.member")'
peer chaincode query -n mychaincode -C mychannel -c '{"Args":["getAllKeys"]}'
```
