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
   textBlock = ''
   blockCount = 0
   for word in words
     blockSize += word.size

     if blockSize <= @experiment.blockSize
       textBlock += word + ' '
     else
       block = Block.new(textBlock, @experiment.blockSize, blockCount)
       @blocks.push(block)
       blockSize = word.size
       textBlock = word + ' '
       blockCount += 1

     end
   end
   #@blocks = @experiment.article.text.chars.each_slice(@experiment.blockSize).map(&:join)
   word_count = get_word_count_by_blocks(@blocks)
   sign_count = get_sign_count_by_blocks(@blocks)
   word_count_divided_by_sign_count = word_count.zip(sign_count).map {|a| a.inject(1.0, :/)}
   @blocks_by_word_count_divided_by_sign_count = Hash[(0..@blocks.size).to_a.zip word_count_divided_by_sign_count]
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

    class Block
      attr_reader :Size, :EspChar, :WordCount, :SignCount, :RawText, :ID
      def initialize(text, size, id)
        @ID = id
        @RawText = text
        @WordCount = TextProcessor.word_count(text)
        @SignCount = TextProcessor.sign_count(text)
        @Size = size
        @EspChar = EspersanCharacteristic.new(text)
      end
    end

    class EspersanCharacteristic
      attr_reader :ESP6, :ESP5, :ESP3
      def initialize(block)
        @block = block
        @ESP6 = ESP6.new(block)
        @ESP5 = ESP5.new(@ESP6)
        @ESP3 = ESP3.new(@ESP6)
      end

    end

    class ESP6
      attr_reader :E1, :E2, :E3, :E4, :E5, :E6
      def initialize(block)
        @E1 = sign_count(block, "птк")
        @E2 = sign_count(block, "сшфцхщ")
        @E3 = sign_count(block, "бдг")
        @E4 = sign_count(block, "взж")
        @E5 = sign_count(block, "мн")
        @E6 = sign_count(block, "лрй")
      end

      private
        def sign_count(text, command)
          return text.count command
        end

    end

    class ESP5
      attr_reader :E1, :E2, :E3, :E4, :E5
      def initialize(esp6)
        if(esp6.instance_of?(ESP6))
          @E1 = esp6.E1
          @E2 = esp6.E2
          @E3 = esp6.E3 + esp6.E4
          @E4 = esp6.E5
          @E5 = esp6.E6
        end

      end
    end

    class ESP3
      attr_reader :E1, :E2, :E3, :EP1, :EP2, :EP3
      def initialize(esp6)
        if(esp6.instance_of?(ESP6))
          @E1 = esp6.E1 + esp6.E2
          @E2 = esp6.E3 + esp6.E4
          @E3 = esp6.E5 + esp6.E6

          #Refactor that!!!
          if(@E1 == @E2)
            @EP1 = @EP2 = 2
            if(@E1 == @E3)
              @EP3 = 2
            elsif @E1 < @E3
              @EP3 = 1
            else
              @EP3 = 3
            end
          elsif(@E1 == @E3)
            @EP1 = @EP3 = 2
            if(@E1 == @E2)
              @EP2 = 2
            elsif @E1 < @E2
              @EP2 = 1
            else
              @EP2 = 3
            end
          elsif(@E2 == @E3)
            @EP2 = @EP3 = 2
            if(@E2 == @E1)
              @EP1 = 2
            elsif @E2 < @E1
              @EP1 = 1
            else
              @EP1 = 3
            end
          else
            if(@E1 < @E2)
              if(@E2 < @E3)
                @EP1 = 3
                @EP2 = 2
                @EP3 = 1
              elsif(@E1 < @E3)
                @EP1 = 3
                @EP2 = 1
                @EP3 = 2
              else
                @EP1 = 2
                @EP2 = 1
                @EP3 = 3
              end
            else
              if(@E2 > @E3)
                @EP1 = 1
                @EP2 = 2
                @EP3 = 3
              elsif(@E1 < @E3)
                @EP1 = 2
                @EP2 = 3
                @EP3 = 1
              else
                @EP1 = 1
                @EP2 = 3
                @EP3 = 2
              end
            end
          end
        end

      end
    end

    def experiment_params
      params.require(:experiment).permit(:blockSize)
    end

    def get_word_count_by_blocks(blocks)

      result = Array.new
      blocks.each { |block|
        result.push(block.WordCount)
      }
      return result
    end

   def get_sign_count_by_blocks(blocks)
     result = Array.new
     blocks.each { |block|
       result.push(block.SignCount)
     }
     return result
   end
end
