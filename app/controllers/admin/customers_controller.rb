module Admin
  class CustomersController < Admin::BaseController
    before_action :set_customer, only: [ :show, :edit, :update, :destroy ]

    def index
      customers = apply_search_sort(Customer.all)

      # # Apply global search
      # if params[:search].present?
      #   customers = customers.search_all_columns(params[:search])
      # end

      # # Apply sorting
      # if params[:sort_column].present? && params[:sort_direction].present?
      #   column = params[:sort_column]
      #   direction = params[:sort_direction]

      #   customers = case column
      #   when "username"
      #     customers.joins(:customer).order("customers.username #{direction}")
      #   else
      #     customers.order("#{column} #{direction}")
      #   end
      # end

      @pagy, @customers = pagy(customers)

      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("customers_table",
            partial: "table",
            locals: { customers: @customers })
        end
      end
    end

    def show
    end

    def edit
    end

    def update
      if @customer.update(customer_params)
        redirect_to admin_customer_path, notice: "Customer was successfully updated."
      else
        render :edit
      end
    end

    def destroy
    end

    private

    def set_customer
      @customers = Customer.find(params[:id])
    end

    def customer_params
      params.require(:customer).permit(:username, :email)
    end
  end
end
