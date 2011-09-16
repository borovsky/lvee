xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0") do
  xml.channel do
    xml.title("LVEE site changes")
    xml.link("http://lvee.org/")
    xml.description("LVEE conference site changes")
    xml.language(I18n.locale)
    for change in @changes
      xml.item do
        title = t("label.editor_log.#{change.change_type}", :obj => change.object_name,
          :user => change.user_name)
        xml.title(title)

        xml.description(change.body)
        xml.author(change.user_name)
        xml.pubDate(change.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        uri = "http://lvee.org/#{I18n.locale}/#{change.url}"
        xml.link(uri)
        xml.guid(uri)
      end
    end
  end
end
