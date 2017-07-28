class CallToActionWidget < Widget

  attribute :action_link, :link
  attribute :alignment, :enum, values: alignments, default: alignments.first
  attribute :button_style, :enum, values: button_styles, default: button_styles.first
  attribute :size, :enum, values: sizes, default: sizes.second

  default_for(:action) do
    Scrivito::Link.new(url: "#", title: "Click here")
  end

  def text_extract
    action_link.title rescue nil
  end

  def self.info_text_for_thumbnail
    "Button with various styling options and sizes"
  end

end
