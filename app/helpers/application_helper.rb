module ApplicationHelper
  def link_to_user(user)
    link_to user.username, user_path(user), class: 'username-link'
  end

  def display_user_with_photo(user)
    if user.profile_photo.attached?
      cl_image_tag(user.profile_photo.key, transformation: [{height: 30, width: 30, crop: "fill"}], class: "profile-photo")
    else
      # Use a default placeholder if no profile photo is attached
      image_tag("default_profile_photo.png", class: "profile-photo")
    end + " " + link_to(user.username, user_path(user), class: 'username-link')
  end
end
