DROP TABLE IF EXISTS musinsa_top50_detail;
CREATE TABLE musinsa_top50_detail (
        rank_no INT,
        brand VARCHAR(200),
        product_name VARCHAR(500),
        sale_price INT,
        original_price INT,
        discount_rate INT,
        review_count INT,
        url VARCHAR(800),
        collected_at DATETIME
    );