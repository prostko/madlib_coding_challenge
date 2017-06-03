class MadLibResponse < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :madLib
end
