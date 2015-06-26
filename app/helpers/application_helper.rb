module ApplicationHelper

  def full_title(page_title = '')
    base_title = "DisDev"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
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
