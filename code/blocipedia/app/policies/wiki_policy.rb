class WikiPolicy < ApplicationPolicy
    class Scope
        attr_reader :user, :scope
        
        def initialize(user, scope)
            @user = user
            @scope = scope
        end
        
        def resolve
            if user.present? && user.role == 'admin'
                wikis = scope.all
            elsif user.present? && user.role == 'premium'
                all_wikis = scope.all
                wikis = []
                all_wikis.each do |wiki|
                    if !wiki.private? || wiki.user == user
                        wikis << wiki
                    end
                end
            else
                all_wikis = scope.all
                wikis = []
                all_wikis.each do |wiki|
                    if !wiki.private? 
                        wikis << wiki
                    end
                end
            end
            wikis
        end
    end
end

