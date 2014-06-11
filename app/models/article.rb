class Article < ActiveRecord::Base
	has_many :experiments, dependent: :destroy
	validates :title, presence: true,
                    length: { minimum: 5 }
end
