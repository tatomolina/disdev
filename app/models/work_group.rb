class WorkGroup < ActiveRecord::Base
  #A work_group is a class that represent group of development with all his members
  has_many :users, foreign_key: "work_group_id"

# It returns the articles whose titles contain one or more words that form the query
def self.search(search)
  # where(:title, query) -> This would return an exact match of the query
  if search
    where("name LIKE ?", "%#{search}%")
  else
    all.limit(10).order(created_at: :desc)
  end
end

end
