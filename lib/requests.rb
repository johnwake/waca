module Requests
  def response(type, uri, *json_body)
    full_url = "#{$base_url}/api#{uri}"

    public_send("#{type.downcase}_response", full_url, json_body, headers = nil)
  end

  def post_response(input_url, json_body, headers)
    @response = RestClient.post(input_url, json_body, headers)
    parse_response_body(@response)
  end

  def put_response(input_url, json_body, headers)
    @response = RestClient.put(input_url, json_body, headers)
    parse_response_body(@response)
  end

  def patch_response(input_url, json_body, headers)
    @response = RestClient.patch(input_url, json_body, headers)
    parse_response_body(@response)
  end

  def get_response(input_url, _json_body = nil, headers)
    @response = RestClient.get(input_url, headers)
    parse_response_body(@response)
  end

  def delete_response(input_url, _json_body = nil, headers)
    @response = RestClient.delete(input_url, headers)
    parse_response_body(@response)
  end

  private

  def authorization_url
    "#{$base_url}/oauth/authorize"
  end

  def parse_response_body(response)
    JSON.parse response.body unless response.nil?
  end

  module_function :response, :post_request, :put_request, :patch_response, :get_response, :delete_response
end

