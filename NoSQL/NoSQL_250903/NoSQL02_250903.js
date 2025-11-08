// 로컬컴퓨터 내 db 목록 확인 
show dbs

// 특정 db에 접속
use funcoding
use nosql01

// 특정 db안에 컬렉션을 보고자 할 때
show collections

// 특정 컬렉션안에 데이터를 확인하고자 할 때
db.test.find()

// 특정 db의 상태정보를 확인할 때
db.stats()

// 특정 db를 삭제하고자 할 때 -> 주의해야 할 사항
// db가 삭제된다는 것은 당연히 db안에 있는 컬렉션도 같이 삭제가 된다는 의미
db.dropDatabase()

// 특정 db > 컬렉션 삭제 (* 해당 db에 "test"라는 컬렉션이 존재하지 않더라도 true라고 출력이 됨. 헷갈리지 않기! / NoSQL은 문법에 있어서 유연한 편.)
db.test.drop()

use funcoding  
// db 작업 후 삭제 -> use funcoding 입력 -> already on db funcoding 출력되어도 물리적으로 db는 삭제된 상태이기 때문에 해당 db 안에서의 추가작업은 불가
// but use funcoding은 db를 새로 생성하는 명령어이기 때문에 funcoding db가 새로 생성된 건 맞음.
// 근데 안에 collection이 없어 db리스트에는 보이지 않음 (*보이지 않지만 새로 생긴거임!)
// 그래서 아래 명령어처럼 새로 collection을 생성하면 funcoding db 생성됨!

// 컬렉션 생성 -> CLI 방식 VS GUI 방식
// 아래는 CLI 방식
db.createCollection("test")

// 특정 db에 접속한 상태에서 삭제 후 재생성을 하는게 아니라 아예 새로운 db를 생성하는 경우에도 가능!!! 신기방기
use abcd
db.createCollection("efg")
db.dropDatabase()

use funcoding

// 컬렉션을 생성하는 2가지 방식
/*

1) 특정 옵션 없이 단순 컬렉션 생성 방식 
2) 별도의 옵션을 설정해서 컬렉션 생성 방식
- capped : true / false (* false는 디폴트값이기 때문에 사용할 이유가 없음)
- capped : true => 고정된 크기의 컬렉션을 갖도록 하겠다는 의미 (*그래서 size가 항상 따라다님)
- size : byte의 단위로 입력하게끔 되어있음
- 컴퓨터는 2진수로 데이터를 처리 => 2진법 사용 => 데이터 처리.저장 단위의 최소 단위 = bit
- bit
- 1byte = 8bit
- 1kb = 2^10 = 1024
1 x 1000이 일반적이나 컴퓨터는 2진수를 사용하기 때문에 2^10 = 1024 사용
- 1mb = 1 x 1024 x 1024 = 1,048,576 bytes
- 5mb = 5 x 1024 x 1024 = 5,242,880 bytes


- max : 해당 컬렉션 안에 저장할 수 있는 데이터 (* = 문서), 몇 개의 문서를 허용할 것인가 (문서의 갯수)
- autoIndexId : true => 모든 문서를 생성할 때마다 _id 필드에 대한 값을 자동으로 설정할 것인가에 대한 여부


*/

db.createCollection("log", {
    capped : true,
    size : 5242880,
    max : 5000
})

// 해당 콜렉션이 capped인지 아닌지 확인 (capped = 메모리(크기) 제한을 뒀는지)
db.log.isCapped()
db.test.isCapped()

//이미 생성된 컬렉션 이름을 수정하고자 할 때 (log -> test01)
db.log.renameCollection("test01")

// 특정 db 안에 collection 생성 -> collection 안에 document({}) 생성
/*

SQL :
INSERT INTO tablename(field name) VALUES (value)

* 객체는 key와 value값의 한 쌍으로 움직임! (객체는 {}, 리스트는 [])
NoSQL : 
db.collectionname.insertOne(
    {
        name : "David",
        age : 20,
        status : "pending"
    }
)

db.collectionname.insertMany(
    [
        {subject : "coffee", author : "abc", views: 50},
        {subject : "shopping", author : "def", views: 100}
    ]
)

*/

db.createCollection("users")

