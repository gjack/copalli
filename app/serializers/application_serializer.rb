class ApplicationSerializer < SimpleDelegator
  def initialize(target)
    @target = target
    super(target)
  end

  def as_json(options = {})
    raise NotImplementedError
  end

  def inspect
    "#{self.class.name} #{as_json}"
  end
end
