module DiffHelper
  def display_diff(base_article, article, render_method, mode=:site)
    if(base_article)
      base = "<div>" + send(render_method, base_article) + "</div>"
      current = "<div>" + send(render_method, article) + "</div>"

      diff_doc = REXML::Document.new
      div = REXML::Element.new('div', nil, {:respect_whitespace =>:all})
      div.attributes['class'] = 'xhtmldiff_wrapper'
      diff_doc << div
      hd = XHTMLDiff.new(div)

      parsed_previous_revision = REXML::HashableElementDelegator.new(
           REXML::XPath.first(REXML::Document.new(base), '/div'))
      parsed_display_content = REXML::HashableElementDelegator.new(
           REXML::XPath.first(REXML::Document.new(current), '/div'))
      Diff::LCS.traverse_balanced(parsed_previous_revision, parsed_display_content, hd)

      diffs = ''
      process_diff(diff_doc, mode)
      diff_doc.write(diffs, -1, true, true)
      diffs.gsub(/\A<div class='xhtmldiff_wrapper'>(.*)<\/div>\Z/m, '\1').html_safe
    else
      ("<div>" + send(render_method, article) + "</div>").html_safe
    end
  end

  protected
  def process_diff(doc, mode)
    REXML::XPath.each(doc, "//ins/descendant-or-self::*") do |e|
      if mode == :rss
        add_attribute_value(e, 'style', INS_STYLE)
      elsif mode==:site
        add_attribute_value(e, 'class', INS_CLASS)
      end
    end
    REXML::XPath.each(doc, "//del/descendant-or-self::*") do |e|
      if mode == :rss
        add_attribute_value(e, 'style', DEL_STYLE)
      elsif mode==:site
        add_attribute_value(e, 'class', DEL_CLASS)
      end
    end
  end

  def add_attribute_value(e, attr, text)
    value = e.attribute(attr) ? e.attribute(attr).value : ''
    value += " " + text;
    e.add_attribute(attr, value)
  end
end
