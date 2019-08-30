class BadgesController < ApplicationController
  def create

    slack_text = request[:text]
    slack_text_tokens = slack_text.split

    if(slack_text_tokens[0] == "create")
      if(request[:user_id] != "UBUQM01QE")
        render :json => "No soup for you!", status: 200 and return
      else
        badge = Badge.new
        badge.name = slack_text_tokens[1]
        badge.description = slack_text_tokens[2]
        badge.group = slack_text_tokens[3]
        badge.small_image_url = slack_text_tokens[4]
        badge.save

        render :json => "I saved #{badge.name}", status: 200 and return
      end
    end

    if(slack_text_tokens[0] == "list")
      for_whom = slack_text_tokens[1]
      text = "All the badges!"

      if(for_whom.blank?)
        badges = Badge.all
      else
        text = "Badge collection of #{for_whom}"
        badges = BadgesSlackUser.where(:slack_user_name => "@gary.moore").map(&:badge)
      end

      attachments = []

      badges.each do |badge|
        badge_json = {
          "type": "image",
          "title": badge.name,
          "image_url": badge.small_image_url,
          "alt_text": badge.description
        }
        attachments << badge_json
      end

      response_to_slack = {
          "text": text,
          "attachments": attachments
          }

      render :json => response_to_slack.to_json, status: 200 and return
    end

    if(slack_text_tokens[0] == "award")
      badge_name = slack_text_tokens[1]
      to_whom = slack_text_tokens[2]

      badge = Badge.where(:name => badge_name).first
      badges_slack_user = BadgesSlackUser.new
      badges_slack_user.badge = badge
      badges_slack_user.slack_user_name = to_whom
      badges_slack_user.save

      render :json => "Awarded #{badge_name} to #{to_whom}", status: 200 and return
    end

    render :json => "I'm sorry #{request[:user_name]}, I'm afraid I can't do that", status: 200
  end
end