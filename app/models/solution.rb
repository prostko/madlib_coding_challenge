class Solution < ActiveRecord::Base
  attr_accessible :solution_hash
  attr_reader :fields
  belongs_to :MadLib, class_name: "MadLib", foreign_key: "mad_lib_id"

  validates :mad_lib_id, presence: true

  after_initialize do |solution|
    self.solution_hash ||= "{}"
    @fields = JSON.parse(self.solution_hash)
  end

  def fill_field(label, value)
    @fields[label] = value

    solution_JSON = JSON.parse(self.solution_hash)
    solution_JSON[label] = value
    self.update_attributes(solution_hash: JSON.generate(solution_JSON))

    @fields
  end

  def resolve
    framework = self.MadLib.framework.dup
    @fields.each do |label, value|
      framework.sub!(label, value[:with])
    end
    framework
  end
end
