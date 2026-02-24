class StoriesController < ApplicationController
  def index
    @stories = Story.all
    @characters = Character.all
  end
end
