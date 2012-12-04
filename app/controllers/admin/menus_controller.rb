class Admin::MenusController < ApplicationController
  before_filter :admin_required
  layout "admin"

  def index
    @menu = Menu.items(:as_object)
  end

  def create
    parent = Menu.where(id: params[:parent_id]).first
    key = params[:title].parameterize("_")
    title = if parent
              parent.title.gsub('title', key)
            else
              "menu.#{key}.title"
            end
    menu = Menu.new(parent_id: parent.try(:id), path: params[:path], title: title, position: 0)
    translation = Translation.new(value: params[:title])
    translation.key = title
    translation.pluralization_index = 0
    translation.language_id = "en"
    Translation.transaction do
      if !translation.save
        flash[:error] = t('description.menu.edit.translation_creation_error')
        return redirect_to admin_menus_path
      elsif !menu.save
        flash[:error] = t('description.menu.edit.menu_creation_error')
        return redirect_to admin_menus_path
      end
    end
    redirect_to admin_menus_path
  end


  def update
    @item = Menu.find(params[:id])
    if params[:move]
      if params[:move] == 'up'
        @item.move_higher
      else
        @item.move_lower
      end
    elsif params[:disable]
      @item.enabled = false
    elsif params[:enable]
      @item.enabled = true
    end
    @item.save

    redirect_to admin_menus_path
  end

  def destroy
    @item = Menu.find(params[:id])
    if @item.enabled?
      flash[:error] = t('description.menu.delete_enabled_forbidden')
    else
      Translation.where(key: @item.title).destroy_all
      @item.destroy
    end
    redirect_to admin_menus_path
  end
end
