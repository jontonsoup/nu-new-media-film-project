class AddProjectIdToConversation < ActiveRecord::Migration
  def change
    add_column :conversations, :project_id, :integer
  end
end
