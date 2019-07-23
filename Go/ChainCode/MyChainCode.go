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
