class FilterLogic < ActiveRecord::Base
    validates_uniqueness_of :keyword, :scope => :user_id
end
