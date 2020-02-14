require 'net/ldap'

class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation if Rails::VERSION::MAJOR < 4
# Connects this user object to Blacklights Bookmarks.
  include Blacklight::User

  devise :omniauthable, :rememberable, :trackable, omniauth_providers: [:oktaoauth]

  #before_validation :fetch_attributes_from_ldap

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :remember_me, :username
  has_many :default_attribute_values, :dependent => :destroy
  has_many :default_attribute_types,  :through   => :default_attribute_values
  has_and_belongs_to_many :roles, :uniq => true

  accepts_nested_attributes_for :default_attribute_values

  default_scope { order:'last_name, first_name'}
  scope :ordered, lambda { |*order|
    { :order => order.flatten.first || 'last_name, first_name' }
  }

  scope :non_privileged, -> { where(:conditions => ["#{quoted_table_name}.`administrator` = ?", false]) }
  scope :administrators, -> { where(:conditions => ["#{quoted_table_name}.`administrator` = ?", true]) }

  def self.ldap_lookup(username)
    return nil if username.blank?
    ldap = Net::LDAP.new :host => 'directory.nd.edu',
                         :port => 389,
                         :auth => { :method   => :simple,
                                    :username => '',
                                    :password => 'anonymous'
                                  }
    results = ldap.search(
      :base          => 'o=University of Notre Dame,st=Indiana,c=US',
      :attributes    => [
                          'uid',
                          'givenname',
                          'sn',
                          'ndvanityname',
                        ],
      :filter        => Net::LDAP::Filter.eq( 'uid', username ),
      :return_result => true
    )
    results.first
  end

  def self.create_user_with_username(username)
    new_user = User.new(:username => username)
    new_user.save!
    new_user
  end

  def self.find_or_create_user_by_username(username)
    existing_user = User.find_by_username(username)
    existing_user ? existing_user : User.create_user_with_username(username)
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
    "#{first_name} #{last_name}"
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

  private

  def name_from_ldap(username)
    begin
      attributes = User.ldap_lookup(username)
      [attributes[:givenname].first, attributes[:sn].first, attributes[:ndvanityname].first]
    rescue
      raise ::Exceptions::NetIDNotFound
    end
  end

  def preferred_name_from_nickname(first_name, last_name, nickname)
    if nickname
      nickname_array = nickname.split(' ')
      if nickname_array.count == 1
        # If there is only one word in the nickname assume it is the first name
        return [nickname, last_name]
      else
        # If there is more than one word in the nickname assume it the full name
        return [nickname_array[0], (nickname_array - [nickname_array[0]]).join(' ')]
      end
    end
    [first_name, last_name]
  end

  #def fetch_attributes_from_ldap
  #  begin
  #    fn, sn, nickname = name_from_ldap(self.username)
  #    self.first_name, self.last_name = preferred_name_from_nickname(fn, sn, nickname)
  #  rescue ::Exceptions::NetIDNotFound
  #    self.errors[:username] = "The netID provided cannot be found in the campus directory. (Use the netID only not the email address)"
  #  end
  #end

end
