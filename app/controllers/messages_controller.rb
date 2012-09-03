class MessagesController < ApplicationController
    # GET /messages
    # GET /messages.json
    def index
        @messages = Message.all

        respond_to do |format|
            format.html # index.html.erb
            format.json { render json: @messages }
        end
    end

    # GET /messages/1
    # GET /messages/1.json
    def show
        @message = Message.find(params[:id])

        respond_to do |format|
            format.html # show.html.erb
            format.json { render json: @message }
        end
    end

    # GET /messages/new
    # GET /messages/new.json
    def new
        @message = Message.new

        respond_to do |format|
            format.html # new.html.erb
            format.json { render json: @message }
        end
    end

    # GET /messages/1/edit
    def edit
        @message = Message.find(params[:id])
    end

    # POST /messages
    # POST /messages.json
    def create
        @message = Message.new(params[:message])
        respond_to do |format|
            unless @message.conversation.nil?
                if @message.save
                    redirect_object = @message

                    if @message.conversation.conversation_object.class.name == "Invitation"
                        @message.conversation.users.each do |user|
                            if user != @message.user
                                notification = Notification.create(user: user, notification_object: @message, notification_type: NotificationType.find_by_name("NewInvitationMessage"))
                            end
                        end
                        redirect_object = @message.conversation.conversation_object


                    end

                    format.html { redirect_to redirect_object, notice: 'Message was successfully sent.' }
                    format.json { render json: @message, status: :created, location: @message }
                else
                    format.html { render action: "new" }
                    format.json { render json: @message.errors, status: :unprocessable_entity }
                end
            else

                unless not params[:conversation_id].nil?
                    conversation = current_user.conversations.create
                    current_project.conversations << conversation
                    current_project.save
                    @message.conversation_id = conversation
                    params[:message][:user_id].each do |id|
                        user = User.find_by_id(id)
                        conversation.users << user
                    end
                else
                    conversation = Conversation.find_by_id(params[:conversation_id])
                    @message.text = params[:text]

                end
                @message.user = current_user
                conversation.messages << @message


                conversation.users.each do |user|
                    notification = Notification.create(user: user, notification_object: @message, notification_type: NotificationType.find_by_name("Default"))
                end
                conversation.save
                if @message.save
                    format.html { redirect_to conversation_url(conversation), notice: 'Message was successfully sent.' }
                    format.json { render json: @message, status: :created, location: @message }
                    format.mobile { redirect_to conversation_url(conversation), notice: 'Message was successfully sent.' }
                else
                 format.html { render action: "new" }
                 format.json { render json: @message.errors, status: :unprocessable_entity }
                 format.mobile { render action: "new" }
             end
         end
     end
 end

    # PUT /messages/1
    # PUT /messages/1.json
    def update
        @message = Message.find(params[:id])

        respond_to do |format|
            if @message.update_attributes(params[:message])
                format.html { redirect_to @message, notice: 'Message was successfully sent.' }
                format.json { head :no_content }
            else
                format.html { render action: "edit" }
                format.json { render json: @message.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /messages/1
    # DELETE /messages/1.json
    def destroy
        @message = Message.find(params[:id])
        @message.destroy

        respond_to do |format|
            format.html { redirect_to messages_url }
            format.json { head :no_content }
        end
    end
end
