class Badge < ActiveRecord::Base
  has_many :badges_slack_users
end