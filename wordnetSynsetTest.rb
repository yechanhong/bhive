require 'rubygems'
require 'wordnet'
require 'wordnet-defaultdb'
#http://www.rubydoc.info/github/ged/ruby-wordnet/master/WordNet

def processWordnetOutput(text)
	encoding_options = {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
	}

	text = text.downcase
	#c = c.gsub(/\\x[0-9a-zA-Z][0-9a-zA-Z]/, '')
	text = text.encode Encoding.find('ASCII'), encoding_options
	text = text.gsub("(n) ", '')
	text = text.gsub(/[();"",]/, '')
	
=begin
	commons.each do |comm|
		text = text.gsub(/ #{comm} /, ' ')
	end
=end
	
	
	return text
end


system ("cls")
#known bug https://bitbucket.org/ged/ruby-wordnet/issue/3/3-sqlite3-sqlexception-no-such-table

lex = WordNet::Lexicon.new
t1 = Time.now;
synset = lex[ :language ]
puts synset

t2 = Time.now;
puts "Total Time: #{t2-t1}"