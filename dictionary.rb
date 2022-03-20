class Dictionary
	def initialize(file)
    @file = file
  end

  # Convert file words to array
  def array
  	arr = Array.new
  	file = File.open(@file) do |f|
  		f.each_line do |line|
        arr.push(line.chomp.downcase)
      end
    end
    arr.reject(&:empty?)
  end

  # Create sequences of each word
  def hash_of_sequences
  	sequences = Array.new
  	words = Array.new
  	duplicates = Array.new
  	array.each do |word|
  		chars = word.chars
  		seqs = chars.map.with_index {|x,i| word.slice(i..3+i)}

  		seqs.keep_if{|x| x.length == 4}.each do |seq|
  			if words.include?(seq)
  				duplicates.push(seq)
  			else
  				words.push(seq)
  			end
  			sequences.push( {word: word, sequence: seq} )
  		end
  	end
  	sequences.delete_if { |hash| duplicates.include?(hash[:sequence]) }
  end

  # Save into file
  def save_file
    sequence_file = File.open( 'sequences.txt', 'w' )
    word_file = File.open( 'words.txt', 'w' )

    hash_of_sequences.each do |hash|
      sequence_file.write("#{hash[:sequence]}\n")
      word_file.write("#{hash[:word]}\n")
    end

    sequence_file.close
    word_file.close
  end
end

dic = Dictionary.new('words_test.txt')
dic.save_file