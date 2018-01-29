class Note < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :note_shares, dependent: :destroy
  has_many :shared_users, through: :note_shares, source: :user

  validates :note, presence: true

  scope :has_tag, -> (tag_name) { joins(:tags).where(tags: { name: tag_name }) }

  def assign_tags tag_names
    self.tags = Tag.find_or_create(tag_names)
  end

  def owners
    [user] + shared_users.where('note_shares.access_role = ?', NoteShare::Owner)
  end

  def readers
    updaters + shared_users.where('note_shares.access_role = ?', NoteShare::Read)
  end

  def updaters
    owners + shared_users.where('note_shares.access_role = ?', NoteShare::Update)
  end

  def sharable_users
    User.where('id NOT IN (?)', related_users)
  end

  def related_users
    [user] + shared_users
  end
end
