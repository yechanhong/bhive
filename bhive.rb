require 'bishop'
require 'obscenity'

#This simple code gets the comments from the formatted file and returns it as an array
def getMessages(fileName)
	comment = ""
	comments = Array.new;
	File.open(fileName, "r") do |infile|
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



#Here we declare and train our Bayes filter with identified messages
classifier = Bishop::Bayes.new{ |probs,ignore| Bishop::robinson(probs, ignore) }

goodMessages = getMessages("nbMessages.txt")
goodMessages.each do |m|
	classifier.train("good",m)
end

badMessages = getMessages("bMessages.txt")
badMessages.each do |m|
	classifier.train("bad",m)
end

#TODO: Print out information on how 
#TODO: [Sensitivity Analysis/Thematic filter is doing] 
#TODO: [Profane filter is picking up the bad words]
#Here we test our filter. This counter prints 10 lines at a time

testMessages = getMessages("commentsNew.txt")
counter = 0
testMessages.each do |m|
	puts m
	puts classifier.guess(m)
	puts "----------------------------------------------"
	counter = counter + 1
	if(counter == 10)
		test = gets
		system ("cls")
		counter = 0
	end
end


