require 'http'

class HttpUtil
  def self.post(uri, key, body)
    req = HTTP.auth("Bearer #{key}")
              .post(uri,
                    json: body)
    JSON.parse(req)
  end

  def self.get(uri, key)
    req = HTTP.auth("Bearer #{key}")
              .get(uri)
    JSON.parse(req)
  end
end
