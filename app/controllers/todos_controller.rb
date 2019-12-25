require 'byebug'
class TodosController < ApplicationController

  def index
    @todos = Todo.with_deleted
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
    if request.xhr?
      @todo.isCompleted ? @todo.update_attribute(:isCompleted, false) : @todo.update_attribute(:isCompleted, true)
      respond_to do |format|
        format.json { render json: {:todo => @todo } }
      end
    else
      if @todo.update(todo_params)
        redirect_to @todo
      else
        redirect_to edit_todo_path(@todo)
      end
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    redirect_to todos_path
  end

  def recover
    @todo = Todo.only_deleted.find(params[:id])
    @todo.restore
    redirect_to todos_path
  end

  def purge
    @todo = Todo.only_deleted.find(params[:id])
    @todo.really_destroy!
    redirect_to todos_path
  end

  private
  def todo_params
    params.require(:todo).permit(:item, :tag_ids => [])
  end
end

