# app/controllers/concerns/searchable_sortable_controller.rb
module SearchableSortableController
  extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction
  end

  def apply_search_sort(collection)
    collection = collection.search_by_columns(params[:search]) if params[:search].present?
    collection = collection.apply_sorting(sort_column, sort_direction) if sort_column && sort_direction
    collection
  end

  private

  def sort_column
    params[:sort_column]
  end

  def sort_direction
    %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : nil
  end
end
