import scrapy

class Pandora(scrapy.spiders.crawl.Spider):
    name="pandora"
    start_urls = [f'https://offshoreleaks.icij.org/investigations/pandora-papers?c=USA&cat=1&from={page}' 
    for page in range(0,700,100)]

    def parse(self,response):
        officers_links = response.css("#search_results tbody a::attr(href)").getall()
        for link in officers_links:
            yield response.follow(link,self.parse_officer)
        


    def parse_officer(self,response):
        print(response.url)
        entity_link = response.css("table[data-category='Entity'] td.description a::attr(href)").get().strip()
        yield {
            "name": response.css("header h1.node__content__header__name::text").get().strip(),
            "entity": response.css("table[data-category='Entity'] td.description a::attr(title)").get().strip(),
            "entityLink":f"https://offshoreleaks.icij.org{entity_link}" ,
            "role": response.css("td.role::text").get().strip(),
            "roleStartDate": response.css("td.role-start-date::text").get().strip(),
            "roleEndDate": response.css("td.role-end-date::text").get().strip(),
            "incorporation": response.css("td.incorporation::text").get().strip(),
            "jurisdiction": response.css("td.jurisdiction::text").get().strip(),
            "status": response.css("td.status::text").get().strip(),
            "address": response.css("table[data-category='Address'] td.description a::text").get().strip() if response.css("table[data-category='Address'] td.description a::text").get() is not None else "",
        }