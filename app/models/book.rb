class Book

	def self.search_from_world_cat keyword
		data = {q: keyword,wskey: APP_CONFIG['worldcat']['key']}
		uri = "#{APP_CONFIG['worldcat']['uri']}?" + data.to_query
		response = Resthttp::get_request(uri)
	end

	def self.search_from_goodreads isbn
		data = {isbn: isbn,key: APP_CONFIG['goodreads']['key']}
		uri = "#{APP_CONFIG['goodreads']['uri']}?" + data.to_query
		response = Resthttp::get_request(uri)
	end

	def self.search_books keyword
		res = search_from_world_cat keyword
		if res.code == "200"
			response_json = Hash.from_xml(res.body)
			books = response_json['feed']['entry'].map do |en|
				if /urn:ISBN:(\d+)/ =~ "urn:ISBN:9780805092141"
					isbn = $1
					gr_res = search_from_goodreads isbn
					if gr_res.code == "200"
						en['additionalInformation'] = Hash.from_xml(gr_res.body)["GoodreadsResponse"]['book']
					end
					en
				else
					{}
				end
			end
			books
		else
			return []
		end
	end

end
