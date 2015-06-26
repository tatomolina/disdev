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
    default_url = "#{root_url}images/guest.png"
    #default_url = "http://ar.selecciones.com/resources/images/default_user_noimage.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{CGI.escape(default_url)}"
  end

  def group_avatar_url(group)
    default_url = "#{root_url}images/work_group.png"
    #default_url = "http://www.distasoft.com.sv/sitio1/images/stories/quienes_somos_distasoft.png"
    gravatar_id = Digest::MD5.hexdigest((User.with_role :owner, group).first.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?d=#{CGI.escape(default_url)}"
  end

  def active_page(active_page)
    @active == active_page ? "active" : ""
  end

  def user_active_page(active_page)
    @active_user == active_page ? "active" : ""
  end

  def group_active_page(active_page)
    @active_group == active_page ? "active" : ""
  end

  def project_active_page(active_page)
    @active_project == active_page ? "active" : ""
  end

end
