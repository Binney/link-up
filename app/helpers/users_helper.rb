module UsersHelper

  def avatar_for(user)
    image_tag "l.jpg", alt: user.name, size: "60x60"
  end

end
