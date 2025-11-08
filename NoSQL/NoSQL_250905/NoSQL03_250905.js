/////문제 1. /////
// 각 영화의 제목과 해당 영화에 달린 댓글을 출력해주세요.

db.movies.find().limit(1)
db.comments.find().limit(1)
db.users.find().limit(1)

db.movies.aggregate([
  {
    $lookup: {
      from: "comments",
      localField: "_id",
      foreignField: "movie_id",
      as: "comments"
    }
  },
  { $project: { _id: 0, title: 1, comments: 1 } }
])

// 선생님 코드 //
db.movies.find().limit()
db.comments.find().limit()

db.movies.aggregate([
  {
    $lookup: {
      from: "comments",
      localField: "_id",
      foreignField: "movie_id",
      as: "movie_comments"
    }
  },
  {
    $project: {
      _id: 0,
      title: 1,
//      movie_comments : 1
      movie_comments: {
        $map: {
          input: "$movie_comments",
          as: "comment",
          in: "$$comment.text"  // -> $$ => 사용자 컴퓨터 안의 임시 저장공간
        }
      }
    }
  }
])

///// 문제 2. /////
// 평점이 가장 높은 영화의 제목과 평점을 출력해주세요.

db.movies.find(
  {},                           
  {title: 1, "imdb.rating": 1, _id: 0}
).sort({"imdb.rating": -1}    
).limit(1);   

db.movies.aggregate([
  {$sort: {"imdb.rating": -1}},        
  {$limit: 1},                           
  {$project: {title: 1, "imdb.rating": 1, _id: 0}}
])

// 선생님 코드 //
db.movies.aggregate([
  {$match: {"imdb.rating": {$ne: ""}}},   //imdb.rating이 빈 문자열이 아닌 문서만 필터링
  {$sort: {"imdb.rating": -1}},        
  {$limit: 1},                           
  {$project: {title: 1, "imdb.rating": 1, _id: 0}}
])

///// 문제 3. /////
// 각 장르별로 평균 평점이 가장 높은 장르의 평균 평점을 출력해주세요.

db.movies.aggregate([
  {$unwind: "$genres"},
  {$group: {
      _id: "$genres",
      avgRating: {$avg: "$imdb.rating"}
    }
  },
  {$sort: {avgRating: -1}},
  {$limit: 1},
  {$project: {
      _id: 0,
      highestAvgRating: "$avgRating"
    }
  }
])

// 선생님 코드 //
db.movies.find().limit(5)

db.movies.aggregate([
  {$unwind: "$genres"},
  {$group: {_id: "$genres",avgRating: {$avg: "$imdb.rating"}}},
  {$sort: {avgRating :-1}},
  {$limit: 1},
//  {$project: {_id: 0, title: 1, avgRating: 1}}
])

///// 문제 4. /////
//개봉년도별(*year) 평균 러닝타임이 가장 짧은 영화의 개봉년도와 평균 러닝타임을 출력해주세요.

db.movies.aggregate([
  {$group: {
      _id: "$year",
      avgRuntime: {$avg: "$runtime"}
    }
  },
  {$sort: {avgRuntime: 1}},
  {$limit: 1},
  {$project: {
      _id: 0,
      year: "$_id",
      avgRuntime: 1
    }
  }
])

//선생님 코드//
db.movies.aggregate([
  {$group: {_id:"$year", avgRuntime: {$avg:"$runtime"}}},
  {$sort: {avgRuntime:1}},
  {$limit : 1}
])

///// 문제 5. /////
// 국가별로 가장 많은 영화를 제작한 감독과 그 감독의 영화 수를 출력해주세요.

db.movies.aggregate([
  {$unwind: "$countries"},
  {$unwind: "$directors"},
  {$group: {
      _id: {country: "$countries", director: "$directors"},
      movieCount: {$sum: 1}
    }
  },
  {$sort: {movieCount: -1}},
  {$group: {
      _id: "$_id.country",
      topDirector: {$first: "$_id.director"},
      movieCount: {$first: "$movieCount"}
    }
  },
  {$project: {
      _id: 0,
      country: "$_id",
      director: "$topDirector",
      movieCount: 1
    }
  }
])

//선생님 코드//
db.movies.aggregate([
  {$unwind: "$countries"},
  {$unwind: "$directors"},
  {$group: {_id: {country:"$countries",director: "$directors"}, count:{$sum:1}}},
  {$sort:{count:-1}},
  {$group : {_id:"$_id.country",topDirector: {$first: "$_id.director"}, movieCount:{$first:"$count"}}}
])

