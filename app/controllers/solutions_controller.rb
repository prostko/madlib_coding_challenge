class SolutionsController < ApplicationController
  def show
    @solution = Solution.find_by_id(params[:id])
    @resolution = @solution.resolve
  end

  def create
    @madlib = MadLib.find_by_id(params[:mad_lib_id])
    @solution = @madlib.solutions.create

    if @madlib
      params[:field_labels].each do |label, value|
        @solution.fill_field(label, value)
      end
        redirect_to mad_lib_solution_path(@madlib, @solution)
    else
    end
  end

  def new
    @madlib = MadLib.find_by_id(params[:mad_lib_id])
  end
end
