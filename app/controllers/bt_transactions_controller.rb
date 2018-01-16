class BtTransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, only: [:destroy, :index]
  
  def index
    sql = "
      SELECT u.name, b.* 
      FROM bt_transactions b
      LEFT JOIN users u on u.id = CAST(cu_id as int)
      ORDER BY bt_updated_at desc
      "

    # @bts = BtTransaction.paginate(page: params[:page], per_page: 25).order('bt_updated_at desc')
  
    @bts = BtTransaction.paginate_by_sql(sql, page: params[:page], per_page: 25)
  end
  
  def destroy
    @bts.destroy
    respond_to do |format|
      format.html { redirect_to bt_transactions_path, notice: 'bt_transaction was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
    def require_admin
      if logged_in? and !current_user.admin?
        flash[:danger] = "Only admin users can perform that action"
        redirect_to root_path
      end
    end
    
end