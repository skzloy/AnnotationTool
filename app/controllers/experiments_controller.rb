class ExperimentsController < ApplicationController
 def create
    @article = Article.find(params[:article_id])
    @experiment = @article.experiments.create(experiment_params)
	  redirect_to article_experiment_path(@experiment)
  end

 def show
   @experiment = Experiment.find(params[:id])
   @blocks = @experiment.article.text.chars.each_slice(@experiment.blockSize).map(&:join)
 end

  private
    def experiment_params
      params.require(:experiment).permit(:blockSize)
    end
end
