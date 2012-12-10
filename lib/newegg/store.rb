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

  end
end