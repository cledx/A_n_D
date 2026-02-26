class StorySample < ApplicationRecord
  SETTINGS = ["Forest", "City", "Desert", "Castle", "Dragon's Lair", "High Seas", "Raging Battlefield", "Dank Sewers", "Cursed Crypt", "High School", "Mountain Pass", "Feywilds", "Deep Ocean"]
  MOODS = ["Dark", "Lighthearted", "Wacky", "Serious", "Uplifting", "Tragic"]

  def generate
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
end
