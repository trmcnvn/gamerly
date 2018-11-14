class ScraperService
  class Polygon < ScraperService
    SOURCE = 'Polygon'.freeze
    base_uri 'https://www.polygon.com'

    def to_a
      featured_news.compact.push(*latest_news.compact)
    end

    private
    def document
      @document ||= Nokogiri::HTML(fetch('/gaming').body)
    end

    def content
      @content ||= document.at_css('.l-root')
    end

    def featured_news
      content.css('.l-hero .c-entry-box--compact--hero').map { |article| parse_article(article) }
    end

    def latest_news
      content.css('.c-compact-river .c-compact-river__entry').map { |article| parse_article(article) }
    end

    def parse_article(fragment)
      href = fragment.at_css('a')['href']
      # We don't want video, review, or guide articles.
      return nil if href =~ /www.polygon.com\/(videos|reviews|guides)/
      response = fetch(href)
      return nil if response.code != 200

      begin
        article_doc = Nokogiri::HTML(response.body)
        {
          source: SOURCE,
          href: href,
          image: article_doc.at_css('meta[property="og:image"]')['content'],
          title: article_doc.at_css('meta[property="og:title"]')['content'],
          summary: summarize(article_doc.css('.c-entry-content').text),
          metadata: {
            author: article_doc.at_css('.c-byline > .c-byline__item > a').content,
            pubdate: DateTime.parse(article_doc.at_css('time.c-byline__item')['datetime'])
          }
        }
      rescue
        nil
      end
    end
  end
end
