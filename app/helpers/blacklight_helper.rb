module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  def application_name
    'Medieval Microfilms &amp; Facsimiles Database'.html_safe
  end

  def styled_application_name
    'Medieval Microfilms <span class="amp">&amp;</span> Facsimiles Database'.html_safe
  end

  def sidebar_items
    @sidebar_items ||= []
  end

  def document_show_link_field document=nil
    if document.has_key?('format') && document['format'] == 'Microfilm'
      document['format']
    else
      blacklight_config.index.show_link.to_sym
    end
  end
end
