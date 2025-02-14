# app/models/post.rb
class Post < ApplicationRecord
  include SearchableSortable

  validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 1500 }
  validates :published_date, presence: true

  belongs_to :customer

  configure_display_columns do
    add_display_column :id,
      label: "ID",
      sortable: true

    add_display_column :username,
      label: "Username",
      association: :customer,
      sortable: true,
      searchable: true,
      filterable: true,
      filter_options: -> { Customer.pluck(:username).uniq },
      format: ->(post) { post.customer.username }

    add_display_column :active,
      label: "Active",
      sortable: true,
      filterable: true,
      filter_options: -> { [ [ "Yes", true ], [ "No", false ] ] },
      format: ->(post) { post.active ? "Yes" : "No" }

    add_display_column :featured,
      label: "Featured",
      sortable: true,
      filterable: true,
      filter_options: -> { [ [ "Yes", true ], [ "No", false ] ] },
      format: ->(post) { post.featured ? "Yes" : "No" }

    add_display_column :title,
      label: "Title",
      sortable: true,
      searchable: true

    add_display_column :content,
      label: "Content",
      searchable: true,
      format: ->(post) { truncate_text(post.content, 100) }

    add_display_column :created_at,
      label: "Created",
      sortable: true,
      filterable: true,
      filter_options: -> {
        [
          [ "Last 24 hours", 24.hours.ago ],
          [ "Last 7 days", 7.days.ago ],
          [ "Last 30 days", 30.days.ago ]
        ]
      },
      format: ->(post) { I18n.l(post.created_at, format: :short) }

    add_display_column :updated_at,
      label: "Updated",
      sortable: true,
      format: ->(post) { I18n.l(post.updated_at, format: :short) }
  end
end

# class Post < ApplicationRecord
#   validates :title, presence: true, uniqueness: true, length: { maximum: 255 }
#   validates :content, presence: true, length: { maximum: 1500 }
#   validates :published_date, presence: true

#   belongs_to :customer

#   scope :search_all_columns, ->(query) {
#     where("posts.title ILIKE :query OR
#            posts.content ILIKE :query OR
#            customers.username ILIKE :query OR
#            CAST(posts.id AS TEXT) ILIKE :query",
#            query: "%#{query}%")
#       .joins(:customer)
#   }

#   def self.published
#     where("published_at <= ?", Time.zone.now)
#   end

#   def self.display_columns
#     @display_columns ||= {
#       id: {
#         label: "ID",
#         format: ->(post) { post.id },
#         sortable: true,
#         searchable: false,
#         filterable: false
#       },
#       username: {
#         label: "Username",
#         format: ->(post) { post.customer.username },
#         sortable: true,
#         searchable: true,
#         filterable: true,
#         filter_options: -> { Customer.pluck(:username).uniq }
#       },
#       active: {
#         label: "Active",
#         format: ->(post) { post.active ? "Yes" : "No" },
#         sortable: true,
#         searchable: false,
#         filterable: true,
#         filter_options: -> { [ [ "Yes", true ], [ "No", false ] ] }
#       },
#       featured: {
#         label: "Featured",
#         format: ->(post) { post.featured ? "Yes" : "No" },
#         sortable: true,
#         searchable: false,
#         filterable: true,
#         filter_options: -> { [ [ "Yes", true ], [ "No", false ] ] }
#       },
#       title: {
#         label: "Title",
#         format: ->(post) { post.title },
#         sortable: true,
#         searchable: true,
#         filterable: false
#       },
#       content: {
#         label: "Content",
#         format: ->(post) { truncate_text(post.content, 100) },
#         sortable: false,
#         searchable: true,
#         filterable: false
#       },
#       created_at: {
#         label: "Created",
#         format: ->(post) { I18n.l(post.created_at, format: :short) },
#         sortable: true,
#         searchable: false,
#         filterable: true,
#         filter_options: -> {
#           [
#             [ "Last 24 hours", 24.hours.ago ],
#             [ "Last 7 days", 7.days.ago ],
#             [ "Last 30 days", 30.days.ago ]
#           ]
#         }
#       },
#       updated_at: {
#         label: "Updated",
#         format: ->(post) { I18n.l(post.updated_at, format: :short) },
#         sortable: true,
#         searchable: false,
#         filterable: false
#       }
#     }
#   end

#   def self.add_display_column(key, label:, format: ->(post) { post.send(key) }, **options)
#     display_columns[key.to_sym] = {
#       label: label,
#       format: format,
#       sortable: options[:sortable] || false,
#       searchable: options[:searchable] || false,
#       filterable: options[:filterable] || false,
#       filter_options: options[:filter_options]
#     }
#   end

#   private

#   def self.truncate_text(text, length)
#     return text if text.length <= length
#     text[0...length] + "..."
#   end
# end
