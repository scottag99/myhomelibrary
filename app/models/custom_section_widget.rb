class CustomSectionWidget < Widget
  attribute :classname, :string
  attribute :idname, :string
  attribute :content, :widgetlist

  def text_extract
    content.map(&:text_extract)
  end

end