db.users.insertOne(
    {subject: "coding", author: "funcoding", views: 50}
)

// 해당 컬렉션 내부에 있는 값을 확인하고자 할 때
db.users.find()

// 해당 컬렉션 내부에 여러개 문서를 동시에 입력
db.users.insertMany(
    [
        {subject: "coffee", author: "xyz", views: 50},
        {subject: "Coffee Shopping", author: "efg", views: 5},
        {subject: "Baking a cake", author: "abc", views: 90},
        {subject: "baking", author: "xyz", views: 100},
        {subject: "Cafe", author: "abc", views: 200}
    ]
)

// NoSQL 구문/문법은 SQL 대비 상대적으로 유연한 문법 체계를 가지고 있음
// ex) {subject: "coffee02", author: 123, views: "zyt"} 도 가능 (* 에러 안 뜸)
// 그러나 해당 키의 값을 찾아와서 형식이 다른 데이터와 일괄적인 처리를 하려고 할 때는 에러가 뜸

// SQL 내 Schema를 정의했던 것처럼 NoSQL에서도 사전에 Schema Validation 유효성 기능설정
// users2 안에 들어가는 요소들이 객체{}의 형태이므로 bsonType : "object"(객체)로 설정
db.createCollection("users2", {
    validator : {
        $jsonSchema: {
            bsonType: "object",
            required: ["subject", "author", "views"],
            properties: {
                subject: {
                    bsonType: "string",
                    description: "must be a string and is required"
                },
                author: {
                    bsonType: "string",
                    description: "must be a string and is required"
                },
                views: {
                    bsonType: "int",
                    description: "must be a integer and is required"                    
                },
            }
        }
    },
    validationAction : "error"
})

db.users.drop()

///// 문제 1. /////
// users 컬렉션 생성
// 다음과 같은 데이터를 삽입
/*
컬렉션 내 size는 100000바이트로 생성 
name, age, hobby, address 키
David, 45, "서울"
Dave, 25, "경기도"
Andy, 50, "골프", "경기도"
Kate, 35, "수원시"
Brown, 8
*/

db.createCollection("users", {
    capped : true,
    size : 100000,
    max : 5000
})

db.users.insertMany(
    [
        {name: "David", age: 45, address: "서울"},
        {name: "Dave", age: 25, address: "경기도"},
        {name: "Andy", age: 50, hobby: "골프", address: "경기도"},
        {name: "Kate", age: 35, address: "수원시"},
        {name: "Brown", age: 8}        
    ]
)

db.users.find()

// 선생님 코드 //
db.createCollection("users", {
    capped: true, size: 100000
})

db.users.insertMany(
    [
        {name: "David", age: 45, address: "서울"},
        {name: "Dave", age: 25, address: "경기도"},
        {name: "Andy", age: 50, hobby: "골프", address: "경기도"},
        {name: "Kate", age: 35, address: "수원시"},
        {name: "Brown", age: 8}        
    ]
)

// find() : 해당 컬렉션 안에 있는 모든 데이터를 읽기 위한 목적의 함수
db.users.find()

/*
만약, 즉정 조건에 해당되는 값을 찾아오고 싶다면?

SELECT * FROM users; (SQL 버전)
db.users.find() (NoSQL 버전)

SELECT _id, name, address FROM users
db.users.find({}, {name: 1, address: 1})
-> 1의 값은 truthy한 값을 의미 (참인 값)
* truthy, falsy : python => 0 / 1 
> {} : 직접 입력 및 삽입한 값뿐만 아니라 자동적으로 내장되어있는 값까지 모두 찾아온다는 의미 = all
> {특정 값을 입력} : 조건 

SELECT name, address FROM users
db.users.find({}, {name: 1, address: 1, _id: 0})

-> 첫번째 인자값 = {} // 두번째 인자값 = {name: 1, address: 1, _id: 0}
-> 첫 번째 인자는 조건절임. 어떤 문서를 가져올지 선택(filter)하는 역할
    -> ex) {name: "Alice"} => name이 Alice인 문서만 가져오기
    -> 만약 {_id:0}을 조건절에 넣으면 _id가 0인 문서만 찾게 됨.
-> 두번째 인자는 Projection. 어떤 필드를 보여줄지, 숨길지를 결정
    -> _id는 기본적으로 항상 반환되기 때문에, 숨기려면 반드시 Projection(두번째 인자) 부분에 _id:0을 넣어야 함!!
    -> 1이면 truthy한 값으로 반환되고, 0이면 falsy한 값이기 때문에 반환되지 않음.

***** db.users.find{} => 해당 DB의 모든 문서를 가져옴. (여기서 projection이 쓰이면 그 때부터는 _id값 + 입력한 projection 값만 출력!)
    
    
SELECT * FROM users WHERE address = "서울"; (SQL 버전)
db.users.find({address: "서울"}) (NoSQL 버전)
-> NoSQL이 SQL보다 구문이 직관적임
*/

