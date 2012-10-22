module MenuHelper
  MAIN_MENU_ID = 'sub-menu'
  MAIN_MENU_SUBMENU_CLASS = 'sub'
  MAIN_MENU_FIRST_ITEM_CLASS = 'first'
  MAIN_MENU_LAST_ITEM_CLASS = 'last'
  MAIN_MENU_LAST_SUBITEM_CLASS = 'last-m'
  MAIN_MENU_ACTIVE_ITEM_CLASS = 'active'

  def render_main_menu
    active_item = params['category']
    active_item = 'main' if params['controller'] == 'main'
    active_item = 'users/current' if ['users', 'sessions'].include?(params['controller'])

    items = menu_items.map {|i| render_main_menu_item(i, active_item)}.join("").html_safe
    content_tag(:ul, items, :id => MAIN_MENU_ID)
  end

  def render_main_menu_item(item, active_item)
    classes = []
    classes << MAIN_MENU_SUBMENU_CLASS if item[2]
    classes << MAIN_MENU_FIRST_ITEM_CLASS if item == menu_items.first
    classes << MAIN_MENU_LAST_ITEM_CLASS if item == menu_items.last
    classes << MAIN_MENU_ACTIVE_ITEM_CLASS if item[1] == active_item
    classes = classes.join(' ')
    submenu = render_main_submenu(item[2]) if item[2]
    link = link_to_menu_item(item[0], item[1])
    content = "#{submenu}#{link}".html_safe
    content_tag(:li, content, :class => classes)
  end

  def render_main_submenu(submenu)
    items = submenu.map {|i| render_main_submenu_item(i, i == submenu.last)}
    content_tag(:ul, items.join('').html_safe)
  end

  def render_main_submenu_item(item, last)
    cls = MAIN_MENU_LAST_SUBITEM_CLASS if last
    link = link_to_menu_item(item.first, item.second)
    content_tag(:li, link, :class => cls)
  end

  def link_to_menu_item(title, link)
    link_to(t(title), "/#{I18n.locale}/#{link}")
  end

  def render_footer_menu
    Menu.enabled.items.dup.delete_if {|i| i[1] == 'main'}.map do |item|
      header = content_tag(:h4, link_to_menu_item(item[0], item[1]))
      submenu = render_footer_submenu(item[2]) if item[2]
      content_tag(:div, (header + submenu.to_s).html_safe, :class => 'column')
    end.join('').html_safe
  end

  def render_footer_submenu(submenu)
    items = submenu.map do |i|
      content_tag(:li, link_to_menu_item(i.first, i.second))
    end.join('').html_safe
    content_tag(:ul, items)
  end

  def menu_items
    unless @menu_items
      @menu_items = Menu.enabled.items
      @menu_items += EDITOR_MENU if editor?
      @menu_items += ADMIN_MENU if admin?
    end

    @menu_items
  end
end
