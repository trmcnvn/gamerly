module ScraperCategories
  GENERAL = 1
  MOBILE = 2
end

class ScraperService
  include HTTParty

  # Return the scraped data as a structured object.
  #
  # ```
  # {
  #   "source": "PCGamer",
  #   "category": "general",
  #   "articles": [{
  #     "href": "<article link>",
  #     "image": "<article image>",
  #     "title": "<article title>",
  #     "summary": "<summarized content>",
  #     "metadata": {
  #       "author": "<author name>",
  #       "pubdate": "<article published date>"
  #     }
  #   }, ...]
  # }
  # ```
  def to_object
    raise NotImplementedError
  end

  private
  def fetch(path = '/', options = {})
    response = self.class.get(path, options)
    response
  end

  def summarize(data)
    data.summarize(language: 'en', ratio: 30)
  end
end
