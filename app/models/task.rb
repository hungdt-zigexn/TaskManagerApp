class Task < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  validates :title, presence: true

  # Scopes for filtering
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :due_before, ->(date) { where("due_date <= ?", date) if date.present? }
  scope :by_tag, ->(tag_name) {
    joins(:tags).where(tags: { name: tag_name }).distinct if tag_name.present?
  }

  # Scope for sorting
  scope :sort_by_field, ->(sort_field) {
    case sort_field
    when "due_date"
      order(due_date: :asc)
    when "title"
      order(title: :asc)
    when "status"
      order(status: :desc)
    else
      order(created_at: :desc)
    end
  }

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |name|
      Tag.where(name: name.strip).first_or_create!
    end
  end
end
