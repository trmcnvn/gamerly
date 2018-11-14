class ScraperService
  include HTTParty

  # Return the scraped data as an array of structured data.
  #
  # ```
  # [{
  #   "source": "<site>"
  #   "href": "<article link>",
  #   "image": "<article image>",
  #   "title": "<article title>",
  #   "summary": "<summarized content>",
  #   "metadata": {
  #     "author": "<author name>",
  #     "pubdate": "<article published date>"
  #   }
  # }]
  # ```
  def to_a
    raise NotImplementedError
  end

  private
  def fetch(path = '/', options = {})
    default_options = {
      headers: {
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3602.2 Safari/537.36'
      }
    }.merge!(options)
    response = self.class.get(path, default_options)
    response
  end

  def summarize(data)
    data.summarize(language: 'en', ratio: 30)
  end
end
