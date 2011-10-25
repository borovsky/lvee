class BigFormBuilder < ActionView::Helpers::FormBuilder
  include ActionView::Helpers::TagHelper
  include ApplicationHelper #FIXME

  def text_field(attribute, options={})
    input(attribute) { super }
  end

  def text_area(attribute, options={})
    input(attribute) { super }
  end

  def select(attribute, choices, options = {}, html_options = {})
    input(attribute) { super }
  end

  def check_box(attribute, options={})
    input(attribute) { super }
  end

  private

  def input(attribute)
    attr = attribute.to_s.gsub(/_id$/, "")
    label_text = I18n.t("label.#{object_name}.#{attr}") + ":"
    desc = I18n.t("description.#{object_name}.#{attr}", :default => "").presence
    field = label(attribute, label_text) + yield
    field += content_tag(:p, textilize_without_paragraph(desc), :class => "description") if desc
    content_tag(:div, field, :class => "field")
  end
end
