require 'httparty'
require 'register_client_manager'
require 'json'

registers_client = RegistersClient::RegisterClientManager.new()
register = registers_client.get_register('government-domain', 'beta')
records = register.get_records.each{|r| 
   hostname =  "www.#{r.item.value['hostname']}.gov.uk"
   ssl_checker_url = "https://www.websecurity.symantec.com/bin/websitesecurity/sslcheckerinfo?h=#{hostname}"
   response = HTTParty.get(ssl_checker_url)
   response_json = JSON.parse(response.body)
   puts({hostname: hostname, response: response_json  })
}
