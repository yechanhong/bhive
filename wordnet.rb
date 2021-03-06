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
index = WordNet::AdverbIndex.instance
topicalData = ""
t1 = Time.now;
lemma = index.find("quickly")
lemma.synsets.each{|a| topicalData = topicalData + processWordnetOutput(a.to_s)}

synset = lemma.synsets[0]

=begin
puts "============Hypernyms"
# Print the full hypernym derivation for the first sense of 'fruit'.
synset.expanded_hypernym.each { |d| puts d }
=end

puts topicalData.split(" ")
t2 = Time.now
puts "Total Time: #{t2-t1}"