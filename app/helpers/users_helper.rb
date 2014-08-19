module UsersHelper

  def avatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    default_avatar = url_encode "http://s23.postimg.org/mfq2jlu8n/image.png" # TODO this probably ought to be changed in the long run, but for now the default Link Up logo is here.
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?d=#{default_avatar}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end
