class Story < ApplicationRecord
  SETTINGS = ["Forest", "City", "Desert", "Castle", "Dragon's Lair", "High Seas"]
  MOODS = ["Dark", "Lighthearted", "Wacky", "Serious", "Uplifting", "Tragic"]
  belongs_to :character
  has_many :messages, dependent: :destroy

  validates :setting, presence: true
  validates :title, presence: true
  validates :mood, presence: true

  def generate_system_prompt
      <<-PROMPT
        You are a Dungeons and Dragons Dungeon Master
        The user is your player, adventuring in your story.
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
  
  def generate_story_option
    ruby_llm = RubyLLM.chat
    self.update({
      mood: MOODS.sample,
      setting: SETTINGS.sample
    })
    summary_prompt = <<-PROMPT
      You are an experienced screenwriter and D&D dungeon master
      The user is a fellow DM asking for story hooks.
      Produce a 1-2 sentence pitch for a story with a tone of #{mood} set in a #{setting}. Return only your pitch in a plain string.
    PROMPT
    self.update({
      summary: ruby_llm.ask(summary_prompt).content
    })
    context_prompt = <<-PROMPT
      You are an experienced screenwriter and D&D dungeon master
      The user is a fellow DM asking for help.
      Help them build out this story pitch with a paragraph of additional background context to build out the world and strengthen the narrative. Return only your paragraph and in a plain string.
      The pitch: #{summary}
    PROMPT
    self.update({
      context: ruby_llm.ask(context_prompt).content
    })
    return self
  end


  # cloudinary settings
  has_one_attached :photo # need add to form
end
