module User::Operation
  class Create < Trailblazer::Operation

    step :create_user
    step :address_present?, Output(:failure) => Id(:send_mail)
    step :create_address

    step :send_mail
    step :set_response

    def create_user(ctx, user_params:, **)
      ctx[:user] = User.create(user_params)
    end

    def address_present(ctx, **)
      ctx[:address_params].present?
    end

    def create_address(ctx, address_params:, **)
      ctx[:user].create_address(address_present)
    end

    def send_mail(ctx, **)
      p "inside denied"
    end
  end
end

