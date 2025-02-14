module ApplicationHelper
  include Pagy::Frontend
  include ActionView::RecordIdentifier  # This adds dom_id

  def table_dom_id(collection)
    "#{dom_id(collection.klass)}_table"
  end
end
