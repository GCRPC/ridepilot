class Lite::LiteCustomersController < ApplicationController

  def index
    @lite_customers = LiteCustomer.for_provider(current_provider_id)
  end

  def show
    @lite_customer = LiteCustomer.find(params[:id])
  end

  def new
    @lite_customer = LiteCustomer.new(:provider_id => current_provider_id)
  end

  def create
    @lite_customer = LiteCustomer.new(lite_customer_params)

    if @lite_customer.save
      redirect_to trips_lite_index_path
    else
      render :new
    end
  end

  def edit
    @lite_customer = LiteCustomer.find(params[:id])
  end

  def update
    @lite_customer = LiteCustomer.find(params[:id])

    if @lite_customer.update(lite_customer_params)
      redirect_to trips_lite_index_path
    else
      render :edit
    end
  end

  def destroy
    @lite_customer = LiteCustomer.find(params[:id])
    @lite_customer.destroy

    redirect_to trips_lite_index_path
  end

  def destroy_all
    if current_user.valid_for_api_authentication?(params[:password])
      LiteCustomer.destroy_all
      render :js => "window.location = '#{trips_lite_index_path}'"
    else
      flash.now[:alert] = 'Error while sending message!'
      render :status => 401, :js => ""
    end
  end

  def autocomplete
    lite_customers = LiteCustomer.all.order(:last_name).by_term( params[:term].downcase, 10 )
    render :json => lite_customers.map { |lite_customer| lite_customer.as_autocomplete }
  end

  def found
    if params[:customer_id].blank?
      redirect_to search_lite_lite_customers_path( :term => params[:customer_name] )
    else
      redirect_to edit_lite_lite_customer_path params[:customer_id]
    end
  end

  def search
    @lite_customers = LiteCustomer.all.order(:last_name).by_term(params[:term].downcase).
      paginate(:page => params[:page], :per_page => 15)

    redirect_to trips_lite_index_path
    #render :action => :index
  end

  private
    def lite_customer_params
      params.require(:lite_customer).permit(
        :id,
        :first_name,
        :last_name,
        :senior,
        :disabled,
        :provider_id
      )
    end
end