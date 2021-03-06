class ConversationsController < ApplicationController

  def new
    @active_user = :messages
    @user = current_user
  end

  def create
    recipients = User.where(id: conversation_params[:recipients])
    conversation = current_user.send_message(recipients, conversation_params[:body], conversation_params[:subject]).conversation
    flash[:notice] = "Your message was successfully sent!"
    redirect_to conversation_path(conversation)
  end

  def show
    @receipts = conversation.receipts_for(current_user)
    @user = current_user
    # mark conversation as read
    conversation.mark_as_read(current_user)
    @active_user = :messages
  end

  def reply
    current_user.reply_to_conversation(conversation, message_params[:body])
    flash[:notice] = "Your reply message was successfully sent!"
    redirect_to conversation_path(conversation)
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to mailbox_inbox_path(current_user)
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to mailbox_inbox_path(current_user)
  end

  private

  def conversation_params
    params.require(:conversation).permit(:subject, :body,recipients:[])
  end

  def message_params
    params.require(:message).permit(:body, :subject)
  end

end
