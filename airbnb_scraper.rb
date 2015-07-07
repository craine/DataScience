require 'open-uri'
require 'nokogiri'
require 'csv'

#store url to be scraped
url = "https://www.airbnb.com/s/Brooklyn--New-York--NY--United-States"

#parse the page with nokogiri
page = Nokogiri::HTML(open(url))

#scrape the max number of pages and store in max_page
page_numbers = []
page.css("div.pagination ul li a[target]").each do |line|
 page_numbers << line.text
end

max_page = page_numbers.max

#initiate empty arrays
	name = []
	price = []
	details = []

#loop once for every page of search results
max_page.to_i.times do |i|

	url ="https://www.airbnb.com/s/Brooklyn--New-York--NY--United-States?page=#{i+1}"
	page = Nokogiri::HTML(open(url))

#store data into arrays

	page.css('h3.h5.listing-name').each do |line|
		name << line.text.strip
	end


	page.css('span.h3.price-amount').each do |line|
		price << line.text.strip
	end


	page.css('div.text-muted.listing-location.text-truncate').each do |line|
	  details << line.text.strip.split(/ · /)
	end

end

# write data to CSV file
CSV.open("airbnb_listings.csv", "w") do |file|
	file << ["Listing Name", "Price", "Room type", "Reviews", "Location"]

	name.length.times do |i|
		file << [name[i], price[i], details[i[0]],details[i[1]],details[i[2]]]
	end
end