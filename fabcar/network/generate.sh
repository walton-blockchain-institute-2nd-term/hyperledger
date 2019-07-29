#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export PATH=$GOPATH/src/github.com/hyperledger/fabric/build/bin:${PWD}/../bin:${PWD}:$PATH
export FABRIC_CFG_PATH=${PWD}
CHANNEL_NAME=mychannel

# remove previous crypto material and config transactions
rm -fr config/*
rm -fr crypto-config/*

# * 수정 중. 테스트 필요 ######################
# crypto-config 디렉토리가 없는 경우 생성합니다.
if [ ! -d "./crypto-config" ]; then
    mkdir crypto-config
fi
#############################################

# generate crypto material
# * GOPATH 경로를 정확하게 알고 나서 안에 ShellScript 분석한 다음 마저 작성
cryptogen generate --config=./crypto-config.yaml
# * 마지막 명령 줄 결과가 0이 아닌 경우
# '$?'란 방금 실행된 스크립트가 반환한 값
# 반환값이 0이 아닌 경우 (1~255은 에러) echo문 출력
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi

#############################
if [ ! -d "./config" ]; then
    mkdir config
fi
#############################

# generate genesis block for orderer
# configtx.yaml 속성 파일 내 정의됨.
# 제네시스 블록을 생성합니다.
configtxgen -profile OneOrgOrdererGenesis -outputBlock ./config/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi

# generate channel configuration transaction
configtxgen -profile OneOrgChannel -outputCreateChannelTx ./config/channel.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel configuration transaction..."
  exit 1
fi

# generate anchor peer transaction
configtxgen -profile OneOrgChannel -outputAnchorPeersUpdate ./config/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Org1MSP..."
  exit 1
fi
