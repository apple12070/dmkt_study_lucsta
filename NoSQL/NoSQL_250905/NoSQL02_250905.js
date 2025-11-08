db.comments.aggregate([
  {
    $lookup:
      {
        from : "movies",
        localField: "movie_id",
        foreignField: "_id",
        as: "movie"
      }
  }
])

db.movies.find(
  {year: {$gte:2010}, genres : "Action"},
  {_id:0, title: 1, year : 1, genres : 1}
)

db.users.aggregate([
  {
    $lookup:
      {
        from: "comments",
        localField: "email",
        foreignField: "email",
        as: "user_comments"
      }
  }
])

// lookup : 서로 다른 컬렉션을 연결한다는 장점이 존재
// 프로그램이 실행되는 측면에서 보면 그렇게 환영받을만한 코드는 아님
// 컬렉션 + 컬렉션 => 새로운 필드 가져와
// 로컬 컴퓨터의 사양이 좋지 못하거나, 클라우드 컴퓨팅 서버의 용량, 자원이 불충분한 경우
//사양이 좀 된 컴퓨터 (6년 이상, 10만개 + 30만개 => x)

db.movies.aggregate([
  {$match : {runtime: {$gte:100}}},
  {$sort: {year: -1}},
  {$skip: 5},
  {$limit: 3}
])

db.movies.aggregate([
  {
    $facet: {
      movieCountByYear: [
          {$group: {_id: "$year", count: {$sum: 1}}}
        ],
        maxRatingByYear : [
          {$group: {_id: "$year", maxRating: {$max: "imdb.rating"}}}
        ]
     }
  }
])

db.movies.aggregate([
  {
    $redact: {
      $cond: {
        if: {$gte: ["$imdb.rating", 7]}, // 조건식
        then: "$$KEEP", // 조건식이 참이면 실행되는 구문 => 사용자 정의 변수를 활용하고자 할 때 (*keep = 유지)
        else: "$$PRUNE"  // 조건식이 거짓이면 실행되는 구문 (*prune = 버림)
      }
    }
  }
])

db.movies.aggregate([
  {$match: {year: {$gte: 2010}}}
])