class StoriesController < ApplicationController
  def index
    @stories = current_user.stories
    @characters = current_user.characters
    @character = Character.find(params[:character_id])
  end
end
