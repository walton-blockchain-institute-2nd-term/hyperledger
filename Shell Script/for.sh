# 해당 쉘 스크립트(for.sh) 실행 디렉토리의 파일 리스트 길이만큼 for문이 돌면서
# database 변수에 디렉토리 안에 존재하는 파일 리스트 이름을 저장
for database in $(ls)
do
# database 출력
echo $database
done

# 출력 값
# Hello.sh
# array.sh
# expr.sh
# for.sh
# readMyAge.sh