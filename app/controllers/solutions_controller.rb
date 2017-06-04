class SolutionsController < ApplicationController
  def show
    @madlib = MadLib.find_by_id(params[:mad_lib_id])
    @solution = Solution.find_by_id(params[:id])
    @resolution = @solution.resolve
  end

  def create
    @madlib = MadLib.find_by_id(params[:mad_lib_id])
    @solution = @madlib.solutions.create

    respond_to do |format|
      format.js {}
      format.html { }
    end

    if @madlib
      params[:field_labels].each do |label, value|
        @solution.fill_field(label, value)
      end
    end

    if @madlib && request.xhr?
      render :json =>  @solution.resolve.to_json
    elsif @madlib
      redirect_to mad_lib_solution_path(@madlib, @solution)
    else
      redirect_to '/'
    end
  end

  def new
    @madlib = MadLib.find_by_id(params[:mad_lib_id])

    respond_to do |format|
      format.js {}
      format.html {}
    end

    if request.xhr?
      render 'solutions/new', layout: false, :content_type => 'text/html'
    end
  end

  def report
    @fields_report = Solution.report_fields
    @answers_report = Solution.report_answers
  end
end
