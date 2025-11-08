// MongoDB > NoSQL, Aggregation=> 집합 | 집계
// Aggregation => 프레임워크
// $push <-> 배열이 아닌 요소들을 하나의 배열의 자료구조 형태로 만들어주는 기능
// 프레임워크 | 라이브러리
// 기존에 학습했던 find() 함수의 상위호환 버전이라고 생각해도 무방!!!
// Linux 운영체제 => pipeline 개념을 벤치마킹 => 함수의 기능이 구현 => 기능
// shard : 샤드 => A (*1번 샤드) 종료 -> B (*2번 샤드) 
// shard - 해당 파이프라인의 중간단계에 있는 독립적인 하나의 요소요소. 샤드들이 모여 하나의 파이프라인이 완성됨.

use sample_mflix

db.movies.find()
db.comments.find()

db.movies.aggregate(
  [
    {$match: {year: 1995}}
  ]
)

db.comments.aggregate([
  {
    $group: {
      _id: "$movie_id",
      commentCount: {$sum:1}
    }
  },
  
    {
      $project : {
        year : "$_id",
        commentCount: 1,
        _id: 0
      }
    }
 ])
// 그룹의 기준값으로 가지고 오려고 하는 요소는 _id로 가져와야 함.
// 그룹으로 나누어 집계값으로 가지고 올 필드명을 먼저 작성 (_id / commentCount)
// $sum을 실행 = 1(truthy한 값)
// "$movie_id"에 $는 세부적인 그룹화를 하겠다는 의미 (목록화)

db.movies.aggregate([
  {
    $group : {
      _id: "$year",
      runtime: {$avg: "$runtime"}
 //     openMovies: {$sum: 1}   
    }
  }
])
//_id를 $ 사용해서 그룹화를 했는데 $avg를 runtime으로 하면 avg는 통 값에 대한 avg값이 출력되므로 error와 비슷한 null값응로 출력.
// 같이 $로 맞춰줘야 각각 목록에 대한 avg 값이 출력됨

db.movies.find().limit(2)

db.movies.aggregate([
  {
    $group: {
      _id: "$year",
      averageRating: {$avg: "$rating"}
    }
  }
])
// $rating은 집계할 수 있는 값이 아님.(imdb 필드 안에 rating 필드 숨어있음) 그래서 null값 떠요~ 사실상 error.
db.movies.aggregate([
  {
    $group: {
      _id: "$year",
      averageRating: {$avg: "$imdb.rating"}
    }
  }
])
// imdb.rating -> imdb 안에 있는 rating값을 찾아오라는 뜻. (온점표기법)

db.movies.aggregate([
  {
    $group: {
      _id: "$year",
      minRating: {$min: "$imdb.rating"},   // "5.2" => string 값으로 인식
      maxRating: {$max: "$imdb.rating"}      // 값 없는 건 숫자열이 아닌 문자열의 형태로 입력되어있어 max 값 계산 불가 (4.8 + "5.2" = null)(자동형변환 일어나지 않음)
//    averageRating: {$avg: "$imdb.rating"}  
    }
  }
])

db.movies.aggregate([
  {
    $group : {
      _id: "$year",
      titles: "$title"
    }
  }
])
// 한 id에 하나의 값이 매칭되지 않아 결과값 출력되지 않음.
// 하나의 배열에 하나의 값을 넣어줘야 함.

db.movies.aggregate([
  {
    $group : {
      _id: "$year",
      titles: {$push: "$title"}
    }
  }
])
//이렇게 배열을 해주면? 하나의 year 그룹 안에 title값들이 배열로 모여서 출력이 되지요~!

db.movies.find(
  {"imdb.rating": ""}
).limit(5)

db.movies.aggregate([
 {
    $addFields: {
    ratingNum: {
      $convert: {
        input: "$imdb.rating",
        to : "double",  //실수자료형으로 자료의 값을 변경하는 역할!! ("8.4" -> 8.4의 실수로 변환)
        onError: null,   // "", "abc" 같은 오류값들은 null값으로 여기고 가져오지 말라는 뜻 (값 변환 과정에서 오류가 날 때 어떻게 처리할지 지정)
        onNull: null   // 진짜 null값은 null로 찾아오라는 뜻
      }
    }
  }
},
  {
    $match: {ratingNum: {$ne: null}}
  },
  {
    $group: {
      _id: "$year",
      minRating: {$min: "$ratingNum"},
      maxRating: {$max: "$ratingNum"}
    }
  }
])


