# app/controllers/admin/features_controller.rb (with proper Pundit)
module Admin
  class FeaturesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_tenant
    
    def index
      # Use policy_scope for Pundit
      @features = policy_scope(Feature).available_for_tenant(@tenant)
      @enabled_features = @tenant.enabled_features.pluck(:feature_id)
    end
    
    def update
      feature = Feature.find(params[:id])
      authorize feature, :admin?  # Add this authorization
      
      if params[:enabled] == "true"
        result = FeatureManager.enable_for_tenant(@tenant, feature.key)
      else
        result = FeatureManager.disable_for_tenant(@tenant, feature.key)
      end
      
      if result[:success]
        redirect_to admin_features_path, notice: "Feature updated successfully"
      else
        redirect_to admin_features_path, alert: result[:error]
      end
    end
    
    private
    
    def set_tenant
      @tenant = current_user.tenant
    end
  end
end