class StoriesController < ApplicationController
  before_action :find_character, only: %i[new create]

  def index
    @stories = current_user.stories
    @characters = current_user.characters
  end

  def new
    @story = Story.new
  end

  def create
    @story = Story.new({
                         character_id: @character.id,
                         health_points: 20,
                         title: "#{@character.name}'s Story",
                         summary: "",
                         level: 1,
                         setting: params[:setting],
                         mood: params[:mood]
                       })
    @story.context = params[:context] || ""
    if @story.save
      @message = Message.create({
                                  story_id: @story.id,
                                  content: "You just created this story"
                                })
      redirect_to messages_path(@message)
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
