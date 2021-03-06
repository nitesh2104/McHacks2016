require "net/http"
require "uri"
require "json"

SCHEDULER.every '60s' do

  url = URI.parse('https://tartan.plaid.com/connect')
  req = Net::HTTP::Post.new(url.request_uri)
  req.set_form_data({'client_id'=>'test_id', 'secret'=>'test_secret', 'username'=>'plaid_test', 'password'=>'plaid_good','type'=>'wells'})
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = (url.scheme == "https")
  response = http.request(req)
  json = JSON.parse(response.body)
  # json["accounts"].each do |account|
  #   puts account["meta"]["name"]
  #   puts "Account Balance: $" + String(account["balance"]["available"])
  # end

  #account_name = json["accounts"].at(0)["meta"]["name"] + " Account"
  account_name = "Personal Saving Account"
  account_balance = json["accounts"].at(1)["balance"]["available"]

  send_event("bank-balance", title: account_name, current: account_balance)
end
