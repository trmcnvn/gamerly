class ScraperService
  class Gamespot < ScraperService
    SOURCE = 'Gamespot'.freeze
    base_uri 'https://www.gamespot.com'

    def to_a
      latest_news.compact
    end

    private
    def document
      @document ||= Nokogiri::HTML(fetch('/news/pc').body)
    end

    def content
      @content ||= document.at_css('#river')
    end

    def latest_news
      content.css('article.media-article').map { |article| parse_article(article) }
    end

    def parse_article(fragment)
      href = fragment.at_css('> a')['href']
      response = fetch(href)
      return nil if response.code != 200

      begin
        article_doc = Nokogiri::HTML(response.body)
        {
          source: SOURCE,
          href: href,
          image: article_doc.at_css('meta[property="og:image"]')['content'],
          title: article_doc.at_css('meta[property="og:title"]')['content'],
          summary: summarize(article_doc.css('section.article-body .js-content-entity-body').text),
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
