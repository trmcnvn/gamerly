class ScraperService
  class Gematsu < ScraperService
    SOURCE = 'Gematsu'.freeze
    base_uri 'https://gematsu.com'

    def to_a
      latest_news.compact
    end

    private
    def document
      @document ||= Nokogiri::HTML(fetch('/').body)
    end

    def content
      @content ||= document.at_css('#content')
    end

    def latest_news
      content.css('.post').map { |article| parse_article(article) }
    end

    def parse_article(fragment)
      href = fragment.at_css('.image-post-title a')['href']
      response = fetch(href)
      return nil if response.code != 200

      begin
        article_doc = Nokogiri::HTML(response.body)
        article_doc.css('.post_content p').each { |node| node.content = "#{node.content}\n\n" }
        {
          source: SOURCE,
          href: href,
          image: article_doc.at_css('meta[property="og:image"]')['content'],
          title: article_doc.at_css('.single_post_title_main').content,
          summary: summarize(article_doc.css('.post_content p').text),
          metadata: {
            author: article_doc.at_css('.single-post-meta-wrapper a[rel="author"]').content,
            pubdate: DateTime.parse(article_doc.at_css('meta[property="article:published_time"]')['content'])
          }
        }
      rescue
        nil
      end
    end
  end
end
