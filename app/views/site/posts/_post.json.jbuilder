json.extract! post, :id, :title, :content, :active, :featured, :published_date, :customer_id, :created_at, :updated_at
json.url post_url(post, format: :json)
