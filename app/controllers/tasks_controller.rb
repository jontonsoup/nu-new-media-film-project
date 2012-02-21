class TasksController < ApplicationController



  def new
    @task = Task.new
    @task_categories = self.current_project.task_categories.find(:all)

    respond_to do |format|
      format.mobile
    end
  end

  def create
    @task = Task.new(params[:task])
    setDefaults @task
    @task.save
    #(@task_categories || []).each { |task_category| @task.task_categories << task_category}
    #@task.save

    respond_to do |format|
      format.html
      format.mobile { redirect_to tasks_url, notice: 'Task Created.' }
    end
  end

  def edit
    @task = Task.find(params[:id])
    respond_to do |format|
      format.mobile
    end
  end
  
  def update
    #params[:task][:task_categories] ||= []
    @task = Task.find(params[:id])
    @task.update_attributes(params[:task])

    respond_to do |format|
      format.html
      format.mobile { redirect_to tasks_url, notice: 'Task Updated.' }
    end
  end
  
  def index
    if(params[:name].nil?)
      @tasks = self.current_project.tasks.find(:all)
    else
      @tasks = self.current_project.task_categories.find_by_name(params[:name]).tasks
    end

    respond_to do |format|
      format.mobile
    end

  end

  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.mobile { redirect_to tasks_url, notice: 'Task Deleted.' }
    end
  end
  
  def setDefaults(task)
    task.status = 0
    task.project_id = self.current_project.id
  end

end
