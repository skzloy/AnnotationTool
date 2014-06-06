class Article < ActiveRecord::Base
	has_many :experiments
	validates :title, presence: true,
                    length: { minimum: 5 }
end
