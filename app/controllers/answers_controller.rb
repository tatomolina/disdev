class AnswersController < ApplicationController
  def create
    @answer = Answer.new(answer_params)
    @blocker = Blocker.find(params[:id_blocker])
    @answer.blocker = @blocker
    authorize @answer
    @answer.user = current_user
    if @answer.save
      flash[:notice] = "Your answer has been posted correctly. Thanks for your contribution"
      # I send him an email to inform that he just being added to the group
      subject = "Answered your blocker"
      body = "The user #{current_user.username} just answered your blocker. Go and check if it is of some help"
      current_user.send_message(@blocker.stand_up.user, body, subject)
    else
      flash[:alert] = "#{@answer.errors.count} errors prohibited this answer from being saved: "
      @answer.errors.full_messages.each do |msg|
        flash[:alert] << "#{msg}"
        flash[:alert] << ", " unless @answer.errors.full_messages.last == msg
      end
    end
    redirect_to @blocker
  end

  def destroy
		@answer = Answer.find(params[:id])
    authorize @answer
    @blocker = @answer.blocker
    if @answer.destroy
       flash[:notice] = "Answer correctly destroyed"
    else
       flash[:alert] = "Answer couldn't be destroyed"
    end
		   redirect_to blocker_path(@blocker)
  end


  private

  def answer_params
    params.require(:answer).permit(:answer)
  end
end
