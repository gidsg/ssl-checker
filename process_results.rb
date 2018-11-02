require 'yaml'
require 'spreadsheet_architect'
require 'httparty'

def is_redirect(hostname)
  response = HTTParty.head('https://' + hostname, follow_redirects: false, verify: false)
  response&.code == 301
end

results = YAML.load_file('results.yml')
puts(results)
with_symantec_certs = results.select{|r| 
  r[:response]['statusCode'].start_with?('yellow-')
}
.sort_by{|r| r[:hostname]}

headers = ['hostname', 'main issuer', 'is redirect?']
data = with_symantec_certs.map{|r|
[r[:hostname], r[:response]['mainIssuer'], is_redirect(r[:hostname]) ]}
file_data = SpreadsheetArchitect.to_csv(headers: headers, data: data)
File.open('with_symantec_certs_2018_10_24.csv', 'w+b') do |f|
  f.write file_data
end