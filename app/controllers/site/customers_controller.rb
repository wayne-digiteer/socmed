module Site
  class CustomersController < ApplicationController
    before_action :set_customer
    def show
      @customer = Customer.find(params[:id])
    end

    private

    def set_customer
      @customer = Customer.find(params[:id])
    end
  end
end
