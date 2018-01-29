class User < ApplicationRecord
  class AccessDenied < ::StandardError; end
  has_many :notes, dependent: :destroy
  has_many :note_shares, dependent: :destroy
  has_many :shared_notes, through: :note_shares, source: :note

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable
  validates :name, presence: true
end
