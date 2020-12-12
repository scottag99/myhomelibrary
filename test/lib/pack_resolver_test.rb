require 'test_helper'
require 'pack_resolver'

class PackResolverTest < ActiveSupport::TestCase
  include PackResolver

  test 'should find pack for PreK English reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_prek_lang_en))
    assert_equal '1ePkEn', pack[:ezid]
    assert_equal 'Pink', pack[:pack_type]
  end

  test 'should find pack for PreK Bilingual reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_prek_lang_bi))
    assert_equal '1ePkBi', pack[:ezid]
    assert_equal 'Blue', pack[:pack_type]
  end

  test 'should find pack for K English reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_k_lang_en))
    assert_equal '1eK1En', pack[:ezid]
    assert_equal 'Orange', pack[:pack_type]
  end

  test 'should find pack for K Bilingual reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_k_lang_bi))
    assert_equal '1eK1Bi', pack[:ezid]
    assert_equal 'Purple', pack[:pack_type]
  end

  test 'should find pack for 1st English reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_1st_lang_en))
    assert_equal '1eK1En', pack[:ezid]
    assert_equal 'Orange', pack[:pack_type]
  end

  test 'should find pack for 1st Bilingual reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_1st_lang_bi))
    assert_equal '1eK1Bi', pack[:ezid]
    assert_equal 'Purple', pack[:pack_type]
  end

  test 'should find pack for 2nd English reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_2nd_lang_en))
    assert_equal '1e23En', pack[:ezid]
    assert_equal 'Yellow', pack[:pack_type]
  end

  test 'should find pack for 2nd Bilingual reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_2nd_lang_bi))
    assert_equal '1e23Bi', pack[:ezid]
    assert_equal 'Green', pack[:pack_type]
  end

  test 'should find pack for 4th English reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_4th_lang_en))
    assert_equal '1e45En', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test 'should find pack for 4th Bilingual reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_4th_lang_bi))
    assert_equal '1e45En', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test 'should find pack for 5th English reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_5th_lang_en))
    assert_equal '1e45En', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test 'should find pack for 5th Bilingual reader in edition 1 campaign' do
    pack = resolve_pack(campaigns(:edition_one_campaign), wishlists(:ed1_5th_lang_bi))
    assert_equal '1e45En', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test 'should find pack for PreK English reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_prek_lang_en))
    assert_equal '2ePkEn', pack[:ezid]
    assert_equal 'Pink', pack[:pack_type]
  end

  test 'should find pack for PreK Bilingual reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_prek_lang_bi))
    assert_equal '2ePkBi', pack[:ezid]
    assert_equal 'Blue', pack[:pack_type]
  end

  test 'should find pack for K English reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_k_lang_en))
    assert_equal '2eK1En', pack[:ezid]
    assert_equal 'Orange', pack[:pack_type]
  end

  test 'should find pack for K Bilingual reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_k_lang_bi))
    assert_equal '2eK1Bi', pack[:ezid]
    assert_equal 'Purple', pack[:pack_type]
  end

  test 'should find pack for 1st English reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_1st_lang_en))
    assert_equal '2eK1En', pack[:ezid]
    assert_equal 'Orange', pack[:pack_type]
  end

  test 'should find pack for 1st Bilingual reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_1st_lang_bi))
    assert_equal '2eK1Bi', pack[:ezid]
    assert_equal 'Purple', pack[:pack_type]
  end

  test 'should find pack for 2nd English reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_2nd_lang_en))
    assert_equal '2e23En', pack[:ezid]
    assert_equal 'Yellow', pack[:pack_type]
  end

  test 'should find pack for 2nd Bilingual reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_2nd_lang_bi))
    assert_equal '2e23Bi', pack[:ezid]
    assert_equal 'Green', pack[:pack_type]
  end

  test 'should find pack for 4th English reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_4th_lang_en))
    assert_equal '2e45En', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test 'should find pack for 4th Bilingual reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_4th_lang_bi))
    assert_equal '2e45En', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test 'should find pack for 5th English reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_5th_lang_en))
    assert_equal '2e45En', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end

  test 'should find pack for 5th Bilingual reader in edition 2 campaign' do
    pack = resolve_pack(campaigns(:edition_two_campaign), wishlists(:ed2_5th_lang_bi))
    assert_equal '2e45En', pack[:ezid]
    assert_equal 'Red', pack[:pack_type]
  end
end
