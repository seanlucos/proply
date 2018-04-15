class Article < ActiveRecord::Base
  attr_accessor :picture_cache, :mimage #to unset field after submission - params.except(:card_number) in your controller
  belongs_to :user 
  validates :user_id, presence: true
  validates :proptype, presence: true
  validates :place, presence: true
  validates :region, presence: true
  validates :area, presence: true
  validates :category, presence: true
  validates :amount, :inclusion => 0..10000000

 	validates :title, presence: true, length: {minimum: 3, maximum: 50}
	validates :description, presence: true, length: {minimum: 10, maximum: 1000} 
	#has_many :images, dependent: :destroy

  # multiple image uploading
	#has_many :images, :inverse_of => :article, dependent: :destroy
	has_many :images, dependent: :destroy
	# enable nested attributes for images through article class
	accepts_nested_attributes_for :images, :allow_destroy => true

  scope :place, -> (place) { where place: place }
  scope :region, -> (region) { where region: region }
  scope :area, -> (area) { where area: area }
  scope :category, -> (category) { where category: category }
  scope :otherinfo, -> (otherinfo) { where otherinfo: otherinfo }  
  scope :proptype, -> (proptype) { where proptype: proptype }
  scope :titletype, -> (titletype) { where titletype: titletype }  
  scope :furnishing, -> (furnishing) { where furnishing: furnishing }    
  scope :zoning, -> (zoning) { where zoning: zoning }    
  scope :lot, -> (lot) { where lot: lot }
  
  def self.search(search)
   where(['title LIKE ? OR description LIKE ?', "%#{search}%", "%#{search}%"])
  end

end
