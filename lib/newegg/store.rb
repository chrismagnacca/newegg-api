module Newegg
  class Store < Api
    attr_accessor :title, :store_department, :store_id, :show_see_all_deals, :categories

    def initialize(title, store_department, store_id, show_see_all_deals)
      self.title = title
      self.store_department = store_department
      self.store_id = store_id
      self.show_see_all_deals = show_see_all_deals
      self.categories = []
    end

    def get_categories(newegg = Newegg)
      self.categories = newegg.categories(self.store_id).freeze if self.categories.empty?
      self.categories
    end

    def to_h(newegg = Newegg)
      @h ||= begin
        categories_hash = []
        get_categories(newegg).each do |c|
          categories_hash << c.to_h
        end
        {
          :title              => title,
          :store_department   => store_department,
          :store_id           => store_id,
          :show_see_all_deals => show_see_all_deals,
          :categories         => categories_hash
        }.freeze
      end
    end

  end
end
