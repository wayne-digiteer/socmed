# app/models/concerns/searchable_sortable.rb
module SearchableSortable
  extend ActiveSupport::Concern

  included do
    class_attribute :display_columns
    self.display_columns = {}
  end

  class_methods do
    def configure_display_columns(&block)
      class_eval(&block)
    end

    def add_display_column(key, label:, format: ->(record) { record.send(key) }, **options)
      self.display_columns = display_columns.merge(
        key.to_sym => {
          label: label,
          format: format,
          sortable: options[:sortable] || false,
          searchable: options[:searchable] || false,
          filterable: options[:filterable] || false,
          filter_options: options[:filter_options],
          association: options[:association]
        }
      )
    end

    def search_by_columns(query)
      return all if query.blank?

      # Get all columns marked as searchable
      searchable_columns = display_columns.select { |_, config| config[:searchable] }

      # Build the search conditions for both table columns and associated columns
      conditions = searchable_columns.map do |key, config|
        if config[:association]
          "#{config[:association].to_s.pluralize}.#{key} ILIKE :query"
        else
          "#{table_name}.#{key} ILIKE :query"
        end
      end

      conditions << "CAST(#{table_name}.id AS TEXT) ILIKE :query"

      includes_associations = display_columns.values.filter_map { |config| config[:association] }.uniq

      query_result = includes(includes_associations).where(conditions.join(" OR "), query: "%#{query}%")

      query_result = query_result.references(*includes_associations) if includes_associations.any?

      query_result
    end


    def apply_sorting(column, direction)
      return all unless column.present? && direction.present?

      column_config = display_columns[column.to_sym]
      return all unless column_config&.fetch(:sortable, false)

      if column_config[:association]
        joins(column_config[:association])
          .order("#{column_config[:association].to_s.pluralize}.#{column} #{direction}")
      else
        order("#{table_name}.#{column} #{direction}")
      end
    end

    private

    def truncate_text(text, length)
      return text if text.blank? || text.length <= length
      "#{text[0...length]}..."
    end
  end
end
