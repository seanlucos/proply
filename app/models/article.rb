class Article < ActiveRecord::Base
  attr_accessor :picture_cache, :mimage #to unset field after submission - params.except(:card_number) in your controller
  belongs_to :user 
  validates :user_id, presence: true
  validates :proptype, presence: true
  validates :place, presence: true
  validates :region, presence: { message: "(or State) can't be blank" }
  validates :area, presence: { message: "(or Town) can't be blank" }
  validates :category, presence: true
  validates :amount, :inclusion => 0..1000000000000

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
  scope :active_days, ->(time) { where("articles.updated_at > ?", time) if time.present? }
  
  def self.search(search)
   where(['LOWER(title) LIKE ? OR LOWER(description) LIKE ?', "%#{search.downcase}%", "%#{search.downcase}%"])
  end

  def expired_31days?
    self.updated_at.to_date < Time.now.ago(31.days)
  end
end
