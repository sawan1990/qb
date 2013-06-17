class Question < ActiveRecord::Base
  acts_as_taggable

  acts_as_taggable_on :topics
  acts_as_taggable_on :qa_topics
  acts_as_taggable_on :dev_topics
  acts_as_taggable_on :complexities
  acts_as_taggable_on :natures

  attr_accessible :qa_topics_list
  attr_accessible :dev_topics_list
  attr_accessible :complexity_list
  attr_accessible :nature_list

  def self.topics
    top_qa_topics(qa_topic_counts.size) +  top_dev_topics(dev_topic_counts.size)
  end

  def self.topic_names
    qa_topics.map(&:name)+dev_topics.map(&:name)
  end

  def self.qa_topics
    top_qa_topics qa_topic_counts.size
  end

  def self.qa_topic_names
    qa_topics.map(&:name)
  end

   def self.dev_topics
    top_dev_topics dev_topic_counts.size
  end

  def self.dev_topic_names
    dev_topics.map(&:name)
  end

  def self.complexities
    top_complexities complexity_counts.size
  end

  def self.complexity_names
    complexities.map(&:name)
  end

  def self.natures
    top_natures nature_counts.size
  end

  def self.nature_names
    natures.map(&:name)
  end
  
  def topic
    qa_topic_list.first || dev_topic_list.first
  end

  def complexity
    complexity_list.first
  end

  def nature
    nature_list.first
  end
end