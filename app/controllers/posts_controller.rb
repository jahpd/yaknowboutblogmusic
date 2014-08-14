class PostsController < ApplicationController

  include PostsHelper

  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, only:[:show, :new, :edit, :update, :destroy]
  before_filter :all_posts_from_current_user, only: [:index]
  before_filter :set_json_compile, only: [:compile]

  # GET /posts
  # GET /posts.json
  def index
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  def hear
    @code = params[:c]
  end

  # GET /posts/1/compile
  # for ajax response
  def compile
    respond_to do |format|
      #format.js {render :json => @json}
      format.json {render(:json => @json, :callback => params['callback'])}
    end
  end


  # POST /posts
  # POST /posts.json
  def create
    # add username to author parameter
    @post = Post.new(
        :author => current_user.name, 
        :title => post_params[:title], 
        :doc => post_params[:doc]
      )

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, :flash => :sucess}
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, :flash => sucess }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :doc)
    end

    def set_json_compile
      code = decompress_for params[:c]
      set_json({:callback => CoffeeScript.compile(code, {:bare => true}), :type =>"text/javascript"})
    end
      
    def set_json(opt)
      @json = Hash.new
      opt.each_pair{|k, v| @json[k] = v}
      @json[:done] = Time.now
      @json.to_json
    end
end
