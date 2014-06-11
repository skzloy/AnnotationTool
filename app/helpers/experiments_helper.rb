module ExperimentsHelper
  class TextProcessor
    def self.word_count(text)
      return text.gsub(/[^-a-zA-Z]/, ' ').split.size
    end

    def self.sign_count(text)
      return text.gsub(' ', '').size
    end
  end
end
