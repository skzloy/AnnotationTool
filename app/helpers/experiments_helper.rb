module ExperimentsHelper
  class TextProcessor
    def word_count(text)
      return text.gsub(/[^-a-zA-Z]/, ' ').split.size
    end

    def sign_count(text)
      return text.gsub(' ', '').size
    end
  end
end
