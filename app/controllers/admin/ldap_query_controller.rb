require 'net/ldap'
require 'json'

class Admin::LdapQueryController < ApplicationController
  before_filter :require_login
  layout false

  def find
    respond_to do |format|
      format.json { render :json => search( params[:term] ), :status => 200 }
    end
  end

  private

  def search(term)
    term.strip! if term
    return "" if term.blank?
    ldap_attributes = ['uid', 'sn', 'givenname', 'ndvanityname']
    ldap = Net::LDAP.new(
      :host => 'directory.nd.edu',
      :port => 389,
      :auth => {
        :method   => :simple,
        :username => '',
        :password => 'anonymous'
      }
    )

    results = ldap.search(
      :base          => 'o=University of Notre Dame,st=Indiana,c=US',
      :attributes    => ldap_attributes,
      :filter        => Net::LDAP::Filter.eq( 'uid', "#{term}*" ) | Net::LDAP::Filter.eq( 'cn', "*#{term}*" ),
      :return_result => true
    )
    if results
      data = []
      results.each do |entry|
        result = {}
        result['netid'] = entry[:uid][0]
        formal_nickname = entry[:ndvanityname][0]                   # edupersonnickname appears to contain the same information
        if formal_nickname && formal_nickname.split(' ').count > 1  # sometimes the formal nickname only contains the first name
          result['name'] = formal_nickname
        else
          result['name'] = "#{entry[:givenname][0]} #{entry[:sn][0]}"
        end
        data << result
      end
      return JSON.generate(data)
    else
      return ""
    end
  end

end
