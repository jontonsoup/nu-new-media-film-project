class Conversation < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :conversation_object, :polymorphic => true
  belongs_to :project
  has_and_belongs_to_many :users
  has_many :messages
end
