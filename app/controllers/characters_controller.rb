class CharactersController < ApplicationController
  before_action :authenticate_user!
  def new
    @character = Character.new
  end

  def create
    @character = current_user.characters.build(character_params)

    if @character.save
      redirect_to new_character_story_path(@character),
                  notice: "Character created! Now write the story."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def character_params
    params.require(:character).permit(
      :name,
      :gender,
      :character_class,
      :race,
      :bio
    )
  end
end
