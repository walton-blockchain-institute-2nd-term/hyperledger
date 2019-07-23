# 하이퍼렛저

## 하이퍼렛저 참고자료
### 해당 자료에 대한 무단 배포를 금합니다 ㅎㅎ 본인만 사용하시고 주변 사람들에게 전파는 절대 금합니다.
### 법적 제제들어오시면 .. ㅎ
- https://drive.google.com/drive/folders/12ilNZ9CTT5ZoHNMWYJY1rhiCxFqWEopi?usp=sharing

# 하이퍼레저 실습 내용 정리
## 강사님 자료 링크 ( 이건 실습 자료니까 가져가서 사용하셔도 됩니다. )
- https://drive.google.com/open?id=1NSjD7hxcKRbE7PWKXBKoFSivB6CP5a94

## ubuntu 16.04 LTS 로 설치
``` cmd
// docker 설치
sudo apt install docker.io
sudo apt install docker-compose
sudo apt install software-properties-common
// 사용자 권한 주기
sudo usermod -aG docker $USER
// reboot
rebooting
```

## Curl , Node.js , Go 설치
``` cmd
// curl 설치
sudo apt-get install curl
// 패키지 매니저 업데이트
sudo apt-get update
sudo apt-get install build-essential libssl-dev
// nvm 설치
curl -sL https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh -o install_nvm.sh
bash install_nvm.sh
source ~/.profile
nvm install v8.11.1
// Go 설치
curl -O https://storage.googleapis.com/golang/go1.11.2.linux-amd64.tar.gz
// 압축 풀기
tar -xvf go1.11.2.linux-amd64.tar.gz
// 압축 해제를 통해 얻은 go 디렉토리를 /usr/local 경로로 이동
sudo mv go /usr/local
// /usr/local/go/bin/go 디렉토리에 대한 링크(바로가기)를 /usr/local/bin/go에 연결
sudo ln -s /usr/local/go/bin/go /usr/local/bin/go
gedit ~/.profile
// 제일 밑에 추가하는부분
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
source ~/.profile
```

## 파이썬, GIT 설치( 설치가 안되어 있는 경우에만 해당 )
```
sudo apt install -y python
sudo apt install -y git
```
또는
```
sudo apt install -y python git
```

## 하이퍼렛저 패브릭 설치
```cmd
sudo curl -sSL http://bit.ly/2ysbOFE | bash -s
vi ~/.profile
// 아까 추가한 부분 수정
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin:~/fabric-samples/bin
source ~/.profile
```


## 잠깐 Tip!
## fabcar , comercial-paper 을 이용해서 프로젝트 진행하는 편이 초급 단계에서는 좋음
## 프로젝트 진행을 할 때에는 기존의 것을 활용해서 하자

# 하이퍼렛저 패브릭 fabcar 실행 명령 순서
1. 패브릭 설치시 fabric-samples도 설치가 된다. 
2. cd fabric-samples에 있는 fabcar 폴더로 이동하고, 이 곳에서 startFabric.sh를 실행한다.
  ``` cmd
  // 폴더이동
  cd fabric-samples/fabcar
  ./startFabric.sh
  ```
3. 자바스크립트 폴더로 이동해서 기존에 설치 되어있던 wallet 폴더를 삭제하고, package.json 설치를 진행한다.
``` cmd
// 폴더이동
cd javascript
// wallet 폴더 삭제
rm -rf wallet
// package.json install
npm install package.json
// admin 등록
node enrollAdmin.js
// user 등록
node registerUser.js
// 쿼리 조회
node query.js
// 등록 
node invoke.js
// 이후 확인 조회
node query.js 
```
