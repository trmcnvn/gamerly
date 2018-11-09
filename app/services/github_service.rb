class GithubService
  def initialize
    @client ||= Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
  end

  def get_gist_content
    gist = @client.gist(gist_id)
    href = gist[:files][file_name][:raw_url]
    HTTParty.get(href).body
  end

  def update_gist_content(data)
    files = {}
    files[file_name] = { content: data.to_json }
    @client.edit_gist(gist_id, { files: files })
  end

  private
  def gist_id
    ENV['GITHUB_GIST_ID']
  end

  def file_name
    ENV['GITHUB_FILENAME']
  end
end
