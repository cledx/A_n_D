class StoriesController < ApplicationController
  before_action :find_character, only: %i[new create]

  def index
    @characters = current_user.characters
    @stories = current_user.stories
    @story = Story.new
    @selected_character =
      if params[:character_id]
        current_user.characters.find(params[:character_id])
      else
        @characters.first
      end
  end

  def new
    @story = Story.new
    @option_1 = StorySample.all.sample
    @option_2 = StorySample.all.sample
    while @option_1 == @option_2
      @option_2 = StorySample.all.sample
    end
  end

  def create
    @story = Story.new({
                         character_id: @character.id,
                         health_points: 100,
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
