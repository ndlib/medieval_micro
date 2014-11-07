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
end
