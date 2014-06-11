include ActionView::Helpers::TextProcessor

class ExperimentsController < ApplicationController
 def create
    @article = Article.find(params[:article_id])
    @experiment = @article.experiments.create(experiment_params)
	  redirect_to article_experiment_path(@experiment)
  end

 def show
   @article = Article.find(params[:article_id])
   @experiment = @article.experiments.find(params[:id])
   @blocks = @experiment.article.text.chars.each_slice(@experiment.blockSize).map(&:join)
 end

  private
    def experiment_params
      params.require(:experiment).permit(:blockSize)
    end

    def get_word_count_by_blocks(blocks)
     for block in blocks
       TextProcessor.word_count(block);
     end
    end
end
