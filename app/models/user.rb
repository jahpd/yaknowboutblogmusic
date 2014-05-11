class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Virtual attribute for authenticating by either name or email
  # This is in addition to a real persisted field like 'name'
  attr_accessor :login

  validate :name,{
    :uniqueness => { :case_sensitive => false },
    :format => { with: /\A[a-zA-Z]+\z/ },
    :message => "only allows letters"
  }

  validates_format_of :email, :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/

  # is the correct method you override with the code above
  # self.find_for_database_authentication(warden_conditions)
  def self.find_first_by_auth_conditions(warden_conditions)
   conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

end
