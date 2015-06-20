module ApplicationHelper

  def full_title(page_title = '')
    base_title = "DisDev"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def avatar_url(user)
    #default_url = "#{root_url}images/guest.png"&d=#{CGI.escape(default_url)}
    default_url = "http://ar.selecciones.com/resources/images/default_user_noimage.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{CGI.escape(default_url)}"
  end

end
