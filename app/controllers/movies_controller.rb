class MoviesController < ApplicationController

  SELECTED_CLASS = "hilite"
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    populate_ratings
    populate_movies

    # update css class for sorted column
    @title_css = SELECTED_CLASS if session[:movies_sort] == "title"
    @release_date_css = SELECTED_CLASS if session[:movies_sort] == "release_date"
  end

  def populate_ratings
    @all_ratings = Movie.all_ratings

    if (params["ratings"] != nil && params["ratings"].count > 0)
      @checked_ratings = params["ratings"].keys
      session[:checked_ratings] = @checked_ratings
    elsif (session[:checked_ratings] != nil)
      @checked_ratings = session[:checked_ratings]
    else
      @checked_ratings = @all_ratings
    end
  end

  def populate_movies
    if (params[:sort] != nil && Movie.column_names.include?(params[:sort]))
      session[:movies_sort] = params[:sort]
      @movies = Movie.where("rating" => @checked_ratings).order(params[:sort])
    elsif (session[:movies_sort] != nil)
      @movies = Movie.where("rating" => @checked_ratings).order(session[:movies_sort])
    else
      @movies = Movie.where("rating" => @checked_ratings)
    end
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

end
