require "open-uri"

class CharactersController < ApplicationController
  before_action :authenticate_user!

  def new
    @character = Character.new
  end

  def create
    clean_params = character_params
    image_url = clean_params.delete(:img_url)
    @character = current_user.characters.build(clean_params)
    if image_url == ""
      file = URI.parse("https://i.pinimg.com/736x/b3/7e/ae/b37eae5174dd61d337fe1fb7d9bfe979.jpg").open
    else
      file = URI.parse(image_url).open
    end
    @character.photo.attach(io: file, filename: "character.png", content_type: "image/png")
    if @character.save
      redirect_to new_character_story_path(@character),
                  notice: "Character created! Now write the story."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def generate_appearance
    race = params[:race]
    char_class = params[:character_class]
    gender = params[:gender]
    appearance_desc = params[:appearance_description]

    begin
      # Usando RubyLLM
      response = RubyLLM.paint("An #{race} #{char_class} character in an RPG game. Just only one front-view full-body
      image of a #{gender} character with #{appearance_desc} in pixel art style with white background,
      don't put text or isolate shapes around .")

      image_url = response.url

      render json: { url: image_url }
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def character_params
    params.require(:character).permit(
      :name,
      :gender,
      :character_class,
      :race,
      :bio,
      :img_url
    )
  end
end
