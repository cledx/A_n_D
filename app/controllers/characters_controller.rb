class CharactersController < ApplicationController
  def new
    @character = Character.new
  end

  def create
    @character = Character.new(character_params)

    if @character.save
      redirect_to @character, notice: "Character created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def character_params
    params.require(:character).permit(
      :name,
      :bio,
      :character_class,
      :gender,
      :race
    )
  end
end
