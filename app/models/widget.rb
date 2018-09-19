class Widget < Scrivito::BasicWidget

  # def valid_widget_classes_for(field_name)
  #   Obj.content_widgets
  # end

  def self.sizes
    %w[
      small
      medium
      large
    ]
  end

  def self.alignments
    %w[
      left
      center
      right
    ]
  end

  def self.bg_colors
    %w[
      none
      white
      light
      dark
      darker
    ]
  end

  def self.colors
    %w[
      default
      primary
      success
      info
      warning
      danger
    ]
  end

  def self.button_styles
    %w[
      default
      primary
      success
      info
      warning
      danger
      link
    ]
  end

  # def column_size(image)
  #   self.container.column_size(image)
  # end

  # def text_extract
  #   ""
  # end
  #
  # def self.description_for_editor
  #   self.name.underscore.gsub("_widget", "").humanize
  # end
  #
  # def self.thumbnail_image_name
  #   "thumbnail_#{self.name.underscore}.png"
  # end
  #
  # def self.info_text_for_thumbnail
  #   ""
  # end

end
