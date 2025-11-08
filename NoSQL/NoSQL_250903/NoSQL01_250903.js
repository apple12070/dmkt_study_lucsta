// 특정 조건에 부합하는 경우, 통으로 문서를 대체(*replace)하는 구문

db.users.find()
// 하나의 문서를 한 쌍으로 인식해서 뭔갈 하려고 할 때 -> 객체
// 반복, 특정 필드 내 세부값을 그룹화하려고 할 때 -> 배열
db.users.updateOne(
  {name : "동현"},
  {$set:{name: "동현2세", age: 31, hobbies:["축구","음악","영화"]}}
)

db.users.find(
  {name:"동현2세"}
)

// 특정 조건에 따라서 필드를 제거하는 문법/구문
db.users.updateOne(
  {name:"유진"},
  {$unset: {age:1}}
)

// 특정 조건을 만족하는 문서가 없는 경우, 새로 추가하기
db.users.updateOne(
  {name: "민준"},
  {$set: {name:"민준",age:22,hobbies:["음악","여행"]}},
  {upsert: true}  // upsert:true값을 주면 존재하지 않던 값도 새로 추가 가능 (업데이트가 아닌 새로운 데이터 추가 가능) 
)

db.users.updateOne(
  {name: "유진"},
  {$set: {age:30}}
)

db.users.updateOne(
  {name: "유진"},
  {$set: {hobbies:"운동"}}
)  // hobbies 안에 값이 단일값으로 나옴 "운동"

db.users.updateOne(
  {name: "유진"},
  {$set: {hobbies:["운동"]}}
)  // hobbies 안에 값이 배열의 형태로 나옴 [1 elements]

// 특정 컬럼 내 배열 형태의 자료에서 값을 추가 : push
db.users.updateOne(
  {name: "유진"},
  {$push: {hobbies:"영화"}}
) 

// 특정 컬럼 내 배열 형태의 자료에서 값을 제거 : pull
db.users.updateOne(
  {name: "유진"},
  {$pull: {hobbies: "운동"}}
)

/*
특정 컬렉션 안에 값을 추가할 때에도 단일값 & 다중값 적용
값을 수정할 때에도 단일값 & 다중값 적용
값을 삭제할 때에도 단일값 & 다중값 적용
*/

//removeOne, removeMany

/*
DELETE FROM users WHERE address = "서울";
db.users.deleteMany(
  {address: "서울"}
)
db.users.deleteMany(
  {} -> 조건이 안에 없으면 all
)
DELETE FROM users;

*/

db.users.deleteMany(
  {address: "수원시"}
)
db.users.find()

db.users.insertMany(
  [
    {name:"David", age:45, address:"서울"},
    {name:"DaveLee", age:25, address: "경기도"},
    {name:"Andy", age:50, hobby: "골프", address: "경기도"},
    {name:"Kate", age:35, address:"수원시"}
  ]
)

db.users.deleteMany(
  {age:{$lt: 30}}
)

db.users.find()

db.users.insertMany(
  [
    {name:"A", age: 20, address: "경기도", date: ISODate("2025-08-15T10:00:00Z")},  //date : "2025-08-15"로 입력하면 문자열로 인식해서 날짜로 출력이 불가능
    {name:"B", age:30, address: "서울", date: ISODate("2025-08-15")},
  ]
)

db.users.updateMany(
  {address:"경기도"},
  {$inc: {age:1}}  // $inc => increase의 약자로, 조건이 참인 경우 입력한 값만큼 해당 컬럼의 값을 증가
)

db.users.deleteMany(
  {date: {$lt:ISODate("2025-09-01")}}
)//-> 이 날짜보다 작은 날짜들을 날려버림











