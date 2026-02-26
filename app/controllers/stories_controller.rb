class StoriesController < ApplicationController
  before_action :find_character, only: %i[new create]

  def index
    @characters = current_user.characters
    @stories = current_user.stories
  end

  def new
    @story = Story.new
    @option_1 = Story.new({
      character_id: @character.id,
      mood: "Pending",
      setting: "Pending",
      title: "Pending"
      }).generate_story_option
    @option_2 = Story.new({
      character_id: @character.id,
      mood: "Pending",
      setting: "Pending",
      title: "Pending"
      }).generate_story_option
  end

  def create
    @story = Story.new({
                         character_id: @character.id,
                         health_points: 20,
                         summary: "",
                         level: 1,
                         setting: params[:story][:setting],
                         mood: params[:story][:mood]
                       })
    @story.title = params[:title] || "#{@character.name}'s Story"
    @story.context = params[:context] || ""
    if @story.save
      @ruby_llm = RubyLLM.chat
      @story_start = Message.new({
        story_id: @story.id
      })
      @ruby_llm.with_instructions(@story.generate_system_prompt)
      @ai_response = @story_start.generate_valid_story_response("Begin the story", @ruby_llm)
      redirect_to message_path(@story_start)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def stories_params
    params.require(:story).permit(:mood, :setting)
  end

  def find_character
    @character = Character.find(params[:character_id])
  end
end
