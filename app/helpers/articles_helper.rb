require 'xhtmldiff'

module ArticlesHelper
  def render_article(article)
    body = "<h1>#{h(article.title)}</h1>"
    body << textilize(article.body)
    body
  end

  def display_diff(base_article, article)
    if(base_article)
      base = "<div>" + render_article(base_article) + "</div>"
      current = "<div>" + render_article(article) + "</div>"

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
      diff_doc.write(diffs, -1, true, true)
      diffs.gsub(/\A<div class='xhtmldiff_wrapper'>(.*)<\/div>\Z/m, '\1')
    else
      "<div>" + render_article(article) + "</div>"
    end
  end
end
