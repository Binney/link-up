class LogbookEntriesController < ApplicationController
  before_action :signed_in_user
  before_action :teacher_or_mentor_account, only: :overview
  before_action :correct_user, only: [:index, :destroy]

  def new
    if current_user.logbook_entries.find_by(template_id: params[:template_id])
      redirect_to edit_logbook_entry_path(current_user.logbook_entries.find_by(template_id: params[:template_id]).id)
    else
      @template = LogbookTemplate.find(params[:template_id])
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
    @logbook_entries = @user.logbook_entries#.paginate(params[:page])
  end

  def overview
    if me_admin?
      # Display all users, sorted by name
      #@users = User.simple_search(params[:search], nil).sort_by { |u| [u.school_id, u.name] }#.paginate(page: params[:page], per_page: 1)
      @users = User.search_by_name(params[:search]).order ('school_id DESC, name DESC')#.sort_by { |u| [u.school_id, u.name] }
    elsif me_teacher?
      # Display all users from your school
      @users = User.search_by_name(params[:search]).select { |u| u.school_id==current_user.school_id }
      #@users = User.simple_search(params[:search], current_user.school.name)..sort_by { |u| [u.school_id, u.name] }#.paginate(page: params[:page], per_page: 1)
    else
      # Display your mentee's logbook records. Ordinary student accounts can't get this far because of before_filter.
      @users = current_user.mentees.search_by_name(params[:search])
      #@users = current_user.mentees.simple_search(params[:search], current_user.school.name)..sort_by { |u| [u.school_id, u.name] }#.paginate(params[:page])
    end
    @sessions = LogbookTemplate.all
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
