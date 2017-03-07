class AddSlugToOrganization < ActiveRecord::Migration[5.0]
  def change
    add_column :organizations, :slug, :string
    Organization.all.each{|o| o.slug = o.name.split[0].downcase; o.save; }
  end
end
