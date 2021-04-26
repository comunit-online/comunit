# frozen_string_literal: true

# Create tables for taxonomy
class CreateTaxonomyComponent < ActiveRecord::Migration[6.1]
  include Biovision::Migrations::ComponentMigration

  private

  def create_taxa
    create_table :taxa, comment: 'Taxa' do |t|
      t.uuid :uuid, null: false
      t.references :simple_image, foreign_key: { on_update: :cascade, on_delete: :nullify }
      t.integer :parent_id
      t.integer :object_count, default: 0, null: false
      t.integer :priority, limit: 2, default: 1, null: false
      t.boolean :visible, default: true, null: false
      t.timestamps
      t.string :name
      t.string :nav_text
      t.string :slug
      t.string :parents_cache, default: '', null: false
      t.integer :children_cache, array: true, default: [], null: false
      t.jsonb :data, default: {}, null: false
    end

    add_index :taxa, :uuid, unique: true
    add_index :taxa, :data, using: :gin
    add_foreign_key :taxa, :taxa, column: :parent_id, on_update: :cascade, on_delete: :cascade
  end

  def create_taxon_users
    create_table :taxon_users, comment: 'Taxa available to users' do |t|
      t.references :taxon, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_update: :cascade, on_delete: :cascade }
      t.jsonb :data, default: {}, null: false
    end

    add_index :taxon_users, :data, using: :gin
  end
end
