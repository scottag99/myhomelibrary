class CreateContents < ActiveRecord::Migration[5.0]
  def change
    create_table :contents do |t|
      t.string :name
      t.string :action_name
      t.text :content

      t.timestamps
    end
    Content.create({:name => 'mhl_lead', :action_name => 'index', :content => 'Books are essential tools for reading success. Through My Home Library, disadvantaged children across Houston gain access to their very own home library.'})
    Content.create({:name => 'sponsor_lead', :action_name => 'index', :content => 'Through your tax-deductible gift of $30, you have the power to make a meaningful difference by
    providing a home library to a low-income child in Houston.'})
    Content.create({:name => 'sponsor_lead', :action_name => 'search', :content => "More than 500 children in need have created a wish list of books for their very own home library. You can make a child’s wish come true by sponsoring a child’s home library of six books with a $30 tax-deductible donation. You may also make a general donation to the My Home Library program using the button below. Thank you for supporting a child in need."})
  end
end
