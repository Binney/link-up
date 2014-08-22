class LogbookTemplatesController < ApplicationController
	before_filter :signed_in_user

	def new
		@logbook_template = LogbookTemplate.new
	end

	def create
		@logbook_template = LogbookTemplate.new(logbook_template_params)
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
			@logbook_templates = LogbookTemplate.all.select { |template| !(current_user.logbook_entries.find_by(template_id: template.id))}
		end
	end

	private

		def logbook_template_params
			params.require(:logbook_template).permit(:title, :content, :deadline, :user_id)
		end

end
