class Image < ActiveRecord::Base
  belongs_to :article
  mount_uploader :image, PictureUploader
  validate :picture_size
  validates :picture, presence: true

  private
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end  
    
end
