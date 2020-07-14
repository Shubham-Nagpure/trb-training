module User::Operation
  class Signin < Trailblazer::Operation
    step Model(User, :find_by, :email), Output(:failure) => Id(:set_error_message)

    step :validate_user, Output(:failure) => Track(:set_error_message)
    step :generate_token
    pass :build_response
    fail :set_error_message

    def validate_user(ctx, model:, params:, **)
      ctx[:user] = model.authenticate(params[:password])
    end

    def generate_token(ctx, model:, **)
      ctx[:token] = JWT.encode({user_id: model.id}, 'HS256')
    end

    def build_response(ctx, model:, token:, **)
      ctx[:data] = { user: model, token: token }
    end

    def set_error_message(ctx, **)
      ctx[:errors] = "Invalid data"
    end
  end
end

