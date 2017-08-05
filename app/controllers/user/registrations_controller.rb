class User::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters
  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:name, :telephone, :agentno, :company, :prefercountry)
    devise_parameter_sanitizer.for(:account_update).push(:name, :telephone, :agentno, :company, :prefercountry)
  end

#did this with error. copied to erb instead 24-nov-2016
#  def new
#    @places = Place.where(status: true)
#    @places_for_dropdown = []
#    @places.each do |i|
#      @places_for_dropdown << [i.name, i.id]
#    end    
#  end
end