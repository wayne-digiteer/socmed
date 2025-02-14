module Admin
  class DashboardController < Admin::BaseController
    def index
      @stats = [
        { title: "Total Users", count: Customer.count },
        { title: "Active Posts", count: Post.count },
        { title: "Featured Posts", count: Post.where(featured: true).count }
      ]
    end
  end
end
