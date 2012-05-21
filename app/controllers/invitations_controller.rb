class InvitationsController < ApplicationController

    #POST /invite
    def invite
        InvitationMailer.invite(self.current_user.name, params[:Name], params[:Email], params[:"Personalized Message"]).deliver

        respond_to do |format|
            format.js
        end
    end

    # GET /invitations
    # GET /invitations.json
    def index
        @invitations = Invitation.where("to_user_id = #{self.current_user.id} OR from_user_id = #{self.current_user.id}")

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @invitations }
        end
    end

    # GET /invitations/1
    # GET /invitations/1.json
    def show
        @invitation = Invitation.find(params[:id]) rescue nil
        if @invitation.nil?
            flash[:error] = "You are not authorized to see that invitation"
            redirect_to root_url
            return
        end
        if (not @invitation.to_users.include?(self.current_user)) and  not (@invitation.from_user == self.current_user)
            flash[:error] = "You are not authorized to see that invitation"
            redirect_to root_url
            return
        end
        @message = Message.new(:conversation => @invitation.conversation, :user => self.current_user)
        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @invitation }
        end
    end

    # GET /invitations/new
    # GET /invitations/new.json
    def new
        @invitation = Invitation.new
        @invitation.from_user = self.current_user
        @invitation.project = self.current_project
        unless params[:user].nil?
            @invitation.to_user = User.find_by_id(params[:user])
        end
        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @invitation }
        end
    end

    # GET /invitations/1/edit
    def edit
        @invitation = Invitation.find(params[:id])
    end

    # POST /invitations
    # POST /invitations.json
    def create
        #to_users = params[:invitation][:to_user_ids].map {|user_id| User.find(user_id)}
        params[:invitation][:from_user] = User.find(params[:invitation][:from_user])
        @invitation = Invitation.new(params[:invitation])
        conversation = Conversation.create
        #debugger
        conversation.users << [@invitation.to_users, @invitation.from_user]
        @invitation.update_attribute(:conversation, conversation)
        @invitation.to_users.each do |user|
            notification = Notification.create!(:user => user, :notification_type => NotificationType.find_by_name("NewInvitation"), :notification_object => @invitation)
        end

        respond_to do |format|
            if @invitation.save
                format.html { redirect_to @invitation, success: 'Invitation was successfully created.' }
                format.json { render json: @invitation, status: :created, location: @invitation }
            else
                format.html { render action: "new" }
                format.json { render json: @invitation.errors, status: :unprocessable_entity }
            end
        end
    end

    # PUT /invitations/1
    # PUT /invitations/1.json
    def update
        @invitation = Invitation.find(params[:id])

        respond_to do |format|
            if @invitation.update_attributes(params[:invitation])
                format.html { redirect_to @invitation, success: 'Invitation was successfully updated.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @invitation.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /invitations/1
    # DELETE /invitations/1.json
    def destroy
        @invitation = Invitation.find(params[:id])
        @invitation.destroy

        respond_to do |format|
            format.html { redirect_to invitations_url }
            format.json { head :no_content }
        end
    end
end
