require 'httparty'
require 'register_client_manager'
require 'json'
require 'yaml'

registers_client = RegistersClient::RegisterClientManager.new()
register = registers_client.get_register('government-domain', 'beta')
results = register.get_records.map{|r| 
   hostname =  "www.#{r.item.value['hostname']}.gov.uk"
   ssl_checker_url = "https://www.websecurity.symantec.com/bin/websitesecurity/sslcheckerinfo?h=#{hostname}"
   response = HTTParty.get(ssl_checker_url)
   result = { hostname: hostname, response: JSON.parse(response.body) }
   puts(result)
   result
}
File.open("results.yml", "w") { |file| file.write(YAML.dump(results)) }


