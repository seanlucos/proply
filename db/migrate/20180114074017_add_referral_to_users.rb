class AddReferralToUsers < ActiveRecord::Migration
  def change
    add_column :users, :referral_name, :text
    add_column :users, :referral_contact, :text
  end
end
