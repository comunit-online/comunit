# frozen_string_literal: true

# Create tables for Comunit
class CreateComunitComponent < ActiveRecord::Migration[6.1]
  def up
    create_component
    create_sites unless Site.table_exists?
  end

  def down
    [Site].each do |model|
      drop_table model.table_name if model.table_exists?
    end

    BiovisionComponent[Biovision::Components::ComunitComponent]&.destroy
  end

  private

  def create_component
    slug = Biovision::Components::ComunitComponent.slug
    settings = {
      Biovision::Components::ComunitComponent::SETTING_MAIN_HOST => 'https://sb-main.comunit.online'
    }

    BiovisionComponent.create(slug: slug, settings: settings)
  end

  def create_sites
    create_table :sites, comment: 'Network sites' do |t|
      t.uuid :uuid, null: false
      t.references :simple_image, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.timestamps
      t.boolean :active, default: false, null: false
      t.boolean :local, default: true, null: false
      t.integer :version, limit: 2, default: 1, null: false
      t.string :name
      t.string :host
      t.string :token
      t.jsonb :data, default: {}, null: false
    end

    add_index :sites, :uuid, unique: true
    add_index :sites, :data, using: :gin
  end
end
