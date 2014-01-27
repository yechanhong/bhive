require 'net/http'
require 'open-uri'
require 'nokogiri'
require 'spellchecker'

#TODO: consider [spelling checking with slangs as proper words] 
#TODO: [A synonym filter that will take similar slangs, phrases and translate them into appropriate thematic words] 
#TODO: [preserving emoticon and symbols as part of bayes analysis]
#This method processes the raw internet text into a formatted text that the filter can process
def processString(text)
	encoding_options = {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
	}
	
	#commons = ["the","of","and","a","to","in","is","you","that","it","he","was","for","on","are","as","with","his","they","I","at","be","this","have","from","or","one","had","by","word","but","not","what","all","were","we","when","your","can","said","there","use","an","each","which","she","do","how","their","if","will","up","other","about","out","many","then","them","these","so","some","her","would","make","like","him","into","time","has","look","two","more","write","go","see","number","no","way","could","people","my","than","first","water","been","call","who","oil","its","now","find","long","down","day","did","get","come","made","may","part"]
	#commons = ["the","of","and","a","to","in","is","you","that","it","he","was","for","on","are","as","with","his","they","I","at","be","this","have","from","or","we"]

	
	text = text.downcase
	#c = c.gsub(/\\x[0-9a-zA-Z][0-9a-zA-Z]/, '')
	text = text.encode Encoding.find('ASCII'), encoding_options
	text = text.gsub(/[.,!?~\/\\*=-@#]/, ' ')
	
=begin
	commons.each do |comm|
		text = text.gsub(/ #{comm} /, ' ')
	end
=end
	
	
	return text
end





#This is the main segment of the code that will extract the comments from a particular video

#url = "http://www.youtube.com/all_comments?v=kffacxfA7G4&page=1"

File.open('newComments.txt', 'w') {|f|


page = 1

for i in 0..5
videoID = "kfVsfOSbJY0"
puts i
commentIndex = (i+page-1)*50+1
url = "http://gdata.youtube.com/feeds/api/videos/#{videoID}/comments?max-results=50&start-index=#{commentIndex}"
data = Nokogiri::HTML(open(url))

data.xpath("//content").each do |element|
	f.write("#Comment\n")
	f.write(processString(element.text)+"\n")	
end
	
end



}
