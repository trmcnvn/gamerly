class ScraperService
  class Gamespot < ScraperService
    SOURCE = 'Gamespot'.freeze
    base_uri 'https://www.gamespot.com'

    def to_a
      latest_news.compact
    end

    private
    def document
      @document ||= Nokogiri::HTML(fetch('/news/pc/').body)
    end

    def content
      @content ||= document.at_css('.river')
    end

    def latest_news
      content.css('.horizontal-card-item').map { |article| parse_article(article) }
    end

    def parse_article(fragment)
      href = fragment.at_css('.horizontal-card-item__link')['href']
      response = fetch(href)
      return nil if response.code != 200

      begin
        article_doc = Nokogiri::HTML(response.body)
        article_doc.css('section.article-body .js-content-entity-body > p').each { |node| node.content = "#{node.content}\n\n" }
        {
          source: SOURCE,
          href: "https://www.gamespot.com#{href}",
          image: article_doc.at_css('meta[property="og:image"]')['content'],
          title: article_doc.at_css('meta[property="og:title"]')['content'],
          summary: summarize(article_doc.css('section.article-body .js-content-entity-body > p').text),
          metadata: {
            author: article_doc.at_css('.news-byline a[rel="author"]').content,
            pubdate: DateTime.parse(article_doc.at_css('.news-byline time')['datetime'])
          }
        }
      rescue
        nil
      end
    end
  end
end
