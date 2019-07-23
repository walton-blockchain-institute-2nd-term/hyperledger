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
