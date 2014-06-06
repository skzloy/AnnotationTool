class ExperimentsController < ApplicationController
 def create
    @article = Article.find(params[:article_id])
    @experiment = @article.experiments.create(experiment_params)
	redirect_to article_path(@article)
  end
 
  private
    def experiment_params
      params.require(:experiment).permit(:blockSize)
    end
end
