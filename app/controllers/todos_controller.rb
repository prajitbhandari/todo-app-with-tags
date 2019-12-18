require 'byebug'
class TodosController < ApplicationController
  respond_to? :html, :js
  def index
    @todos = Todo.all
  end

  def new
    @todo = Todo.new
  end

  def edit
    @todo = Todo.find(params[:id])
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      redirect_to @todo
      #   redirect_to todo_path(@todo)
      #   redirect_to todo_path(id: @todo.id)
      #   redirect_to "todos_path/#{@todo.id}"
    else
      redirect_to new_todo_path
    end
  end

  def show
    @todo = Todo.find(params[:id])
  end

  def update
    @todo = Todo.find(params[:id])
    @todo.isCompleted ? @todo.update_attribute(:isCompleted, nil) : @todo.update_attribute(:isCompleted, true)

    if request.xhr?
      # respond to Ajax request
      respond_to do |format|
        #format.js { render :file => "/todos/index.html.erb" }
        format.js
      end
    else
      redirect_to todos_path
    end

    #if @todo.update(todo_params)
    #  redirect_to todos_path
    #else
    #  redirect_to edit_todo_path(@todo)
    #end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    redirect_to todos_path
  end

  #def completed
  #  @todo = Todo.find(params[:id])
  #  @todo.update_attribute(:isCompleted, true)
  #  redirect_to todos_path, notice: "Task Completed"
  #end


  private
  def todo_params
    params.require(:todo).permit(:item, :isCompleted, :tag_ids => [])
  end
end

