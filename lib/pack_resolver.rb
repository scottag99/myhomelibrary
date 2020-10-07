module PackResolver

  def resolve_pack(campaign, wishlist)
    packs = {
      'SEAJ': 'Pink',
      'SBAJ': 'Blue',
      'SEKM': 'Orange',
      'SBKM': 'Purple',
      'SENP': 'Yellow',
      'SBNP': 'Green',
      'SQZ': 'Red',
      'REPK': 'Apple',
      'RBPK': 'Butterfly',
      'REK': 'Cactus',
      'RBK': 'Dinosaur',
      'RMEAK':	'Elephant',
      'RFEAK':	'Flower',
      'RNBAK':	'Giraffe',
      'RMELP':	'Heart',
      'RFELP':	'Key',
      'RNBLP':	'Moon',
      'RMEQZ':	'Owl',
      'RFEQZ':	'Puzzle'
    }

    unless (wishlist.grade =~ /(PreK|K)/i).nil?
      catalog_name = campaign.prek_k_source.try(:name)
    else
      catalog_name = campaign.first_fifth_source.try(:name)
    end

    if catalog_name.nil?
      return {ezid: "Unknown", pack_type: "Unknown"}
    end

    unless (catalog_name =~ /BBHLF/i).nil?
      catalog = 'R'
    else
      catalog = catalog_name[0]
    end

    lang = wishlist.language.try(:name) == 'BI' ? 'B' : 'E'

    # BBHLF is gendered but only 1-5
    if catalog == 'R'
      unless (wishlist.grade =~ /(PreK|K)/i).nil?
        ezid = "R#{lang}#{wishlist.grade == 'PreK' ? 'PK' : 'K'}"
      else
        lvl = case wishlist.reading_level.try(:name)
          when 'A'..'K' then 'AK'
          when 'L'..'P' then 'LP'
          when 'Q'..'Z' then 'QZ'
          else '-'
        end

        # QZ has no bilingual option: all are English
        if lvl == 'QZ'
          ezid = "R#{wishlist.reader_gender}EQZ"
        else
          # bilingual books are not gendered unless the level is QZ
          gender = lang == 'B' ? 'N' : wishlist.reader_gender
          ezid = "R#{gender}#{lang}#{lvl}"
        end
      end
    else
      lvl = case wishlist.reading_level.try(:name)
        when 'A'..'J' then 'AJ'
        when 'K'..'M' then 'KM'
        when 'N'..'P' then 'NP'
        when 'Q'..'Z' then 'QZ'
        else '-'
      end

      if lvl == 'QZ'
        ezid = 'SQZ'
      else
        ezid = "S#{lang}#{lvl}"
      end
    end
    return {ezid: ezid, pack_type: packs[ezid.to_sym]}
  end
end
