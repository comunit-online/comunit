json.id taxon.id
json.type taxon.class.table_name
json.attributes do
  json.call(taxon, :name, :slug, :nav_text, :parent_id, :parents_cache, :children_cache)
end
json.meta do
  json.text_for_link taxon.text_for_link
  json.html(
    render(
      partial: 'admin/taxa/entity/in_search',
      locals: { entity: taxon },
      formats: [:html]
    )
  )
end
json.links do
  json.self admin_taxon_path(id: taxon.id)
end
unless taxon.parent.nil?
  json.relationships do
    json.parent do
      json.data do
        json.id taxon.parent_id
        json.type taxon.parent.class.table_name
      end
      json.links do
        json.self admin_taxon_path(id: taxon.parent_id)
      end
    end
  end
end
