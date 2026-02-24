class StoriesController < ApplicationController
  def index
    @stories = current_user.stories
    @characters = current_user.characters
  end
end
