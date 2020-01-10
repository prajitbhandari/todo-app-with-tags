require 'byebug'
class TodosController < ApplicationController

  def index
    #debugger
    @todos = Todo.with_deleted
  end

  def new
    @todo = Todo.new
  end

  def edit
    #debugger
    @todo = Todo.with_deleted.find(params[:id])
  end

  def create
    #debugger
    @todo = Todo.new(todo_params)
    @todo.save
    redirect_to todos_path

      #redirect_to @todo
      #   redirect_to todo_path(@todo)
      #   redirect_to todo_path(id: @todo.id)
      #   redirect_to "todos_path/#{@todo.id}"
    #else
    #  redirect_to new_todo_path
    #end
  end

  def show
    #debugger
    @todo = Todo.with_deleted.find(params[:id])
  end

  def update
    @todo = Todo.with_deleted.find(params[:id])
    if request.xhr?
      @todo.isCompleted ? @todo.update_attribute(:isCompleted, false) : @todo.update_attribute(:isCompleted, true)
      respond_to do |format|
        #format.html {redirect_to todos_path}
        format.json { render json: {:todo => @todo } }
      end
    else
      if @todo.update(todo_params)
        respond_to do |format|
          format.html{redirect_to @todo}
        end
      else
        render edit_todo_path(@todo)
      end
    end
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
  end

  def recover
    @todo = Todo.only_deleted.find(params[:id])
    @todo.restore
  end

  def purge
    @todo = Todo.only_deleted.find(params[:id])
    @todo.really_destroy!
  end

  private
  def todo_params
    params.require(:todo).permit(:item, :tag_ids => [])
  end
end

