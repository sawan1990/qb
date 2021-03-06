class Question < ActiveRecord::Base
  has_many :objective_options

  def options
    return unless is_objective?
    
    objective_options.select{ |option| option.statement  and option.statement .strip.length > 0 }
  end

  def update_objective_options options
    return objective_options.destroy unless options

    options = options.values if options.is_a? Hash
    options.reverse!

    self.objective_options.each do |existing|
      updated_one = options.pop

      if updated_one
        existing.statement  = updated_one[:statement]
        existing.is_correct = updated_one[:is_correct]
        existing.save
      else
        existing.destroy
      end
    end

    options.each do |new_one|
      objective_options.create new_one
    end
  end

  def assign_objective_options options
    return objective_options.destroy unless options

    options = options.values if options.is_a? Hash

    objective_options.each do |existing|
      updated_one = options.pop

      unless updated_one.eql? ""
        existing.statement  = updated_one[:statement]
        existing.is_correct = updated_one[:is_correct]
        #existing.save
      else
        existing.destroy
      end
    end

    options.each do |new_one|
      objective_options.new new_one unless new_one.eql? ""
    end
  end
end
