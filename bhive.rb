require 'bishop'
require 'obscenity'

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


system ("cls")
#Here we declare and train our Bayes filter with identified messages
classifier = Bishop::Bayes.new{ |probs,ignore| Bishop::robinson(probs, ignore) }

goodMessages = getMessages("nbMessages.txt")
puts "good #{ goodMessages.size()}"
goodMessages.each do |m|
	classifier.train("good",m)
end

badMessages = getMessages("bMessages.txt")
puts "bad #{ badMessages.size()}"
badMessages.each do |m|
	classifier.train("bad",m)
end

#TODO: Print out information on how 
#TODO: [Sensitivity Analysis/Thematic filter is doing] 
#TODO: [Profane filter is picking up the bad words]	
#Here we test our filter. This counter prints 10 lines at a time

testMessages = getMessages("commentsNew.txt")
puts "test #{ testMessages.size()}"
counter = 0
scoreSum = 0
size = 0
testMessages.each do |m|
	
	check1 = 0
	check2 = 0
	result = classifier.guess(m)
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
	
	if(score >= 0.28 && score != -1)
		puts m
		puts score
		puts "----------------------------------------------"
		counter = counter + 1
	end	

	if(counter == 30)
		test = gets
		system ("cls")
		counter = 0
	end
end

puts scoreSum/size
