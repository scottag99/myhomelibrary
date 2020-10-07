require 'test_helper'
require 'pack_resolver'

class PackResolverTest < ActiveSupport::TestCase
  include PackResolver

  test "should find pack for A level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_a))
    assert_equal 'SEAJ', pack[:ezid]
    assert_equal 'Pink', pack[:pack_type]
  end

  test "should find pack for F level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_f))
    assert_equal 'SEAJ', pack[:ezid]
    assert_equal 'Pink', pack[:pack_type]
  end

  test "should find pack for J level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_j))
    assert_equal 'SEAJ', pack[:ezid]
    assert_equal 'Pink', pack[:pack_type]
  end

  test "should find pack for bilingual A level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_a))
    assert_equal 'SBAJ', pack[:ezid]
    assert_equal 'Blue', pack[:pack_type]
  end

  test "should find pack for bilingual F level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_f))
    assert_equal 'SBAJ', pack[:ezid]
    assert_equal 'Blue', pack[:pack_type]
  end

  test "should find pack for bilingual J level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_j))
    assert_equal 'SBAJ', pack[:ezid]
    assert_equal 'Blue', pack[:pack_type]
  end

  test "should find pack for K level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_k))
    assert_equal 'SEKM', pack[:ezid]
    assert_equal 'Orange', pack[:pack_type]
  end

  test "should find pack for L level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_l))
    assert_equal 'SEKM', pack[:ezid]
    assert_equal 'Orange', pack[:pack_type]
  end

  test "should find pack for M level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_m))
    assert_equal 'SEKM', pack[:ezid]
    assert_equal 'Orange', pack[:pack_type]
  end

  test "should find pack for bilingual K level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_k))
    assert_equal 'SBKM', pack[:ezid]
    assert_equal 'Purple', pack[:pack_type]
  end

  test "should find pack for bilingual L level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_l))
    assert_equal 'SBKM', pack[:ezid]
    assert_equal 'Purple', pack[:pack_type]
  end

  test "should find pack for bilingual M level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_m))
    assert_equal 'SBKM', pack[:ezid]
    assert_equal 'Purple', pack[:pack_type]
  end

  test "should find pack for N level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_n))
    assert_equal 'SENP', pack[:ezid]
    assert_equal 'Yellow', pack[:pack_type]
  end

  test "should find pack for O level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_o))
    assert_equal 'SENP', pack[:ezid]
    assert_equal 'Yellow', pack[:pack_type]
  end

  test "should find pack for P level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_p))
    assert_equal 'SENP', pack[:ezid]
    assert_equal 'Yellow', pack[:pack_type]
  end

  test "should find pack for bilingual N level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_n))
    assert_equal 'SBNP', pack[:ezid]
    assert_equal 'Green', pack[:pack_type]
  end

  test "should find pack for bilingual O level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_o))
    assert_equal 'SBNP', pack[:ezid]
    assert_equal 'Green', pack[:pack_type]
  end

  test "should find pack for bilingual P level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_p))
    assert_equal 'SBNP', pack[:ezid]
    assert_equal 'Green', pack[:pack_type]
  end

  test "should find pack for Q level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_q))
    assert_equal 'SQZ', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test "should find pack for V level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_v))
    assert_equal 'SQZ', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test "should find pack for Z level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_en_lvl_z))
    assert_equal 'SQZ', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test "should find pack for bilingual Q level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_q))
    assert_equal 'SQZ', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test "should find pack for bilingual V level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_v))
    assert_equal 'SQZ', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test "should find pack for bilingual Z level reader in single source campaign" do
    pack = resolve_pack(campaigns(:single_source_campaign), wishlists(:single_source_lang_bi_lvl_z))
    assert_equal 'SQZ', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test "should find pack for PreK reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_prek))
    assert_equal 'REPK', pack[:ezid]
    assert_equal 'Apple', pack[:pack_type]
  end

  test "should find pack for K reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_kinder))
    assert_equal 'REK', pack[:ezid]
    assert_equal 'Cactus', pack[:pack_type]
  end

  test "should find pack for bilingual PreK reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_prek))
    assert_equal 'RBPK', pack[:ezid]
    assert_equal 'Butterfly', pack[:pack_type]
  end

  test "should find pack for bilingual K reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_kinder))
    assert_equal 'RBK', pack[:ezid]
    assert_equal 'Dinosaur', pack[:pack_type]
  end

  test "should find pack for A level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_a))
    assert_equal 'RMEAK', pack[:ezid]
    assert_equal 'Elephant', pack[:pack_type]
  end

  test "should find pack for female A level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_a_female))
    assert_equal 'RFEAK', pack[:ezid]
    assert_equal 'Flower', pack[:pack_type]
  end

  test "should find pack for F level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_f))
    assert_equal 'RMEAK', pack[:ezid]
    assert_equal 'Elephant', pack[:pack_type]
  end

  test "should find pack for female F level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_f_female))
    assert_equal 'RFEAK', pack[:ezid]
    assert_equal 'Flower', pack[:pack_type]
  end

  test "should find pack for K level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_k))
    assert_equal 'RMEAK', pack[:ezid]
    assert_equal 'Elephant', pack[:pack_type]
  end

  test "should find pack for female K level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_k_female))
    assert_equal 'RFEAK', pack[:ezid]
    assert_equal 'Flower', pack[:pack_type]
  end

  test "should find pack for bilingual A level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_a))
    assert_equal 'RNBAK', pack[:ezid]
    assert_equal 'Giraffe', pack[:pack_type]
  end

  test "should find pack for bilingual female A level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_a_female))
    assert_equal 'RNBAK', pack[:ezid]
    assert_equal 'Giraffe', pack[:pack_type]
  end

  test "should find pack for bilingual F level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_f))
    assert_equal 'RNBAK', pack[:ezid]
    assert_equal 'Giraffe', pack[:pack_type]
  end

  test "should find pack for bilingual female F level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_f_female))
    assert_equal 'RNBAK', pack[:ezid]
    assert_equal 'Giraffe', pack[:pack_type]
  end

  test "should find pack for bilingual K level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_k))
    assert_equal 'RNBAK', pack[:ezid]
    assert_equal 'Giraffe', pack[:pack_type]
  end

  test "should find pack for bilingual female K level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_k_female))
    assert_equal 'RNBAK', pack[:ezid]
    assert_equal 'Giraffe', pack[:pack_type]
  end

  test "should find pack for L level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_l))
    assert_equal 'RMELP', pack[:ezid]
    assert_equal 'Heart', pack[:pack_type]
  end

  test "should find pack for female L level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_l_female))
    assert_equal 'RFELP', pack[:ezid]
    assert_equal 'Key', pack[:pack_type]
  end

  test "should find pack for N level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_n))
    assert_equal 'RMELP', pack[:ezid]
    assert_equal 'Heart', pack[:pack_type]
  end

  test "should find pack for female N level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_n_female))
    assert_equal 'RFELP', pack[:ezid]
    assert_equal 'Key', pack[:pack_type]
  end

  test "should find pack for P level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_p))
    assert_equal 'RMELP', pack[:ezid]
    assert_equal 'Heart', pack[:pack_type]
  end

  test "should find pack for female P level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_p_female))
    assert_equal 'RFELP', pack[:ezid]
    assert_equal 'Key', pack[:pack_type]
  end

  test "should find pack for bilingual L level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_l))
    assert_equal 'RNBLP', pack[:ezid]
    assert_equal 'Moon', pack[:pack_type]
  end

  test "should find pack for bilingual female L level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_l_female))
    assert_equal 'RNBLP', pack[:ezid]
    assert_equal 'Moon', pack[:pack_type]
  end

  test "should find pack for bilingual N level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_n))
    assert_equal 'RNBLP', pack[:ezid]
    assert_equal 'Moon', pack[:pack_type]
  end

  test "should find pack for bilingual female N level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_n_female))
    assert_equal 'RNBLP', pack[:ezid]
    assert_equal 'Moon', pack[:pack_type]
  end

  test "should find pack for bilingual P level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_p))
    assert_equal 'RNBLP', pack[:ezid]
    assert_equal 'Moon', pack[:pack_type]
  end

  test "should find pack for bilingual female P level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_p_female))
    assert_equal 'RNBLP', pack[:ezid]
    assert_equal 'Moon', pack[:pack_type]
  end

  test "should find pack for Q level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_q))
    assert_equal 'RMEQZ', pack[:ezid]
    assert_equal 'Owl', pack[:pack_type]
  end

  test "should find pack for female Q level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_q_female))
    assert_equal 'RFEQZ', pack[:ezid]
    assert_equal 'Puzzle', pack[:pack_type]
  end

  test "should find pack for V level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_v))
    assert_equal 'RMEQZ', pack[:ezid]
    assert_equal 'Owl', pack[:pack_type]
  end

  test "should find pack for female V level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_v_female))
    assert_equal 'RFEQZ', pack[:ezid]
    assert_equal 'Puzzle', pack[:pack_type]
  end

  test "should find pack for Z level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_z))
    assert_equal 'RMEQZ', pack[:ezid]
    assert_equal 'Owl', pack[:pack_type]
  end

  test "should find pack for female Z level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_en_lvl_z_female))
    assert_equal 'RFEQZ', pack[:ezid]
    assert_equal 'Puzzle', pack[:pack_type]
  end

  test "should find pack for bilingual Q level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_q))
    assert_equal 'RMEQZ', pack[:ezid]
    assert_equal 'Owl', pack[:pack_type]
  end

  test "should find pack for bilingual female Q level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_q_female))
    assert_equal 'RFEQZ', pack[:ezid]
    assert_equal 'Puzzle', pack[:pack_type]
  end

  test "should find pack for bilingual V level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_v))
    assert_equal 'RMEQZ', pack[:ezid]
    assert_equal 'Owl', pack[:pack_type]
  end

  test "should find pack for bilingual female V level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_v_female))
    assert_equal 'RFEQZ', pack[:ezid]
    assert_equal 'Puzzle', pack[:pack_type]
  end

  test "should find pack for bilingual Z level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_z))
    assert_equal 'RMEQZ', pack[:ezid]
    assert_equal 'Owl', pack[:pack_type]
  end

  test "should find pack for bilingual female Z level reader in multiple source campaign" do
    pack = resolve_pack(campaigns(:multiple_source_campaign), wishlists(:multiple_source_lang_bi_lvl_z_female))
    assert_equal 'RFEQZ', pack[:ezid]
    assert_equal 'Puzzle', pack[:pack_type]
  end
end
