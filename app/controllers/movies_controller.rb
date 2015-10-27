class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
     @all_ratings = Movie.all_ratings
     @movies = Movie.all
     if params[:ratings]==nil
       @selected=Movie.all_ratings
       session.delete(:ratings)
     end
        if params[:ratings]!=nil
         @movies = @movies.select{|movie| params[:ratings].has_key?(movie.rating)}
         session[:ratings]=params[:ratings]
         @selected=params[:ratings].keys
       end
         if session[:ratings]!=nil
         @movies=@movies.select{|movie| session[:ratings].has_key?(movie.rating)}
          @selected=session[:ratings].keys
          end
   
   if(params[:sort_param]== 'title')
      @movies=@movies.sort_by{|movie|movie.title}
   @highlight_movies ='hilite'
  end
  if(params[:sort_param]== 'release_date')
    @movies=@movies.sort_by{|movie|movie.release_date}
    @highlight_rating='hilite'
  end
end
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
