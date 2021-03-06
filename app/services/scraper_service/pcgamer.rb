class ScraperService
  class Pcgamer < ScraperService
    SOURCE = 'PCGamer'.freeze
    base_uri 'https://www.pcgamer.com'

    def to_a
      featured_news.push(*latest_news).compact
    end

    private
    def document
      @document ||= Nokogiri::HTML(fetch('/news/').body)
    end

    def content
      @content ||= document.at_css('#content')
    end

    def featured_news
      items = content.css('#homePageCarousel .feature-block-item-wrapper')
      items.map do |item|
        parse_article(item)
      end
    end

    def latest_news
      # lambda to extract the articles and parse them
      get_article_content = lambda { |content|
        latest = content.at_css('section[data-next="latest"]')
        latest.css('.listingResult[data-page="1"]').map do |item|
          parse_article(item)
        end
      }

      # Get the first and second page of articles
      # We really should grab all articles until we hit the next day
      items = get_article_content.call(content)
      second_page_content = Nokogiri::HTML(fetch('/news/page/2/').body).at_css('#content')
      items.push(*get_article_content.call(second_page_content))
    end

    def parse_article(fragment)
      # Skip if this isn't a news article
      category = fragment.at_css('a.category-link')
      return nil if category == nil || category.content&.downcase != 'news'

      # Visit the article and build object
      href = fragment.at_css('a')['href']
      response = fetch(href)
      return nil if response.code != 200

      begin
        article_doc = Nokogiri::HTML(response.body)
        article_doc.css('#article-body p').each { |node| node.content = "#{node.content}\n\n" }
        {
          source: SOURCE,
          href: href,
          image: article_doc.at_css('meta[property="og:image"]')['content'],
          title: article_doc.at_css('meta[property="og:title"]')['content'],
          summary: summarize(article_doc.css('#article-body p').text),
          metadata: {
            author: article_doc.at_css('a[rel="author"] > span').content,
            pubdate: DateTime.parse(article_doc.at_css('meta[name="pub_date"]')['content'])
          }
        }
      rescue
        nil
      end
    end
  end
end
