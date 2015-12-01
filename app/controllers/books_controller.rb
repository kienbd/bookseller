class BooksController < ApplicationController

	def index

	end

	def search
		#books = Book.search_books params[:query]
		@books = []
		f = File.open("books.txt","r")
		f.each_line do |line|
			@books << eval(line)
		end
		f.close
	end

	def purchase
		@title = params[:title]
		@author = params[:author]
		@image = params[:image]
	end

	def confirm_payment
		@title = params[:title]
		@author = params[:author]
		@image = params[:image]
		@res = Payment.made_payment params
	end

end
