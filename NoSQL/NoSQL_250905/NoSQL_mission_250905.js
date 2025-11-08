///// 20250905 미션 /////

db.movies.find().limit(1)
db.comments.find().limit(1)
db.users.find().limit(1)

/// 1) 사용자-댓글 매칭 (필수)
// -> 각 사용자users 문서에 commentsCount 필드를 추가하여 댓글 개수를 계산하세요.

db.users.aggregate([
  {$lookup: {
      from: "comments",     
      localField: "email",  
      foreignField: "email",
      as: "user_comments"
    }
  },
  {$addFields: {
      commentsCount: { $sum: { $map: { input: "$user_comments", as: "c", in: 1 } } }
    }
  },
  {$project: {user_comments: 0}
  }
])

// ----------------------------------------------(두 구문 차이 공부하기)
// 수민언니 구문 -> 여러가지 코드 구문 보고 공부하고 싶어서 언니것도 받아서 같이 정리해뒀습니다!!
db.users.aggregate([
  {
    $lookup:
      {
        from: "comments",
        localField: "name",
        foreignField: "name",
        as: "user_comments"
      }
  },
  {$unwind: "$user_comments"}, 
  {
    $group: {
      _id: "$name",
      commentsCount : {$sum:1} 
    }
  },
  {
    $addFields: {
     commentsCount: "$commentsCount"
    }
  }
])





/// 2) 댓글 길이 조건 처리 (필수)
// -> 댓글(text) 길이를 기준으로 100자 이상 → "LONG COMMENT", 100자 미만 → "SHORT COMMENT"라는 새 필드(commentType)를 $cond로 추가하세요.

db.comments.aggregate([
  {$addFields: {
      commentType: {
        $cond: [
          { $gte: [ { $strLenCP: "$text" }, 100 ] }, 
          "LONG COMMENT",
          "SHORT COMMENT"
        ]
      }
    }
  }
])

/// 3) Facet 분석 (필수)
// -> 하나의 $facet으로 다음을 동시에 분석하세요.
// -> 최신 영화 TOP 5: year 내림차순 정렬 후 상위 5개
// -> 고평점 영화 개수: imdb.rating >= 8인 영화 수
// -> 장르별 영화 분포: genres를 $unwind 후 장르별 영화 수 집계

db.movies.aggregate([
  {
    $facet: {
      latestMovies: [
        { $sort: { year: -1 } },
        { $limit: 5 }
      ],
      highRatingCount: [
        { $match: { "imdb.rating": { $gte: 8 } } },
        { $count: "count" }
      ],
      genreDistribution: [
        { $unwind: "$genres" },
        { $group: { _id: "$genres", count: { $sum: 1 } } },
        { $sort: { count: -1 } }
      ]
    }
  }
])

/// 4) 사용자 활동 Facet 분석 (선택)
// -> 하나의 $facet을 사용하여,댓글이 가장 많은 사용자 TOP 3,평균 댓글 길이가 가장 긴 사용자 TOP 3, 댓글이 없는 사용자 목록을 각각 산출하세요.

db.users.aggregate([
  {
    $lookup: {
      from: "comments",
      localField: "email",
      foreignField: "email",
      as: "user_comments"
    }
  },
  {
    $addFields: {
      commentsCount: { $sum: { $map: { input: "$user_comments", as: "c", in: 1 } } },
      avgCommentLength: { 
        $avg: { $map: { input: "$user_comments", as: "c", in: { $strLenCP: "$$c.text" } } }
      }
    }
  },
  {
    $facet: {
      topCommenters: [
        { $sort: { commentsCount: -1 } },
        { $limit: 3 }
      ],
      topAvgLength: [
        { $sort: { avgCommentLength: -1 } },
        { $limit: 3 }
      ],
      noComments: [
        { $match: { commentsCount: 0 } }
      ]
    }
  }
])


/// 5) KEEP/PRUNE 활용 (선택)
// -> comments 컬렉션에서 imdb.rating ≥ 7인 영화에 달린 댓글만 남기고 나머지는 제거하세요.
// -> 조건을 만족하는 경우 → $$KEEP
// -> 조건을 만족하지 않는 경우 → $$PRUNE

db.movies.aggregate([
  {
    $redact: {
      $cond: {
        if: { $gte: ["$imdb.rating", 7] }, 
        then: "$$KEEP",                    
        else: "$$PRUNE"                    
      }
    }
  }
])

/// 6) 극장 데이터 필터링 (선택)
// -> theaters 컬렉션에서 location.address.state = "CA"인 극장만 남기세요.

db.theaters.find({ "location.address.state": "CA" })