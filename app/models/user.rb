class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either name or email
  # This is in addition to a real persisted field like 'name'
  attr_accessor :login

  # This validates name in with only letters
  validate :name,{
    :uniqueness => { :case_sensitive => false },
    :format => { with: /\A[a-zA-Z]+\z/ },
    :message => "only allows letters"
  }

  # This Validates email
  # [letters/numbers@something.som]
  # see more on https://en.wikipedia.org/wiki/Regular_expression
  validates_format_of(:email, {
    :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/
  })

  # is the correct method you override with the code above
  # for authenticate user
  def self.find_first_by_auth_conditions(warden_conditions)
   conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where([
        "lower(name) = :value OR lower(email) = :value", 
        {:value => login.downcase }
      ]).first
    else
      where(conditions).first
    end
  end

end
