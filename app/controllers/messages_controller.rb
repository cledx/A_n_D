class MessagesController < ApplicationController
  
  def create
    @message = Message.new(message_params)
    @message.story_id = params[:story_id]
    @story = Story.find(params[:story_id])
    @character = Character.find(@story.character_id)
    @message.role = "user"
    if @message.save
      @ai_response = narrator_response
      @ai_message = Message.new({
        story_id: @message.story_id,
        role: "assistant", 
        content: @ai_response["story_text"]
      })
      @ai_message.save
      @story.health_points += @ai_response["health_change"]
      redirect_to message_path(@ai_message)
    else
      @display_messages = @story.messages.last(5)
      @current_message = @message
      render :show, status: :unprocessable_entity
    end
  end

  def show
    @current_message = Message.find(params[:id])
    @message = Message.new
    @story = Story.find(@current_message.story_id)
    @display_messages = @story.messages.last(5)
    @character = @story.character
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def generate_system_prompt
      system_prompt = <<-PROMPT
        You are a Dungeons and Dragons Dungeon Master
        The user is a your player, adventuring in your story.
        The user is a Level #{@story.level} #{@character.race} #{@character.character_class}
        The story is set a #{@story.mood} story set in a Fantasy #{@story.setting}
        Narrate the user through the adventure, presenting them with challenges along the way.
        Return your response in the form of a JSON with the following keys:{
        story_text: The story text to be displayed to the user. Describe the scene and what the non-player characters within the scene are doing or saying. Write in the second-person.
        option_1: A recommended course of action for the player
        option_2: A second recommended course of action for the user
        dice_roll: If the user has told you an action that would require a dice roll, return a number here with the difficulty (out of 20) of the dice roll. If the action does not require a dice roll, return with false. A JSON with a die roll should have Roll a Die as option_1 and option_2.
        health_change: If the user's actions or the scene have caused the user's health to change, return a positive or negative value here. If the player's JSON ever contains a health value of 0, they have died and the adventure is over.
        }
      PROMPT
  end

  def build_conversation_history
    @story.messages.each do |message|
      puts message
      @ruby_llm.add_message(message)
    end
  end

  def player_action_data
    player_data = {
      player_action: @message.content,
      player_health: @story.health_points
    }
  end

  def narrator_response
    @ruby_llm = RubyLLM.chat
    @ruby_llm.with_instructions(generate_system_prompt)
    build_conversation_history
    ai_message = @ruby_llm.ask("#{player_action_data}")
    @ai_json = {}
    valid_response = false
    until valid_response
      begin
        parsed = JSON.parse(ai_message.content)
        if parsed.is_a?(Hash) && parsed.key?("option_1") && parsed.key?("option_2")
          @ai_json = parsed
          valid_response = true
        else
          ai_message = @ruby_llm.ask("#{ai_message.content} (SYSTEM MESSAGE): ERROR, PREVIOUS RESPONSE DOES NOT CONTAIN option_1 AND option_2 KEYS /n #{player_action_data}")
        end

        rescue JSON::ParserError
          ai_message = @ruby_llm.ask("#{ai_message.content} (SYSTEM MESSAGE): ERROR, PREVIOUS RESPONSE NOT A JSON /n #{player_action_data}")
      end
    end
    @ai_json
  end
end
