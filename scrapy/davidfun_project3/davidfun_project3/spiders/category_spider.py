import scrapy
from davidfun_project3.items import DavidfunProject3Item


class CategorySpiderSpider(scrapy.Spider):
    name = "category_spider"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io"]

    def parse(self, response):
        categories = response.css("a.text-dark::text").getall()
        for category in categories :
            item = DavidfunProject3Item()
            item["category"] = category
            yield item
