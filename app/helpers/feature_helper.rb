module FeatureHelper
  def feature_enabled?(feature_key)
    return false unless current_tenant
    
    @enabled_features ||= current_tenant.enabled_features.pluck(:key)
    @enabled_features.include?(feature_key)
  end
  
  def with_feature(feature_key, &block)
    yield if feature_enabled?(feature_key)
  end
end