import scrapy
from davidfun_project2.items import DavidfunProject2Item


class DavidfunSpider(scrapy.Spider):
    name = "davidfun"
    allowed_domains = ["davelee-fun.github.io"]
    start_urls = ["https://davelee-fun.github.io"]

    def parse(self, response):
        item = DavidfunProject2Item()
        item["title"] = response.css("h1.sitetitle::text").get()
        description = response.xpath("//p[@class='lead']/text()").get()
        item["description"] = description    
        yield item
