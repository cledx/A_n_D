class StoriesController < ApplicationController
 
  def new
    @character = Character.find(params[:character_id])
    @story = Story.new({
      character_id: @character.id
      health_points: 20,
      title: "#{@character.name}'s Story",
      summary: "",
      level: 1
    })
  end

  def create

  end

  private

  def stories_params
    params.require(:story).permit(:mood, :setting)
  end

end
