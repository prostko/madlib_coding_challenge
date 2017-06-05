class MadLibsController < ApplicationController
  def home
    @madlibs = MadLib.last(20).reverse
  end

  def new
    @params = params if params
  end

  def create
    @madlib = MadLib.new(title: params['madlib_title'], text: params['madlib_text'])
    @madlib.update_attributes(user_id: current_user.id) if current_user

    respond_to do |format|
      format.js {}
      format.html {}
    end

    if @madlib.save
      if request.xhr?
        render 'solutions/new', layout: false, :content_type => 'text/html'
      else
        redirect_to new_mad_lib_solution_path(@madlib)
      end
    else
      @errors = @madlib.errors.full_messages
      if request.xhr?
        render :json =>  @errors.to_json
      else
        render 'new'
      end
    end
  end

  def show
    @madlib = MadLib.find_by_id(params[:id])

    respond_to do |format|
      format.json{ render json: @madlib.to_json }
    end
  end
end