db.movies.aggregate([
  {$unwind: "$countries"},
  {$unwind: "$directors"},
  {$group: {_id: {country: "$countries", director: "$directors"}, count: {$sum: 1}}},
  {$group:
      {
          _id:"$_id.country",
          top:{
              $topN:{
                  n:1,
                  sortBy:{count:-1},
                  output:{director:"$_id.director",movieCount:"$count"}
              }
          }
      }
  },
  {
      $project:{
          _id:0,
          country:"$_id",
          topDirector:{$first:"$top.director"},
          movieCount:{$first:"$top.movieCount"}
      }
  }
])

///// 문제 6. /////
//각 연도별로 가장 많은 평점을 받은 영화의 제목과 평점을 출력하세요

db.movies.aggregate([
  {$sort: { year: 1, "imdb.rating": -1}},
  {$group: {
      _id: "$year",
      topMovie: { $first: "$title" },
      topRating: { $first: "$imdb.rating"}}
  },
  {$project: {
      _id: 0,
      year: "$_id",
      title: "$topMovie",
      rating: "$topRating"
    }
  },
  {$sort: {year: 1}}
])

// 선생님 코드 //

db.movies.aggregate([
  {$sort: {"year":1, "imdb.rating":-1}},
  {$group: {_id:"$year", title: {$first: "$title"}, maxRating: {$first:"$imdb.rating"}}},
  {$project: {_id: 0, year: "$_id", title: 1, maxRating: 1}}
])


///// 문제 7. /////
// 각 장르별 영화 갯수를 출력하세요.

db.movies.aggregate([
  {$unwind:"$genres"},
  {$group: {_id: "$genres", Moviecount : {$sum:1}}}
])

// 선생님 코드 //
db.movies.aggregate([
  {$unwind: "$genres"},
  {$group: {_id: "$genres", count: {$sum:1}}},
  {$sort: {count: -1}},
  {$project: {_id:0,genre:"$_id",movieCount:"$count"}}
])

///// 문제 8. /////
// 평균평점이 가장 높은 감독과 해당 감독의 평균 평점을 출력하세요.

db.movies.find().limit(1)
db.movies.aggregate([
  {$unwind: "$directors"},
  {$group: {_id: "$directors", avgRating:{$avg:"$imdb.rating"}}},
    {$sort: {avgRating : -1}},
    {$limit:1}
])

// 선생님 코드 //

db.movies.aggregate([
  {$unwind: "$directors"},
  {$group: {_id: "$directors", avgRating: {$avg: "$imdb.rating"}}},
  {$sort: {avgRating:-1}},
  {$limit:1},
  {$project: {_id:0, director: "$_id", avgRating:1}}
])

///// 문제 9. /////
// 장르별 평균 러닝타임이 가장 긴 장르와 해당 장르의 평균 러닝타임을 출력해주세요.

db.movies.aggregate([
  {$unwind: "$genres"},
  {$group: {_id:"$genres", avgRuntime: {$avg:"$runtime"}}},
  {$sort: {avgRuntime:-1}},
  {$limit:1},
  {$project: {_id:0, genres:"$_id", avgRuntime:1}}
])

// 선생님 코드 //
db.movies.aggregate([
  {$unwind: "$genres"},
  {$group: {_id: "$genres", avgRuntime: {$avg:"$runtime"}}},
  {$sort : {avgRuntime:-1}},
  {$limit:1},
  {$project: {_id:0, genres: "$_id", avgRuntime:1}}
])

///// 문제 10. /////
// 각 영화의 제목과 해당 영화에 대해 댓글을 남긴 사용자들을 출력하세요.

db.movies.aggregate([
  {
    $lookup: {
      from: "comments",        
      localField: "_id",        
      foreignField: "movie_id", 
      as: "movie_comments"      
    }
  },
  {
    $project: {
      _id: 0,
      title: 1,
      commenters: {
        $map: {
          input: "$movie_comments",
          as: "c",
          in: { $ifNull: ["$$c.name", "$$c.email"] } 
        }
      }
    }
  }
])

// 선생님 코드 //
db.movies.aggregate([
  {
    $lookup: {
      from: "comments",
      localField: "_id",
      foreignField:"movie_id",
      as: "movie_comments"
    }
  },
  {$project: {_id:0, title: 1, users: "$movie_comments.name"}}
])