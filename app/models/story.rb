class Story < ApplicationRecord
  belongs_to :character
  has_many :messages, dependent: :destroy

  validates :setting, presence: true
  validates :title, presence: true
  validates :mood, presence: true

  def generate_system_prompt
      <<-PROMPT
        You are a Dungeons and Dragons Dungeon Master
        The user is a your player, adventuring in your story.
        The user is a Level #{level} #{character.race} #{character.character_class}
        The story is set a #{mood} story set in a Fantasy #{setting}
        Narrate the user through the adventure, presenting them with challenges along the way.
        Return your response in the form of a JSON with the following keys:{
        story_text: The story text to be displayed to the user. Describe the scene and what the non-player characters within the scene are doing or saying. Write in the second-person.
        option_1: A recommended course of action for the player
        option_2: A second recommended course of action for the user
        dice_roll: If the user has told you an action that would require a dice roll, return a number here with the difficulty (out of 20) of the dice roll. If the action does not require a dice roll, return with false. A JSON with a die roll should have Roll a Die as option_1 and option_2.
        health_change: If the user's actions or the scene have caused the user's health to change, return a positive or negative value here. If the player's JSON ever contains a health value of 0, they have died and the adventure is over.
        }
      PROMPT
  end
end
