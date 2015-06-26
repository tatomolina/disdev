class MailboxController < ApplicationController

  def inbox
    @inbox = mailbox.inbox
    @active = :inbox
    @active_user = :messages
    @user = User.find(params[:id])
    authorize @user
  end

  def sent
    @sent = mailbox.sentbox
    @active = :sent
    @active_user = :messages
    @user = User.find(params[:id])
    authorize @user
  end

  def trash
    @trash = mailbox.trash
    @active = :trash
    @active_user = :messages
    @user = User.find(params[:id])
    authorize @user
  end

end
