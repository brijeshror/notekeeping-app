class Tag < ApplicationRecord
  def self.find_or_create tag_names = []
    return [] if tag_names.blank?
    tag_names = tag_names.map(&:strip)
    not_included_tags = tag_names - Tag.pluck(:name)

    tags = Tag.where('name IN (?)', tag_names).to_a
    not_included_tags.each do |name|
      tags << Tag.create(name: name.strip)
    end
    tags
  end
end
