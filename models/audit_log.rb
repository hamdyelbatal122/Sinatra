require 'sequel'

migration 'create audit_logs' do
  database.create_table? :audit_logs do
    primary_key :id
    String :action, null: false
    String :entity_type, null: false
    Integer :entity_id, null: false
    Integer :user_id, null: true
    String :details, null: true
    DateTime :created_at
    index :entity_type
    index :user_id
  end
end

class AuditLog < Sequel::Model
end
