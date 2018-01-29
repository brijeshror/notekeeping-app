class NoteShare < ApplicationRecord
  AccessRoles = [Read = 'read', Update='update', Owner='owner']
  belongs_to :note
  belongs_to :user
  belongs_to :creator, class_name: 'User'

  validates :access_role, presence: true

  def destroy_transitive_share
    _other_shares = note.note_shares.where(creator_id: user_id)
    self.destroy
    _other_shares.each { |ns| ns.destroy_transitive_share }
  end
end
