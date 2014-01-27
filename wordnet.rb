require 'rubygems'
require 'wordnet'

system ("cls")
# Open the index file for nouns
index = WordNet::VerbIndex.instance
# Find the word 'fruit'
lemma = index.find("are")
# Find all the synsets for 'fruit', and pick the first one.
lemma.synsets.each{|a| puts a}
synset = lemma.synsets[0]


puts "============Hypernyms"
# Print the full hypernym derivation for the first sense of 'fruit'.
synset.expanded_hypernym.each { |d| puts d }