class CustomColumnWidget < Widget

  attribute :column1, :widgetlist
  attribute :column2, :widgetlist
  attribute :column3, :widgetlist
  attribute :column4, :widgetlist
  attribute :column5, :widgetlist
  attribute :column6, :widgetlist
  attribute :column1_width, :enum, values: ("0".."12").to_a, default: "4"
  attribute :column2_width, :enum, values: ("0".."12").to_a, default: "4"
  attribute :column3_width, :enum, values: ("0".."12").to_a, default: "4"
  attribute :column4_width, :enum, values: ("0".."12").to_a, default: "0"
  attribute :column5_width, :enum, values: ("0".."12").to_a, default: "0"
  attribute :column6_width, :enum, values: ("0".."12").to_a, default: "0"
  attribute :classname, :string

  class Column
    def initialize(widget:, width:, widget_list_attr_name:)
      @widget = widget
      @widget_list_attr_name = widget_list_attr_name
      @width = width
      if @width < 1 && widget_list.present?
        @width = 1
      end
    end

    attr_reader :widget_list_attr_name
    attr_reader :width

    def widget_list
      @widget.send(@widget_list_attr_name)
    end

    def empty?
      width < 1 && widget_list.empty?
    end

    def with_changed_width_by(change_by)
      with_width(width + change_by)
    end

    def with_width(new_width)
      self.class.new({
        widget: @widget,
        width: new_width,
        widget_list_attr_name: widget_list_attr_name,
      })
    end
  end

  def columns
    cols = 6.downto(1).map do |number|
      Column.new({
        widget: self,
        width: send("column#{number}_width").to_i,
        widget_list_attr_name: "column#{number}",
      })
    end.drop_while(&:empty?)
    while cols.sum(&:width) > 12
      decreased = false
      cols = cols.map do |column|
        if !decreased && column.width > 1
          decreased = true
          column.with_changed_width_by(-1)
        else
          column
        end
      end
    end
    if (total_width = cols.sum(&:width)) < 12
      cols = [cols.first.with_changed_width_by(12 - total_width)] + cols[1..-1]
    end
    cols.reverse
  end

  def text_extract
    [column1, column2, column3, column4, column5, column6].map {|c| c.map(&:text_extract)}
  end

  def self.description_for_editor
    "Columns"
  end

  def self.info_text_for_thumbnail
    "Display content in 1-6 columns with adjustable widths"
  end

  # def column_size(image)
  #   column = image.container_attribute_name
  #   self.send("#{column}_width") * (100/12.0)
  # end

end
