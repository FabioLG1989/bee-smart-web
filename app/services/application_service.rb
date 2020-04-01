class ApplicationService
  def self.call(*args, &block)
    service = new(*args, &block)
    service.call
  end
end
