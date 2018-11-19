class GithubService
  attr_reader :client, :gist_id, :gist

  def initialize(gist_id = nil)
    @client = Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    @gist_id = gist_id || ENV['GITHUB_GIST_ID']
    @gist = @client.gist(@gist_id)
  end

  def get_gist_content
    href = @gist[:files][file_name][:raw_url]
    HTTParty.get(href).body
  end

  def update_gist_content(data)
    files = {}
    files[file_name] = { content: data.to_json }
    @client.edit_gist(@gist_id, { files: files })
  end

  def last_updated_at
    @gist[:updated_at]
  end

  private
  def file_name
    ENV['GITHUB_FILENAME']
  end
end
