class User < ActiveRecord::Base
  # validates_format_of :name, with: /^[a-zA-Z0-9 ]*$/
  validates_format_of :name, with: /\A[a-zA-Z0-9 &_();:'$!]*\z/
  validates_uniqueness_of :name
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessor :m_gold
  has_one :payment
  accepts_nested_attributes_for :payment
  has_many :articles, dependent: :destroy
  has_many :paypals, dependent: :destroy
  has_many :cards

# must check the following during updates only
  # validates :name, presence: true, :on => :update --- taken out coz forgot password issue 20/10/2016
  # validates :telephone, presence: true, :on => :update   --- taken out coz forgot password issue 20/10/2016
  validates_presence_of :name, :agentno, :company, :telephone
  
  serialize :notification_params, Hash
  def paypal_url(return_path)
    values = {
        business: "landmarketing001@gmail.com",
        cmd: "_xclick",
        upload: 1,
        return: "#{Rails.application.secrets.app_host}#{return_path}",
        #invoice: '229',
        amount: '350.00',
        item_name: 'Package-1',
        currency_code: 'MYR',
        #item_number: id,
        notify_url: "#{Rails.application.secrets.app_host}/hook",
        quantity: '1'
    }
    "#{Rails.application.secrets.paypal_host}/cgi-bin/webscr?" + values.to_query
  end
  
end
