class Obj < Scrivito::BasicObj

  attribute :header_class, :string
  attribute :show_in_menu, :enum, values: %w[true false], default: 'true'
  attribute :menu_order, :integer, default: 1000
  attribute :menu_text, :string

  def get_menu_order
    return menu_order.presence || 1000
  end 

  # def self.valid_page_classes_beneath(parent_path)
  #   [Page, BlogPage, BlogPostPage]
  # end
  #
  # def valid_widget_classes_for(field_name)
  #   if %w[body].include?(field_name)
  #     self.class.section_widgets
  #   else
  #     self.class.content_widgets
  #   end
  # end
  #
  # def self.content_widgets
  #   Scrivito.models.widgets.to_a - section_widgets
  # end
  #
  # def self.section_widgets
  #   [
  #     SectionWidget,
  #   ]
  # end
  #
  # def text_extract
  #   ""
  # end
  #
  # def self.description_for_editor
  #   self.name.underscore.humanize
  # end
  #
  # def self.thumbnail_image_name
  #   "thumbnail_#{self.name.underscore}.png"
  # end
  #
  # def self.info_text_for_thumbnail
  #   ""
  # end

  # def column_size
  #   100
  # end

end
