#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# e: shell script가 실행될 때 모든 라인의 실행 결과를 검사해서 에러가 발생한 경우 바로 스크립트 실행을 종료
# v: 실행을 위해 읽은 명령을 화면에 모두 표시
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

# docker-compose.yml 속성 파일을 읽어 속성 파일 내 정의된 모든 실행중인 컨테이너를 중지
docker-compose -f docker-compose.yml down
# docker-compose.yml 속성 파일 내 정의된 이미지 중 ca, orderer, peer, couchdb를 실행하여 컨테이너로 동작하게 함
docker-compose -f docker-compose.yml up -d ca.example.com orderer.example.com peer0.org1.example.com couchdb
docker ps -a

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
# 하이퍼레저 패브릭 시작 대기 시간(초)
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# *확인 필요 peer0에게 MSP(Membership Service Providers) 권한 부여 후 channel.tx 파일로부터 channel 생성
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel create -o orderer.example.com:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx
# peer0을 생성한 channel에 join
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.example.com/msp" peer0.org1.example.com peer channel join -b mychannel.block
