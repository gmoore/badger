class CreateBadgesUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :badges_slack_users do |t|
      t.integer :badge_id

      # Would rather use id here, but we only get the name
      # and it's a total pain to get the ID
      t.string  :slack_user_name
      t.timestamps
    end
  end
end
