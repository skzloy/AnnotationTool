# encoding: utf-8

class ExperimentsController < ApplicationController

 def create
    @article = Article.find(params[:article_id])
    @experiment = @article.experiments.create(experiment_params)
	  redirect_to article_experiment_path(@article, @experiment)
  end

 def show
   @article = Article.find(params[:article_id])
   @experiment = @article.experiments.find(params[:id])
   words = @experiment.article.text.split(' ')
   @blocks = Array.new
   blockSize = 0
   block = ''
   for word in words
     blockSize += word.size

     if blockSize <= @experiment.blockSize
       block += word + ' '
     else
       @blocks.push(block)
       blockSize = word.size
       block = word + ' '

     end




   end
   #@blocks = @experiment.article.text.chars.each_slice(@experiment.blockSize).map(&:join)
   @word_count = get_word_count_by_blocks(@blocks)
 end

  private
   class TextProcessor
     def self.word_count(text)
       return text.gsub(/[^\p{Cyrillic}]/, ' ').split.size
     end

     def self.sign_count(text)
       return text.gsub(' ', '').size
     end
   end

    def experiment_params
      params.require(:experiment).permit(:blockSize)
    end

    def get_word_count_by_blocks(blocks)
      result = Array.new
      blocks.each { |block|
        result.push(TextProcessor.word_count(block))
      }
      return result
    end
end
