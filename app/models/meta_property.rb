class MetaProperty < ActiveRecord::Base
  include RequestAudited
  attr_accessor :key

  audited
  belongs_to :meta_template, touch: true
  belongs_to :property

  delegate :data_type, to: :property, allow_nil: true

  # callbacks
  before_validation :set_property_from_key
  after_save :update_templatable_document
  after_destroy :index_templatable_document

  validates :property, presence: true,
    uniqueness: {scope: [:meta_template_id], case_sensitive: false}
  validates :meta_template, presence: true
  validates :value, presence: true
  validates :value, numericality: true, if: :numeric_data_type?
  validates_each :value, if: :date_data_type? do |record, attr, value|
    message = 'is not a valid date (format: yyyy-MM-dd[THH:mm[:ss]])'
    begin
      parsed_date = DateTime.parse(value)
    rescue
    end
    record.errors.add(attr, message) unless parsed_date &&
      parsed_date.to_s(:iso8601).start_with?(value)
  end

  validates_each :key do |record, attr, value|
    record.errors.add(attr, 'key is not in the template') if value && !record.property
  end

  def set_property_from_key
    if key
      self.property = nil
      if meta_template && meta_template.template
        self.property = meta_template.template.properties.where(key: key).first
      end
    end
  end

  def update_templatable_document
    reload
    meta_template.templatable.__elasticsearch__.update_document
  end

  def index_templatable_document
    meta_template.templatable.reload
    meta_template.templatable.__elasticsearch__.index_document
  end

private
  def date_data_type?
    data_type && data_type.to_s == 'date'
  end

  def numeric_data_type?
    data_type && numeric_data_types.include?(data_type.to_s)
  end

  def numeric_data_types
    [
      'long',
      'integer',
      'short',
      'byte',
      'double',
      'float'
    ]
  end
end
