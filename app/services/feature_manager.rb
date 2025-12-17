# app/services/feature_manager.rb
class FeatureManager
  class << self
    def enable_for_tenant(tenant, feature_key, config = {})
      feature = Feature.find_by(key: feature_key)
      return { success: false, error: "Feature not found" } unless feature
      
      # Check dependencies
      dependency_result = check_dependencies(tenant, feature)
      return dependency_result unless dependency_result[:success]
      
      # Create or update tenant feature
      tenant_feature = TenantFeature.find_or_initialize_by(tenant: tenant, feature: feature)
      tenant_feature.configuration = config
      
      if tenant_feature.save && tenant_feature.enable!
        { success: true, tenant_feature: tenant_feature }
      else
        { success: false, error: tenant_feature.errors.full_messages }
      end
    end
    
    def disable_for_tenant(tenant, feature_key)
      tenant_feature = tenant.tenant_features.joins(:feature).where(features: { key: feature_key }).first
      return { success: false, error: "Feature not enabled for this tenant" } unless tenant_feature
      
      if tenant_feature.disable!
        { success: true }
      else
        { success: false, error: tenant_feature.errors.full_messages }
      end
    end
    
    def check_dependencies(tenant, feature)
      missing_deps = feature.dependencies.reject do |dep_key|
        tenant.feature_enabled?(dep_key)
      end
      
      if missing_deps.any?
        { 
          success: false, 
          error: "Missing dependencies: #{missing_deps.join(', ')}",
          missing_dependencies: missing_deps 
        }
      else
        { success: true }
      end
    end
    
    def available_features_for_agency(agency)
      Feature.where(is_agency_only: true).or(
        Feature.where(is_agency_only: false, is_core: false)
      )
    end
  end
end