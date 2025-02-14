# app/controllers/admin/posts_controller.rb
module Admin
  class PostsController < Admin::BaseController
    before_action :set_post, only: [ :show, :edit, :update, :destroy ]

    def index
      posts = apply_search_sort(Post.all)

      @pagy, @posts = pagy(posts)

      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("posts_table",
            partial: "table",
            locals: { posts: @posts })
        end
      end
    end

    def show
    end

    def edit
      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("modal",
            partial: "modal",
            locals: { post: @post })
        end
      end
    end

    def update
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to admin_posts_path, notice: "Post was successfully updated." }
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.replace("posts_table",
                partial: "table",
                locals: { posts: Post.all }),
              turbo_stream.remove("modal")
            ]
          end
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace("modal",
              partial: "modal",
              locals: { post: @post })
          end
        end
      end
    end

    def destroy
      @post.destroy

      respond_to do |format|
        format.html { redirect_to admin_posts_path, notice: "Post was successfully destroyed." }
        format.turbo_stream do
          @pagy, posts = pagy(Post.all, request_path: "/admin/posts")

          render turbo_stream: turbo_stream.replace("posts_table",
            partial: "table",
            locals: { posts: posts })
        end
      end
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :active, :featured, :published_date)
    end
  end
end
