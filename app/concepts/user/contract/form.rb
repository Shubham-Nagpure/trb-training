module User::Contract
  class Form < Reform::Form
    property :name
    property :email
    property :mobile_number
    property :password
    property :password_confirmation

    validates :name, :mobile_number, :email, presence: true
    validates_uniqueness_of :email
    validates :mobile_number, numericality: { only_integer: true }
  end
end