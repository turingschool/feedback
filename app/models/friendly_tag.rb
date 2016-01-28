class FriendlyTag
  def self.word_list
    @word_list ||= File.read("./config/words.txt").split("\n")
  end

  def self.generate(length = 4)
    length.times.map do
      word_list.sample
    end.join("-")
  end
end
