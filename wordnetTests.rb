require 'rubygems'
require 'wordnet'

def processWordnetOutput(text)
	encoding_options = {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
	}

	text = text.downcase
	#c = c.gsub(/\\x[0-9a-zA-Z][0-9a-zA-Z]/, '')
	text = text.encode Encoding.find('ASCII'), encoding_options
	text = text.gsub(/\([a-z]\)/, '')
	text = text.gsub(/[();"",]/, '')
	
	
=begin
	commons.each do |comm|
		text = text.gsub(/ #{comm} /, ' ')
	end
=end
	
	
	return text
end


system ("cls")
include WordNet
topicalData = ""
t1 = Time.now;
lemmas = WordNetDB.find("great")
puts lemmas.size
for i in 0..lemmas.size()-1
lemma = lemmas[i]
lemma.synsets.each{|a| puts processWordnetOutput(a.to_s)}
synset = lemma.synsets[0]
puts "---"
end