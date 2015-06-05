When /^I do a "(.*)" request to "(.*)"$/ do |type, url, *json_body|
	@response = Requests.response(type, url, json_body)
end

Then /^the response should validate against:$/ do |string|
	result = Waca::JsonValidator.validate(@response, JSON.parse(string))
  expect(result).to eq(true)
end
