class StatWidget < Widget
    attribute :classname, :string, default: 'stat-numbers'
    attribute :css_style, :string, default: ''
    attribute :metric, :enum, values: %w[Organizations Wishlists Books], default: 'Organizations';
    attribute :previous_year_only, :enum, values: %w[Yes No], default: 'No'
    attribute :offline_count, :integer, default: 0

    def calculate
        m = case metric
            when 'Organizations'
                Organization
            when 'Wishlists'
                Wishlist
            when 'Books'
                WishlistEntry
            else
                Organization
        end
        if previous_year_only == 'Yes'
            d = 1.year.ago
            v = m.where(created_at: d.beginning_of_year..d.end_of_year).count
        else
            v = m.count
        end
        v + offline_count
    end
end
