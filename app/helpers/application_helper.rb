# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def icon_masquerade_link(user)
    link_to image_tag('/assets/stylesheets/icons/masquerade.png', :alt =>'Masquerade', :title => 'Masquerade'), start_masquerade_path(user), { :class => 'icon-link' }
  end

  def icon_show_admin_link(model)
    link_to image_tag('/assets/stylesheets/icons/magnifier.png', :alt =>'Show', :title => 'Show'), { :controller => "admin/#{model.class.to_s.tableize}", :action => 'show', :id => model }, { :class => 'icon-link' }
  end

  def icon_show_link(model)
    link_to image_tag('/assets/stylesheets/icons/magnifier.png', :alt =>'Show', :title => 'Show'), { :controller => model.class.to_s.tableize.to_sym, :action => 'show', :id => model }, { :class => 'icon-link' }
  end

  def icon_edit_admin_link(model)
    link_to image_tag('/assets/stylesheets/icons/pencil.png', :alt =>'Edit', :title => 'Edit'), { :controller => "admin/#{model.class.to_s.tableize}", :action => 'edit', :id => model }, { :class => 'icon-link' }
  end

  def icon_edit_link(model)
    link_to image_tag('/assets/stylesheets/icons/pencil.png', :alt =>'Edit', :title => 'Edit'), { :controller => model.class.to_s.tableize.to_sym, :action => 'edit', :id => model }, { :class => 'icon-link' }
  end

  def icon_destroy_link(model, message)
    link_to image_tag('/assets/stylesheets/icons/bin_closed.png', :alt => 'Destroy', :title => 'Destroy'), model, :confirm => message, :method => :delete, :class => 'icon-link'
  end

  def icon_destroy_admin_link(model, message)
    link_to image_tag('/assets/stylesheets/icons/bin_closed.png', :alt => 'Destroy', :title => 'Destroy'), { :controller => "admin/#{model.class.to_s.tableize}", :action => 'destroy', :id => model}, :confirm => message, :method => :delete, :class => 'icon-link'
  end

  def edit_record_link
    model_name, id = params[:id].split('-')

    if can? :edit, model_name.camelize.constantize
      link_to 'Edit this Record', url_for(:controller => "admin/#{model_name.pluralize}", :action => 'edit', :id => id), :class => 'edit-record'
    end
  end

  # Microfilms don't have a title.
  # Marina didn't like the default display of "#{format}-#{id}"
  # This is a hack to allow conditional rendering of the record title.
  #def document_index_title(document)
  #  format = document[Blacklight.config[:index][:record_display_type]]
  #  if format.constantize == Microfilm
  #    "Microfilm"
  #  else
  #    document_show_link_field
  #  end
  #end

  #def document_show_title(document)
  #  format = document[Blacklight.config[:index][:record_display_type]]
  #  if format.constantize == Microfilm
  #    content_tag(:h1, "Microfilm")
  #  else
  #    content_tag(:h1, document_heading)
  #  end
  #end
end
