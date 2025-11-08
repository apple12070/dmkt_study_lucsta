// 1. users 문서에 commentsCount 필드를 추가하고 댓글 개수 계산하기
// 2. 댓글 길이를 기준으로 100자 이상 => LONG COMMENT
// 100자 미만 => SHORT COMMENT
// array = 배열 = list
// iterable = 반복순회 가능한 자료구조
// for in =>

db.users.find().limit(1)
db.comments.find().limit(1)

db.users.aggregate([
  {
    $lookup: {
      from: "comments",
      localField: "email",
      foreignField: "email",
      as: "C"
    }
  },
  {
    $addFields: {
      commentount: {$size: "$C"},   // $size : 배열의 길이(원소 개수)를 구할 때 사용
      commentsAnnotated: {
        $map: {
          input: "$c",
          as: "x",
          in: {
            text: "$$x.text",
            date: "$$x.date",
            movie_id: "$$x.movie_id",
            commentType: {
              $cond: [
                {$gte: [{$strLenCP:{$ifNull:["$$x.text",""]}}, 100]},
                "LONG COMMENT",
                "SHORT COMMENT"
              ]
            }
          }
        }
      }
    }
  }
])