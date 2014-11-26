module Newegg
  class Category < Api
    attr_accessor :description, :category_type, :category_id, :store_id, :show_see_all_deals, :node_id
    
    def initialize(description, category_type, category_id, store_id, show_see_all_deals, node_id)
      self.description = description
      self.category_type = category_type
      self.category_id = category_id
      self.store_id = store_id
      self.show_see_all_deals = show_see_all_deals
      self.node_id = node_id
    end

    def to_h
      @h ||= {
          :description   => description,
          :category_type => category_type,
          :category_id   => category_id,
          :store_id      => store_id,
          :node_id       => node_id
      }.freeze
      @h
    end

  end
end
