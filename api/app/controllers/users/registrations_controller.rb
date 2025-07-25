# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)
    resource.save
    if resource.persisted?
      sign_in(resource, store: false) # triggers devise-jwt to issue token
      render json: {
        status: { code: 200, message: "Signed up and logged in successfully." },
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
      }, status: :ok
    else
      render json: {
        status: { code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
      }, status: :unprocessable_entity
    end
  end

  private

  # Override the default devise sign_up which auto signs_in and writes to the session.
  def sign_up(resource_name, resource)
    # Do nothing here to avoid session write errors
  end
end
