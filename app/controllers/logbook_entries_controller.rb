class LogbookEntriesController < ApplicationController
  before_action :signed_in_user
  before_action :teacher_or_mentor_account, only: :overview
  before_action :correct_user, only: [:index, :destroy]

  def new
    if current_user.logbook_entries.find_by(template_id: params[:template_id])
      redirect_to edit_logbook_entry_path(current_user.logbook_entries.find_by(template_id: params[:template_id]).id)
    else
      @template = LogbookTemplate.find(params[:template_id])
      if @template.school_id != current_user.school_id
        flash[:error] = "That logbook template is for a different school."
        redirect_to logbook_path
      end
    	@logbook_entry = @template.logbook_entries.build
      @questions = @template.content.split("<text>")
    end
  end

  def create
  	@logbook_entry = current_user.logbook_entries.build(logbook_entry_params.merge(content: parse_content))
  	if @logbook_entry.save
  		flash[:success] = "Saved to logbook!"
  		redirect_to @logbook_entry
  	else
  		render 'new'
  	end
  end

  def edit
    @logbook_entry = LogbookEntry.find(params[:id])
    @template = LogbookTemplate.find(@logbook_entry.template_id)
    @questions = @template.content.split("<text>")
    @answers = @logbook_entry.content.split("<template>")
  end

  def update
    @logbook_entry = LogbookEntry.find(params[:id])
    if @logbook_entry.update_attribute(:content, parse_content)
      flash[:success] = "Logbook entry updated."
      redirect_to @logbook_entry
    else
      render 'edit'
    end
  end

  def show
    @logbook_entry = LogbookEntry.find(params[:id])
    @template = LogbookTemplate.find(@logbook_entry.template_id)
    @questions = @template.content.split("<text>")
    @answers = @logbook_entry.content.split("<template>")
  end

  def index
    @logbook_entries = @user.logbook_entries
  end

  def overview
    puts "Viewing over"
    puts params[:school_search]
    puts params[:name_search]

    if me_admin?
      if params[:school_search].blank? || params[:school_search][0].blank?
        @schools = School.all
      else
        @schools = [School.find(params[:school_search][0].to_i)]
      end
      puts @schools.first.name
    elsif me_teacher? 
      @schools = [current_user.school]
    else
      flash[:error] = "This part of the site is off limits to all those who do not wish to die a most painful death."
    end
  end

  def destroy
    @logbook_entry = LogbookEntry.find(params[:id])
    user_id = @logbook_entry.user_id
    if @logbook_entry.destroy
      flash[:success] = "Logbook entry destroyed."
      redirect_to logbook_path
    end
  end

  private

    def logbook_entry_params
      params.require(:logbook_entry).permit(:content, :template_id)
    end

    def parse_content
      i = 0
      content = ""
      # TODO also need to check if any fields are blank and mark entry as incomplete if so
      while params.has_key?("questions#{i}")
        content += params["questions#{i}"]
        content += "<template>"
        i+=1
      end
      return content
    end

end
