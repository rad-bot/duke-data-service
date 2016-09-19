namespace :elasticsearch do
  namespace :index do
    desc "creates indices for all indexed models"
    task create: :environment do
      Rails.logger.level = 3
      current_indices = DataFile.__elasticsearch__.client.cat.indices
      ElasticsearchResponse.indexed_models.each do |indexed_model|
        if current_indices.include? indexed_model.index_name
          indexed_model.__elasticsearch__.client.indices.delete index: indexed_model.index_name
        end
        indexed_model.__elasticsearch__.client.indices.create(
          index: indexed_model.index_name,
          body: {
            settings: indexed_model.settings.to_hash,
            mappings: indexed_model.mappings.to_hash
          }
        )
      end
    end #create

    desc "drops indices for all indexed models"
    task drop: :environment do
      Rails.logger.level = 3
      current_indices = DataFile.__elasticsearch__.client.cat.indices
      ElasticsearchResponse.indexed_models.each do |indexed_model|
        if current_indices.include? indexed_model.index_name
          indexed_model.__elasticsearch__.client.indices.delete index: indexed_model.index_name
        end
      end
    end #drop
  end
end
