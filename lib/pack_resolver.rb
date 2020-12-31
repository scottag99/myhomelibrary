module PackResolver

  def resolve_pack(campaign, wishlist)
    unknown = Catalog.new(source: 'Unknown')
    catalog = case wishlist.grade
      when 'PreK', 'K' then campaign.prek_k_source || unknown
      else campaign.first_fifth_source || unknown
    end

    lang_code = wishlist.language.try(:name) == 'BI' ? 'Bi' : 'En'

    grade_code = case wishlist.grade
      when 'PreK' then 'Pk'
      when 'K', '1st' then 'K1'
      when '2nd', '3rd' then '23'
      when '4th', '5th' then
        lang_code = 'En'
        '45'
      else 'U'
    end

    ezid = "#{campaign.catalog_edition}e#{grade_code+lang_code}"
    pack = catalog.packs.find_by_ezid(ezid)

    return {
      ezid: ezid,
      pack_type: pack.try(:pack_type),
      lang_code: lang_code,
      source: catalog.source,
      price: pack.try(:price)
    }
  end
end
