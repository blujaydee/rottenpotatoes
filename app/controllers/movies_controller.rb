class MoviesController < ApplicationController

  before_filter :ratings_function


  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # @selected_ratings = []

    # @by = params[:by]
    # @redirect = false

    # if params[:by].nil? && !session[:by].nil?
    #   @by = session[:by]
    #   # @redirect = true
    # elsif params[:by] != session[:by]
    #   session[:by] = params[:by]
    #   # @by = params[:by]
    #   # @redirect = true
    # end #end for sorting

    # if params[:ratings].nil? && !session[:ratings].nil?
    #   @selected_ratings = session[:ratings]
    #   # @redirect = true
    # elsif params[:ratings] != session[:ratings]
    #   session[:ratings] = params[:ratings]
    #   # @selected_ratings = params[:ratings]
    #   # @redirect = true
    # elsif !params[:ratings].nil? #
    #   params[:ratings].each_key do |key|
    #     @selected_ratings << key
    #   end
    #   session[:ratings] = @selected_ratings
    # else #first time loading
    #   @selected_ratings = @all_ratings
    # end #end for ratings

    # if @redirect == true #redirect with saved info in sesh
    #   flash.keep
    #   # flash.now[:notice] = "#{session[:ratings]}"
    #   redirect_to movies_path(:rating => session[:ratings], :order => session[:by]) and return
    # end

    # @movies = Movie.find(:all, :conditions => {:rating => @selected_ratings}, :order => @by)

    # session.clear     #first attemp
    @all_ratings = Movie.all_ratings
    
    @selected_ratings = {}
    @redirect = false
    ratings = params[:ratings]
    if !(ratings.nil?)
      if ratings != session[:ratings]
        # @redirect = true
      end
      @selected_ratings = ratings
      session[:ratings] = @selected_ratings
    elsif ratings.nil? && !(session[:ratings].nil?)
      @selected_ratings = session[:ratings]
      @redirect = true
    elsif session[:ratings].nil?
      @all_ratings.each do |key|
        @selected_ratings[key] = 1
      end
    end
#redirect_to movies_path(:commit=>params[:commit],:utf8=>params[:utf8],:sort => session[:sort],:ratings =>session[:ratings
    if params[:by].nil?
      if !(session[:by].nil?)
        @sort = session[:by]
        @redirect = true
      end
    else
      @sort = params[:by]
      session[:by] = @sort
    end
    if @redirect
      flash.keep
      redirect_to movies_path(:commit=>params[:commit],:utf8=>params[:utf8],:by => session[:by], :ratings => session[:ratings]) and return
    end
     #redirect_to movies_path(:rating => session[:ratings], :order => session[:by])
    # flash.now[:notice] = "#{session[:ratings]}"

    @movies = Movie.find(:all, :conditions => {:rating => @selected_ratings.keys}, :order => @sort)

  end
 
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def ratings_function
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
  end

end
