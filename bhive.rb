require 'bishop' 
require 'obscenity'
require 'engtagger'
require 'wordnet'


#This simple code gets the comments from the formatted file and returns it as an array
def getMessages(fileName)
	comment = ""
	comments = Array.new;
	File.open(fileName, "r") do |infile|
		line = infile.gets
		while (line = infile.gets)

			if(line.eql?("#Comment\n"))
				if(!comments.eql?(""))
					comments.push(comment);
				end
				comment = ""
			else
				comment = comment + line
			end
		end
	end
	
	return comments
end

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
	text = text.gsub(/[();!.1234567890"",]/, '')
	
=begin
	commons.each do |comm|
		text = text.gsub(/ #{comm} /, ' ')
	end
=end
	
	
	return text
end

def wordTopicalData(word)
	index = WordNet::NounIndex.instance
	topicalData = ""
	lemma = index.find(word)
	if(lemma != nil)
		lemma.synsets.each{|a| topicalData = topicalData + processWordnetOutput(a.to_s)}
		synset = lemma.synsets[0]
	end
	return topicalData.split(" ")
end

def getSensitive(sensitivesPath)
	sensitiveTopics = Array.new
	topic = Array.new;topic.push("")
	File.open(sensitivesPath, "r") do |infile|
		line = infile.gets
		while (line = infile.gets)

			if(line.eql?("#Topic\n"))
				#done
				sensitiveTopics.push(topic)
				topic = Array.new;topic.push("")
			else
				#puts line
				topic[0]= topic[0].concat(" #{line.delete("\n")}")
				#puts topic[0]
				topic.concat(wordTopicalData(line.delete("\n")))
			end
		end
	end
	sensitiveTopics.push(topic)
	return sensitiveTopics
end

def wait()
	test = gets;system ("cls")
end


system ("cls")
#Here we declare and train our Bayes filter with identified messages

subject = "bieber"
sensitivesPath = "testCases/#{subject}/sensitive.txt"
nbMessagesPath = "testCases/#{subject}/nb.txt"
bMessagesPath = "testCases/#{subject}/b.txt"
testMessagesPath = "testCases/#{subject}/test.txt"
tagger = EngTagger.new
classifier = Bishop::Bayes.new{ |probs,ignore| Bishop::robinson(probs, ignore) }


#Sensitive Topics
sensitiveTopics = getSensitive(sensitivesPath)
sensitiveTopics.each do |topic|
	puts "Topic: #{topic[0]} \n"
	topic.delete_at(0)
	puts topic.join(" ")
	puts ""

end

wait() 

#Training
goodMessages = getMessages(nbMessagesPath )

goodMessages.each do |m|
	classifier.train("good",m)
end

badMessages = getMessages(bMessagesPath)

badMessages.each do |m|
	classifier.train("bad",m)
end



#TODO: Print out information on how 
#TODO: [Sensitivity Analysis/Thematic filter is doing] 
#TODO: [Profane filter is picking up the bad words]	
#Here we test our filter. This counter prints 10 lines at a time


testMessages = getMessages(testMessagesPath)
testScores = Array.new
scoreSum = 0;size = 0
t1 = Time.now;
testMessages.each do |m|
	
	check1 = 0
	check2 = 0
	result = classifier.guess(m)
	
	#score & score sum calculation
	if(result[0] != nil)
		check1 = 1
	end
	if(result[1] != nil)
		check2 = 1
	end	
	score = -1
	if(check1 == 1 && check2 == 1)
		score =  (result[0][1]+(1-result[1][1]))/2
	elsif(check1 == 1)
		score =  (result[0][1])
	elsif(check2 == 1)
		score = (1-result[1][1])
	end
	if(score != -1)
		scoreSum = scoreSum + score
		size = size + 1
	end
	testScores.push(score)
	

end
t2 = Time.now
avgScore = scoreSum/size

puts "Non-Bullying Messages"
counter = 0;i=0;nbCount =0;
testScores.each do |score|
	if(score <= avgScore && score != -1)
		puts "Message #{nbCount+1}  --------------------------------------------"
		puts "Probability: #{score.round(3)}"
		puts "Confidence: #{((avgScore - score)/avgScore).round(3)}"
		puts testMessages[i]
		puts "";puts ""
		counter = counter + 1
		nbCount = nbCount + 1
	end	
	if(counter == 30)
		wait();counter = 0
	end
	i = i+1;
end

wait()

puts "Bullying Messages"
counter = 0;i=0;bCount = 0;
testScores.each do |score|
	if(score >= avgScore && score != -1)
		puts "Message #{bCount+1}  --------------------------------------------"
		puts "Probability: #{score.round(3)}"
		puts "Confidence: #{((score - avgScore)/(1-avgScore)).round(3)}"
		puts testMessages[i]
		#puts tagger.add_tags(m)
		
		puts "";puts ""
		counter = counter + 1
		bCount = bCount + 1
	end	
	if(counter == 30)
		wait();counter = 0
	end
	i = i+1;
end




wait()
puts "Bhive Filter Report"
puts ""
puts "#{subject} test case"
puts ""
puts "=Training Data"
puts "  -# Good messages: #{ goodMessages.size()}"
puts "  -# Bad messages: #{ badMessages.size()}"
puts "=Testing Results"
puts "  -Time Taken: #{t2-t1}"
puts "  -Test Data Size: #{testMessages.size()}"
puts "  -Average Probability: #{avgScore}"
puts "  -Parsed Bullying Message: #{bCount}"
puts "  -Parsed Non-Bullying Message: #{nbCount}"
puts "  -Undetermined Messages: #{(testMessages.size() - bCount - nbCount)}"


