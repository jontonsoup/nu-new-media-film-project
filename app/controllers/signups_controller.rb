class SignupsController < ApplicationController
  # GET /signups
  # GET /signups.json
  def index
    @signups = Signup.all

    if(params.has_key?(:notice))
      @success_text = params[:notice]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @signups }
    end
  end

  # GET /signups/1
  # GET /signups/1.json
  def show
    @signup = Signup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @signup }
    end
  end

  # GET /signups/new
  # GET /signups/new.json
  def new
    @signup = Signup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @signup }
    end
  end

  # GET /signups/1/edit
  def edit
    @signup = Signup.find(params[:id])
  end

  # POST /signups
  # POST /signups.json
  def create
    @signup = Signup.new(params[:signup])

    if @signup.save
      respond_to do |format|
        flash[:success] = 'You have succesfully signed up to be an alpha tester!'
        AlphaTestSignupValidation.welcome_email(@signup.id).deliver
        format.html { redirect_to root_url }
        format.json { render :json => @signup, :status => :created, :location => @signup }
      end
    else
      flash[:error] = "You have errors in the form. Please fix them before continuing."
      #this causes the url to go to /signups!
      redirect_to signup_path
    end
  end

  # PUT /signups/1
  # PUT /signups/1.json
  def update
    @signup = Signup.find(params[:id])

    respond_to do |format|
      if @signup.update_attributes(params[:signup])
        format.html { redirect_to @signup, :notice => 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @signup.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /signups/1
  # DELETE /signups/1.json
  def destroy
    @signup = Signup.find(params[:id])
    @signup.destroy

    respond_to do |format|
      format.html { redirect_to signups_url }
      format.json { head :ok }
    end
  end
end
