// 0904미션 _ 해설

db.movies.find().limit(1)
db.comments.find().limit(1)
db.users.find({name:"홍길동1"})

// 1번 문제 해설
db.movies.find(
  {year: {$gte:2010}, genres : "Action"},
  {_id:0, title: 1, year : 1, genres : 1}
)

db.movies.aggregate([
  {$match: {year:{$gte:2010}, genres: "Action"}},
  {$project: {_id:0, title: 1, year : 1, genres : 1}}
])

// 2번 문제 해설
db.users.insertOne({
    name: "홍길동",
    email: "hong@test.com",
    password: "test123",
    preference: ["Action","Comedy"],
    createdAt: new Date()
})

db.users.aggregate([
  {$documents: [
    {
      name: "홍길동1",
      email: "hong@test.com",
      password: "test123",
      preference: ["Action","Comedy"],
      createdAt: new Date()      
    }
  ]},
  {$merge: {into: "users"}}
])
// -----> 이건 버전이 안맞아서 사용할 수 없음. 그냥 이런 방식도 있다라고만 알고있기.

db.comments.find().limit(5)


db.comments.insertOne({
      name: "홍길동1",
      email: "hong@test.com",
      movie_id: "573a13adf29313caabd2b765  ",
      text: "Action 영화 최고",
      createdAt: new Date()   
})

db.comments.find({name:"홍길동"})

// Javascript => 변수를 선언할 때, const, let, var
// const => 재선언, 재할당 불가 // 엄격한 변수
// let => 재선언 불가, 재할당 가능 // 상대적으로 덜 엄격한 변수
// var => 재선언, 재할당 가능

const m = db.movies.findOne(
  {year: {$gte:2010}, genres: "Action"},
  {_id:1, title:1}
)

m
m._id

// 3번 문제 해설
db.comments.insertOne({
      name: "홍길동1",
      email: "hong@test.com",
      movie_id: "573a13adf29313caabd2b765  ",
      text: "Action 영화 최고",
      createdAt: new Date()   
})

db.comments.updateOne(
  {email: "hong@test.com", movie_id: m._id},
  {$set: {text: "Action 영화 진짜 재밌다!", editedAt: new Date()}}
)
// 4번 문제 해설
db.movies.aggregate([
  {$unwind : "$genres"},
  {$group: {_id: "$genres", count:{$sum:1}}},
  {$sort:{count: -1}},
  {$limit: 3}
])

// 5번 문제 해설
db.movies.find(
  {"imdb.rating": {$gte: 8.5}},
  {_id:0, title: 1, year : 1, "imdb.rating": 1}
).sort({year: -1})

db.movies.aggregate([
  {$match: {"imdb.rating": {$gte: 8.5}}},
  {$project: {_id:0, title: 1, year : 1, "imdb.rating": 1}},
  {$sort: {year:-1}}
])

//6번 문제 해설

db.comments.aggregate([
  {
    $addFields: {    // 문자열로 교체하는 addFields
      testStr: {
        $convert: {
          input: "$text",
          to: "string",
          onError: "",
          onNull: ""
        }
      }
    }
  },
  {
    $addFields: {    // 글자수를 찾아오는 addFields
      textLen: {$strLenCP:"$testStr"}
    }
  },
  {$group: {
    _id : "$email",
    totalComments : {$sum:1}, // 사용자별 댓글 수 총합
    avgTextLength : {$avg: "$textLen"} // 댓글의 평균 길이
    }
  },
  {
    $sort: {totalComments:-1, avgTextLength:-1}
  },
  {
    $limit: 5
  }
])

// 7. 1)
db.comments.aggregate([
    {$addFields: {textStr:{$convert:{input:"$text",to:"string",onError:"",onNull:""}}}}, //이렇게 찾아온 값을 
    {$addFields : {textLen:{$strLenCP:"$textStr"}}}, // 다시 문자열의 길이로 만들 수 있음!
    {$group: {_id:"$email",totalComments:{$sum:1},avgTextLen:{$avg:"$textLen"}}},
    {$sort:{totalComments:-1,avgTextLen:-1}}, //1차정렬, 2차정렬
    {$limit:5}
])

//ifNull 활용

db.comments.aggregate([
  {
    $addFields: {    // 문자열로 교체하는 addFields
      testLen: {$strLenCP: {$ifNull: ["$text",""]}},
    }
  },
  {$group: {
    _id : "$email",
    totalComments : {$sum:1}, // 사용자별 댓글 수 총합
    avgTextLength : {$avg: "$textLen"} // 댓글의 평균 길이
    }
  },
  {
    $sort: {totalComments:-1, avgTextLength:-1}
  },
  {
    $limit: 5
  }
])




