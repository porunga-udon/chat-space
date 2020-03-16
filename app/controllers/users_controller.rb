class UsersController < ApplicationController

  def index
    return nil if params[:keyword] == ""

    if params[:group_id].present?
      @group = Group.find(params[:group_id])
      @members = @group.users
      @users = User.where(['name LIKE ?', "%#{params[:keyword]}%"] ).where.not(id: @members.ids).limit(10)
    else
      @users = User.where(['name LIKE ?', "%#{params[:keyword]}%"] ).where.not(id: current_user.id).limit(10)
    end
    
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def edit
  end

  def update 
    if current_user.update(user_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
