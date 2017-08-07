module SrcsetHelper

  def srcset_for(obj)
    image = obj.try(:binary)
    return unless image

    [160, 320, 640, 1280, 2560].map do |width|
      transformed_image = image.transform(width: width)
      url = scrivito_url(transformed_image)

      "#{url} #{width}w"
    end.join(", ")
  end
end
