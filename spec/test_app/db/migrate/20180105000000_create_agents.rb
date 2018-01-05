class CreateAgents < ActiveRecord::Migration[5.1]
  def up
    unless Agent.table_exists?
      create_table :agents do |t|
        t.timestamps
        t.boolean :bot, default: false, null: false
        t.boolean :mobile, default: false, null: false
        t.string :name, null: false, index: true
      end
    end
  end

  def down
    if Agent.table_exists?
      drop_table :agents
    end
  end
end
