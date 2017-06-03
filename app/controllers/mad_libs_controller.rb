class MadLibsController < ApplicationController
  def home
    @madlibs = MadLib.last(20).reverse
  end

  def new
    @params = params if params
  end

  def create
    @madlib = MadLib.new(title: params['madlib_title'], text: params['madlib_text'])
    if @madlib.save
      redirect_to new_mad_lib_solution_path(@madlib)
    else
      @errors = @madlib.errors.full_messages
      render 'new'
    end
  end
end
