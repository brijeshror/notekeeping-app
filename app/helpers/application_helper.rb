module ApplicationHelper
	def flash_messages
    content_tag :div, class: :flash_messages do
      flash.each do |type, message|
        alert = { success: 'alert-success', error: 'alert-error', alert: 'alert-warning', notice: 'alert-info' }[type.to_sym] || type.to_s
        alert_div = content_tag :div, message, class: "alert #{alert}" do
          close_button = button_tag(class: 'close') do
            content_tag :div, '×'
          end
          concat close_button
          concat message
        end

        concat alert_div
      end
    end
  end

  def form_error_messages obj
    return if !obj.errors.any?
    content_tag :div, id: :error_explanation do
      content_tag :div, class: :errors do
        content_tag :ul do
          obj.errors.full_messages.each do |message|
            concat content_tag :li, message
          end
        end
      end
    end
  end

  def title_tag text
    if content_for?(:meta_title_tag)
      content_for(:meta_title_tag)
    else
      content_tag :title, text
    end
  end
end
