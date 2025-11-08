use reviews

db.createCollection("reviews")

// 1) 데이터 삽입 (Insert) (고객 리뷰 10개 컬렉션에 저장 - customer_name, product, rating, comment, date 필드 포함)

db.reviews.insertMany([
  {customer_name: "김수연",
   product: "무선 이어폰",
   rating: 5,
   comment: "음질이 좋아요!",
   date: ISODate("2025-08-15T10:00:00Z")},
  {customer_name: "박지훈",
   product: "노트북",
   rating: 4,
   comment: "가성비가 좋습니다.",
   date: ISODate("2025-07-20T14:30:00Z")},
  {customer_name: "이민지",
   product: "스마트워치",
   rating: 3,
   comment: "배터리가 좀 빨리 닳아요.",
   date: ISODate("2025-08-01T09:15:00Z")},
  {customer_name: "최동현",
   product: "무선 이어폰",
   rating: 2,
   comment: "생각보다 불편해요.",
   date: ISODate("2024-07-15T11:00:00Z")},
  {customer_name: "정혜원",
   product: "노트북",
   rating: 5,
   comment: "디자인이 세련됐습니다.",
   date: ISODate("2025-08-10T15:45:00Z")},
  {customer_name: "오세준",
   product: "스마트폰 케이스",
   rating: 4,
   comment: "튼튼하고 만족합니다.",
   date: ISODate("2025-08-05T12:20:00Z")},
  {customer_name: "한예지",
   product: "무선 이어폰",
   rating: 5,
   comment: "착용감이 편해요.",
   date: ISODate("2024-06-01T08:00:00Z")},
  {customer_name: "윤태호",
   product: "스마트워치",
   rating: 4,
   comment: "헬스 기능이 유용합니다.",
   date: ISODate("2025-07-30T19:00:00Z")},
  {customer_name: "김민정",
   product: "노트북",
   rating: 3,
   comment: "무게가 조금 무거워요.",
   date: ISODate("2024-09-10T16:40:00Z")},
  {customer_name: "송지호",
   product: "스마트폰 케이스",
   rating: 5,
   comment: "디자인이 예쁘고 튼튼해요!",
   date: ISODate("2025-08-12T18:10:00Z")}
 ]
)

db.reviews.find()

// 2) 데이터 조회 (Find) - rating 4점 이상인 리뷰만 조회 / 특정 product의 리뷰만 필터링

db.reviews.find({rating: { $gte: 4 } })

db.reviews.find({product :  "노트북"})

// 3) 데이터 수정 (Update) - 한 고객의 리뷰 코멘트를 "배송이 빨라서 만족합니다"로 수정하기 / 특정 제품 리뷰 별점을 일괄적으로 +1 하기

db.reviews.updateOne(
  { customer_name: "김수연" },
  { $set: { comment: "배송이 빨라서 만족합니다" }}
)

db.reviews.updateMany(
  { product: "무선 이어폰" },
  { $inc: { rating: 1 } }
)

db.reviews.find()

// 4) 데이터 삭제 (Delete) - 오래된 리뷰(date 기준 1년 이상 지난 것)을 삭제하기

db.reviews.deleteMany(
  {date:{$lt:ISODate("2024-09-03")}}
)

db.reviews.find()
