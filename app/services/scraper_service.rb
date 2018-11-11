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
    response = self.class.get(path, options)
    response
  end

  def summarize(data)
    data.summarize(language: 'en', ratio: 30)
  end
end
