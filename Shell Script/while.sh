# lists에 현재 디렉토리에 있는 파일 명들을 저장
lists=$(ls)
# lists 배열의 길이를 num 변수에 저장
num=${#lists[@]}
# index 변수 초기 값을 0으로 지정
index=0
# num이 0보다 클 경우 while문 실행
while [ $num -ge 0 ]
do
# lists[index] 출력
echo ${lists[$index]}
# index 값 1 증가
index=`expr $index + 1`
# num 값 1 감소
num=`expr $num - 1`
done

# 출력 값
# Hello.sh array.sh expr.sh for.sh readMyAge.sh while.sh