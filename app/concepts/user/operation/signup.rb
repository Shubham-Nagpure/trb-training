module User::Operation
  class Signup < Trailblazer::Operation
    step Model(User, :new)

    step Contract::Build(constant: User::Contract::Form)
    step Contract::Validate(key: :user)
    step Contract::Persist()
    step :generate_token
    pass :build_response
    fail :set_error_message

    def generate_token(ctx, model:, **)
      ctx[:token] = JWT.encode({user_id: model.id}, 'HS256')
    end

    def build_response(ctx, model:, token:, **)
      ctx[:data] = { user: model, token: token }
    end

    def set_error_message(ctx, model:, **)
      ctx[:errors] = ctx[:"contract.default"].errors.full_messages.presence || ctx[:"contract.default"].model.errors.full_messages  
    end
  end
end

