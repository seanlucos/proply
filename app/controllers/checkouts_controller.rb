class CheckoutsController < ApplicationController
  TRANSACTION_SUCCESS_STATUSES = [
    Braintree::Transaction::Status::Authorizing,
    Braintree::Transaction::Status::Authorized,
    Braintree::Transaction::Status::Settled,
    Braintree::Transaction::Status::SettlementConfirmed,
    Braintree::Transaction::Status::SettlementPending,
    Braintree::Transaction::Status::Settling,
    Braintree::Transaction::Status::SubmittedForSettlement,
  ]

  def new
    # @client_token = Braintree::ClientToken.generate
    @client_token = gateway.client_token.generate
  end

  def show
    # @transaction = Braintree::Transaction.find(params[:id])
    @transaction = gateway.transaction.find(params[:id])
    @result = _create_result_hash(@transaction)
    
    ## 1. update user.status from session[:m_gold] -- may not be sysAdmin
    ## 2. create bt_transaction from @transaction AND @result

    if @transaction.id.present?
      @transaction.id
      @user = User.find session[:m_id]
      @user.status = session[:m_gold]
      @user.transaction_id = @transaction.id    ## dngs9xq6
      @user.purchased_at = Time.now
      @user.save
      
      # insert bt_transaction:
      @bt = BtTransaction.new 
      
      @bt.cu_id = session[:m_id]
      @bt.cc_holder = session[:m_gold]
      
      @bt.bt_id = @transaction.id
      @bt.bt_type = @transaction.type
      @bt.bt_amount = @transaction.amount
      @bt.bt_status = @transaction.status
      @bt.bt_created_at = @transaction.created_at
      @bt.bt_updated_at = @transaction.updated_at
      
      @bt.cc_token = @transaction.credit_card_details.token
      @bt.cc_bin = @transaction.credit_card_details.bin
      @bt.cc_last4 = @transaction.credit_card_details.last_4
      @bt.cc_type = @transaction.credit_card_details.card_type
      @bt.cc_expire_on = @transaction.credit_card_details.expiration_date
      # @bt.cc_holder = @transaction.credit_card_details.cardholder_name
      @bt.cc_origin = @transaction.credit_card_details.customer_location
      
      if @transaction.customer_details.id.present?
        # @bt.cu_id = @transaction.customer_details.id
        @bt.cu_firstname = @transaction.customer_details.first_name
        @bt.cu_lastname = @transaction.customer_details.last_name
        @bt.cu_email = @transaction.customer_details.email
        @bt.cu_company = @transaction.customer_details.company
        @bt.cu_website = @transaction.customer_details.website
        @bt.cu_phone = @transaction.customer_details.phone
        @bt.cu_fax = @transaction.customer_details.fax
      end
      @bt.save
    end
  end

  def create
    amount = params["amount"] # In production you should not take amounts directly from clients
    nonce = params["payment_method_nonce"]

    # result = Braintree::Transaction.sale(
    result = gateway.transaction.sale(
      amount: amount,
      payment_method_nonce: nonce,
      :options => {
        :submit_for_settlement => true
      }
    )

    if result.success? || result.transaction
      redirect_to checkout_path(result.transaction.id)
    else
      error_messages = result.errors.map { |error| "Error: #{error.code}: #{error.message}" }
      flash[:error] = error_messages
      redirect_to new_checkout_path
    end
  end

  def _create_result_hash(transaction)
    status = transaction.status

    # result in show page
    # <img src=<%= asset_path("#{@result[:icon]}.svg") %> alt="">

    if TRANSACTION_SUCCESS_STATUSES.include? status
      result_hash = {
        :header => "Sweet Success!",
        :icon => "success",
        :message => "Your transaction has been successfully processed."
      }
    else
      result_hash = {
        :header => "Transaction Failed",
        :icon => "fail",
        :message => "Your transaction has a status of #{status}. See the Braintree API response and try again."
      }
    end

    # if TRANSACTION_SUCCESS_STATUSES.include? status
    #     :message => "Your test transaction has been successfully processed. See the Braintree API response and try again."
    #     :message => "Your test transaction has a status of #{status}. See the Braintree API response and try again."
    # end

  end

  def gateway
    env = ENV["BT_ENVIRONMENT"]

    @gateway ||= Braintree::Gateway.new(
      :environment => env && env.to_sym,
      :merchant_id => ENV["BT_MERCHANT_ID"],
      :public_key => ENV["BT_PUBLIC_KEY"],
      :private_key => ENV["BT_PRIVATE_KEY"],
    )
  end
end
