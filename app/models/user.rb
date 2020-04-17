class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation if Rails::VERSION::MAJOR < 4
# Connects this user object to Blacklights Bookmarks.
  include Blacklight::User

  devise :omniauthable, :rememberable, :trackable, omniauth_providers: [:oktaoauth]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :remember_me, :username
  has_many :default_attribute_values, :dependent => :destroy
  has_many :default_attribute_types,  :through   => :default_attribute_values
  has_and_belongs_to_many :roles, :uniq => true

  accepts_nested_attributes_for :default_attribute_values

  default_scope { order([:last_name, :first_name]) }
  scope :ordered, lambda { |*order|
    order( order.flatten.first || [:last_name, :first_name] )
  }

  def self.create_user_with_username(username)
    new_user = User.new(:username => username)
    new_user.save!
    new_user
  end

  def self.find_or_create_user_by_okta_rawinfo(rawinfo)
    netid = rawinfo.netid
    existing_user = User.find_by_username(netid)
    existing_user ? existing_user : create_user_with_username(netid)
  end

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    username
  end

  def netid
    username
  end

  def full_name
    "#{first_name} #{last_name} (#{netid})"
  end

  def has_role?(role)
    self.roles.include?(Role.find_by_name(role.to_s))
  end

  def role_names
    self.roles.map{|role| role.name}.join(', ')
  end

  def default_attribute_for(attribute)
    default_attribute_values.joins(:default_attribute_type).where('`default_attribute_types`.`attribute_name` = ?', attribute.to_s).first.value rescue nil
  end
end
