module ConditionsFu
  
  class ConditionsArray < Array
    
    def initialize(*args)
      super
    end
    
    def create_active_record_conditions
      conditions = ""
      self.each do |condition|
        if self.last == condition
          conditions << " #{condition[0]}"
        else
          conditions << "#{condition[0]} #{condition[2]} "
        end
      end
      [conditions.strip, self.map{|i| i[1]}].flatten
    end
    
  end
  
  class Lathe
    
    def self.run(*args)
      blueprint = Builder.blueprint
      if args.first.is_a?(Symbol)
        named_blueprint = Builder.blueprint(args.shift) 
        raise "No blueprint found" if named_blueprint.nil?
      end
      lathe = self.new(args.shift)
      lathe.instance_eval(&named_blueprint) if named_blueprint
      lathe.conditions.create_active_record_conditions
    end
    
    attr_reader :conditions 
    
    def initialize(_params)
      @params = _params
      @conditions = ConditionsArray.new
    end
    
    def params
      @params
    end
    
    private
    
    # Warning: Postgres ONLY
    def includes(options = {})
      return if options.values.include?(nil)
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} ~* ?", options.values.first, binding]
    end

    #Warning: Postgres ONLY
    def is_like(options = {})
      return if options.values.include?(nil)
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} ILIKE ?", "%#{options.values.first}%", binding]
    end

    def not_equal_to(options = {})
      return if options.values.include?(nil)
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} != ?", options.values.first, binding]
    end

    def equal_to(options = {})
      return if options.values.include?(nil)
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} = ?", options.values.first, binding]
    end

    def greater_than_or_equal_to(options = {})
      return if options.values.include?(nil)
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} >= ?", options.values.first, binding]
    end

    def greater_than(options = {})
      return if options.values.include?(nil)
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} > ?", options.values.first, binding]
    end

    def less_than_or_equal_to(options = {})
      return if options.values.include?(nil)
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} <= ?", options.values.first, binding]
    end

    def less_than(options = {})
      return if options.values.include?(nil)
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} < ?", options.values.first, binding]
    end

    def is_true(options = {})
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} = ?", true, binding]
    end

    def is_false(options = {})
      binding = get_binding_from(options)
      @conditions << ["#{options.keys.first} IS NOT ?", true, binding]
    end
    
    def binding(bind, &proc)
      p bind
      proc.call
    end

    def get_binding_from(options={})
      if options[:binding].nil?
        return "AND"
      else
        return options.delete(:binding)
      end
    end
    
  end
  
  class Builder

    def self.blueprint(name = :master, &blueprint)
      @conditions = ConditionsArray.new
      @prints ||= {}
      @prints[name] = blueprint if block_given?
      @prints[name]
    end
    
    def self.make(blueprint, params)
      Lathe.run(blueprint, params)
    end
    
    def self.named_blueprints
      @blueprints.reject{|name,_| name == :master }.keys
    end
  
    def self.clear_blueprints!
      @blueprints = {}
    end



  end
end