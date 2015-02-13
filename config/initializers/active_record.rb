ActiveRecord::Associations::AssociationCollection.class_eval do
  def new_by_user(user, attributes = {})
    new(attributes) { |obj| obj.user = user; yield(obj) if block_given? }
  end
  
  def build_by_user(user, attributes = {})
    build(attributes) { |obj| obj.user = user; yield(obj) if block_given? }
  end
  
  def create_by_user(user, attributes = {})
    create(attributes) { |obj| obj.user = user; yield(obj) if block_given? }
  end
end