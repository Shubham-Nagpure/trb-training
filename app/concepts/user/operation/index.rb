module User::Operation
  class Index < Trailblazer::Operation

    step :is_valid_user?
    step :load_data
    fail :set_errors
    pass :build_user

    def is_valid_user?(ctx, **)
      true
    end

    def load_data(ctx, **)
      ctx[:users] = User.all
    end

    def set_errors(ctx, **)
      ctx[:errors] = 'Invalid users'
    end

    def build_user(ctx, **)
      ctx[:build_user] = 'Build successfully'
    end
  end
end
