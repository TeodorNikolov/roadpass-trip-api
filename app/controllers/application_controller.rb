class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  #protect_from_forgery with: :null_session

  # Simulate a current_user in tests
  def current_user
    return @current_user if defined?(@current_user)
    @current_user = Rails.env.test? ? OpenStruct.new(id: 1) : nil
  end

  skip_before_action :authenticate_user!, raise: false if Rails.env.test?

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages },
           status: :unprocessable_content
  end

  def render_not_found
    render json: { error: "Resource not found" }, status: :not_found
  end
end
