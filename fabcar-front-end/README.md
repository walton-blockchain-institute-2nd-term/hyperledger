

# 부수적인 내용들 
## DB종류 
- world state => DB에 저장
- Private Data => DB에 저장 ( 권한이 있는 애들만 가지고 있는다 -> SIDE DB에 대한 내용 )
- blockchain => FILE로 저장
- TransientDB => 다른 Peer에서 사용하려고 할 떄, Push 해주는 용도, 요청한 피어는 Pull 받음
## First-network 안의 구조
byfn.sh
## orderer 
- 블록을 만들어 주는 놈
## orderer 합의 프로세스
- solo 
- kafka
- raft

# TLS
SSL / PKI와 같은 구조
## 간단한 예시로 HTTP, HTTPS의 차이

Web Server <-> Web Client
1. 클라이언트가 서버에 요청, 이때 가장 중요한것은 Method, Url이 가장 중요.
2. 요청에 의해 응답을 HTML + JSON을 전송
이때 그냥 HTTP라면 덤프 떠서 읽으면 알 수 있음

HTTPS -> 암호화 된 통신을 진행함


