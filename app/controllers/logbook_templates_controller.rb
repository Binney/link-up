class LogbookTemplatesController < ApplicationController
	before_filter :signed_in_user
	before_filter :admin_account, only: [:new, :create, :edit, :update, :destroy]

	def new
		@logbook_template = LogbookTemplate.new
	end

	def create
		@logbook_template = LogbookTemplate.new(logbook_template_params)
		unless me_admin?
		  @logbook_template.school_id = current_user.school_id
		end
		if @logbook_template.save
			flash[:success] = "Template saved successfully."
			redirect_to @logbook_template
		else
			render 'new'
		end
	end

	def edit
		@logbook_template = LogbookTemplate.find(params[:id])
	end

	def update
		@logbook_template = LogbookTemplate.find(params[:id])
		unless me_admin?
		  logbook_template_params[:school_id] = current_user.school_id
		end
		if @logbook_template.update(logbook_template_params)
		  flash[:success] = "Logbook template updated."
		  redirect_to @logbook_template
		else
		  render 'edit'
		end
	end

	def show
		if me_teacher? || me_admin?
	  	@logbook_template = LogbookTemplate.find(params[:id])
		  @questions = @logbook_template.content.split("<text>")
		else
			redirect_to new_logbook_entry_path(template_id: params[:id])
		end
	end

	def index
		if me_admin? || me_teacher?
			@logbook_templates = LogbookTemplate.all
		else
			@logbook_templates = LogbookTemplate.all.select { |template| template.start_time<Time.now && current_user.school_id==template.school_id && !(current_user.logbook_entries.find_by(template_id: template.id))}
		end
	end

	def destroy
		@logbook_template = LogbookTemplate.find(params[:id])
		@logbook_template.destroy
		redirect_to logbook_templates_path
	end

	private

		def logbook_template_params
			params.require(:logbook_template).permit(:title, :content, :start_time, :deadline, :user_id, :school_id)
		end

		def correct_school
			unless me_admin?
				@logbook_template = LogbookTemplate.find(params[:id])
				if @logbook_template.school_id != current_user.school_id
					flash[:error] = "That logbook template isn't for your school."
					redirect_to root_path
				end
			end
		end

end
