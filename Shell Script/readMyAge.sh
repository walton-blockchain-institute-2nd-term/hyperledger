# 나이 물어보는 문구 출력
echo "How old are you?"
# age라는 변수에 입력 받은 나이 저장
read age

# 나이가 20세 이상일 경우
# if문을 쓸 때는 then을 꼭 사용해야 함
if [ "$age" -ge 20 ]
then
# 성인이라는 문구 출력
echo "Your are adult."
# 나이가 14 ~ 20세일 경우
elif [ "$age" -ge 14 ]
then
# 학생이라는 문구 출력
echo "You are student."
else
# 그렇지 않으면 어린이라는 문구 출력
echo "You are kid."
# if문을 끝낼 때 fi 사용
fi

# 출력 값
# How old are you?
# 값 입력 ex) 22
# You are adult.
