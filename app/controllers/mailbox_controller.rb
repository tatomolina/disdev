class MailboxController < ApplicationController

  def inbox
    @inbox = mailbox.inbox
    @active = :inbox
    @active_user = :messages
  end

  def sent
    @sent = mailbox.sentbox
    @active = :sent
    @active_user = :messages
  end

  def trash
    @trash = mailbox.trash
    @active = :trash
    @active_user = :messages
  end

end
