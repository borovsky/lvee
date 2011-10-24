class BigFormBuilder < ActionView::Helpers::FormBuilder

  def text_field(attribute, options={})
    label_text = I18n.t("label.#{object_name}.#{attribute.to_s.gsub(/_id$/, "")}") + ":"
    label(attribute, label_text) + super
  end

  def text_area(attribute, options={})
    label_text = I18n.t("label.#{object_name}.#{attribute.to_s.gsub(/_id$/, "")}") + ":"
    label(attribute, label_text) + super
  end

  def select(method, choices, options = {}, html_options = {})
    label_text = I18n.t("label.#{object_name}.#{method.to_s.gsub(/_id$/, "")}") + ":"
    label(method, label_text) + super
  end

  def check_box(attribute, options={})
    label_text = I18n.t("label.#{object_name}.#{attribute.to_s.gsub(/_id$/, "")}") + ":"
    label(attribute, label_text) + super
  end
end
