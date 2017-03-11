class PictureUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::MiniMagick
  process resize_to_limit: [400, 300] 
  process :watermark
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #"#{model.class.to_s.underscore}"
    "#{model.class.to_s.underscore}"
    #"uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def watermark
    #second_image = MiniMagick::Image.open("https://s3.amazonaws.com/arealestate1/image/logo.gif")
    #manipulate! do |img|
    #  result = img.composite(second_image) do |c|
    #    c.compose "Over"    # OverCompositeOp
    #    c.gravity "Center" # copy second_image onto first_image from (20, 20)
    #  end
    #  result
    #end
    manipulate! do |image|
      image.combine_options do |c|
        c.gravity 'Center'
        c.pointsize '22'
        c.annotate('+0+0', "http://landmark.my")
        c.fill 'grey'
      end
      image
    end

  end
  
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  #process scale: [400, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
     %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end