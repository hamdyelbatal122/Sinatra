require 'sequel'

migration 'create links' do
  database.create_table? :links do
    primary_key :id
    String :name, unique: true, null: false
    String :url, null: false
    String :category, null: true
    String :tags, null: true # comma-separated
    Integer :hits, default: 0
    DateTime :created_at
    index :name
    index :category
  end
end

class Link < Sequel::Model
  def hit!
    self.hits += 1
    self.save(validate: false)
  end

  def tag_list
    (tags || '').split(',').map(&:strip).reject(&:empty?)
  end

  def validate
    super
    errors.add(:name, 'cannot be empty') if !name || name.empty?
    errors.add(:url, 'cannot be empty') if !url || url.empty?
  end
end
