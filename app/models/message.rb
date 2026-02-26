class Message < ApplicationRecord
  belongs_to :story

  validates :content, presence: true, length: { minimum: 10 }

  def build_conversation_history(ruby_llm)
    story.messages.each do |message|
      ruby_llm.add_message(message)
    end
  end

  def generate_valid_story_response(message, ruby_llm)
    ai_message = ruby_llm.ask(message)
    parsed_json = {}
    valid_response = false
    until valid_response
      begin
        parsed = JSON.parse(ai_message.content)
        if parsed.is_a?(Hash) && parsed.key?("option_1") && parsed.key?("option_2")
          parsed_json = parsed
          valid_response = true
        else
          ai_message = ruby_llm.ask("#{ai_message.content} (SYSTEM MESSAGE): ERROR, PREVIOUS RESPONSE DOES NOT CONTAIN option_1 AND option_2 KEYS /n #{player_action_data}")
        end

        rescue JSON::ParserError
          ai_message = ruby_llm.ask("#{ai_message.content} (SYSTEM MESSAGE): ERROR, PREVIOUS RESPONSE NOT A JSON /n #{player_action_data}")
      end
    end
    self.update({
        role: "assistant", 
        content: parsed_json["story_text"],
        option_1: parsed_json["option_1"],
        option_2: parsed_json["option_2"],
        dice_roll: parsed_json["dice_roll"]
      })
      story.health_points += (parsed_json["health_change"] || 0)
      story.save
  end

  def player_action_data
    player_data = {
      player_action: content,
      player_health: story.health_points
    }
  end

  def narrator_response(user_message, ruby_llm)
    ruby_llm.with_instructions(story.generate_system_prompt)
    message.build_conversation_history(ruby_llm)
    if @story.health_points == 0
      self.update({
        content: "You have died.",
        option_1: "Game Over",
        option_2: "Game Over"
      })
    else
      self.generate_valid_story_response("#{user_message.player_action_data}", @ruby_llm)
    end
  end
end
