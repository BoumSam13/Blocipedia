class WikisController < ApplicationController
  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id]);
    
    role = current_user.role
    case role
      when "standard"
        if @wiki.private
          flash[:alert] = "You are not authorized to see this private wiki since you are signed up with a standard membership!"
          redirect_to root_path
        end
      when "premium"
        if @wiki.private && @wiki.user != current_user
          flash[:alert] = "You are not authorized to see this private wiki since you did not create it!"
          redirect_to root_path
        end
    end
  end

  def new
    @wiki = Wiki.new
  end
  
  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    
    if current_user.standard?
      @wiki.update_attribute(:private, false)
    end
    
    if @wiki.save
      flash[:notice] = "Wiki was saved successfully."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    
    role = current_user.role
    case role
      when "standard"
        if @wiki.private
          flash[:alert] = "You are not authorized to edit this private wiki since you are signed up with a standard membership!"
          redirect_to root_path
        end
      when "premium"
        if @wiki.private && @wiki.user != current_user
          flash[:alert] = "You are not authorized to edit this private wiki since you did not create it!"
          redirect_to root_path
        end
    end
  end
  
  def update
    @wiki = Wiki.find(params[:id])
    @wiki.assign_attributes(wiki_params)
    
    if @wiki.save
      flash[:notice] = "Wiki was updated successfully."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end
  
  def destroy
    @wiki = Wiki.find(params[:id])
    
    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash[:alert] = "There was an error deleting the post."
      render :show
    end
  end
  
  private
  
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
