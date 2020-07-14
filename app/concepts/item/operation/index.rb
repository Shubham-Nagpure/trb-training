module Item::Operation
  class Index < Trailblazer::Operation

    step :load_data

    def load_data(ctx, **)
      ctx[:items] = Item.all
    end
  end
end
