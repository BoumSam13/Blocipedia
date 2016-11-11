class CollaboratorsController < ApplicationController
  before_action :set_wiki
  
  def new
    @collaborator = @wiki.collaborators.new
  end
  
  def show
    @collaborator = Collaborator.find(params[:id])
  end
  
  def create
    @collaborator = @wiki.collaborators.new(collaborator_params)
    
    if @collaborator.save
      flash[:notice] = "#{@collaborator.user.name} was added as a collaborator to this wiki."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error adding the collaborator. Please try again."
      redirect_to @wiki
    end
  end

  def destroy
    @collaborator = Collaborator.find(params[:id])
    
    if @collaborator.destroy
      flash[:notice] = "#{@collaborator.user.name} was removed from this wiki."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error removing the collaborator. Please try again."
      redirect_to @wiki
    end
  end
  
  private
  
  def set_wiki
    @wiki = Wiki.find(params[:wiki_id])
  end
  
  def collaborator_params
    params.require(:collaborator).permit(:wiki_id, :user_id)
  end
end
