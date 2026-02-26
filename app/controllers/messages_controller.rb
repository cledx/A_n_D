class MessagesController < ApplicationController
  
  def create
    @message = Message.new(message_params)
    @message.story_id = params[:story_id]
    @story = Story.find(params[:story_id])
    @character = Character.find(@story.character_id)
    @message.role = "user"
    if @message.save
      @ruby_llm = RubyLLM.chat
      @ai_message = Message.create({
        story_id: @message.story_id,
        content: "Pending Response..."
      })
      @ai_message.narrator_response(@message, @ruby_llm)
      redirect_to message_path(@ai_message)
    else
      @display_messages = @story.messages.last(5)
      @current_message = @message
      render :show, status: :unprocessable_entity
    end
  end

  def show
    @current_message = Message.find(params[:id])
    @message = Message.new
    @story = Story.find(@current_message.story_id)
    @display_messages = @story.messages.last(5)
    @character = @story.character
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

end
