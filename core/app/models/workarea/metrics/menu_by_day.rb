module Workarea
  module Metrics
    class MenuByDay
      include ByDay
      include Scoring

      field :menu_id, type: String
      field :views, type: Integer, default: 0
      field :orders, type: Integer, default: 0
      field :units_sold, type: Integer, default: 0
      field :discounted_units_sold, type: Integer, default: 0
      field :merchandise, type: Float, default: 0.0
      field :discounts, type: Float, default: 0.0
      field :revenue, type: Float, default: 0.0

      index(reporting_on: 1, orders: 1)
      index(menu_id: 1, reporting_on: 1)
      scope :by_menu, ->(id) { where(menu_id: id) }
    end
  end
end
