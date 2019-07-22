# findMyId라는 이름의 함수 생성
function findMyId()
{
# 사용자 bstudent를 찾고 모든 출력을 파이프를 통해 /dev/null로 보내고 출력은 하지 않음
grep "bstudent" /etc/passwd > /dev/null
# 리턴 값을 받아서 if문 실행
# 사용자가 bstudent와 일치 할 경우
if [ "$?" -eq 0 ]; then
 # Match found. 출력
 echo "Match found."
 # 쉘 스크립트 종료
 exit
# 다른 사용자일 경우
else
 # No match found. 출력
 echo "No match found."
# if문 끝내기
fi
}

# findMyId라는 함수를 실행하겠다는 문구 출력
echo "Start function findMyId"
# 함수 실행
findMyId
echo "End"

# 출력 값
# Start function findMyId
# (현재 사용자가 bstudent일 경우)
# Match found.
# (다른 사용자일 경우)
# No match found.
# End