package main

//외부 모듈 추가
import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
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
