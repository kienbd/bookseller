class Payment

	def self.made_payment params
		if params[:service] == "internal"
			uri = APP_CONFIG['payments']['internal']
			raw = Resthttp::post_request(uri,params)
			res = Resthttp::Response.new(raw)
			return res.is_ok? || res.status_code == '202'
		else
			uri = APP_CONFIG['payments']['external']
			client = Savon.client(wsdl: "#{uri}?WSDL",endpoint: "#{uri}")
			begin
				response = client.call(:transaction,message: {alo: "test"})
				return ["200","202"].include? response.code
			rescue  Savon::HTTPError
				return false
			end
		end
	end

end
