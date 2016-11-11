class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators
  has_many :users, through: :collaborators
  
  def all_users
      available = []
      
      @wiki = Wiki.find(id)
      User.where.not(name: @wiki.user.name).order(name: :asc).each do |user|
        if !users.include?(user)
          available << user 
        end
      end

      return available
  end
end
