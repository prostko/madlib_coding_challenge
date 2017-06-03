class MadLib < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :title, :text
  attr_reader :field_labels, :framework

  has_many :solutions
  validates :text, presence: true

  after_initialize do |this|
    this.transpile_text_to_fields
    this.create_framework(@field_labels)
  end

  def has_field?(field_name)
    @field_labels.include?(field_name)
  end

  def transpile_text_to_fields
    matches = match_pattern(self.text)
    count = Hash.new(0)

    @field_labels = matches.map do |word|
      count[word] += 1
      word = "#{word} (#{count[word]}):".downcase.capitalize
    end
    @field_labels
  end

  def create_framework(labels)
    @framework = self.text.dup
    whole_matches = @framework.scan(/({.*?})/)
    whole_matches.each_with_index do |word, index|
        @framework.sub!(/#{word[0]}/, "#{labels[index]}")
    end
    @framework
  end

  private
  def match_pattern(string)
    string.scan(/{(.*?)}/).flatten
  end

end
