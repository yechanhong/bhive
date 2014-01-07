require 'rubygems'
require 'wordnet'

# Open the index file for nouns
index = WordNet::NounIndex.instance
# Find the word 'fruit'
lemma = index.find("fruit")
# Find all the synsets for 'fruit', and pick the first one.
lemma.synsets.each{|a| puts a}

synset = lemma.synsets[0]
puts "============Hypernyms"
# Print the full hypernym derivation for the first sense of 'fruit'.
synset.expanded_hypernym.each { |d| puts d }