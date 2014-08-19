module ApplicationHelper

 def full_title(page_title)
    base_title = "Link Up"
    if page_title.empty?
    	base_title
    else
    	"#{page_title} | #{base_title}".html_safe
    end
  end

	def asset_url(asset)
	  "#{request.protocol}#{request.host_with_port}#{asset_path(asset)}"
	end

end
