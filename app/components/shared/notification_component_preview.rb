class NotificationComponentPreview < ViewComponent::Preview
  layout "preview"

  @variants = [
    OpenStruct.new(id: "success", name: "Success", description: "Success alert (sometimes dismissable)"),
    OpenStruct.new(id: "notice", name: "Notice", description: "General information alert (sometimes dismissable)"),
    OpenStruct.new(id: "danger", name: "Danger", description: "Warnings to user (never dismissable)"),
    OpenStruct.new(id: "empty", name: "Empty", description: "Basic inline emphasis"),
  ]

  @form = NotificationComponentPreview::Form

  def self.form
    @form
  end

  def self.options
    @options || []
  end

  def self.variants
    @variants || []
  end

  def default
  end
end
