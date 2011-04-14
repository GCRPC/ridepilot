class FundingSourcesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def new
    @funding_source = FundingSource.new
    @providers = Provider.all
    @checked_providers = []
  end

  def show
    redirect_to :action=>:edit
  end

  def create
    funding_source_params = params[:funding_source]
    @funding_source = FundingSource.create(funding_source_params)

    if @funding_source.save
      redirect_to(@funding_source, :notice => 'Funding source was successfully created.')
    else
      @providers = Provider.all
      render :action=>:new
    end
  end

  def edit
    @providers = Provider.all
    @checked_providers = @funding_source.providers
  end

  def update
    funding_source_params = params[:funding_source]
    if @funding_source.update_attributes(funding_source_params)

      #now, handle changes to the provider list
      new_provider_ids = params["provider"]

      current_visibilities = @funding_source.funding_source_visibilities
      for visibility in current_visibilities
        if ! new_provider_ids.member? visibility.provider_id
          visibility.destroy
        end
      end
      current_provider_ids = current_visibilities.map {|x| x.provider_id}
      for id in new_provider_ids
        if ! current_provider_ids.member? id
          FundingSourceVisibility.create(:provider_id=>id, :funding_source_id=>@funding_source.id)
        end
      end

      redirect_to(@funding_source, :notice => 'Funding source was successfully created.')
    else
      @providers = Provider.all
      @checked_providers = @funding_source.providers
      render :action=>:edit
    end
  end

end
