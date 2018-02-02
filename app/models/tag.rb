class Tag < ApplicationRecord
  scope :find_tags, -> (tag_names = []) do
    with_filter_names(tag_names) { |names| where('name IN (?)', names) }
  end

  def self.find_or_create tag_names = []
    with_filter_names tag_names do |names|
      tags = []
      found_tags = find_tags(tag_names)
      tags.push *found_tags
      tags.push *(names - found_tags.pluck(:name)).map { |name| Tag.create(name: name.strip) }
    end
  end

  private

  def  self.with_filter_names names = []
    tag_names = (names.blank? ? [] : names).map(&:strip)
    tag_names = tag_names.blank? ? [] : tag_names
    (block_given? && tag_names.present?) ? yield(tag_names) : tag_names
  end
end
