
module Order::Operation
  class Index < Trailblazer::Operation

    step :load_data

    def load_data(ctx, **)
      ctx[:orders] = Order.all
    end
  end
end
