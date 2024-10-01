import scrapy


class MarketSpider(scrapy.Spider):
    name = 'market'
    #allowed_domains = ['https://yahoo.com']
    start_urls = ['https://finance.yahoo.com/quote/jagx/history?period1=1580515200&period2=1588204800&interval=1d&filter=history&frequency=1d&includeAdjustedClose=true']

    def parse(self, response):
        print(response)
        pass
