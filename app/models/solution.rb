class Solution < ActiveRecord::Base
  attr_accessible :solution_hash, :user_id
  attr_reader :fields

  belongs_to :MadLib, class_name: "MadLib", foreign_key: "mad_lib_id"
  belongs_to :user

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
      if value.class == Hash
        framework.sub!(label, value[:with])
      else
        framework.sub!(label, value)
      end
    end
    framework
  end

  def self.report_fields
    field_count = []
    field_report = Hash.new(0)
    fields_array = self.all.reduce([]) {|array, solution| array + solution.MadLib.fields}
    fields_array.map!{|field| field.split(' ')[0].gsub(/[^0-9a-z]/i, '')}
    fields_array.each{ |field| field_report[field] += 1}
    field_report.each{|field, count| field_count << "#{field.capitalize}s: #{count}" }
    field_count
  end

  def self.report_answers
    answer_report = Hash.new{ |h, k| h[k] = [] }
    field_answer_count = Hash.new

    answers_array = self.all.each do |solution|
      solution.fields.each do |field, answer|
        answer_report[field[0..-5].strip]  << answer
      end
    end

    answer_report.each do |field_name, array_of_answers|
      answer_hash_count = Hash.new(0)
      answer_count = []

      array_of_answers.each{|answer| answer_hash_count[answer] += 1 }
      answer_hash_count.each{|answer, count| answer_count << "#{answer}: #{count}"}
      field_answer_count[field_name] = answer_count
    end
    field_answer_count
  end
end
