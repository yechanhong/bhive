
#read in data
 encoding_options = {
    :invalid           => :replace,  # Replace invalid byte sequences
    :undef             => :replace,  # Replace anything not defined in ASCII
    :replace           => '',        # Use a blank for those replacements
  }
  
counter =0
comment = ""
comments = Array.new;

File.open("bMessages.txt", "r") do |infile|
    while (line = infile.gets)

        if(line.eql?("#Comment\n"))
			if(!comments.eql?(""))
				comments.push(comment);
			end
			comment = ""
		else
			comment = comment + line
		end
        #puts "#{counter}: #{line}"
    end
end


#process message
pcomments = Array.new
comments.each do |c|
	c = c.downcase
	#c = c.gsub(/\\x[0-9a-zA-Z][0-9a-zA-Z]/, '')
	c = c.encode Encoding.find('ASCII'), encoding_options
	c = c.gsub(/[.,!?~\/\\*=-@#]/, '')
	c = c.gsub(/he/, '')
	c = c.gsub(/the/, '')
	c = c.gsub(/is/, '')
	c = c.gsub(/i/, '')
	pcomments.push(c)
end


#Incorporate to database
bsize = 0
bully = Hash.new(0)
pcomments.each do |c|
	bsize = bsize + 1
	commentFeatures = Hash.new(0)
	features = c.split(' ')
	features.each do |f|
		if(commentFeatures[f] = 0)
			commentFeatures[f] = 1
		end
	end
	
	commentFeatures.keys.each do |f|
		if(bully[f]==0)
			bully[f] = 1
		else
			bully[f] = bully[f] + 1
		end				
	end
end


##================================================ Now time for no bullying
comment = ""
comments = Array.new;
File.open("nbMessages.txt", "r") do |infile|
    while (line = infile.gets)

        if(line.eql?("#Comment\n"))
			if(!comments.eql?(""))
				comments.push(comment);
			end
			comment = ""
		else
			comment = comment + line
		end
        #puts "#{counter}: #{line}"
    end
end


#process message
pcomments = Array.new
comments.each do |c|
	c = c.downcase
	#c = c.gsub(/\\x[0-9a-zA-Z][0-9a-zA-Z]/, '')
	c = c.encode Encoding.find('ASCII'), encoding_options
	c = c.gsub(/[.,!?~\/\\*=-@#]/, '')
	pcomments.push(c)
end


#Incorporate to database
nbsize = 0
nbully = Hash.new(0)
pcomments.each do |c|
	nbsize = nbsize +1
	commentFeatures = Hash.new(0)
	features = c.split(' ')
	features.each do |f|
		if(commentFeatures[f] = 0)
			commentFeatures[f] = 1
		end
	end
	
	commentFeatures.keys.each do |f|
		if(nbully[f]==0)
			nbully[f] = 1
		else
			nbully[f] = nbully[f] + 1
		end				
	end
end


#=================== Calculating Probabilities=====================!!!!!!!!!!

File.open("comments.txt", "r") do |infile|
    while (line = infile.gets)

        if(line.eql?("#Comment\n"))
			if(!comments.eql?(""))
				comments.push(comment);
			end
			comment = ""
		else
			comment = comment + line
		end
        #puts "#{counter}: #{line}"
    end
end


#process message
pcomments = Array.new
comments.each do |c|
	c = c.downcase
	c = c.encode Encoding.find('ASCII'), encoding_options
	c = c.gsub(/[.,!?~\/\\*=-@#]/, '')
	pcomments.push(c)
end

k = (bsize+0.0)/(bsize+nbsize)
pcomments.each do |c|
	#prob = (bsize+0.0)/(bsize+nbsize);
	prob = 1
	features = c.split(' ')
	features.each do |f|
		prf = (bully[f]+nbully[f]+1.0)/(bsize+nbsize)
		prfb = k*(bully[f]+1.0)/(bsize) 
		#puts "#{f} #{prfb/prf} x -- #{prob}" 
		prob = prob*prfb/prf
	end
	
	if(prob != 1)
		puts c
		puts prob
	end
	
end



File.open('output.txt', 'w') {|f|
	f.write(bully.sort_by { |word, freq| freq }.reverse)
}


#puts bully
#puts size
#Database is set up, derieve the probability

