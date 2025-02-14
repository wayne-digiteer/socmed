module Admin
  class PostsController < Admin::BaseController
    before_action :set_post, only: [ :show, :edit, :update, :destroy ]

    def index
      @posts = Post.all

      # Apply global search
      if params[:search].present?
        @posts = @posts.search_all_columns(params[:search])
      end

      # Apply sorting
      if params[:sort_column].present? && params[:sort_direction].present?
        column = params[:sort_column]
        direction = params[:sort_direction]

        @posts = case column
        when "username"
          @posts.joins(:user).order("customers.username #{direction}")
        else
          @posts.order("#{column} #{direction}")
        end
      end

      respond_to do |format|
        format.html
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("posts", partial: "admin/posts/table", locals: { posts: @posts })
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
        format.json { head :no_content }
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
