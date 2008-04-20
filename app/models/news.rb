class News < ActiveRecord::Base
    acts_as_authorizable

    attr_protected :user_id # публикуем только от своего имени

end
