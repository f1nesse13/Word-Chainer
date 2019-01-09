require 'set'
class WordChainer
  
  def self.from_file(dictionary, word_length)
    word_length > 0 ? word_length : word_length = 5
    words = Set.new
    File.foreach(dictionary) do |line|
      if (line = line.chomp).length == word_length
       words.add(line)
      end
    end
    WordChainer.new(words)
  end

  def initialize(words)
    @dictionary = words
  end

  def adjacent_words(word)
    word_list = []
    word.each_char.with_index do |word_char, i|
      ("a".."z").each do |check_char|
        next if word_char == check_char
        check_word = word.dup
        check_word[i] = check_char
        word_list << check_word if dictionary.include?(check_word)
    end 
  end
  word_list
end
  
  def run(source=@dictionary.to_a.sample, target=@dictionary.to_a.sample)
    @dictionary.add(target) if !@dictionary.include?(target)
    @current_words = [source]
    @all_seen_words = {source => nil}
    until @current_words.empty? || @all_seen_words.include?(target)
      explore_current_words    
    end

    build_path(target)
  end

  def explore_current_words
    new_current_words = []
    @current_words.each do |current_word|
      adjacent_words(current_word).each do |adjacent_word|
        next if @all_seen_words.key?(adjacent_word)
        new_current_words << adjacent_word
        @all_seen_words[adjacent_word] = current_word
      end
    end
    @current_words = new_current_words
  end

  def build_path(target)
    path = []
    current_word = target
    until current_word.nil?
      path << current_word
      current_word = @all_seen_words[current_word]
    end
    path.reverse
  end

  attr_reader :dictionary
  
end
if $0 == __FILE__
  puts "\nWhen running this script an argument can be added to select"
  puts "how many characters the random words selected will be \n\n"
  runner = WordChainer.from_file("dictionary.txt", 
  word_length=ARGV.shift.to_i)
  p runner.run
end