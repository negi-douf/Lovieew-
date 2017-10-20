module ApplicationHelper
  def show_avatar(user)
    unless user.avatar.blank?
      img_url = user.avatar
    else
      img_url = 'no_image.png'
    end
    image_tag(img_url, alt: user.name)
  end
end
