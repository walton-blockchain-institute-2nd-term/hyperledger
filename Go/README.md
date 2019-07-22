# Go 언어 
- 가비지 컬렉터 존재
- 변수와 포인터 동일
- 불필요한 요소 제거

## Call By Value vs Call By Reference
- 매개변수에 저장하는 방식차이
- 값에 의한 호출
    - 독립성 보장
- 참조에 의한 호출
    - 종속성이 생김
    - 메모리 효율이 높아짐

# 디렉토리 생성
``` cmd
mkdir ~/go && cd go
```
# bin, pkg, src 세가지 폴더 생성
``` cmd
mkdir bin
mkdir pkg
mkdir src
```

# src 폴더로 이동 후 실습 폴더 생성
```cmd
cd src && mkdir Day01
```

# hello.go 생성
```go
package main

import "fmt"

func main() {
    fmt.Println("HELLO WORLD!!")
}
```

# go build 실행
## 작성한 후 터미널에서 go build hello.go
## VS Code 에서는 ctrl + ` 을 눌러 터미널 실행 가능 이후 go build hello.go
## 그냥 go build 를 해도 진행은 가능하나 폴더명으로 생성된다.