db.movies.aggregate([
  {
    $group: {
      _id: "$year",
      directors: {$push: "$directors"}   // 기존 데이터가 배열의 형태를 가지고 있음 => 그걸 다시 배열로 가지고 온 상황 (중첩배열)
    }
  }
])

db.movies.find()

// $addToSet: 배열에 값을 추가할 때, 동일한 중복값을 제거하고 한번만 가져오는 역할
// 동일한 감독의 값을 가지고 있었을 경우, 한번만 출력하게 함!!
// 집합(set)처럼 유일한 값을 추가하고 싶을 때 사용
db.movies.aggregate([
  {
    $group: {
      _id: "$year",
      directors: {$addToSet: "$directors"}
    }
  }
])

db.movies.find()

db.movies.aggregate([
  {$unwind: "$genres"},
  {
    $group: {
      _id: "$year",
      genres : {$addToSet: "$genres"}  // [스포츠], [스포츠]
      // 객체지향언어 => set함수 => 중복되는 값을 제거하고, 1번만 값을 가져오는 역할을 함
    }
  }
])

db.movies.aggregate([
  {
    $group: {
      _id: "$year",
      firstMovie: {$first: "$title"},
      lastMovie: {$last: "$title"}
    }
  }
])


db.movies.aggregate([
  {
    $group: {
      _id: "$year",
      avgTitleLength: {$avg: {$strLenCP: {$toString:"$title"}}}
    }
  }
])

db.movies.aggregate([
  {$match: {year: {$gte: 2000}}},
  {$count: "movies_since_2000"}
])

db.movies.find().limit(5)

db.movies.aggregate([
  {$sort: {"year": 1, "title": 1}},
  {$limit: 10}
])
// 프레임워크의 독자적인 문법

db.movies.aggregate([
  {$limit: 5}
])

db.movies.aggregate([
  {$sort: {"imdb.rating": 1}},
  {$limit: 5}
])


///// 문제 1. /////
// 2000년 이후로 출시된 영화의 수는 몇 개인가요?

db.movies.aggregate([
  {$match: {year: {$gte: 2000}}},
  {$count: "movies_since_2000"}
])

///// 문제 2. /////
//각 연도별로 출시된 영화의 개수는?

db.movies.aggregate([
  {$group : {
    _id: "$year",
    movieCount: {$sum: 1}}
  }
])

///// 문제 3. /////
// 가장 많은 영화가 출시된 연도는 언제일까?

db.movies.aggregate([
  {$group: {
    _id: "$year",
    count: {$sum: 1}
  }},
  {$sort: {count: -1}},
  {$limit:1}
])  

///// 문제 4. /////
//각 연도별 평균 영화 러닝타임


db.movies.aggregate([
  {$group: {
      _id: "$year",
      avgRuntime: { $avg: "$runtime" }}
  },
  {$sort: { avgRuntime: -1 }}
])

///// 문제 5. /////
// 러닝타임이 가장 긴 영화는 어떤 영화인가요?

db.movies.aggregate([
  { $sort: { runtime: -1 } },
  { $limit: 1 }
])


///// 문제 6. ///////
// 각 영화 장르별 평균 평점은 어떻게 될까요?

db.movies.aggregate([
  {$unwind: "$genres"},
  {$group: {
    _id: "$genres",
    avgRating: {$avg: "$imdb.rating"}
  }},
  {$sort: {avgRating: 1}}
])

///// 문제 7. /////
// 각 연도별 영화 제목의 평균 길이를 구해주세요.

db.movies.aggregate([
  {$group: {
    _id : "$year",
    avgTitleLength: {$avg: {$strLenCP: {$toString:"$title"}}}
    } // 1. 연도 그룹화 -> "제목"의 길이 계산 -> 평균값 계산 // 제목에 정수 있는 경우 에러!, -> $toString: 사용
  },
  {$sort: {avgTitleLength:1}}
])

///// 문제 8. /////
// 각 연도별 가장 먼저 출시된 (*year) 영화의 제목은 무엇인가요?

db.movies.aggregate([
  {$sort: {"year":1, "released":1}},
  {$group: {_id: "$year"}},
    {$sort: {_id: 1}}
])

///// 문제 9. /////
//각 연도별 개봉된 영화의 장르들을 출력해주세요. (단, 장르는 한번씩만 출력되어야 합니다.)

db.movies.aggregate([
  {$unwind: "$genres"},
  {$group: {
      _id: "$year",           
      uniqueGenres: { $addToSet: "$genres"}}},
  { $sort: { _id: 1 } }
])



db.movies.find()








