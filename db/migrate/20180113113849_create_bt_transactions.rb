class CreateBtTransactions < ActiveRecord::Migration
  def change
    create_table :bt_transactions do |t|
      t.string   :bt_id
      t.string   :bt_type
      t.decimal  :bt_amount, precision: 10, scale: 2
      t.string   :bt_status
      t.datetime :bt_created_at
      t.datetime :bt_updated_at
  
      t.string   :cc_token
      t.string   :cc_bin
      t.string   :cc_last4
      t.string   :cc_type
      t.datetime :cc_expire_on
      t.string   :cc_holder
      t.string   :cc_origin
  
      t.string   :cu_id
      t.string   :cu_firstname
      t.string   :cu_lastname
      t.string   :cu_email
      t.string   :cu_company
      t.string   :cu_website
      t.string   :cu_phone
      t.string   :cu_fax

    end
  end
end
