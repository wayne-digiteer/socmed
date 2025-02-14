# app/models/customer.rb
class Customer < ApplicationRecord
  include SearchableSortable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts

  configure_display_columns do
    add_display_column :id,
      label: "ID",
      sortable: true

    add_display_column :username,
      label: "Username",
      sortable: true,
      searchable: true

    add_display_column :email,
      label: "Email",
      sortable: true,
      searchable: true

    add_display_column :created_at,
      label: "Created",
      sortable: true,
      format: ->(customer) { I18n.l(customer.created_at, format: :short) }
  end
end
#
# class Customer < ApplicationRecord
#   validates :username, presence: true
#   # Include default devise modules. Others available are:
#   # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
#   devise :database_authenticatable, :registerable,
#          :recoverable, :rememberable, :validatable
#   has_many :posts
# end
