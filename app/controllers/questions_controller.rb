class QuestionsController < ApplicationController
  before_filter :question
  before_filter :validate_tags, :only => [:create, :update]

  def index
    tags = filter_tags
     @current_user = current_user
    # http://stackoverflow.com/questions/2082399/thinking-sphinx-and-acts-as-taggable-on-plugin
    if(current_user.roles.first.name.eql? "admin" rescue false)
      @questions = Question.tagged_with(tags, :match_all => false).paginate(:page => params[:page]) unless tags.blank?
      @questions ||= Question.paginate(:page => params[:page])
  #    @all_questions = Question.all
    elsif(current_user.first_name.eql? "devjudge")
      @judge = true
      conditions = ["track='dev'"]
      conditions[0] << " and  created_at between '"+params[:fromdate] +"' and '"+params[:todate] +"'"  if(params[:fromdate])
      @questions = Question.tagged_with(tags, :match_all => false).paginate(:page => params[:page],:conditions => conditions).order("created_at DESC") unless tags.blank?
      @questions ||= Question.paginate(:page => params[:page],:conditions => conditions).order("created_at DESC")

    elsif( current_user.first_name.eql? "qajudge")
      @judge = true
      conditions = ["track='qa'"]
      conditions[0] << " and  created_at between '"+params[:fromdate] +"' and '"+params[:todate] +"'"  if(params[:fromdate])
      @questions = Question.tagged_with(tags, :match_all => false).paginate(:page => params[:page],:conditions => conditions).order("created_at DESC") unless tags.blank?
      @questions ||= Question.paginate(:page => params[:page],:conditions => conditions).order("created_at DESC")
    else
      @questions = Question.tagged_with(tags, :match_all => false).paginate(:page => params[:page],:conditions => ['submitter_id='+current_user.id.to_s]) unless tags.blank?
      @questions ||= Question.paginate(:page => params[:page],:conditions => ['submitter_id='+current_user.id.to_s])
    #  @all_questions = Question.find_all_by_submitter_id current_user.id
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.text { send_data @questions.text_format, :filename => "#{Time.now.utc.to_s.gsub('-', '').gsub(':', '').delete(' ')}_questions_#{tags.join('_')}.txt" }
    end
  end

  def show
  end

  def new
  end

  def create
    
    @question.assign_attributes params[:question]
    @question.topic_list = params[:question][:topic_list] unless params[:question][:topic_list].blank?
    
    @question.assign_objective_options params[:objective_options] if  params[:question]["nature_list"].eql?"Objective"
    @question.submitter = current_user


    if @question.save_attachments(params[:attachment]) and (@question.save! rescue false)
      redirect_to @question, :notice => "Successfully created question."
    else
      @question.errors[:base] << @attachments_errors
      render :new
    end
  end

  def edit
  end

  def update
    if @question.submitter != current_user
      flash[:error] = "For now, only owner can edit this."
      render :edit
      return
    end

    @question.assign_attributes params[:question]
    @question.topic_list = params[:question][:topic_list] unless params[:question][:topic_list].blank?
    @question.update_objective_options params[:objective_options]
    
    @question.assign_attributes :delta => true
    
    if @question.save_attachments(params[:attachment]) and @question.update_attributes(params[:statement]) and @question.save
      redirect_to @question, :notice  => "Successfully updated question."

    else
      @question.errors[:base] << @attachments_errors
      render :edit
    end
  end

  def destroy

    @question = Question.find_by_id params[:id]
    if((current_user.roles.first.name.eql? "admin" rescue false) or (@question.submitter == current_user))
      @question.destroy
      redirect_to questions_url, :notice => "Question Deleted Successfully"
    else
      redirect_to questions_url, :notice => "Question Not deleted:- You were not permitted to delete the question"
    end
  end

  def import
    if request.post?
      importer = QuestionImporter.new params[:questions_file], current_user

      @upload_error = importer.upload_error
      @failed_upload_question_numbers = importer.failed_upload_question_numbers
      @successfuly_upload_question_numbers = importer.successfuly_upload_question_numbers
      @questions = importer.successfuly_upload_questions
      
      if not @upload_error
        render :index, :notice => 'Questions uploaded!'

      else
        @questions = Question.paginate(:page => params[:page])
        flash[:error] = "Questions upload failed: #{@upload_error}"
        render :index
      end
    end
  end

  def finalize
    if(current_user.first_name.eql? "qajudge" or current_user.first_name.eql? "devjudge")
      question = Question.find params[:id]
      NotifyMailer.select_question(question).deliver
    end
    redirect_to "/questions"
  end

  private

  def validate_tags
  #  params[:question][:topic_list] = params[:other_topic] if params[:question][:topic_list]=='Other'
  #  params[:question].delete :topic_list if params[:question][:topic_list].downcase.include? 'other'
  end

  def filter_tags
    tags = []
    tags << params[:complexity].to_s  unless params[:complexity].blank?
    tags << params[:topic].to_s       unless params[:topic].blank?
    tags << params[:search].to_s      unless params[:search].blank?
    tags = tags.collect{ |tag| tag.downcase }
    tags = tags.uniq.compact
  end

  def question
    @question ||= Question.find_by_id(params[:id]) || Question.new
  end



end
