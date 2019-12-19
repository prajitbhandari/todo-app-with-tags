require 'byebug'
class TodosController < ApplicationController

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
    render json: @todos
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    redirect_to todos_path
  end

  private
  def todo_params
    params.require(:todo).permit(:item, :isCompleted, :tag_ids => [])
  end
end

