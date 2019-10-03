# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  def index
    @movies = Movie.order(params[:sort_by])

    # Lists all possible ratings to search
    @all_ratings = Movie.all_ratings
    
    # If nothing is checked
    if @chosen_rating_type.nil? 
      @chosen_rating_type = @all_ratings
    end

    # At the case when no checkbox is marked
    unless params[:ratings].nil?
      # Select only the ratings checked
      @chosen_rating_type =  params[:ratings].select {|k,v| v.eql? "1" }.keys
      @movies = Movie.where(:rating => @chosen_rating_type)
    end

    unless params[:ratings].eql? session[:ratings]
      if params[:ratings].nil?
        params[:ratings] = session[:ratings]
      end
      
      if session[:ratings].nil?
        session[:ratings] = params[:ratings]
      end

    end

  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end