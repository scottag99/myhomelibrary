module PackResolver

  def resolve_pack(campaign, wishlist)
    packs = {
      'PkEn': 'Pink',
      'PkBi': 'Blue',
      'K1En': 'Orange',
      'K1Bi': 'Purple',
      '23En': 'Yellow',
      '23Bi': 'Green',
      '45En': 'Red'
    }

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


    return {ezid: "#{campaign.catalog_edition}e#{grade_code+lang_code}", pack_type: packs[(grade_code+lang_code).to_sym], lang_code: lang_code}
  end
end
