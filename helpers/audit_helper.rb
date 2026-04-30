require_relative '../models/audit_log'

helpers do
  def log_audit(action, entity_type, entity_id, details = nil)
    AuditLog.create(
      action: action,
      entity_type: entity_type,
      entity_id: entity_id,
      user_id: current_user&.id,
      details: details,
      created_at: Time.now
    )
  end
end
