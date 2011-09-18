helpers do
  def set_page_title(sub_title = '')
    @page_title = [sub_title,settings.base_page_title].join(settings.page_title_separator)
  end
end
