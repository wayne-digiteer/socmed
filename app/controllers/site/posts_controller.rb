# app/controllers/site/posts_controller.rb
module Site
  class PostsController < BaseController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :authenticate_customer!, except: %i[ index show ]

  # GET /posts or /posts.json
  def index
    if params[:tab] == "featured"
      @posts = Post.where(featured: true)
                   .where("published_date <= ?", DateTime.now)
                   .order(published_date: :desc)
                   .limit(5)
    else
      @posts = Post.where(active: true)
                   .where("published_date <= ?", DateTime.now)
                   .order(published_date: :desc)
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    if @post.customer != current_customer
      redirect_to "/", alert: "You are not authorized to edit this post."
    end
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)
    @post.customer = current_customer

    # print the current user and the customer
    puts "Current User: #{current_customer}"

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    if @post.customer != current_user
      redirect_to @post, notice: "You are not authorized to delete this post."
    end

    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.expect(post: [ :title, :content, :active, :featured, :published_date, :customer_id ])
    end
  end
end
