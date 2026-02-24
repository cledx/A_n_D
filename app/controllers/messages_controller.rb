class MessagesController < ApplicationController
  def create
    @message = Message.new(message_params)
    @message.story_id = params[:story_id]
    @message.role = "user"
    if @message.save
      response = narrator_response
      Message.create(role: "narrator", story_id: @story.id, content: response)
      redirect_to message_path(@message)
    else
      render :new, status: :unprocessable_entity
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

  def narrator_response
    ruby_llm = RubyLLM.chat
    ruby_llm.with_instructions(SYSTEM_PROMPT)
    return ruby_llm.ask(@message.content)
  end
end