// findOne() : 매칭되어지는 한개의 document 문서를 검색해서 찾아온다.

// 어떤 쿼리의 조건을 의미하는 명칭 : query criteria (*기준)

/*

db.users.find(
  {age: {$gt: 18}}, -> query criteria // $gt = greater than = 초과(>)
  {name: 1, address: 1, _id: 1} -> projection
).limit(5) -> cursor 
*/

///// 문제 2. /////
// users Collection에서 Dave인 문서의 name, age, address, _id를 출력하세요.

// 선생님 코드 //
db.users.find(
    {name : "Dave"},
    {name: 1, age: 1, address: 1}
)

db.users.find(
    {name: "Kate"},
    {name: 1, age: 1, address: 1, _id: 0}
)

// 비교연산자
/*  
$eq : = (equal)
$gt : > (greater than)
$gte : >= (greater than or equal)
$lt : < (less than)
$lte : <= (less than or equal)

$nin (not in) : 특정 값을 갖고있지 않은 경우.  => 집합요소
$in (in) : 특정 값을 갖고있는 경우. (*배열의 자료형태 -> 복수의 값을 기준으로 검색)
$ne: (not enough) (*단일 값의 형태)

SELECT * FROM users WHERE age > 25;
db.users.find({age: {$gt: 25}})

SELECT * FROM users WHERE age < 25;
db.users.find({age: {$lt: 25}})

SELECT * FROM users WHERE age > 25 AND age <= 50;
db.users.find({age: {$lte: 50, $gt: 25}})

*/

db.users.find(
    {age: {$gt: 20}}
)

db.users.find(
    {age: {$lt: 25}}
)

db.users.find(
    {age: {$gt: 25, $lte: 50}}
)

db.users.find(
    {age: {$in: [45,50]}}
)

db.users.find(
    {age: {$nin: [45,50]}}
)

db.users.find(
    {age: {$nin: [25]}}
)

db.users.find(
    {age: {$ne: 25}}
)
// -> 조건에 일치하는 값만 출력되고 일치하지 않는다면 출력되지 않음!

///// 문제 3. /////
/* 
1) age가 20보다 큰 문서의 name만 출력
2) age가 50이고, address가 경기도인 문서의 name만 출력
3) age가 30보다 작은 문서의 name과 age 출력
*/

// 1)
db.users.find(
    {age: {$gt: 20}},
    {name : 1, _id : 0}
)
// 2)
db.users.find(
    {age: 50, address: "경기도" },
    {name : 1, _id : 0}
)
// 3)
db.users.find(
    {age: {$lt: 30}},
    {name : 1, age:1,_id : 0}
)


// 선생님 코드 //
// 1)
db.users.find(
    {age: {$gt: 20}},
    {name: 1, _id: 0}
)
// 2)
db.users.find(
    {age: {$eq: 50}, address: "경기도"},
    {name : 1, _id : 0}
)
db.users.find(
    {age: 50, address: "경기도"},
    {name : 1, _id : 0}
)
// 3)
db.users.find(
    {age: {$lt: 30}},
    {name : 1, age : 1,_id : 0}
)

// 논리연산 문법 (*$and나 $or은 무조건 대괄호로 쓰기!)
/*

SELECT * FROM users WHERE address = "서울" AND age = 45;
db.users.find(
    {$and: [{address: "서울"}, {age}]}
)

SELECT * FROM users WHERE address = "경기도" OR age = 45;
db.users.find(
    {$or: [{address: "경기도"}, {age: 45}]}
)

SELECT * FROM users WHERE age != 45
db.users.find({age: {$not:{$eq: 45}}}) -> 정석적인 방법
db.users.find({age: {$ne:45}}) -> $eq 생략이 가능한 방법 (* {$ne:value} = {$not:{$eq:value}})
*/

