class NotifyMailer < ActionMailer::Base
  default from: "qb@gslab.com"

  def select_question(question)
    @question = question
    mail(:to => "sawan@gslab.com", :subject => "Question of the day")
  end
end
