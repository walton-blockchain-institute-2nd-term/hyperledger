# avengers 배열 생성
avengers=("Ironman" "Thor" "Hawkeye")

# avengers 배열의 3번째 인덱스에 해당하는 값 출력
echo ${avengers[2]}
# avengers 배열의 모든 값 출력 1
echo ${avengers[@]}
# avengers 배열의 모든 값 출력 2
echo ${avengers[*]}
# avengers 배열의 길이 출력
echo ${#avengers[@]}

# 해당 쉘 스크립트(array.sh) 실행 디렉토리의 파일 리스트를 저장
filelist=( $(ls) )
# filelist의 모든 값 출력
echo ${filelist[*]}

# 출력 값
# Hawkeye
# Ironman Thor Hawkeye
# Ironman Thor Hawkeye
# 3
# Hello.sh array.sh expr.sh