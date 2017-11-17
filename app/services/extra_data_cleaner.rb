class ExtraDataCleaner
  attr_reader :entity_name, :ids

  def initialize(entity_name, ids)
    @entity_name = entity_name
    @ids         = Array.wrap(ids)
  end

  def clean_extra_data
    return if ids.blank?

    entity_class.where.not(id: ids).delete_all
  end

  private

  def entity_class
    entity_name.to_s.camelize.constantize
  end
end
