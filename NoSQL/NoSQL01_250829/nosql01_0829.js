// 컬렉션 저장하기 (*특정 옵션설정)
db.createCollection(
    "log", {capped:true, size:524880, max:5000}
)

/*
중간에 복문으로 주석처리 하고 싶을 때!
나는 주석이야!!!
*/

// 구문이 종료되는 지점에서 ctrl + enter : 해당 구문 실행
// 전체구문 실행 : ctrl + shift + enter

show collections

db.log.isCapped()
db.log.renameCollection("test02")