db.users.find(
    {$and:[{address: "서울"}, {age: 45}]}
)

///// 문제 4. /////
// name이 Brown이거나, age가 35인 모든 값 출력!!

db.users.find(
    {$or:[{name:"Brown"},{age:35}]}
)

// 선생님 코드 //
db.users.find(
    {$or: [{name: "Brown"},{age:35}]}
)


// 정규표현식 -> 어떤 특정 문자열을 찾아오도록 설정 => 패턴
// 해당 패턴에 부가적으로 옵션을 설정 -> 플래그

// SELECT * FROM users WHERE name like "%Da%"

db.users.find(
    {name: {$regex:/Da/}}
)

/*

name 키 (*필드명) 내부의 값이 "Da"로 시작하는 모든 문서를 찾아라!!
db.users.find(
    {name: {%regex:/^Da/}} -> 정석적인 방법
)
=> ^은 특정 문자로 반드시 시작하는 문자열을 의미 : ^Da => Da로 시작하는 문자열!
db.users.find(
    {name: /^Da/} -> 약식 방법
)

*/

// 정렬 (sort)

/*
SELECT * FROM users WHERE address = "경기도"
ORDER BY age ASC

db.users.find(
  {address: "경기도"}
).sort({age: 1})  => ASC

db.users.find(
  {address: "경기도"}
).sort({age: -1})  => DES

*/

db.users.find(
    {address: "경기도"}
).sort({age: -1})

// 현재 컬렉션 내 문서의 개수를 확인하고자 할 때 : count()
db.users.find().count()  //  정석적인 구문
db.users.count()   // 약식 구문

// 현재 컬렉션 내 필드 존재 여부로 문서 개수 확인하고자 할 때 : $exists => 속성

// $가 붙어있다는 것은 NoSQL 문법에서 예약어로 사용되고 있다.
// $가 붙어있는 예약어 중에서 연산자, 속성

db.users.count(
    {address:{$exists:true}}
)

db.users.find({address:{$exists:true}}).count()
db.users.find({address:{$exists:false}}).count()

// 중복제거 : distinct
/*
SELECT DISTINCT(address) FROM users;
db.users.distinct("address")

결과값이 같은 비슷한 구문!!!!!
db.users.findOne()
db.users.find().limit(1)

*/

db.users.distinct("address")
db.users.find().limit(2)

//데이터 수정!!!!! => 

// 이미 생성된 컬렉션 안에 신규값을 추가!!!

db.users.insertMany(
    [
        {name: "유진", age: 25, hobbies:["독서","영화","요리"]},
        {name: "동현", age: 30, hobbies:["축구","음악","영화"]},
        {name: "혜진", age: 35, hobbies:["요리","여행","독서"]}
    ]
)

// $all : 배열 자료구조를 갖고 있는 필드에서 충족되는 모든 값을 포함하는 문서를 찾아올 때  ([] 사용)
db.users.find(
    {hobbies: {$all:["축구","음악"]}}
)

// SELECT * FROM users WHERE hobbies LIKE "%축구%" AND "%음악%" 

// Document 수정
/*
1) updateOne (*정석)  //  update (*약식)
- 매칭되는 1개의 문서를 업데이트 할 때 사용
2) updateMany
- 매칭되는 모든 문서를 업데이트 할 때 사용

db.users.updateMany(
    {age: {$gt: 25}},
    {$set: {address: "서울"}}
)

UPDATE users SET address = "서울" WHERE age > 25;

 */

///// 문제 5. /////
// age가 40보다 큰 문서의 address를 "수원시"로 변경하기!!

db.users.updateMany(
    {age:{$gt: 40}},
    {$set: {address: "수원"}}
)

// 선생님 코드 //
db.users.updateMany(
    {age:{$gt: 40}},
    {$set: {address: "수원시"}}
)

db.users.find()

db.users.updateOne(
    {name: "유진"},
    {$set: {age: 26}}
)













